local api = require("api")
local DISPLAY = require("hot_swap/display")
local SETTINGS = require("hot_swap/settings")

local dataFile = {}
dataFile.Name = "hot_swap/gears.lua"

local hot_swap = {
    name = "Hot Swap",
    version = "0.5.1",
    author = "MikeTheShadow & Psejik",
    desc = "A plugin to hotswap gear and titles."
}

-- чтение из файла
GetSavedItems = function(reverse)
    if reverse == nil then reverse = false end
    local savedData = api.File:Read(dataFile.Name)
    return savedData or {}
end

--[[
local function GetSavedItems()
    local savedData = api.File:Read(dataFileName)
    return savedData or {}
end
]]

--запись в файл массива
SaveItems = function(gears) api.File:Write(dataFile.Name, gears) end

local function OnLoad()
	-- чтение данных из общих настроек
    local settings = api.GetSettings("hot_swap")
	
	-- набор гиров берем из отдельного файла
	dataFile.gear_sets = GetSavedItems()
	--api.Log:Err(hot_swap.name .. " data loaded")
	
	-- сохранение пустого массива при запуске, если не было обнаружено старого
    if dataFile.gear_sets == nil then
        dataFile.gear_sets = {}
        --api.SaveSettings()
		SaveItems(dataFile.gear_sets)
    end
	
    settings.show_creation_window = true
    DISPLAY.CreateMainDisplay(settings, dataFile.gear_sets)
    SETTINGS.CreateSettingsWindow(settings, dataFile.gear_sets)
end

local function OnUpdate()
    DISPLAY.Update()
end

local function OnUnload()
    DISPLAY.Destroy()
    SETTINGS.Destroy()
end

local function OnSettingToggle()
    SETTINGS.Toggle()
end

hot_swap.OnLoad = OnLoad
api.On("UPDATE", OnUpdate)
hot_swap.OnUnload = OnUnload
hot_swap.OnSettingToggle = OnSettingToggle

return hot_swap



-- ################


-- добавление в массив
--[[
    local savedData = UI.GetSavedItems()

    local existingData = savedData[realIndex]
	
    if existingData then
        for i = 1, #savedData do
            if i == realIndex then savedData[i] = data end
        end
    else
        table.insert(savedData, data)
    end
    hot_swap.SaveItems(savedData)
]]