Config = {}

Config.Distance = 10.0 -- Distance to target to be able to call hitman on him.
Config.Target_NPCs = true -- allow to hit npcs that are not players.
Config.Draw_Marker_On_Target = true -- Draw marker on target.

Config.Gang_Male_Model = "g_m_m_chicold_01"
Config.Gang_Car = "schafter3"
Config.Start_Position_For_Gang = vector3(-240.1, -617.87, 33.94)



Config.Min_Health_On_Target_For_Gang_To_Leave = 10
--[[
    This is used in case you must keep a player above a certain HP
    this way the peds will leave if he is on the ground
]]


Config.Target_Acquired_Text = "A gang is on the way!" -- Text that will be displayed when target is found when you press "call gang".
Config.Target_Not_Found_Text = "There is no-one around you!"





--[[
    MAIL
]]
Config.Sender_Mail = "The Gang"
Config.Subject = "Done."
Config.Target_Acquired_Subject = "Got it."
Config.Message = "It has been done."

Config.Message_Already_Hitting = "We are busy right now."
