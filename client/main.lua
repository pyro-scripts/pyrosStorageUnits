--[[
                           ______                         __  __     _ __    
   ___  __ _________  ___ / __/ /____  _______ ____ ____ / / / /__  (_) /____
  / _ \/ // / __/ _ \(_-<_\ \/ __/ _ \/ __/ _ `/ _ `/ -_) /_/ / _ \/ / __(_-<
 / .__/\_, /_/  \___/___/___/\__/\___/_/  \_,_/\_, /\__/\____/_//_/_/\__/___/
/_/   /___/                                   /___/                          
]]--

local QBCore = exports['qb-core']:GetCoreObject()

-- ==============================
-- Facility Blips
-- ==============================
CreateThread(function()
    for _, facility in pairs(Config.Facilities) do
        local blip = AddBlipForCoord(
            facility.npc.coords.x,
            facility.npc.coords.y,
            facility.npc.coords.z
        )

        SetBlipSprite(blip, Config.FacilityBlip.Sprite)
        SetBlipScale(blip, Config.FacilityBlip.Scale)
        SetBlipColour(blip, Config.FacilityBlip.Colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(facility.label)
        EndTextCommandSetBlipName(blip)
    end
end)

-- ==============================
-- Spawn NPC(s)
-- ==============================
CreateThread(function()
    for key, facility in pairs(Config.Facilities) do
        RequestModel(facility.npc.model)
        while not HasModelLoaded(facility.npc.model) do Wait(0) end

        local ped = CreatePed(
            0,
            facility.npc.model,
            facility.npc.coords.xyz,
            facility.npc.coords.w,
            false, false
        )

        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        exports['qb-target']:AddTargetEntity(ped, {
            options = {
                {
                    label = facility.label,
                    icon = 'box',
                    action = function()
                        OpenFacilityMenu(key, facility)
                    end
                }
            },
            distance = Config.TargetDistance
        })
    end
end)

-- ==============================
-- Facility Menu
-- ==============================
function OpenFacilityMenu(facilityKey, facility)
    lib.registerContext({
        id = 'facility_' .. facilityKey,
        title = facility.label,
        options = {
            {
                title = 'Rent a Unit',
                icon = 'warehouse',
                onSelect = function()
                    OpenRentMenu(facilityKey, facility)
                end
            },
            {
                title = 'Owned Units',
                icon = 'box-open',
                onSelect = function()
                    TriggerServerEvent('psu:server:getOwnedUnits', facilityKey)   
                end
            }
        }
    })

    lib.showContext('facility_' .. facilityKey)
end

-- ==============================
-- Rent Menu
-- ==============================
function OpenRentMenu(facilityKey, facility)
    local options = {}

    for _, unit in ipairs(facility.units) do
        options[#options+1] = {
            title = unit.name,
            description = ('$%s | Max Weight: %s'):format(unit.price, unit.maxWeight),
            onSelect = function()
                TriggerServerEvent('psu:server:rentUnit', facilityKey, unit)
            end
        }
    end

    lib.registerContext({
        id = 'rent_' .. facilityKey,
        title = 'Available Units',
        options = options
    })

    lib.showContext('rent_' .. facilityKey)
end

-- ==============================
-- Owned Units Menu
-- ==============================
RegisterNetEvent('psu:client:showOwnedUnits', function(units)
    local options = {}

    for _, unit in pairs(units) do
        options[#options+1] = {
            title = unit.unit_name,
            description = unit.expired and '❌ EXPIRED' or ('⏳ %d day%s left'):format(unit.daysLeft, unit.daysLeft ~= 1 and 's' or ''),
            icon = 'clock',
            onSelect = function()
                TriggerServerEvent('psu:server:renewUnit', unit.id)
            end
        }
    end

    lib.registerContext({
        id = 'owned_units',
        title = 'Your Storage Units',
        options = options
    })

    lib.showContext('owned_units')
end)

-- ==============================
-- Storage Target Zones
-- ==============================
RegisterNetEvent('psu:client:createStorageZone', function(stashId, coords)
    if not stashId or not coords then
        print('pyrosStorageUnits (ERROR): Invalid storage zone data', stashId, coords)
        return
    end

    if Config.Target == "qb" then
        exports['qb-target']:AddBoxZone(
            'psu_' .. stashId,
            coords,
            1.5, 1.5,
            {
                name = 'psu_' .. stashId,
                minZ = coords.z - 1,
                maxZ = coords.z + 1
            },
            {
                options = {
                    {
                        label = 'Open Storage Unit',
                        icon = 'fa-solid fa-box',
                        event = 'psu:client:openStorageFT',
                        args = {
                            stashId = stashId
                        }
                    }
                },
                distance = Config.TargetDistance
            }
        )
    elseif Config.Target == "ox" then
        exports.ox_target:addBoxZone({
            coords = coords,
            size = vec3(1.5, 1.5, 2.0),
            rotation = 0.0,
            debug = false,
            options = {
                {
                    name = stashId,
                    icon = 'fa-solid fa-box',
                    label = 'Open Storage Unit',
                    onSelect = function()
                        TriggerServerEvent('psu:server:tryOpen', stashId)
                    end
                }
            }
        })
    else
        print('pyrosStorageUnits (ERROR): Target Config Set Incorrectly! Please Fix and Restart Script')
    end
end)

-- ==============================
-- Open Storage FT
-- ==============================
RegisterNetEvent('psu:client:openStorageFT', function(data)
    if not data or not data.args or not data.args.stashId then
        print('pyrosStorageUnits (ERROR): Missing stashId from qb-target', json.encode(data))
        return
    end

    TriggerServerEvent('psu:server:tryOpen', data.args.stashId)
end)

-- ==============================
-- Inventory + Blips
-- ==============================
RegisterNetEvent('psu:client:createBlip', function(coords, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 473)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
end)

-- ==============================
-- QBCore Events
-- ==============================
RegisterNetEvent('psu:client:loadOwnedUnits', function(units)
    for _, unit in ipairs(units) do
        local coords = json.decode(unit.coords)

        TriggerEvent('psu:client:createStorageZone', unit.stash_id, coords)
        TriggerEvent('psu:client:createBlip', coords, Config.Facilities[unit.facility].label .. ' Storage')
    end
end)


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(2000)
    TriggerServerEvent('psu:server:requestOwnedUnits')
end)

AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    for _, blip in ipairs(storageBlips) do
        RemoveBlip(blip)
    end
    storageBlips = {}
end)