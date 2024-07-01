local islandVec = vector3(4840.571, -5174.425, 2.0)
local _isCloseToCayo = false
local _isCayoMinimapLoaded = false

local cayoFixBlip = AddBlipForCoord(5943.0, -6272.0, 0)
SetBlipSprite(cayoFixBlip, 575)
SetBlipDisplay(cayoFixBlip, 4)
SetBlipScale(cayoFixBlip, 0.0)
SetBlipColour(cayoFixBlip, 0)
SetBlipAsShortRange(cayoFixBlip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Cayo Perico")
EndTextCommandSetBlipName(cayoFixBlip)

Citizen.CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(GetPlayerPed(-1))
        local isCloseToCayo = #(pCoords - islandVec) < 2000.0

        if _isCloseToCayo ~= isCloseToCayo then
            _isCloseToCayo = isCloseToCayo
            _isCayoMinimapLoaded = isCloseToCayo

            SetIslandEnabled("HeistIsland", isCloseToCayo)
            SetUseIslandMap(isCloseToCayo)
            SetAiGlobalPathNodesType(isCloseToCayo and 1 or 0)
            SetScenarioGroupEnabled('Heist_Island_Peds', isCloseToCayo)
            SetAudioFlag('PlayerOnDLCHeist4Island', isCloseToCayo)
            SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', isCloseToCayo, true)
            SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', not isCloseToCayo, true)
            
            SetToggleMinimapHeistIsland(isCloseToCayo)
        end

        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local wait = 500

        if IsPauseMenuActive() and not IsMinimapInInterior() then
            if _isCayoMinimapLoaded then
                _isCayoMinimapLoaded = false
                SetToggleMinimapHeistIsland(false)
            end

            SetRadarAsExteriorThisFrame()
            SetRadarAsInteriorThisFrame(GetHashKey("h4_fake_islandx"), 4700.0, -5145.0, 0, 0)
            wait = 0
        elseif not _isCayoMinimapLoaded and _isCloseToCayo then
            _isCayoMinimapLoaded = true
            SetToggleMinimapHeistIsland(true)
        end

        Citizen.Wait(wait)
    end
end)
