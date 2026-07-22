local nuiReady = false
local dataReady = false
local menuOpen = false
local dataPushed = false

---@type EmoteType[]
local EMOTE_TYPES_FOR_UI = {
    EmoteType.EMOTES,
    EmoteType.DANCES,
    EmoteType.PROP_EMOTES,
    EmoteType.ANIMAL_EMOTES,
    EmoteType.EXITS,
    EmoteType.WALKS,
    EmoteType.EXPRESSIONS,
    EmoteType.SHARED,
    EmoteType.White2do,
    EmoteType.White3ro,
    EmoteType.White5to,
}

local CATEGORY_FROM_TYPE = {
    [EmoteType.EMOTES]        = 'general',
    [EmoteType.DANCES]        = 'dances',
    [EmoteType.PROP_EMOTES]   = 'prop',
    [EmoteType.ANIMAL_EMOTES] = 'animal',
    [EmoteType.EXITS]         = 'general',
    [EmoteType.WALKS]         = 'walks',
    [EmoteType.EXPRESSIONS]   = 'expressions',
    [EmoteType.SHARED]        = 'shared',
    [EmoteType.White2do]      = 'custom',
    [EmoteType.White3ro]      = 'custom',
    [EmoteType.White5to]      = 'custom',
}

---@param emoteType EmoteType
---@return table<string, EmoteData|WalkData|ExpressionData|SharedEmoteData>
local function getDataTable(emoteType)
    if emoteType == EmoteType.WALKS then return WalkData end
    if emoteType == EmoteType.EXPRESSIONS then return ExpressionData end
    if emoteType == EmoteType.SHARED then return SharedEmoteData end
    return EmoteData
end

local function buildFlatEmoteList()
    local out = {}
    local favMap = GetFavoriteEmotes and GetFavoriteEmotes() or {}

    for _, emoteType in ipairs(EMOTE_TYPES_FOR_UI) do
        local source = getDataTable(emoteType)
        for name, data in pairs(source) do
            -- EmoteData mixes Emotes/Dances/Prop/Animal/Exits, so filter by emoteType.
            if emoteType == EmoteType.WALKS
                or emoteType == EmoteType.EXPRESSIONS
                or emoteType == EmoteType.SHARED
                or data.emoteType == emoteType
            then
                local id = emoteType .. '_' .. name
                local categoryId = CATEGORY_FROM_TYPE[emoteType] or 'general'
                local hasPermission = HasEmotePermission and HasEmotePermission(name, emoteType) or true

                out[#out + 1] = {
                    id            = id,
                    name          = name,
                    label         = data.label or name,
                    emoteType     = emoteType,
                    categoryId    = categoryId,
                    isFavorite    = favMap[id] ~= nil,
                    hasPermission = hasPermission,
                }
            end
        end
    end

    return out
end

local function pushEmoteDataToUI()
    if not (nuiReady and dataReady) then return end
    SendNUIMessage({
        type   = 'LOAD_EMOTE_DATA',
        emotes = buildFlatEmoteList(),
    })
    dataPushed = true
    DebugPrint('[NuiBridge] LOAD_EMOTE_DATA pushed (' .. #buildFlatEmoteList() .. ' emotes)')
end

RegisterNUICallback('NUI_READY', function(_, cb)
    nuiReady = true
    DebugPrint('[NuiBridge] NUI_READY')
    cb({ ok = true })
    pushEmoteDataToUI()
    TriggerEvent('rpemotes:internal:nuiMounted')
end)

RegisterNUICallback('CLOSE_MENU', function(_, cb)
    CloseEmoteMenu()
    cb({ ok = true })
end)

RegisterNUICallback('ROUTE_EMOTE', function(data, cb)
    if data and data.emoteName and data.emoteType then
        if data.emoteName == '_reset' then
            if data.emoteType == EmoteType.WALKS then
                ResetWalk()
                DeleteResourceKvp('walkstyle')
            elseif data.emoteType == EmoteType.EXPRESSIONS then
                DeleteResourceKvp(EmoteType.EXPRESSIONS)
                ClearFacialIdleAnimOverride(PlayerPedId())
            end
        elseif not (TryGroupTriggerEmote and TryGroupTriggerEmote(data.emoteName, data.emoteType)) then
            RouteEmoteToFunction(data.emoteName, data.emoteType, 1)
        end
    end
    cb({ ok = true })
end)

RegisterNUICallback('FAVORITE_EMOTE', function(data, cb)
    if data and data.id and data.name and data.emoteType and data.label then
        ToggleFavoriteEmote(data.id, {
            id               = data.id,
            name             = data.name,
            emoteType        = data.emoteType,
            label            = data.label,
            textureVariation = 1,
        })
        pushEmoteDataToUI()
    end
    cb({ ok = true })
end)

RegisterNUICallback('CANCEL_EMOTE', function(_, cb)
    if EmoteCancel then EmoteCancel() end
    if DestroyAllProps then DestroyAllProps() end
    cb({ ok = true })
end)

-- Search focus flips KeepInput so typing in the box doesn't reach the game.
RegisterNUICallback('SEARCH_FOCUS', function(data, cb)
    local focused = data and data.focused
    SetNuiFocusKeepInput(not focused)
    cb({ ok = true })
end)

RegisterNUICallback('GROUP_GET_NEARBY', function(_, cb)
    cb({ players = GetNearbyPlayersList and GetNearbyPlayersList() or {} })
end)

RegisterNUICallback('GROUP_CREATE', function(_, cb)
    TriggerServerEvent('rpemotes:server:groupCreate')
    cb({ ok = true })
end)

RegisterNUICallback('GROUP_INVITE', function(data, cb)
    if data and data.targetId then
        TriggerServerEvent('rpemotes:server:groupInvite', tonumber(data.targetId))
    end
    cb({ ok = true })
end)

RegisterNUICallback('GROUP_KICK', function(data, cb)
    if data and data.targetId then
        TriggerServerEvent('rpemotes:server:groupKick', tonumber(data.targetId))
    end
    cb({ ok = true })
end)

RegisterNUICallback('GROUP_LEAVE', function(_, cb)
    TriggerServerEvent('rpemotes:server:groupLeave')
    cb({ ok = true })
end)

RegisterNUICallback('GROUP_DISBAND', function(_, cb)
    TriggerServerEvent('rpemotes:server:groupDisband')
    cb({ ok = true })
end)

RegisterNUICallback('GROUP_ACCEPT_INVITE', function(_, cb)
    if AcceptGroupInvite then AcceptGroupInvite() end
    cb({ ok = true })
end)

RegisterNUICallback('GROUP_DECLINE_INVITE', function(_, cb)
    if DeclineGroupInvite then DeclineGroupInvite() end
    cb({ ok = true })
end)

local DISABLED_CONTROLS = {
    1,   -- LOOK_LR
    2,   -- LOOK_UD
    24,  -- ATTACK
    25,  -- AIM
    199, -- FRONTEND_PAUSE_ALTERNATE
    200, -- FRONTEND_PAUSE
    257, -- ATTACK2
    263, -- MELEE_ATTACK1
}

local function killPauseMenu()
    if IsPauseMenuActive() then
        SetFrontendActive(false)
    end
end

local function startMenuInputThread()
    CreateThread(function()
        while menuOpen do
            Wait(0)
            for i = 1, #DISABLED_CONTROLS do
                DisableControlAction(0, DISABLED_CONTROLS[i], true)
            end
            killPauseMenu()
        end
        -- Grace period: swallow trailing ESC press after the menu closes
        -- so it doesn't open the pause menu / map.
        for _ = 1, 30 do
            Wait(0)
            DisableControlAction(0, 199, true)
            DisableControlAction(0, 200, true)
        end
    end)
end

function OpenEmoteMenu()
    if menuOpen then
        CloseEmoteMenu()
        return
    end
    menuOpen = true
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(true)
    SendNUIMessage({ type = 'OPEN_MENU', value = true })
    startMenuInputThread()
end

function CloseEmoteMenu()
    if not menuOpen then return end
    menuOpen = false
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SendNUIMessage({ type = 'OPEN_MENU', value = false })
end

-- Compat shims kept so the rest of the codebase (Utils.lua etc.) doesn't break.
function InitMenu()
    dataPushed = false
    pushEmoteDataToUI()
end

function RebuildEmoteMenu()
    pushEmoteDataToUI()
end

AddEventHandler('rpemotes:internal:emoteDataReady', function()
    dataReady = true
    pushEmoteDataToUI()
end)
