local addonName = ...
--
-- Set Custom Interface CVar Defaults
--
local defaults = {
	worldTimeSpeed = 0.0166666675359011,
	worldTimeSpeedMin = 0.0166666675359011,
	worldTimeSpeedMax = 50,
	worldNightLight = 1,
	worldNightLightMin = 0,
	worldNightLightMax = 1,
}

RegisterCVar("MT_WorldTimeSpeed", defaults.worldTimeSpeed)
RegisterCVar("MT_NightLight", defaults.worldNightLight)

-- [[ MachinimaTool Options Panel ]] --

MachinimaToolPanelOptions = {
	MT_WorldTimeSpeed = { text = "World Time Speed Rate", minValue = defaults.worldTimeSpeedMin, maxValue = defaults.worldTimeSpeedMax, valueStep = 0.5, },
	MT_NightLight = { text = "Nightlight", minValue = defaults.worldNightLightMin, maxValue = defaults.worldNightLightMax, valueStep = 0.05, },
	wmoCulling = { text = "WMO Culling" },
	terrainCulling = { text = "Terrain Culling" },
}

-- @robinsch: init these with game time
local SET_HOUR = select(1, GetGameTime());
local SET_MINUTE = select(2, GetGameTime());

function MachinimaTool_UpdateSettings(cvar, value)
	MachinimaToolDB[cvar] = value

	if cvar == "MT_WorldTimeSpeed" then
		SetWorldTimeSpeed(value)
	elseif cvar == "MT_NightLight" then
		-- ??
	end
end

function MachinimaTool_RefreshSettings()
	MachinimaTool_UpdateSettings("MT_WorldTimeSpeed", tonumber(GetCVar("MT_WorldTimeSpeed")))
	MachinimaTool_UpdateSettings("MT_NightLight", tonumber(GetCVar("MT_NightLight")))
end

function MachinimaTool_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self.name = addonName;
	self.options = MachinimaToolPanelOptions;

	UIDropDownMenu_SetWidth(MachinimaToolAlarmHourDropDown, 30, 40);
	UIDropDownMenu_SetText(MachinimaToolAlarmHourDropDown, format(TIMEMANAGER_24HOUR, 0));
	UIDropDownMenu_Initialize(MachinimaToolAlarmHourDropDown, AlarmHourDropDown_Initialize);

	UIDropDownMenu_SetWidth(MachinimaToolAlarmMinuteDropDown, 30, 40);
	UIDropDownMenu_SetText(MachinimaToolAlarmMinuteDropDown, format(TIMEMANAGER_MINUTE, 0));
	UIDropDownMenu_Initialize(MachinimaToolAlarmMinuteDropDown, AlarmMinuteDropDown_Initialize);
end

function MachinimaTool_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == addonName then
			MachinimaToolDB = MachinimaToolDB or {
				MT_WorldTimeSpeed = defaults.worldTimeSpeed,
				MT_NightLight = defaults.worldNightLight
			}
			SetCVar("MT_WorldTimeSpeed", MachinimaToolDB["MT_WorldTimeSpeed"])
			SetCVar("MT_NightLight", MachinimaToolDB["MT_NightLight"])
			MachinimaTool_RefreshSettings()
			InterfaceOptionsPanel_OnLoad(self);
		end
	end
end

function MachinimaTool_ResetTimeLocker()
	UIDropDownMenu_SetSelectedValue(MachinimaToolAlarmHourDropDown, 0);
	UIDropDownMenu_SetSelectedValue(MachinimaToolAlarmMinuteDropDown, 0);

	ResetWorldTime();

	MachinimaToolWorldTimeSpeed:SetMinMaxValues(0, 0);
	MachinimaToolWorldTimeSpeed:SetMinMaxValues(0.0166666675359011, 50);
	MachinimaToolWorldTimeSpeed:SetValue(0.0166666675359011);
	MachinimaToolWorldTimeSpeed:Enable();
end

function AlarmHourDropDown_Initialize()
	local info = UIDropDownMenu_CreateInfo();

	local hourMin = 0;
	local hourMax = 23;

	for hour = hourMin, hourMax, 1 do
		info.value = hour;
		info.text = format(TIMEMANAGER_24HOUR, hour);
		info.func = AlarmHourDropDown_OnClick;
		info.checked = nil;
		UIDropDownMenu_AddButton(info);
	end
end

function AlarmMinuteDropDown_Initialize()
	local info = UIDropDownMenu_CreateInfo();

	for minute = 0, 55, 5 do
		info.value = minute;
		info.text = format(TIMEMANAGER_MINUTE, minute);
		info.func = MinuteDropDown_OnClick;
		info.checked = nil;
		UIDropDownMenu_AddButton(info);
	end
end

function AlarmHourDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedValue(MachinimaToolAlarmHourDropDown, self.value);
	SET_HOUR = self.value;

	MachinimaToolWorldTimeSpeed:SetValue(0.0166666675359011);
	MachinimaToolWorldTimeSpeed:Disable();

	SetWorldTime(SET_HOUR, SET_MINUTE);
	SetWorldTimeSpeed(0);
end

function MinuteDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedValue(MachinimaToolAlarmMinuteDropDown, self.value);
	SET_MINUTE = self.value;

	MachinimaToolWorldTimeSpeed:SetValue(0.0166666675359011);
	MachinimaToolWorldTimeSpeed:Disable();

	SetWorldTime(SET_HOUR, SET_MINUTE);
	SetWorldTimeSpeed(0);
end
