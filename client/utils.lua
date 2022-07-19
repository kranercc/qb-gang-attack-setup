local HITTING_SOMEONE = false
function get_target()
    local closest_ped = QBCore.Functions.GetClosestPed(GetEntityCoords(PlayerPedId()), {PlayerPedId()})
    local d = Vdist(GetEntityCoords(PlayerPedId()), GetEntityCoords(closest_ped))
    if d < Config.Distance then
        if not IsPedAPlayer(closest_ped) then
            if Config.Target_NPCs then
                return closest_ped
            end
        else
            return closest_ped
        end
    end
    return nil
end

AddRelationshipGroup('KRANE_MURDERERS_NPCS')

function Create_The_Murder_Team(no_members) 
    local npcs = {}
    for i=1, no_members do
        local model = GetHashKey(Config.Gang_Male_Model)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
            RequestModel(model)
        end
        local npc = CreatePed(1, model, Config.Start_Position_For_Gang, 0, true, true)
        SetEntityAsMissionEntity(npc, 0, 0)
        SetPedRelationshipGroupHash(npc, GetHashKey('KRANE_MURDERERS_NPCS'))
        SetRelationshipBetweenGroups(1, 'KRANE_MURDERERS_NPCS', 'KRANE_MURDERERS_NPCS')
    
        GiveWeaponToPed(npc, GetHashKey("WEAPON_PISTOL"), 200, false, true)

        table.insert(npcs, npc)
    end

    return npcs
end

function Put_NPCs_In_Veh()
    local the_veh = nil
    local model = GetHashKey(Config.Gang_Car) 
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
        RequestModel(model)
    end
    local murder_team = Create_The_Murder_Team(4)
    QBCore.Functions.SpawnVehicle(model, function(vehicle)
        SetVehicleNumberPlateText(vehicle, "iKillu")

        SetPedIntoVehicle(murder_team[1], vehicle, -1)
        SetPedIntoVehicle(murder_team[2], vehicle, 0)
        SetPedIntoVehicle(murder_team[3], vehicle, 1)
        SetPedIntoVehicle(murder_team[4], vehicle, 2)

        SetVehicleEngineOn(vehicle, value, instantly, otherwise)
        the_veh = vehicle
    end, Config.Start_Position_For_Gang, true)
    while the_veh == nil do Wait(0) end

    return {vehicle = the_veh, npcs = murder_team}
end


function Go_Hit_Target(target) 
    local data = Put_NPCs_In_Veh()
    local npcs = data.npcs
    local vehicle = data.vehicle
    
    local veh_blip = AddBlipForEntity(vehicle)
    SetBlipSprite(veh_blip, 0)
    SetBlipColour(veh_blip, 1)
    SetBlipRoute(veh_blip, true)

    CreateThread(function() 
        HITTING_SOMEONE = true
        CreateThread(function() 
            while Config.Draw_Marker_On_Target and GetEntityHealth(target) > Config.Min_Health_On_Target_For_Gang_To_Leave do
                Wait(0)
                local x,y,z = table.unpack(GetEntityCoords(target))
                DrawMarker(0, x, y, z + 2, 0, 0, 0, 0, 0, 0, 0.3, 0.3, 0.3, 255, 255, 255, 200, 0, 0, 0, 0)
            end
        end)

        while GetEntityHealth(target) > Config.Min_Health_On_Target_For_Gang_To_Leave do
            Wait(2000)
            local x,y,z = table.unpack(GetEntityCoords(target))
            local d_car_to_target = Vdist(GetEntityCoords(target), GetEntityCoords(vehicle))
            local drive_flag = 787004
            if d_car_to_target > 20.0 then
                TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(vehicle, -1), vehicle, x, y, z, 60.0, drive_flag, 5.0) 
                TaskCombatPed(GetPedInVehicleSeat(vehicle, 0), target, 0, 16)
                TaskCombatPed(GetPedInVehicleSeat(vehicle, 1), target, 0, 16)
                TaskCombatPed(GetPedInVehicleSeat(vehicle, 2), target, 0, 16)
            else
                if IsPedInAnyVehicle(target, false) then
                    if GetEntitySpeed(GetVehiclePedIsIn(target, false)) < 10.0 then
                        TaskEveryoneLeaveVehicle(vehicle)
                        for _, gang_member in pairs(npcs) do
                            TaskCombatPed(gang_member, target, 0, 16)
                        end
                    else
                        TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(vehicle, -1), vehicle, x, y, z, 60.0, drive_flag, 5.0) 
                        TaskCombatPed(GetPedInVehicleSeat(vehicle, 0), target, 0, 16)
                        TaskCombatPed(GetPedInVehicleSeat(vehicle, 1), target, 0, 16)
                        TaskCombatPed(GetPedInVehicleSeat(vehicle, 2), target, 0, 16)            
                    end
                else
                    TaskEveryoneLeaveVehicle(vehicle)
                    for _, gang_member in pairs(npcs) do
                        TaskCombatPed(gang_member, target, 0, 16)
                    end    
                end
            end
        end
        
        HITTING_SOMEONE = fasle
        ClearPedTasks(npcs[1])
        ClearPedTasks(npcs[2])
        ClearPedTasks(npcs[3])
        ClearPedTasks(npcs[4])
        RemoveBlip(veh_blip)
        Wait(1000)

        TaskEnterVehicle(npcs[1], vehicle, 20000, -1, 1.5, 1, 0)
        TaskEnterVehicle(npcs[2], vehicle, 20000, 0, 1.5, 1, 0)
        TaskEnterVehicle(npcs[3], vehicle, 20000, 1, 1.5, 1, 0)
        TaskEnterVehicle(npcs[4], vehicle, 20000, 2, 1.5, 1, 0)


        while GetPedInVehicleSeat(vehicle, -1) == 0 do 
            Wait(2000) 
            TaskEnterVehicle(npcs[1], vehicle, 20000, -1, 1.5, 1, 0)         
            print("not in driver seat")
        end

        Wait(5000)
        TaskVehicleDriveToCoordLongrange(GetPedInVehicleSeat(vehicle, -1), vehicle, Config.Start_Position_For_Gang, 60.0, drive_flag, 5.0) 

        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Sender_Mail,
            subject = Config.Subject,
            message = Config.Message,
            button = {}
        })

        Wait(30000)

        delete_everything(npcs, vehicle)
    end)
end

function delete_everything(npcs, vehicle)
    for _, npc in pairs(npcs) do
        while DoesEntityExist(npc) do
            Wait(0)
            DeleteEntity(npc)
        end
    end
    QBCore.Functions.DeleteVehicle(vehicle)
end


RegisterNetEvent('krane-hitman-call', function(data)
    if HITTING_SOMEONE then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Sender_Mail,
            subject = Config.Target_Acquired_Subject,
            message = Config.Message_Already_Hitting,
            button = {}
        })
        return
    end
    if get_target() then
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = Config.Sender_Mail,
            subject = Config.Target_Acquired_Subject,
            message = Config.Target_Acquired_Text,
            button = {}
        })
        QBCore.Functions.Notify(Config.Target_Acquired_Text, 'success', 7500)
        Go_Hit_Target(get_target())
    else
        QBCore.Functions.Notify(Config.Target_Not_Found_Text, 'error', 7500)
    end
end)

