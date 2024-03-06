local addonName = ...

-- [[ AmbientMod Options Panel ]] --

AmbientModPanelOptions = {
	worldTimeSpeed = { text = "Time Speed", minValue = 0.0166666675359011, maxValue = 75.0, valueStep = 0.5, },
	ambientShade = { text = "Ambient Shade", minValue = 0.05, maxValue = 1, valueStep = 0.005, },
	lightLinearAttenuation = { text = "Light Radius", minValue = 0.005, maxValue = 1, valueStep = 0.0025, },
	lightQuadraticAttenuation = { text = "Light \"Cube\"", minValue = 0.005, maxValue = 1.0, valueStep = 0.0025, },
	fogDistance = { text = "Fog Distance", minValue = 100, maxValue = 1600, valueStep = 1.0, },
	fogDensity = { text = "Fog Density", minValue = 0.001, maxValue = 1.10, valueStep = 0.0025, },
	wmoCulling = { text = "WMO Culling" },
	terrainCulling = { text = "Terrain Culling" },
	entityCulling = { text = "Entity Culling" },
	entityShadows = { text = "Entity Shadows" },
	staticLOD = { text = "Static LOD" },
	lightCulling = { text = "Light Culling" },
	lightLimitFix = { text = "Light Limit Patch" },
	overrideDayProgress = { text = "Day Progress Override", minValue = 0.005, maxValue = 1.0, valueStep = 0.005, },
}

function AmbientMod_OnLoad(self)
	self:RegisterEvent("ADDON_LOADED")
	self.name = addonName;
	self.options = AmbientModPanelOptions;
end

function AmbientMod_OnEvent(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon == addonName then
			InterfaceOptionsPanel_OnLoad(self);
		end
	end
end

function AmbientMod_ResetTimeLocker()
	ResetWorldTime();

	SetCVar("overrideDayProgress", 0.0);

	AmbientModWorldTimeSpeed:SetValue(0.0166666675359011);
	AmbientModWorldTimeSpeed:Enable();
end
