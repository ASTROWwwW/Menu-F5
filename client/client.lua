ESX = exports["es_extended"]:getSharedObject()
local playerName = "N/A"
local playerJob = {}
local ShowName = {}
local gamerTags = {}
local playerData = {}
local noClipEnabled = false
local noClipSpeed = 1.0
local minSpeed = 0.1
local maxSpeed = 10.0
local societymoney2 = 0
local isInvisible = false
local employees = {}
local playerData = {}
local visualOptions = {
    {label = "Vue & lumières améliorées", modifier = "tunnel"},
    {label = "Vue & lumières améliorées x2", modifier = "Barry1_Stoned"},
    {label = "Vue & lumières améliorées x3", modifier = "drug_flying_01"},
    {label = "Vue lumineux", modifier = "rply_contraste"},
    {label = "Vue lumineux x2", modifier = "rply_vignette"},
    {label = "Couleurs amplifiées", modifier = "rply_saturation"},
    {label = "Noir & blancs", modifier = "rply_saturation_neg"},
    {label = "Visual 1", modifier = "NG_blackout"},
    {label = "Blanc", modifier = "Scanline"},
    {label = "Dégats", modifier = "ExplosionJosh"}
}

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
    RefreshMoney2()
end)

function RefreshMoney2()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
            societymoney2 = ESX.Math.GroupDigits(money)
        end, ESX.PlayerData.job2.name)
    end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		if ShowName then
			local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
			for _, v in pairs(GetActivePlayers()) do
				local otherPed = GetPlayerPed(v)
			
				if otherPed ~= pPed then
					if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
						SetMpGamerTagVisibility(gamerTags[v], 4, 1)
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
		else
			for _, v in pairs(GetActivePlayers()) do
				RemoveMpGamerTag(gamerTags[v])
			end
		end
    end
end)
function hasAdminPermissions()
return playerData.group == 'admin' or playerData.group == 'owner'
end
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
    end
    
    ESX.TriggerServerCallback('f5menu:getPlayerData', function(data)
        playerData = data
        
    end)
    function SetRectangleBanner(menu, r, g, b, a)
        menu:SetRectangleBanner(r, g, b, a)
    end
    


RMenu.Add('f5menu', 'main', RageUI.CreateMenu("Menu F5", " by astrxw"))
SetRectangleBanner(RMenu:Get('f5menu', 'main'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'wallet', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'main'), "Portefeuille", "Informations sur votre portefeuille"))
SetRectangleBanner(RMenu:Get('f5menu', 'wallet'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'vehicle', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'main'), "Gestion des véhicules", "Options pour gérer votre véhicule"))
SetRectangleBanner(RMenu:Get('f5menu', 'vehicle'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'business', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'main'), "Gestion Entreprise", "Options pour gérer votre entreprise"))
SetRectangleBanner(RMenu:Get('f5menu', 'business'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'fire', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'business'), "Licencier Employé", "Liste des employés à licencier"))
SetRectangleBanner(RMenu:Get('f5menu', 'fire'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'gang', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'main'), "Gestion Organisation", "Options pour gérer votre organisation"))
SetRectangleBanner(RMenu:Get('f5menu', 'gang'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'fireGang', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'gang'), "Licencier Employé", "Liste des employés à licencier"))
SetRectangleBanner(RMenu:Get('f5menu', 'fireGang'), 178, 22, 22 , 30)
RMenu.Add('f5menu', 'divers', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'main'), "Divers", "Options diverses"))
SetRectangleBanner(RMenu:Get('f5menu', 'divers'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'touches', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'divers'), "Touches", "Liste des touches"))
SetRectangleBanner(RMenu:Get('f5menu', 'touches'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'commandes', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'divers'), "Commandes utiles", "Liste des commandes utiles"))
SetRectangleBanner(RMenu:Get('f5menu', 'commandes'), 88, 223, 237 , 255)
RMenu.Add('f5menu', 'vision', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'divers'), "Vision", "Types de vision"))
SetRectangleBanner(RMenu:Get('f5menu', 'vision'), 178, 22, 22 , 30)

RMenu.Add('f5menu', 'admin', RageUI.CreateSubMenu(RMenu:Get('f5menu', 'main'), "Administration", "Options pour les administrateurs"))
SetRectangleBanner(RMenu:Get('f5menu', 'admin'), 153, 32, 32  , 100)

end)

local function GetClosestPlayer()
    local players = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, player in ipairs(players) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)

            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = player
                closestDistance = distance
            end
        end
    end

    return closestPlayer, closestDistance
end

local isMenuOpen = false

function ToggleF5Menu()
    if isMenuOpen then
        RageUI.Visible(RMenu:Get('f5menu', 'main'), false)
        isMenuOpen = false
    else
        ESX.TriggerServerCallback('f5menu:getPlayerData', function(data)
            playerName = data.name
            playerJob = data.job
            RageUI.Visible(RMenu:Get('f5menu', 'main'), true)
            isMenuOpen = true
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isMenuOpen then
            RageUI.IsVisible(RMenu:Get('f5menu', 'main'), true, true, true, function()
                local playerData = ESX.GetPlayerData()
                local playerId = GetPlayerServerId(PlayerId())

                RageUI.Separator("Mon ID : ~p~" .. playerId)
                RageUI.Line()

                
                RageUI.Button("~p~→→~s~ Portefeuille", "Voir les détails de votre portefeuille", {RightLabel = "→"}, true, function(_, _, Selected)
                    if Selected then
                    end
                end, RMenu:Get('f5menu', 'wallet'))

                if playerData.job ~= nil and playerData.job.grade_name == 'boss' then
                    RageUI.Button("~p~→→~s~ Gestion Entreprise", nil, {RightLabel = "→→"}, true, function(_, _, Selected)
                        if Selected then
                        end
                    end, RMenu:Get('f5menu', 'business'))
                else
                    RageUI.Button('~p~→→~s~ Gestion Entreprise', nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_, _, Selected)
                        if Selected then
                            
                        end
                    end)
                end
                if playerData.job2 ~= nil and playerData.job2.grade_name == 'boss' then
                    RageUI.Button("~p~→→~s~ Gestion Organisation", nil, {RightLabel = "→→"}, true, function(_, _, Selected)
                        if Selected then
                        end
                    end, RMenu:Get('f5menu', 'gang'))
                else
                    RageUI.Button('~p~→→~s~ Gestion Organisation', nil, {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_, _, Selected)
                        if Selected then
                           
                        end
                    end)
                end
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if vehicle ~= 0 then
                    RageUI.Button("~p~→→~s~ Gestion des véhicules", "Options pour gérer votre véhicule", {RightLabel = "→"}, true, function(_, _, Selected)
                        if Selected then
                            -- Ouvrir le sous-menu de gestion des véhicules
                        end
                    end, RMenu:Get('f5menu', 'vehicle'))
                else
                    RageUI.Button("~p~→→~s~ Gestion des véhicules", "Vous devez être dans un véhicule pour accéder à cette option",  {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_, _, _) end)
                end
                RageUI.Button("~p~→→~s~ Divers", "Options diverses", {RightLabel = "→"}, true, function(_, _, Selected)
                    if Selected then
                        -- Ouvrir le sous-menu Divers
                    end
                end, RMenu:Get('f5menu', 'divers'))
RageUI.Line()
                if hasAdminPermissions() then
                    RageUI.Button("~p~→→~s~ Administration", "Options pour les administrateurs", {RightLabel = "→"}, true, function(_, _, Selected)
                        if Selected then
                            -- Ouvrir le sous-menu Administration
                        end
                    end, RMenu:Get('f5menu', 'admin'))
                else
                    RageUI.Button('~p~→→~s~ Administration', "Vous n'avez pas les permissions", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_, _, _) end)
                end
            end, function()
                
                
            end)

            RageUI.IsVisible(RMenu:Get('f5menu', 'gang'), true, true, true, function()
                RageUI.Button("~p~→→~s~ Embaucher un employé", "Embauchez un nouvel employé pour votre organisation", {}, true, function(_, _, Selected)
                    if Selected then
                        local closestPlayer, closestDistance = GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            local targetId = GetPlayerServerId(closestPlayer)
                            local targetName = GetPlayerName(closestPlayer)
                            TriggerServerEvent('organisation:hireEmployee', targetId, targetName)
                        else
                            exports['mythic_notify']:DoHudText('inform', 'Aucun joueur à proximité.')
                        end
                    end
                end)
            
                RageUI.Button("~p~→→~s~ Licencier un employé", "Voir la liste des employés à licencier", {}, true, function(_, _, Selected)
                    if Selected then
                        ESX.TriggerServerCallback('organisation:getEmployees', function(employeeList)
                            employees = employeeList
                            RageUI.Visible(RMenu:Get('f5menu', 'fireGang'), true)
                        end)
                    end
                end)
            
                RageUI.Button("~p~→→~s~ Gérer les salaires", "Ajustez les salaires de vos employés", {}, true, function(_, _, Selected)
                    if Selected then
                        local playerId = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('organisation:manageSalaries', playerId)
                        exports['mythic_notify']:DoHudText('inform', 'Vous avez ajusté le salaire de vos employés')
                    end
                end)
            end, function()
                -- Ajoutez ici des widgets supplémentaires si nécessaire
            end)
            
            RageUI.IsVisible(RMenu:Get('f5menu', 'fireGang'), true, true, true, function()
                RageUI.Button("~p~→→~s~ Rafraîchir la liste", nil, {}, true, function(_, _, Selected)
                    if Selected then
                        ESX.TriggerServerCallback('organisation:getEmployees', function(employeeList)
                            employees = employeeList
                        end)
                    end
                end)
            
                for _, employee in ipairs(employees) do
                    RageUI.Button(employee.name .. " - " .. employee.grade, nil, {}, true, function(_, _, Selected)
                        if Selected then
                            TriggerServerEvent('organisation:fireEmployee', employee.identifier, employee.name)
                            RageUI.CloseAll()
                        end
                    end)
                end
            end)
            RageUI.IsVisible(RMenu:Get('f5menu', 'business'), true, true, true, function()
                 local jobLabel = (playerData.job and playerData.job.label) or "N/A"
                local gradeLabel = (playerData.job and playerData.job.grade_label) or "N/A"
                RageUI.Separator(" Job : ~p~" .. jobLabel, nil, {}, true, function(_, _, _) end)
                RageUI.Separator("Grade : ~b~" .. gradeLabel, nil, {RightLabel = "→→"}, true, function(_, _, _) end)
                RageUI.Button("~p~→→~s~ Embaucher un employé", "Embauchez un nouvel employé pour votre entreprise", {}, true, function(_, _, Selected)
                    if Selected then
                        local closestPlayer, closestDistance = GetClosestPlayer()
                        if closestPlayer ~= -1 and closestDistance <= 3.0 then
                            local targetId = GetPlayerServerId(closestPlayer)
                            local targetName = GetPlayerName(closestPlayer)
                            TriggerServerEvent('business:hireEmployee', targetId, targetName)
                        else
                            exports['mythic_notify']:DoHudText('inform', 'Aucun joueur à proximité.')
                        end
                    end
                end)
            
                RageUI.Button("~p~→→~s~ Licencier un employé", "Voir la liste des employés à licencier", {}, true, function(_, _, Selected)
                    if Selected then
                        ESX.TriggerServerCallback('business:getEmployees', function(employeeList)
                            employees = employeeList
                            RageUI.Visible(RMenu:Get('f5menu', 'fire'), true)
                        end)
                    end
                end)
            
                RageUI.Button("~p~→→~s~ Gérer les salaires", "Ajustez les salaires de vos employés", {}, true, function(_, _, Selected)
                    if Selected then
                        local playerId = GetPlayerServerId(PlayerId())
                        TriggerServerEvent('business:manageSalaries', playerId)
                        exports['mythic_notify']:DoHudText('inform', 'Vous avez ajusté le salaire de vos employés')
                    end
                end)
            end, function()
                -- Ajoutez ici des widgets supplémentaires si nécessaire
            end)
            
            RageUI.IsVisible(RMenu:Get('f5menu', 'fire'), true, true, true, function()
                RageUI.Button("~p~→→~s~ Rafraîchir la liste", nil, {}, true, function(_, _, Selected)
                    if Selected then
                        ESX.TriggerServerCallback('business:getEmployees', function(employeeList)
                            employees = employeeList
                        end)
                    end
                end)
            
                for _, employee in ipairs(employees) do
                    RageUI.Button(employee.name .. " - " .. employee.grade, nil, {}, true, function(_, _, Selected)
                        if Selected then
                            TriggerServerEvent('business:fireEmployee', employee.identifier, employee.name)
                            RageUI.CloseAll()  
                        end
                    end)
                end
            end)
           


            local cinematicMode = false

RageUI.IsVisible(RMenu:Get('f5menu', 'divers'), true, true, true, function()
    
    RageUI.Button("~p~→→~s~ Touches", "Voir la liste des touches", {RightLabel = "→"}, true, function(_, _, Selected)
        if Selected then
            -- Ouvrir le sous-menu Touches
        end
    end, RMenu:Get('f5menu', 'touches'))

    RageUI.Button("~p~→→~s~ Commandes utiles", "Voir la liste des commandes utiles", {RightLabel = "→"}, true, function(_, _, Selected)
        if Selected then
            -- Ouvrir le sous-menu Commandes utiles
        end
    end, RMenu:Get('f5menu', 'commandes'))

    RageUI.Button("~p~→→~s~ Vision", "Changer le type de vision", {RightLabel = "→"}, true, function(_, _, Selected)
        if Selected then
            -- Ouvrir le sous-menu Vision
        end
    end, RMenu:Get('f5menu', 'vision'))

    RageUI.Button("~p~→→~s~ Tomber", "Faire tomber le joueur en mode ragdoll", {}, true, function(_, _, Selected)
        if Selected then
            ragdolling = not ragdolling
            while ragdolling do
             Wait(0)
            local myPed = GetPlayerPed(-1)
            SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
            ResetPedRagdollTimer(myPed)
            AddTextEntry(GetCurrentResourceName(), ('Appuyez sur ~INPUT_JUMP~ pour vous ~p~Réveiller'))
            DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
            ResetPedRagdollTimer(myPed)
            if IsControlJustPressed(0, 22) then 
            break
                end
            end
        end
    end)
    RageUI.Button("~p~→→~s~ Voir ton ID", "Voir ton identifiant de joueur", {RightLabel = "→"}, true, function(_, _, Selected)
        if Selected then
            ShowPlayerID()
        end
    end)
end)

RageUI.IsVisible(RMenu:Get('f5menu', 'touches'), true, true, true, function()
    RageUI.Separator("~y~Liste des touches")
    RageUI.Button("📱 ~g~F1 - Ouvrir le téléphone", nil, {}, true, function(_, _, _) end)
    RageUI.Button("🎒 ~b~F2 - Ouvrir l'inventaire", nil, {}, true, function(_, _, _) end)
    RageUI.Button("👥 ~p~F3 - Ouvrir le menu d'interaction", nil, {}, true, function(_, _, _) end)
    RageUI.Button("🛠 ~o~F5 - Ouvrir ce menu", nil, {}, true, function(_, _, _) end)
    -- Ajoutez plus de touches si nécessaire
end)

RageUI.IsVisible(RMenu:Get('f5menu', 'commandes'), true, true, true, function()
    RageUI.Separator("~y~Commandes utiles")
    RageUI.Button("📝 ~g~/me [message] - Action personnelle", nil, {}, true, function(_, _, _) end)
    RageUI.Button("📄 ~b~/do [message] - Description d'action", nil, {}, true, function(_, _, _) end)
    RageUI.Button("💬 ~p~/ooc [message] - Discussion hors personnage", nil, {}, true, function(_, _, _) end)
    -- Ajoutez plus de commandes si nécessaire
end)

RageUI.IsVisible(RMenu:Get('f5menu', 'vision'), true, true, true, function()
    RageUI.Separator("~p~Types de vision")

    for i, option in ipairs(visualOptions) do
        RageUI.Checkbox(option.label, nil, false, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Active, Selected, Checked)
            if Selected then
                if Checked then
                    SetTimecycleModifier(option.modifier)
                else
                    ClearTimecycleModifier()
                end
                
            end
        
        end)
    end
end)


RageUI.IsVisible(RMenu:Get('f5menu', 'admin'), true, true, true, function()
    -- Afficher le rang, l'ID et le nom du joueur
    local playerId = GetPlayerServerId(PlayerId())
    local playerName = GetPlayerName(PlayerId())
    local playerRank = playerData.group -- Assurez-vous que 'playerData.group' est correctement initialisé

    RageUI.Separator("[~p~".. playerRank .. "~s~]~s~ ID: ~b~"  .. playerId .. "~s~~r~ " .. playerName)
    RageUI.Line()
    RageUI.Checkbox("Afficher id + noms", "Afficher ou masquer les noms et IDs des joueurs", ShowName, {}, function(Hovered, Active, Selected, Checked)
        if Selected then
            ShowName = Checked
            if Checked then
                ShowName = true
            else
                ShowName = false
            end
        end
    end)
    RageUI.Checkbox("~p~→→~s~ NoClip", "Activer ou désactiver le mode NoClip.", noClipEnabled, {}, function(Hovered, Active, Selected, Checked)
        if noClipEnabled ~= Checked then
            ToggleNoClip(Checked)
        end
    end)

    RageUI.Checkbox("~p~→→~s~ Invisible", "Activer ou désactiver l'invisibilité.", isInvisible, {}, function(Hovered, Active, Selected, Checked)
        if Selected then
            ToggleInvisibility(Checked)
        end
    end)
    
    RageUI.Button("~p~→→~s~ Téléportation marqueur", nil, {RightLabel = "→→"},true, function(Hovered, Active, Selected)
        if (Selected) then   
            local playerPed = GetPlayerPed(-1)
            local WaypointHandle = GetFirstBlipInfoId(8)
            if DoesBlipExist(WaypointHandle) then
                local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
                SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.9, false, false, false, true)
            else
                ESX.ShowNotification("~r~Marqueur Introuvable !")
            end
        end
    end)
    
    
    RageUI.Button("~p~→→~s~ Téléportation joueur", nil, {RightLabel = "→→"}, true, function(_, _, Selected)
        if Selected then
            local targetPlayerId = KeyboardInput("Entrez l'ID du joueur", "", 10)
            
            if targetPlayerId ~= nil and tonumber(targetPlayerId) then
                TeleportToPlayer(tonumber(targetPlayerId))
            else
                ESX.ShowNotification("ID de joueur invalide.")
            end
        end
    end)

    RageUI.Button("~p~→→~s~ Revive Joueur", nil, {RightLabel = "→→"}, true, function(_, _, Selected)
        if Selected then
            local targetId = KeyboardInput("Entrez l'ID du joueur", "", 10)
            targetId = tonumber(targetId)
            if targetId then
                TriggerServerEvent('f5menu:revivePlayer', targetId)
            else
                ESX.ShowNotification("ID du joueur invalide")
            end
        end
    end)

RageUI.Line()
RageUI.Separator("~y~↓ Gestion véhicule ↓")
    RageUI.Button("~p~→→~s~ Faire apparaître un véhicule", nil, {RightLabel = "→→"}, true, function(_, _, Selected)
        if Selected then
            local ModelName = KeyboardInput("Nom du véhicule?", "", 100)
            
            if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
                RequestModel(ModelName)
                while not HasModelLoaded(ModelName) do
                    Citizen.Wait(0)
                end
                local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId()), GetEntityHeading(PlayerPedId()), true, true)
                TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                Wait(50)
            else
                ESX.ShowNotification("Erreur !")
            end
        end
    end)


   
    RageUI.Button("~p~→→~s~ Réparer véhicule", nil, {RightLabel = "→→"}, true, function(_, _, Selected)
        if Selected then
            local plyVeh = GetVehiclePedIsIn(PlayerPedId(), false)
					        SetVehicleFixed(plyVeh)
					        SetVehicleDirtLevel(plyVeh, 0.0) 
						end  
    end)

   
    RageUI.Button("~p~→→~s~ Upgrade véhicule", nil, {RightLabel = "→→"}, true, function(_, _, Selected)
        if Selected then
            UpgradeVehicle()
        end
    end)
    
    RageUI.Button("~p~→→~s~ Supprimer véhicule", nil, {RightLabel =  "→"}, true, function(_, Active, Selected)
        if Selected then
            local playerPed = PlayerPedId()

            if IsPedSittingInAnyVehicle(playerPed) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)

                if GetPedInVehicleSeat(vehicle, -1) == playerPed then
                    ESX.ShowNotification('Le véhicule a été delete.')
                    ESX.Game.DeleteVehicle(vehicle)
                   
                else
                    ESX.ShowNotification('Mettez vous place conducteur ou sortez de la voiture.')
                end
            else
                local vehicle = ESX.Game.GetVehicleInDirection()

                if DoesEntityExist(vehicle) then
                    ClearPedTasks(playerPed)
                    ESX.ShowNotification('Le véhicule à été delete.')
                    ESX.Game.DeleteVehicle(vehicle)

                else
                    ESX.ShowNotification('Aucune voiture autour')
                end
            end
            end
        end)
        RageUI.Button("~p~→→~s~ Changer la plaque", nil, {RightLabel =  "→"}, true, function(_, Active, Selected)
            if (Selected) then
            if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                local plaqueVehicule = KeyboardInput("Plaque", "", 8)
                SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false), plaqueVehicule)
                ESX.ShowNotification("La plaque du véhicule est désormais : ~g~"..plaqueVehicule)
            else
                ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
            end
        end
    end)
        
end)



RegisterNetEvent('f5menu:upgradeVehicleClient')
AddEventHandler('f5menu:upgradeVehicleClient', function()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        ESX.Game.SetVehicleProperties(vehicle, {
            modEngine = 3,
            modBrakes = 2,
            modTransmission = 2,
            modSuspension = 3,
            modTurbo = true
        })
        ESX.ShowNotification("Véhicule amélioré")
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option")
    end
end)





    
            RageUI.IsVisible(RMenu:Get('f5menu', 'wallet'), true, true, true, function()
                local playerData = ESX.GetPlayerData()
                local jobLabel = (playerData.job and playerData.job.label) or "N/A"
                local gradeLabel = (playerData.job and playerData.job.grade_label) or "N/A"
                local money = playerData.money or 0
            
                RageUI.Separator("↓ ~p~Portefeuille~s~ ↓")
            
                RageUI.Button("~p~→→~s~ Nom : " .. playerName, nil, {RightLabel = "→→"}, true, function(_, _, _) end)
                RageUI.Button("~p~→→~s~ Job : " .. jobLabel, nil, {RightLabel = "→→"}, true, function(_, _, _) end)
                RageUI.Button("~p~→→~s~ Grade : " .. gradeLabel, nil, {RightLabel = "→→"}, true, function(_, _, _) end)
                RageUI.Line()
                RageUI.Button("~p~→→~s~ Argent liquide : ~g~$" .. money, nil, {RightLabel = "→→"}, true, function(_, _, _) end)
            
                local bankAccount = 0
                local dirtyMoney = 0
            
                if playerData.accounts then
                    for _, account in ipairs(playerData.accounts) do
                        if account.name == 'bank' then
                            bankAccount = account.money or 0
                        elseif account.name == 'black_money' then
                            dirtyMoney = account.money or 0
                        end
                    end
                end
            
                RageUI.Button("~p~→→~s~ Banque : ~b~$" .. bankAccount, nil, {RightLabel = "→→"}, true, function(_, _, _) end)
                RageUI.Button("~p~→→~s~ Argent sale : ~r~$" .. dirtyMoney, nil, {RightLabel = "→→"}, true, function(_, _, _) end)
            end, function()
                -- Ajoutez ici des widgets supplémentaires si nécessaire
            end)

            RageUI.IsVisible(RMenu:Get('f5menu', 'vehicle'), true, true, true, function()
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                
                if vehicle ~= 0 then
                    local vehName, vehPlate, vehSpeed = GetVehicleInfo(vehicle)
                    RageUI.Separator("~y~Informations du véhicule")
                    RageUI.Separator("~b~Modèle : ~s~" .. vehName)
                    RageUI.Separator("~b~Plaque : ~s~" .. vehPlate)
                    RageUI.Separator("~b~Vitesse : ~s~" .. string.format("%.2f km/h", vehSpeed))
                end
             RageUI.Line()
             
             RageUI.Button("Définir limiteur de vitesse", "Définir la limite de vitesse pour le limitateur", {}, true, function(_, _, Selected)
                if Selected then
                    local result = KeyboardInput("Définir la limite de vitesse (km/h)", "", 3)
                    if result ~= nil and result ~= "" then
                        maxSpeed = tonumber(result)
                        SetSpeedLimiter(maxSpeed)
                    else
                        ESX.ShowNotification("Valeur invalide")
                    end
                end
            end)
        
            RageUI.Button("Désactiver le limitateur de vitesse", "Désactiver le limitateur de vitesse", {}, true, function(_, _, Selected)
                if Selected then
                    DisableSpeedLimiter()
                end
            end)
        -- Conduite automatique
        RageUI.Button("Activer/Désactiver conduite automatique", "Activer ou désactiver la conduite automatique vers le point sur la carte", {}, true, function(_, _, Selected)
            if Selected then
                ToggleAutoDrive(not autoDriveActive)
            end
        end)
                RageUI.Button("Verrouiller/Déverrouiller", "Verrouiller ou déverrouiller votre véhicule", {}, true, function(_, _, Selected)
                    if Selected then
                        LockUnlockVehicle()
                    end
                end)
            
                RageUI.Button("Ouvrir/Fermer Portes", "Ouvrir ou fermer les portes du véhicule", {}, true, function(_, _, Selected)
                    if Selected then
                        OpenCloseVehicleDoors()
                    end
                end)
            
                RageUI.Button("Démarrer/Éteindre le moteur", "Démarrer ou éteindre le moteur du véhicule", {}, true, function(_, _, Selected)
                    if Selected then
                        ToggleVehicleEngine()
                    end
                end)
            
                RageUI.Button("Changer de siège", "Changer de siège dans le véhicule", {}, true, function(_, _, Selected)
                    if Selected then
                        ChangeVehicleSeat()
                    end
                end)
            end)
        end
    end
end)





Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 166) then -- Touche F5 par défaut
            ToggleF5Menu()
        end
    end
end)

-- Fonction pour verrouiller/déverrouiller le véhicule
function LockUnlockVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        local locked = GetVehicleDoorLockStatus(vehicle)
        if locked == 1 then -- Le véhicule est déverrouillé
            SetVehicleDoorsLocked(vehicle, 2)
            ESX.ShowNotification("Véhicule verrouillé")
        else -- Le véhicule est verrouillé
            SetVehicleDoorsLocked(vehicle, 1)
            ESX.ShowNotification("Véhicule déverrouillé")
        end
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option")
    end
end

-- Fonction pour ouvrir/fermer les portes du véhicule
function OpenCloseVehicleDoors()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        local doorOpen = GetVehicleDoorAngleRatio(vehicle, 0) > 0.1 -- Vérifie si la porte avant gauche est ouverte
        if doorOpen then
            for i = 0, 5 do
                SetVehicleDoorShut(vehicle, i, false)
            end
            ESX.ShowNotification("Portes fermées")
        else
            for i = 0, 5 do
                SetVehicleDoorOpen(vehicle, i, false, false)
            end
            ESX.ShowNotification("Portes ouvertes")
        end
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option")
    end
end

-- Fonction pour démarrer/éteindre le moteur du véhicule
function ToggleVehicleEngine()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        local engineOn = GetIsVehicleEngineRunning(vehicle)
        if engineOn then
            SetVehicleEngineOn(vehicle, false, false, true)
            SetVehicleUndriveable(vehicle, true)
            ESX.ShowNotification("Moteur éteint")
        else
            SetVehicleEngineOn(vehicle, true, false, true)
            SetVehicleUndriveable(vehicle, false)
            ESX.ShowNotification("Moteur démarré")
        end
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option")
    end
end

-- Fonction pour changer de siège dans le véhicule
function ChangeVehicleSeat()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        local maxSeats = GetVehicleModelNumberOfSeats(GetEntityModel(vehicle))
        local freeSeatFound = false

        for i = -1, maxSeats - 2 do
            if IsVehicleSeatFree(vehicle, i) then
                TaskWarpPedIntoVehicle(playerPed, vehicle, i)
                ESX.ShowNotification("Vous avez changé de siège")
                freeSeatFound = true
                break
            end
        end

        if not freeSeatFound then
            ESX.ShowNotification("Aucun siège libre disponible")
        end
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option")
    end
end




function ToggleBoostFPS(enable)
    if enable then
        -- Appliquer un modificateur de cycle temporel pour réduire les effets graphiques
        SetTimecycleModifier("MP_Powerplay_blend")
    else
        -- Réinitialiser les modificateurs de cycle temporel
        ClearTimecycleModifier()
    end
end

function SetPlayerToRagdoll()
    local playerPed = PlayerPedId()
    if not IsPedRagdoll(playerPed) then
        SetPedToRagdoll(playerPed, 1000, 1000, 0, true, true, false)
    end
end

function ShowPlayerID()
    local playerId = GetPlayerServerId(PlayerId())
    ESX.ShowNotification("Ton ID : " .. playerId)
end

function GetVehicleInfo(vehicle)
    local vehName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
    local vehPlate = GetVehicleNumberPlateText(vehicle)
    local vehSpeed = GetEntitySpeed(vehicle) * 3.6 -- Convertir de m/s à km/h
    return vehName, vehPlate, vehSpeed
end

local autoDriveActive = false

function ToggleAutoDrive(enable)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        if enable then
            local waypointBlip = GetFirstBlipInfoId(8) -- 8 est le type de blip pour les waypoints
            if DoesBlipExist(waypointBlip) then
                local waypointCoords = GetBlipInfoIdCoord(waypointBlip)
                TaskVehicleDriveToCoord(playerPed, vehicle, waypointCoords.x, waypointCoords.y, waypointCoords.z, 20.0, 0, GetEntityModel(vehicle), 786603, 1.0, true)
                ESX.ShowNotification("Conduite automatique activée vers le point sur la carte")
            else
                ESX.ShowNotification("Veuillez placer un point sur la carte pour utiliser la conduite automatique")
            end
        else
            ClearPedTasks(playerPed)
            ESX.ShowNotification("Conduite automatique désactivée")
        end
        autoDriveActive = enable
    end
end

local speedLimiterEnabled = false
local maxSpeed = 50.0 -- Limite de vitesse par défaut en km/h

function SetSpeedLimiter(speed)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    
    if vehicle ~= 0 then
        maxSpeed = speed
        speedLimiterEnabled = true
        -- Convertir la vitesse en m/s
        local maxSpeedMps = maxSpeed / 3.6 -- Convertir de km/h à m/s
        SetVehicleMaxSpeed(vehicle, maxSpeedMps)
        ESX.ShowNotification("Limitateur de vitesse activé à : " .. maxSpeed .. " km/h")
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option")
    end
end

function DisableSpeedLimiter()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if vehicle ~= 0 then
        speedLimiterEnabled = false
        -- Réinitialiser la vitesse maximale à une valeur élevée pour lever la restriction
        SetVehicleMaxSpeed(vehicle, 999.0)
        ESX.ShowNotification("Limitateur de vitesse désactivé")
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option")
    end
end





function KeyboardInput(textEntry, exampleText, maxStringLength)
    -- Affiche le clavier à l'écran
    AddTextEntry('FMMC_KEY_TIP1', textEntry) --Sets the Text above the typing field in the black square
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", exampleText, "", "", "", maxStringLength)

    -- Attend que le joueur termine sa saisie
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    -- Vérifie si le joueur a entré du texte ou annulé
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) -- Attend un peu pour éviter les problèmes d'interface
        return result -- Renvoie le texte saisi par le joueur
    else
        Citizen.Wait(500) -- Attend un peu pour éviter les problèmes d'interface
        return nil -- Renvoie nil si le joueur a annulé
    end
end

function ToggleNoClip(enable)
    noClipEnabled = enable
    local ped = PlayerPedId()
    if noClipEnabled then
        SetEntityInvincible(ped, true)
        SetEntityVisible(ped, false, false)
        ESX.ShowNotification("Noclip ~g~activé")
    else
        SetEntityInvincible(ped, false)
        SetEntityVisible(ped, true)
        TeleportToGround()  -- Ajouter cette ligne pour téléporter le joueur au sol
        ESX.ShowNotification("Noclip ~r~désactivé")
    end
end



function GetPosition()
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
    return x, y, z
end

function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()

    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)

    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end

    return x, y, z
end



function TeleportToGround()
    local ped = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(ped, true))
    local groundFound, groundZ = GetGroundZFor_3dCoord(x, y, z + 1000, false)
    
    if groundFound then
        SetEntityCoords(ped, x, y, groundZ, false, false, false, true)
    else
        -- Si aucune surface n'a été trouvée, téléporte à une altitude par défaut
        SetEntityCoords(ped, x, y, z, false, false, false, true)
    end
end
Citizen.CreateThread(function()
    while true do
        local waitTime = 500
        if noClipEnabled then
            local ped = PlayerPedId()
            local x, y, z = GetPosition()
            local dx, dy, dz = GetCamDirection()
            local speed = noClipSpeed

            SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
            waitTime = 0  
            if IsControlPressed(0, 32) then -- MOVE UP
                x = x + speed * dx
                y = y + speed * dy
                z = z + speed * dz
            end

            if IsControlPressed(0, 269) then -- MOVE DOWN
                x = x - speed * dx
                y = y - speed * dy
                z = z - speed * dz
            end

            -- Utilisation de la molette de la souris pour ajuster la vitesse
            if IsControlJustPressed(1, 241) then -- Molette vers le haut
                noClipSpeed = math.min(noClipSpeed + 0.1, maxSpeed)
             
            end

            if IsControlJustPressed(1, 242) then -- Molette vers le bas
                noClipSpeed = math.max(noClipSpeed - 0.1, minSpeed)
               
            end

            SetEntityCoordsNoOffset(ped, x, y, z, true, true, true)
        end
        Citizen.Wait(waitTime)
    end
end)
function ToggleInvisibility(enable)
    isInvisible = enable
    local ped = PlayerPedId()
    if isInvisible then
        SetEntityVisible(ped, false, false)
        ESX.ShowNotification("Invisibilité ~g~activée")
    else
        SetEntityVisible(ped, true, false)
        ESX.ShowNotification("Invisibilité ~r~désactivée")
    end
end
function TeleportToCoords(coords)
    SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    ESX.ShowNotification("Téléporté aux coordonnées.")
end

function TeleportToPlayer(targetId)
    TriggerServerEvent('f5menu:teleportToPlayer', targetId)
end

RegisterNetEvent('f5menu:teleportToCoords')
AddEventHandler('f5menu:teleportToCoords', function(coords)
    TeleportToCoords(coords)
end)

function TeleportToCoords(x, y, z)
    local playerPed = PlayerPedId()

    if x and y and z then
        x = tonumber(x)
        y = tonumber(y)
        z = tonumber(z)

        if x and y and z then
            local newCoords = vector3(x, y, z)
            if DoesEntityExist(playerPed) then
                SetEntityCoords(playerPed, newCoords, false, false, false, true)
                ESX.ShowNotification("Téléporté aux coordonnées : " .. x .. ", " .. y .. ", " .. z)
            else
                ESX.ShowNotification("Entité joueur non trouvée.")
            end
        else
            ESX.ShowNotification("Coordonnées invalides.")
        end
    else
        ESX.ShowNotification("Vous devez entrer des valeurs pour X, Y et Z.")
    end
end

function TeleportToPlayer(targetPlayerId)
    ESX.TriggerServerCallback('f5menu:getPlayerCoords', function(targetCoords)
        if targetCoords then
            SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, true)
            ESX.ShowNotification("Téléporté au joueur : " .. targetPlayerId)
        else
            ESX.ShowNotification("Le joueur cible n'existe pas ou est hors ligne.")
        end
    end, targetPlayerId)
end

function UpgradeVehicle()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle ~= 0 then
        -- Perform upgrades
        SetVehicleModKit(vehicle, 0)
        for i = 0, 49 do
            local modCount = GetNumVehicleMods(vehicle, i)
            for j = 0, modCount - 1 do
                SetVehicleMod(vehicle, i, j, false)
            end
        end
        ToggleVehicleMod(vehicle, 18, true)  -- Turbo
        ToggleVehicleMod(vehicle, 20, true)  -- Tires Smoke
        SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
        SetVehicleWindowTint(vehicle, 1)  -- Light smoke tint
        SetVehicleNumberPlateTextIndex(vehicle, 5)  -- Blue on white 3 plate
        SetVehicleColours(vehicle, 12, 12)  -- Black primary and secondary color
        SetVehicleExtraColours(vehicle, 111, 111)  -- Race yellow pearlescent and wheel color
        ESX.ShowNotification("Véhicule amélioré")
    else
        ESX.ShowNotification("Vous devez être dans un véhicule pour utiliser cette option")
    end
end