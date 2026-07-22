--[[
    Headless emote data builder.

    Reads the global `RP` table (populated by `AnimationList.lua` and
    extended by `AnimationListCustom.lua`) and lifts it into the four
    runtime tables that every other client script depends on:

        EmoteData         — Emotes / Dances / PropEmotes / AnimalEmotes / Exits
        SharedEmoteData   — Shared
        WalkData          — Walks
        ExpressionData    — Expressions

    This used to live in the old `client/EmoteMenu.lua`, mixed in with
    NativeUI calls. The new `client/NuiBridge.lua` consumes the result
    and pushes it to the Svelte UI.
]]

---@type table<string, EmoteData>
EmoteData = {}

---@type table<string, SharedEmoteData>
SharedEmoteData = {}

---@type table<string, ExpressionData>
ExpressionData = {}

---@type table<string, WalkData>
WalkData = {}

---@type table<string, {name: string, emoteType: EmoteType}[]>
local categoryToEmotes = {}

CONVERTED = false

---@param emoteName string
---@param emote EmoteData
local function convertToEmoteData(emoteName, emote)
    local arraySize = 0
    for i = 1, 4 do
        if emote[i] then arraySize = arraySize + 1 end
    end

    if arraySize == 1 then
        emote.anim = emote[1]
        emote.label = emoteName
    elseif arraySize == 2 then
        emote.anim = emote[1]
        emote.label = emote[2]
    elseif arraySize >= 3 then
        local t = emote[1]
        if t == ScenarioType.MALE or t == ScenarioType.SCENARIO or t == ScenarioType.OBJECT then
            emote.scenario = emote[2]
            emote.scenarioType = t
        else
            emote.dict = emote[1]
            emote.anim = emote[2]
            emote.secondPlayersAnim = emote[4]
        end
        emote.label = emote[3]
    end

    local opts = emote.AnimationOptions
    if opts and not opts.onFootFlag then
        if opts.EmoteMoving then opts.onFootFlag = AnimFlag.MOVING
        elseif opts.EmoteLoop then opts.onFootFlag = AnimFlag.LOOP
        elseif opts.EmoteStuck then opts.onFootFlag = AnimFlag.STUCK
        end
    end

    if opts and opts.Attachto then
        opts.pos = opts.pos or vector3(opts.xPos or 0.0, opts.yPos or 0.0, opts.zPos or 0.0)
        opts.rot = opts.rot or vector3(opts.xRot or 0.0, opts.yRot or 0.0, opts.zRot or 0.0)
    end

    if opts and not opts.vehicleRequirement then
        if opts.NotInVehicle then opts.vehicleRequirement = VehicleRequirement.NOT_ALLOWED
        elseif opts.onlyInVehicle then opts.vehicleRequirement = VehicleRequirement.REQUIRED
        end
    end

    if opts and (opts.SyncOffsetSide or opts.SyncOffsetFront
        or opts.SyncOffsetHeight or opts.SyncOffsetHeading) then
        opts.syncOffset = vector4(
            opts.SyncOffsetSide or 0.0,
            opts.SyncOffsetFront or 1.0,
            opts.SyncOffsetHeight or 0.0,
            opts.SyncOffsetHeading or 180.0)
    end
end

local function expandCustomCategories()
    local expanded = {}
    for categoryName, emoteTypeMap in pairs(Config.CustomCategories) do
        expanded[categoryName] = {}
        for emoteType, emoteNames in pairs(emoteTypeMap) do
            if #emoteNames == 0 then
                if RP and RP[emoteType] then
                    for emoteName in pairs(RP[emoteType]) do
                        expanded[categoryName][#expanded[categoryName] + 1] = {
                            name = emoteName, emoteType = emoteType,
                        }
                    end
                end
            else
                for _, emoteName in ipairs(emoteNames) do
                    if RP and RP[emoteType] and RP[emoteType][emoteName] then
                        expanded[categoryName][#expanded[categoryName] + 1] = {
                            name = emoteName, emoteType = emoteType,
                        }
                    end
                end
            end
        end
    end
    return expanded
end

local function convertRP()
    local newRP = {}
    assert(RP ~= nil)
    for emoteType, content in pairs(RP) do
        for emoteName, emoteData in pairs(content) do
            if Config.AdultEmotesDisabled and emoteData.AdultAnimation then
                goto continue
            end
            if Config.AbusableEmotesDisabled and emoteData.abusable then
                goto continue
            end

            if emoteType == EmoteType.EXPRESSIONS then
                emoteData.anim = emoteData[1]
                emoteData.label = emoteData[2] or emoteName
                ExpressionData[emoteName] = emoteData
            elseif emoteType == EmoteType.WALKS then
                emoteData.anim = emoteData[1]
                emoteData.label = emoteData[2] or emoteName
                WalkData[emoteName] = emoteData
            elseif emoteType == EmoteType.SHARED then
                if type(emoteData) == "table" then
                    local sharedEmote = {}
                    for k, v in pairs(emoteData) do sharedEmote[k] = v end
                    sharedEmote.emoteType = emoteType
                    convertToEmoteData(emoteName, sharedEmote)
                    SharedEmoteData[emoteName] = sharedEmote
                end
            else
                if type(emoteData) == "table" then
                    newRP[emoteName] = {}
                    for k, v in pairs(emoteData) do newRP[emoteName][k] = v end
                else
                    newRP[emoteName] = { emoteData }
                end
                newRP[emoteName].emoteType = emoteType
                convertToEmoteData(emoteName, newRP[emoteName])
            end
            ::continue::
        end
    end
    EmoteData = newRP
    categoryToEmotes = expandCustomCategories()
end

function GetCategoryToEmotes()
    return categoryToEmotes
end

CreateThread(function()
    LoadAddonEmotes()
    convertRP()
    RP = nil
    CONVERTED = true
    TriggerEvent("rpemotes:internal:emoteDataReady")
end)
