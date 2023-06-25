local addonName = ...
--
-- Set Custom Interface CVar Defaults
--
local defaults = {
	worldTimeSpeed = 0.0166666675359011,
	worldTimeSpeedMin = 0.0166666675359011,
	worldTimeSpeedMax = 50,
	worldNightLight = 1,
	worldNightLightMin = 0.05,
	worldNightLightMax = 1,
	worldLightLinearAttenuation = 1,
	worldLightLinearAttenuationMin = 0.005,
	worldLightLinearAttenuationMax = 1,
	worldLightQuadraticAttenuation = 1,
	worldLightQuadraticAttenuationMin = 0.005,
	worldLightQuadraticAttenuationMax = 1,
}

RegisterCVar("MT_WorldTimeSpeed", defaults.worldTimeSpeed)
RegisterCVar("MT_NightLight", defaults.worldNightLight)
RegisterCVar("MT_LightLinearAttenuation", defaults.worldLightLinearAttenuation)
RegisterCVar("MT_LightQuadraticAttenuation", defaults.worldLightQuadraticAttenuation)

-- [[ MachinimaTool Options Panel ]] --

MachinimaToolPanelOptions = {
	MT_WorldTimeSpeed = { text = "World Time Speed Rate", minValue = defaults.worldTimeSpeedMin, maxValue = defaults.worldTimeSpeedMax, valueStep = 0.5, },
	MT_NightLight = { text = "Ambient Shade", minValue = defaults.worldNightLightMin, maxValue = defaults.worldNightLightMax, valueStep = 0.005, },
	MT_LightLinearAttenuation = { text = "Light Linear Attenuation", minValue = defaults.worldLightLinearAttenuationMin, maxValue = defaults.worldLightLinearAttenuationMax, valueStep = 0.0025, },
	MT_LightQuadraticAttenuation = { text = "Light Quadratic Attenuation", minValue = defaults.worldLightQuadraticAttenuationMin, maxValue = defaults.worldLightQuadraticAttenuationMax, valueStep = 0.0025, },
	wmoCulling = { text = "WMO Culling" },
	terrainCulling = { text = "Terrain Culling" },
	useAlphaAmbienceSound = { text = "Ambience Sound (Alpha Client 0.5.3)" },
}

-- @robinsch: init these with game time
local SET_HOUR = select(1, GetGameTime());
local SET_MINUTE = select(2, GetGameTime());

function MachinimaTool_UpdateSettings(cvar, value)
	MachinimaToolDB[cvar] = value

	if cvar == "MT_WorldTimeSpeed" then
		SetWorldTimeSpeed(value)
	elseif cvar == "MT_NightLight" then
		SetCVar("ambientShade", MachinimaToolDB["MT_NightLight"])
	elseif cvar == "MT_LightLinearAttenuation" then
		SetCVar("lightLinearAttenuation", MachinimaToolDB["MT_LightLinearAttenuation"])
	elseif cvar == "MT_LightQuadraticAttenuation" then
		SetCVar("lightQuadraticAttenuation", MachinimaToolDB["MT_LightQuadraticAttenuation"])
	end
end

function MachinimaTool_RefreshSettings()
	MachinimaTool_UpdateSettings("MT_WorldTimeSpeed", tonumber(GetCVar("MT_WorldTimeSpeed")))
	MachinimaTool_UpdateSettings("MT_NightLight", tonumber(GetCVar("MT_NightLight")))
	MachinimaTool_UpdateSettings("MT_LightLinearAttenuation", tonumber(GetCVar("MT_LightLinearAttenuation")))
	MachinimaTool_UpdateSettings("MT_LightQuadraticAttenuation", tonumber(GetCVar("MT_LightQuadraticAttenuation")))
end

function MachinimaTool_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self.name = addonName;
	self.options = MachinimaToolPanelOptions;

	UIDropDownMenu_SetWidth(MachinimaToolHourDropDown, 30, 40);
	UIDropDownMenu_SetText(MachinimaToolHourDropDown, format(TIMEMANAGER_24HOUR, 0));
	UIDropDownMenu_Initialize(MachinimaToolHourDropDown, HourDropDown_Initialize);

	UIDropDownMenu_SetWidth(MachinimaToolMinuteDropDown, 30, 40);
	UIDropDownMenu_SetText(MachinimaToolMinuteDropDown, format(TIMEMANAGER_MINUTE, 0));
	UIDropDownMenu_Initialize(MachinimaToolMinuteDropDown, MinuteDropDown_Initialize);
end

function MachinimaTool_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == addonName then
			MachinimaToolDB = MachinimaToolDB or {
				MT_WorldTimeSpeed = defaults.worldTimeSpeed,
				MT_NightLight = defaults.worldNightLight,
				MT_LightLinearAttenuation = defaults.worldLightLinearAttenuation,
				MT_LightQuadraticAttenuation = defaults.worldLightQuadraticAttenuation,
			}
			SetCVar("MT_WorldTimeSpeed", MachinimaToolDB["MT_WorldTimeSpeed"])
			SetCVar("MT_NightLight", MachinimaToolDB["MT_NightLight"])
			SetCVar("MT_LightLinearAttenuation", MachinimaToolDB["MT_LightLinearAttenuation"])
			SetCVar("MT_LightQuadraticAttenuation", MachinimaToolDB["MT_LightQuadraticAttenuation"])
			MachinimaTool_RefreshSettings()
			InterfaceOptionsPanel_OnLoad(self);
		end
	end
end

function MachinimaTool_ResetTimeLocker()
	UIDropDownMenu_SetSelectedValue(MachinimaToolHourDropDown, 0);
	UIDropDownMenu_SetSelectedValue(MachinimaToolMinuteDropDown, 0);

	ResetWorldTime();

	MachinimaToolWorldTimeSpeed:SetMinMaxValues(0, 0);
	MachinimaToolWorldTimeSpeed:SetMinMaxValues(0.0166666675359011, 50);
	MachinimaToolWorldTimeSpeed:SetValue(0.0166666675359011);
	MachinimaToolWorldTimeSpeed:Enable();
end

function HourDropDown_Initialize()
	local info = UIDropDownMenu_CreateInfo();

	local hourMin = 0;
	local hourMax = 23;

	for hour = hourMin, hourMax, 1 do
		info.value = hour;
		info.text = format(TIMEMANAGER_24HOUR, hour);
		info.func = HourDropDown_OnClick;
		info.checked = nil;
		UIDropDownMenu_AddButton(info);
	end
end

function MinuteDropDown_Initialize()
	local info = UIDropDownMenu_CreateInfo();

	for minute = 0, 55, 5 do
		info.value = minute;
		info.text = format(TIMEMANAGER_MINUTE, minute);
		info.func = MinuteDropDown_OnClick;
		info.checked = nil;
		UIDropDownMenu_AddButton(info);
	end
end

function HourDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedValue(MachinimaToolHourDropDown, self.value);
	SET_HOUR = self.value;

	MachinimaToolWorldTimeSpeed:SetValue(0.0166666675359011);
	MachinimaToolWorldTimeSpeed:Disable();

	SetWorldTime(SET_HOUR, SET_MINUTE);
	SetWorldTimeSpeed(0);
end

function MinuteDropDown_OnClick(self)
	UIDropDownMenu_SetSelectedValue(MachinimaToolMinuteDropDown, self.value);
	SET_MINUTE = self.value;

	MachinimaToolWorldTimeSpeed:SetValue(0.0166666675359011);
	MachinimaToolWorldTimeSpeed:Disable();

	SetWorldTime(SET_HOUR, SET_MINUTE);
	SetWorldTimeSpeed(0);
end
