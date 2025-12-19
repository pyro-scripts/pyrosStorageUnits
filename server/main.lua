--[[
                           ______                         __  __     _ __    
   ___  __ _________  ___ / __/ /____  _______ ____ ____ / / / /__  (_) /____
  / _ \/ // / __/ _ \(_-<_\ \/ __/ _ \/ __/ _ `/ _ `/ -_) /_/ / _ \/ / __(_-<
 / .__/\_, /_/  \___/___/___/\__/\___/_/  \_,_/\_, /\__/\____/_//_/_/\__/___/
/_/   /___/                                   /___/                          
]]--

local QBCore = exports['qb-core']:GetCoreObject()

-- ==============================
-- Helpers
-- ==============================
local function GetGlobalUnitCount(citizenid)
    return MySQL.scalar.await(
        'SELECT COUNT(*) FROM storage_units where citizenid = ?',
        { citizenid }
    )
end

-- ==============================
-- Rent Unit
-- ==============================
RegisterNetEvent('psu:server:rentUnit', function(facilityKey, unit)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cid = Player.PlayerData.citizenid

    if GetGlobalUnitCount(cid) >= Config.MaxUnitsPerCharacter then
        if Config.Notifications == "pyrosNotifs" then
            return TriggerClientEvent('pyrosNotifs:send',
                src,
                'Error!',
                'You have reached the maximum number of storage units.',
                'error',
                5000
            )
        elseif Config.Notifications == "qb" then
            return TriggerClientEvent('QBCore:Notify',
                src,
                'You have reached the maximum number of storage units.',
                'error'
            )
        elseif Config.Notifications == "ox" then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error!',
                description = 'You have reached the maximum number of storage units.',
                type = 'error'
            })
        else
            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
        end
    end

    if not Player.Functions.RemoveMoney('bank', unit.price) then
        if Config.Notifications == "pyrosNotifs" then
            return TriggerClientEvent('pyrosNotifs:send',
                src,
                'Error!',
                'Insufficent Funds.',
                'error',
                5000
            )
        elseif Config.Notifications == "qb" then
            return TriggerClientEvent('QBCore:Notify',
                src,
                'Insufficent Funds.',
                'error'
            )
        elseif Config.Notifications == "ox" then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error!',
                description = 'Insufficent Funds.',
                type = 'error'
            })
        else
            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
        end
    end

    local facility = Config.Facilities[facilityKey]
    local coord = facility.storageCoords[math.random(#facility.storageCoords)]
    local stashId = ('psu_%s_%s_%s'):format(facilityKey, cid, math.random(1000,9999))

    MySQL.insert(
        'INSERT INTO storage_units (citizenid, facility, unit_name, stash_id, coords, rent_expires, max_weight) VALUES (?, ?, ?, ?, ?, ?, ?)',
        { cid, facilityKey, unit.name, stashId, json.encode(coord), os.time() + Config.RentDuration, unit.maxWeight }
    )

    TriggerClientEvent('psu:client:createBlip', src, coord, facility.label)
    TriggerClientEvent('psu:client:createStorageZone', src, stashId, coord)
    if Config.Notifications == "pyrosNotifs" then
            return TriggerClientEvent('pyrosNotifs:send',
                src,
                'Success!',
                'Successfully Rented a ' .. unit.name .. '!',
                'success',
                5000
            )
        elseif Config.Notifications == "qb" then
            return TriggerClientEvent('QBCore:Notify',
                src,
                'Successfully Rented a ' .. unit.name .. '!',
                'success'
            )
        elseif Config.Notifications == "ox" then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Success!',
                description = 'Successfully Rented a ' .. unit.name .. '!',
                type = 'success'
            })
        else
            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
        end
end)

-- ==============================
-- Renew Unit
-- ==============================
RegisterNetEvent('psu:server:renewUnit', function(unitId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local citizenid = Player.PlayerData.citizenid

    local unit = MySQL.single.await(
        'SELECT * FROM storage_units WHERE id = ?',
        { unitId }
    )

    if not unit then
        if Config.Notifications == "pyrosNotifs" then
            return TriggerClientEvent('pyrosNotifs:send',
                src,
                'Error!',
                'Storage unit not found.',
                'error',
                5000
            )
        elseif Config.Notifications == "qb" then
            return TriggerClientEvent('QBCore:Notify',
                src,
                'Storage unit not found.',
                'error'
            )
        elseif Config.Notifications == "ox" then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error!',
                description = 'Storage unit not found.',
                type = 'error'
            })
        else
            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
        end
    end

    if unit.citizenid ~= citizenid then
        if Config.Notifications == "pyrosNotifs" then
            return TriggerClientEvent('pyrosNotifs:send',
                src,
                'Error!',
                'This is not your storage unit.',
                'error',
                5000
            )
        elseif Config.Notifications == "qb" then
            return TriggerClientEvent('QBCore:Notify',
                src,
                'This is not your storage unit.',
                'error'
            )
        elseif Config.Notifications == "ox" then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error!',
                description = 'This is not your storage unit.',
                type = 'error'
            })
        else
            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
        end
    end

    local facility = Config.Facilities[unit.facility]
    if not facility then return end

    local unitCost
    for _, cfgUnit in ipairs(facility.units) do
        if cfgUnit.name == unit.unit_name then
            unitCost = cfgUnit.price
            break
        end
    end

    if not unitCost then
        if Config.Notifications == "pyrosNotifs" then
            return TriggerClientEvent('pyrosNotifs:send',
                src,
                'Error!',
                'Invalid unit configuration.',
                'error',
                5000
            )
        elseif Config.Notifications == "qb" then
            return TriggerClientEvent('QBCore:Notify',
                src,
                'Invalid unit configuration.',
                'error'
            )
        elseif Config.Notifications == "ox" then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error!',
                description = 'Invalid unit configuration.',
                type = 'error'
            })
        else
            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
        end
    end

    if not Player.Functions.RemoveMoney('bank', unitCost) then
        if Config.Notifications == "pyrosNotifs" then
            return TriggerClientEvent('pyrosNotifs:send',
                src,
                'Error!',
                'Insufficent Funds.',
                'error',
                5000
            )
        elseif Config.Notifications == "qb" then
            return TriggerClientEvent('QBCore:Notify',
                src,
                'Insufficent Funds.',
                'error'
            )
        elseif Config.Notifications == "ox" then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error!',
                description = 'Insufficent Funds.',
                type = 'error'
            })
        else
            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
        end
    end

    local now = os.time()
    local newExpiry = math.max(unit.rent_expires or 0, now) + Config.RentDuration

    MySQL.update(
        'UPDATE storage_units SET rent_expires = ?, last_reminder = 0 WHERE id = ?',
        { newExpiry, unitId }
    )

    local secondsLeft = newExpiry - now
    local daysLeft = math.ceil(secondsLeft / 86400)

    if Config.Notifications == "pyrosNotifs" then
        return TriggerClientEvent('pyrosNotifs:send',
            src,
            'Successfully Renewed!',
            ('Your storage unit has been renewed! You now have %d day%s left.'):format(daysLeft, daysLeft ~= 1 and 's' or ''),
            'success',
            5000
        )
    elseif Config.Notifications == "qb" then
        return TriggerClientEvent('QBCore:Notify',
            src,
            ('Your storage unit has been renewed! You now have %d day%s left.'):format(daysLeft, daysLeft ~= 1 and 's' or ''),
            'success'
        )
    elseif Config.Notifications == "ox" then
        return TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error!',
            description = ('Your storage unit has been renewed! You now have %d day%s left.'):format(daysLeft, daysLeft ~= 1 and 's' or ''),
            type = 'error'
        })
    else
        return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
    end
end)

-- ==============================
-- Open Storage
-- ==============================
RegisterNetEvent('psu:server:tryOpen', function(stashId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local unit = MySQL.single.await(
        'SELECT * FROM storage_units WHERE stash_id = ?',
        { stashId }
    )
    if not unit then return end

    local now = os.time()
    local expired = now > unit.rent_expires
    local allowed = unit.citizenid == Player.PlayerData.citizenid

    if Config.PoliceRaid.Enabled then
        local job = Player.PlayerData.job
        if Config.PoliceRaid.Jobs[job.name] and job.grade.level >= Config.PoliceRaid.Jobs[job.name] then
            allowed = TriggerClientEvent
        end
    end

    if expired or not allowed then
        if Config.Notifications == "pyrosNotifs" then
            return TriggerClientEvent('pyrosNotifs:send',
                src,
                'Error!',
                'This storage unit has expired.',
                'error',
                5000
            )
        elseif Config.Notifications == "qb" then
            return TriggerClientEvent('QBCore:Notify',
                src,
                'This storage unit has expired.',
                'error'
            )
        elseif Config.Notifications == "ox" then
            return TriggerClientEvent('ox_lib:notify', src, {
                title = 'Error!',
                description = 'This storage unit has expired.',
                type = 'error'
            })
        else
            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
        end
    end

    local maxWeight = tonumber(unit.max_weight)
    if not maxWeight or maxWeight <= 0 then
        print('pyrosStorageUnits (ERROR): INVALID max_weight for stash:', stashId, unit.maxWeight)
        return
    end

    if Config.Inventory == "qb" then
        TriggerClientEvent('inventory:client:SetCurrentStash', src, stashId)
        exports['qb-inventory']:OpenInventory(
            src,
            'stash',
            stashId,
            {
                label = 'Storage Unit',
                weight = maxWeight,
                slots = 50
            }
        )
    elseif Config.Inventory == "ox" then
        exports.ox_inventory:openInventory('stash', stashId)
        exports.ox_inventory:setStashProperties(stashId, {
            maxWeight = maxWeight,
            slots = 50
        })
    else
        print('pyrosStorageUnits (ERROR): Inventory Config Set Incorrectly! Please Fix and Restart Script')
    end
end)

-- ==============================
-- Request Owned Units (load on start)
-- ==============================
RegisterNetEvent('psu:server:requestOwnedUnits', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local units = MySQL.query.await([[
        SELECT stash_id, coords, facility
        FROM storage_units
        WHERE citizenid = ?
        AND rent_expires > ?
    ]], {
        Player.PlayerData.citizenid,
        os.time()
    })

    TriggerClientEvent('psu:client:loadOwnedUnits', src, units)
end)

-- ==============================
-- Owned Units
-- ==============================
RegisterNetEvent('psu:server:getOwnedUnits', function(facilityKey)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local now = os.time()

    local units = MySQL.query.await(
        'SELECT * FROM storage_units WHERE citizenid = ? AND facility = ?',
        { Player.PlayerData.citizenid, facilityKey }
    )

    for _, unit in ipairs(units) do
        unit.daysLeft = math.ceil((unit.rent_expires - now) / 86400)
        unit.expired = unit.daysLeft <= 0
        if unit.daysLeft <= 0 then unit.daysLeft = 0 end
    end

    TriggerClientEvent('psu:client:showOwnedUnits', src, units)
end)

-- ==============================
-- Expiry Reminders + Auto Wipe
-- ==============================
CreateThread(function()
    while true do
        Wait(10*60*1000)

        local now = os.time()
        local units = MySQL.query.await('SELECT * FROM storage_units')

        for _, unit in pairs(units) do
            local timeLeft = unit.rent_expires - now

            -- Reminders
            for _, t in ipairs(Config.Expiry.ReminderTimes) do
                if timeLeft <= t and unit.last_reminder < t then
                    MySQL.update(
                        'UPDATE storage_units SET last_reminder = ? WHERE id = ?',
                        { t, unit.id }
                    )

                    local Player = QBCore.Functions.GetPlayerByCitizenId(unit.citizenid)
                    if Player then
                        if Config.Notifications == "pyrosNotifs" then
                            return TriggerClientEvent('pyrosNotifs:send',
                                Player.PlayerData.source,
                                'Expiry Warning!',
                                ('Your storage unit expires in %s'):format(lib.formatTime(timeLeft)),
                                'warn',
                                7500
                            )
                        elseif Config.Notifications == "qb" then
                            return TriggerClientEvent('QBCore:Notify',
                                Player.PlayerData.source,
                                ('Your storage unit expires in %s'):format(lib.formatTime(timeLeft)),
                                'warning'
                            )
                        elseif Config.Notifications == "ox" then
                            return TriggerClientEvent('ox_lib:notify', src, {
                                title = 'Error!',
                                description = 'This storage unit has expired.',
                                type = 'error'
                            })
                        else
                            return print("pyrosStorageUnits (ERROR): Notifications Config Set Incorrectly! Please Fix and Restart Script")
                        end
                    end
                end
            end

            if now - unit.rent_expires >= Config.Expiry.DeleteAfter then
                exports['qb-iventory']:ClearStash(unit.stash_id)
                MySQL.execute(
                    'DELETE FROM storage_units WHERE id = ?',
                    { unit.id }
                )
            end
        end
    end
end)