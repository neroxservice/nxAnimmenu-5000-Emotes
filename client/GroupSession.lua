---@class GroupMember
---@field id   number
---@field name string

---@class GroupSessionState
---@field ownerId   number
---@field ownerName string
---@field members   GroupMember[]

---@type GroupSessionState|nil
GroupSession = nil

local NEARBY_RADIUS = 10.0
local INVITE_TTL_MS = 30000

---@type { ownerId: number, expireAt: number }|nil
local pendingInvite = nil

function IsInGroup()
    return GroupSession ~= nil
end

function IsGroupOwner()
    if not GroupSession then return false end
    return GroupSession.ownerId == GetPlayerServerId(PlayerId())
end

local function pushGroupStateToNUI()
    SendNUIMessage({
        type    = 'GROUP_STATE',
        group   = GroupSession,
        isOwner = IsGroupOwner(),
    })
end

function GetNearbyPlayersList()
    local myCoords   = GetEntityCoords(PlayerPedId())
    local myServerId = GetPlayerServerId(PlayerId())

    local excluded = { [myServerId] = true }
    if GroupSession then
        for i = 1, #GroupSession.members do
            excluded[GroupSession.members[i].id] = true
        end
    end

    local out = {}
    for _, playerId in ipairs(GetActivePlayers()) do
        local serverId = GetPlayerServerId(playerId)
        if not excluded[serverId] then
            local ped = GetPlayerPed(playerId)
            if DoesEntityExist(ped) then
                local dist = #(myCoords - GetEntityCoords(ped))
                if dist <= NEARBY_RADIUS then
                    out[#out + 1] = {
                        id       = serverId,
                        name     = GetPlayerName(playerId) or 'Unknown',
                        distance = math.floor(dist * 10) / 10,
                    }
                end
            end
        end
    end
    return out
end

function TryGroupTriggerEmote(emoteName, emoteType)
    if not IsGroupOwner() then return false end
    if emoteType == EmoteType.WALKS
        or emoteType == EmoteType.EXPRESSIONS
        or emoteType == EmoteType.SHARED then
        return false
    end
    TriggerServerEvent('rpemotes:server:groupTriggerEmote', emoteName)
    return true
end

local function clearPendingInvite()
    pendingInvite = nil
    SendNUIMessage({ type = 'GROUP_INVITE_CLEAR' })
end

function AcceptGroupInvite()
    if not pendingInvite then return end
    TriggerServerEvent('rpemotes:server:groupAccept', pendingInvite.ownerId)
    clearPendingInvite()
end

function DeclineGroupInvite()
    if not pendingInvite then return end
    TriggerServerEvent('rpemotes:server:groupDecline')
    clearPendingInvite()
end

RegisterNetEvent('rpemotes:client:groupState', function(state)
    GroupSession = state
    pushGroupStateToNUI()
end)

RegisterNetEvent('rpemotes:client:groupInvite', function(ownerSrc, ownerName)
    pendingInvite = {
        ownerId  = ownerSrc,
        expireAt = GetGameTimer() + INVITE_TTL_MS,
    }
    SendNUIMessage({
        type      = 'GROUP_INVITE',
        ownerId   = ownerSrc,
        ownerName = ownerName,
    })
    SetTimeout(INVITE_TTL_MS, function()
        if pendingInvite and pendingInvite.ownerId == ownerSrc then
            clearPendingInvite()
        end
    end)
end)

AddEventHandler('rpemotes:internal:nuiMounted', function()
    pushGroupStateToNUI()
end)

RegisterCommand('+um_groupAcceptInvite', AcceptGroupInvite, false)
RegisterCommand('+um_groupDeclineInvite', DeclineGroupInvite, false)
RegisterKeyMapping('+um_groupAcceptInvite', 'Accept group emote invite', 'keyboard', 'Y')
RegisterKeyMapping('+um_groupDeclineInvite', 'Decline group emote invite', 'keyboard', 'N')
