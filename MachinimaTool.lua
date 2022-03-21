--
-- Set Custom Interface CVar Defaults
--
C_CVar:SetDefault("C_CVAR_WORLD_TIME_SPEED", 0.0166666675359011)
C_CVar:SetDefault("C_CVAR_WORLD_TIME_SPEED_MIN", 0.0166666675359011)
C_CVar:SetDefault("C_CVAR_WORLD_TIME_SPEED_MAX", 50)

C_CVar:SetDefault("C_CVAR_WORLD_NIGHTLIGHT", 1)
C_CVar:SetDefault("C_CVAR_WORLD_NIGHTLIGHT_MIN", 0)
C_CVar:SetDefault("C_CVAR_WORLD_NIGHTLIGHT_MAX", 1)

local function CustomCVarsLoaded()
	SetWorldTimeSpeed(C_CVar:Get("C_CVAR_WORLD_TIME_SPEED"))
	SetWorldTimeSpeed(C_CVar:Get("C_CVAR_WORLD_NIGHTLIGHT"))
end

C_Hook:Register("InterfaceOptions", "VARIABLES_LOADED", CustomCVarsLoaded)

-- [[ MachinimaTool Options Panel ]] --

MachinimaToolPanelOptions = {
	C_CVAR_WORLD_TIME_SPEED = { text = "World Time Speed Rate", minValue = GetCVarMin("C_CVAR_WORLD_TIME_SPEED"), maxValue = GetCVarMax("C_CVAR_WORLD_TIME_SPEED"), valueStep = 0.5, },
	C_CVAR_WORLD_NIGHTLIGHT = { text = "Nightlight", minValue = GetCVarMin("C_CVAR_WORLD_NIGHTLIGHT"), maxValue = GetCVarMax("C_CVAR_WORLD_NIGHTLIGHT"), valueStep = 0.05, },
}

-- @robinsch: init these with game time
local SET_HOUR = select(1, GetGameTime());
local SET_MINUTE = select(2, GetGameTime());

function MachinimaTool_OnLoad(self)
	self.name = "MachinimaTool";
	self.options = MachinimaToolPanelOptions;

	UIDropDownMenu_SetWidth(MachinimaToolAlarmHourDropDown, 30, 40);
	UIDropDownMenu_SetText(MachinimaToolAlarmHourDropDown, format(TIMEMANAGER_24HOUR, 0));
	UIDropDownMenu_Initialize(MachinimaToolAlarmHourDropDown, AlarmHourDropDown_Initialize);

	UIDropDownMenu_SetWidth(MachinimaToolAlarmMinuteDropDown, 30, 40);
	UIDropDownMenu_SetText(MachinimaToolAlarmMinuteDropDown, format(TIMEMANAGER_MINUTE, 0));
	UIDropDownMenu_Initialize(MachinimaToolAlarmMinuteDropDown, AlarmMinuteDropDown_Initialize);

	InterfaceOptionsPanel_OnLoad(self);
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
