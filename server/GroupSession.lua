-- groups[ownerSrc] = { ownerName, members = { [src] = true, ... } }
local groups = {}

-- srcToOwner[src] = ownerSrc (or nil if not in any group).
local srcToOwner = {}

-- invites[targetSrc] = ownerSrc.
local invites = {}

local INVITE_TIMEOUT_MS = 30000
local MAX_GROUP_MEMBERS = 32

local function buildPayload(ownerSrc)
    local group = groups[ownerSrc]
    if not group then return nil end

    local members = {}
    for src in pairs(group.members) do
        members[#members + 1] = {
            id   = src,
            name = GetPlayerName(src) or 'Unknown',
        }
    end
    return {
        ownerId   = ownerSrc,
        ownerName = group.ownerName,
        members   = members,
    }
end

local function broadcastGroupState(ownerSrc)
    local group = groups[ownerSrc]
    if not group then return end
    local payload = buildPayload(ownerSrc)
    for src in pairs(group.members) do
        TriggerClientEvent('rpemotes:client:groupState', src, payload)
    end
end

local function clearStateFor(srcs)
    for i = 1, #srcs do
        TriggerClientEvent('rpemotes:client:groupState', srcs[i], nil)
    end
end

-- Removes `src` from their group. If they're the owner, the whole group is disbanded.
local function leaveGroup(src)
    local ownerSrc = srcToOwner[src]
    if not ownerSrc then return end

    local group = groups[ownerSrc]
    if not group then
        srcToOwner[src] = nil
        return
    end

    if src == ownerSrc then
        local memberList = {}
        for memberSrc in pairs(group.members) do
            srcToOwner[memberSrc] = nil
            memberList[#memberList + 1] = memberSrc
        end
        groups[ownerSrc] = nil
        clearStateFor(memberList)
    else
        group.members[src] = nil
        srcToOwner[src] = nil
        TriggerClientEvent('rpemotes:client:groupState', src, nil)
        broadcastGroupState(ownerSrc)
    end
end

RegisterNetEvent('rpemotes:server:groupCreate', function()
    local src = source
    if srcToOwner[src] then return end

    groups[src] = {
        ownerName = GetPlayerName(src) or 'Unknown',
        members   = { [src] = true },
    }
    srcToOwner[src] = src
    broadcastGroupState(src)
end)

RegisterNetEvent('rpemotes:server:groupInvite', function(targetSrc)
    local src = source
    targetSrc = tonumber(targetSrc)
    if not targetSrc or targetSrc == src then return end

    if srcToOwner[src] ~= src then return end
    if srcToOwner[targetSrc] then return end
    if GetPlayerPing(tostring(targetSrc)) == 0 then return end

    local group = groups[src]
    if not group then return end

    local memberCount = 0
    for _ in pairs(group.members) do memberCount = memberCount + 1 end
    if memberCount >= MAX_GROUP_MEMBERS then return end

    invites[targetSrc] = src
    TriggerClientEvent('rpemotes:client:groupInvite', targetSrc, src,
        GetPlayerName(src) or 'Unknown')

    SetTimeout(INVITE_TIMEOUT_MS, function()
        if invites[targetSrc] == src then
            invites[targetSrc] = nil
        end
    end)
end)

RegisterNetEvent('rpemotes:server:groupAccept', function(ownerSrc)
    local src = source
    ownerSrc = tonumber(ownerSrc)
    if invites[src] ~= ownerSrc then return end
    invites[src] = nil

    local group = groups[ownerSrc]
    if not group then return end
    if srcToOwner[src] then return end

    group.members[src] = true
    srcToOwner[src] = ownerSrc
    broadcastGroupState(ownerSrc)
end)

RegisterNetEvent('rpemotes:server:groupDecline', function()
    invites[source] = nil
end)

RegisterNetEvent('rpemotes:server:groupKick', function(targetSrc)
    local src = source
    targetSrc = tonumber(targetSrc)
    if srcToOwner[src] ~= src then return end
    if not targetSrc or targetSrc == src then return end

    local group = groups[src]
    if not group or not group.members[targetSrc] then return end

    group.members[targetSrc] = nil
    srcToOwner[targetSrc] = nil
    TriggerClientEvent('rpemotes:client:groupState', targetSrc, nil)
    broadcastGroupState(src)
end)

RegisterNetEvent('rpemotes:server:groupLeave', function()
    leaveGroup(source)
end)

RegisterNetEvent('rpemotes:server:groupDisband', function()
    local src = source
    if srcToOwner[src] ~= src then return end
    leaveGroup(src)
end)

RegisterNetEvent('rpemotes:server:groupTriggerEmote', function(emote)
    local src = source
    if srcToOwner[src] ~= src then return end
    if type(emote) ~= 'string' or emote == '' then return end

    local group = groups[src]
    if not group then return end

    for memberSrc in pairs(group.members) do
        TriggerClientEvent('rpemotes:client:doGroupEmote', memberSrc, emote)
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    invites[src] = nil
    leaveGroup(src)
end)
