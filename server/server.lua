ESX = exports["es_extended"]:getSharedObject()


ESX.RegisterServerCallback('f5menu:getPlayerName', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT firstname, lastname, `group` FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            cb(result[1].firstname .. ' ' .. result[1].lastname, result[1].group)
        else
            cb("N/A", "user")
        end
    end)
end)


ESX.RegisterServerCallback('business:getEmployees', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local jobName = xPlayer.getJob().name

    MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, job_grade FROM users WHERE job = @job', {
        ['@job'] = jobName
    }, function(results)
        local employees = {}

        for _, result in ipairs(results) do
            table.insert(employees, {
                identifier = result.identifier,
                name = result.firstname .. ' ' .. result.lastname,
                grade = result.job_grade
            })
        end

        cb(employees)
    end)
end)

RegisterServerEvent('organisation:hireEmployee')
AddEventHandler('organisation:hireEmployee', function(targetId, targetName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    local job2Name = xPlayer.getJob2().name

    MySQL.Async.execute('UPDATE users SET job2 = @job2, job2_grade = @job2_grade WHERE identifier = @identifier', {
        ['@job2'] = job2Name,
        ['@job2_grade'] = 1,
        ['@identifier'] = xTarget.identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            xTarget.setJob2(job2Name, 1)
            TriggerClientEvent('mythic_notify:client:DoHudText', source, { type = 'inform', text = "Vous avez embauché " .. targetName .. "." })
            TriggerClientEvent('mythic_notify:client:DoHudText', targetId, { type = 'inform', text = "Vous avez été embauché par " .. xPlayer.getName() .. "." })
        end
    end)
end)

RegisterServerEvent('organisation:fireEmployee')
AddEventHandler('organisation:fireEmployee', function(identifier, targetName)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE users SET job2 = @job2, job2_grade = @job2_grade WHERE identifier = @identifier', {
        ['@job2'] = 'unemployed',
        ['@job2_grade'] = 0,
        ['@identifier'] = identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            local xTarget = ESX.GetPlayerFromIdentifier(identifier)
            if xTarget then
                xTarget.setJob2('unemployed', 0)
                TriggerClientEvent('mythic_notify:client:DoHudText', xTarget.source, { type = 'inform', text = "Vous avez été licencié par " .. xPlayer.getName() .. "." })
            end
            TriggerClientEvent('mythic_notify:client:DoHudText', source, { type = 'inform', text = "Vous avez licencié " .. targetName .. "." })
        end
    end)
end)

RegisterServerEvent('organisation:manageSalaries')
AddEventHandler('organisation:manageSalaries', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    MySQL.Async.execute('UPDATE job2_grades SET salary = salary + 100 WHERE job2_name = @job2', {
        ['@job2'] = xPlayer.getJob2().name
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('mythic_notify:client:DoHudText', -1, { type = 'inform', text = "Les salaires ont été ajustés." })
        end
    end)
end)

ESX.RegisterServerCallback('organisation:getEmployees', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job2Name = xPlayer.getJob2().name

    MySQL.Async.fetchAll('SELECT identifier, firstname, lastname, job2_grade FROM users WHERE job2 = @job2', {
        ['@job2'] = job2Name
    }, function(results)
        local employees = {}

        for _, result in ipairs(results) do
            table.insert(employees, {
                identifier = result.identifier,
                name = result.firstname .. ' ' .. result.lastname,
                grade = result.job2_grade
            })
        end

        cb(employees)
    end)
end)


ESX.RegisterServerCallback('business:getMaxGrade', function(source, cb, jobName)
    MySQL.Async.fetchScalar('SELECT MAX(grade) FROM job_grades WHERE job_name = @jobName', {
        ['@jobName'] = jobName
    }, function(maxGrade)
        cb(maxGrade)
    end)
end)

ESX.RegisterServerCallback('business:isPlayerBoss', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.getJob()

    MySQL.Async.fetchScalar('SELECT MAX(grade) FROM job_grades WHERE job_name = @jobName', {
        ['@jobName'] = job.name
    }, function(maxGrade)
        if job.grade == maxGrade then
            cb(true)
        else
            cb(false)
        end
    end)
end)
ESX.RegisterServerCallback('f5menu:getPlayerData', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb({
        name = xPlayer.getName(),
        job = xPlayer.getJob()
    })
end)




RegisterServerEvent('business:hireEmployee')
AddEventHandler('business:hireEmployee', function(targetId, targetName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)
    local jobName = xPlayer.getJob().name

    MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
        ['@job'] = jobName,
        ['@job_grade'] = 1,
        ['@identifier'] = xTarget.identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            xTarget.setJob(jobName, 1)
            TriggerClientEvent('mythic_notify:client:DoHudText', source, { type = 'inform', text = "Vous avez embauché " .. targetName .. "." })
            TriggerClientEvent('mythic_notify:client:DoHudText', targetId, { type = 'inform', text = "Vous avez été embauché par " .. xPlayer.getName() .. "." })
        end
    end)
end)

RegisterServerEvent('business:fireEmployee')
AddEventHandler('business:fireEmployee', function(identifier, targetName)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
        ['@job'] = 'unemployed',
        ['@job_grade'] = 0,
        ['@identifier'] = identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            local xTarget = ESX.GetPlayerFromIdentifier(identifier)
            if xTarget then
                xTarget.setJob('unemployed', 0)
                TriggerClientEvent('mythic_notify:client:DoHudText', xTarget.source, { type = 'inform', text = "Vous avez été licencié par " .. xPlayer.getName() .. "." })
            end
            TriggerClientEvent('mythic_notify:client:DoHudText', source, { type = 'inform', text = "Vous avez licencié " .. targetName .. "." })
        end
    end)
end)


RegisterServerEvent('business:manageSalaries')
AddEventHandler('business:manageSalaries', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    MySQL.Async.execute('UPDATE job_grades SET salary = salary + 100 WHERE job_name = @job', {
        ['@job'] = xPlayer.getJob().name
    }, function(rowsChanged)
        if rowsChanged > 0 then
            TriggerClientEvent('mythic_notify:client:DoHudText', -1, { type = 'inform', text = "Les salaires ont été ajustés." })
        end
    end)
end)

ESX.RegisterServerCallback('f5menu:getPlayerData', function(source, cb)
    local attempts = 0
    local maxAttempts = 10
    local interval = 1000 -- 1 seconde

    local function getPlayerData()
        local xPlayer = ESX.GetPlayerFromId(source)

        if xPlayer then
            local data = {
                name = xPlayer.getName(),
                job = xPlayer.getJob(),
                group = xPlayer.getGroup()
            }
            cb(data)
        else
            attempts = attempts + 1
            if attempts < maxAttempts then
                Citizen.SetTimeout(interval, getPlayerData)
            else
                print("Erreur: Impossible de récupérer les données du joueur après " .. maxAttempts .. " tentatives pour le joueur ID: " .. tostring(source))
                cb(nil)
            end
        end
    end

    getPlayerData()
end)
RegisterServerEvent('f5menu:teleportToCoords')
AddEventHandler('f5menu:teleportToCoords', function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if coords and type(coords.x) == "number" and type(coords.y) == "number" and type(coords.z) == "number" then
            TriggerClientEvent('f5menu:teleportToCoords', source, coords)
        else
            TriggerClientEvent('esx:showNotification', source, 'Coordonnées invalides.')
        end
    end
end)
RegisterServerEvent('f5menu:revivePlayer')
AddEventHandler('f5menu:revivePlayer', function(targetId)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and (xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'owner') then
        TriggerClientEvent('esx_ambulancejob:revive', targetId)
    else
        print(('f5menu: %s attempted to revive a player without permissions!'):format(xPlayer.identifier))
    end
end)
ESX.RegisterServerCallback('f5menu:getPlayerCoords', function(source, cb, targetPlayerId)
    local targetPlayer = ESX.GetPlayerFromId(targetPlayerId)
    if targetPlayer then
        local targetCoords = GetEntityCoords(GetPlayerPed(targetPlayerId))
        cb(targetCoords)
    else
        cb(nil)
    end
end)

