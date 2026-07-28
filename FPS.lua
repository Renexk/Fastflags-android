-- FastFlags + Ultra No Textures para Delta

local flags = {
    ["DFIntTaskSchedulerTargetFps"] = "99999",
    ["FFlagTaskSchedulerLimitTargetFpsTo2402"] = "False",
    ["FFlagGameBasicSettingsFramerateCap5"] = "False",
    ["DFIntDebugFRMQualityLevelOverride"] = "1",
    ["FIntRomarkStartWithGraphicQualityLevel"] = "1",
    ["FFlagDisablePostFx"] = "True",
    ["FFlagDisableBloom"] = "True",
    ["FFlagDisableDepthOfField"] = "True",
    ["FFlagDisableShadows"] = "True",
    ["FFlagDisableGlobalShadows"] = "True",
    ["FIntRenderShadowIntensity"] = "0",
    ["DFFlagDebugPauseVoxelizer"] = "True",
    ["DFFlagTextureQualityOverrideEnabled"] = "True",
    ["DFIntTextureQualityOverride"] = "0",
    ["DFIntTextureCompositorActiveJobs"] = "0",
    ["FStringPartTexturePackTable2022"] = "",
    ["FStringPartTexturePackTablePre2022"] = "",
    ["FStringTerrainMaterialTable2022"] = "",
    ["FStringTerrainMaterialTablePre2022"] = "",
    ["FIntFRMMinGrassDistance"] = "0",
    ["FIntFRMMaxGrassDistance"] = "0",
    ["FIntRenderGrassDetailStrands"] = "0",
    ["FIntRenderGrassHeightScaler"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistance"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL12"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL23"] = "0",
    ["DFIntCSGLevelOfDetailSwitchingDistanceL34"] = "0",
    ["FIntDebugForceMSAASamples"] = "0",
    ["FIntRenderLocalLightUpdatesMax"] = "1",
    ["FIntRenderLocalLightUpdatesMin"] = "1",
    ["FFlagFastGPULightCulling3"] = "True",
    ["FFlagEnableReducedLatency"] = "True",
    ["DFIntPhysicsStepsPerFrame"] = "1",
    ["FFlagDebugDisplayFPS"] = "True"
}

-- Intentar aplicar FastFlags (si Delta lo soporta)
pcall(function()
    for flag, value in pairs(flags) do
        setfflag(flag, value)
    end
end)

-- Parte de quitar TODAS las texturas (esto sí se nota mucho)
local function strip(obj)
    if obj:IsA("BasePart") or obj:IsA("MeshPart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
        obj.CastShadow = false
        if obj:IsA("MeshPart") then
            obj.TextureID = ""
        end
    elseif obj:IsA("Decal") or obj:IsA("Texture") or obj:IsA("SurfaceAppearance") then
        pcall(function() obj:Destroy() end)
    elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") then
        obj.Enabled = false
    end
end

for _, v in pairs(workspace:GetDescendants()) do
    strip(v)
end

workspace.DescendantAdded:Connect(strip)

-- Lighting
local Lighting = game:GetService("Lighting")
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

print("✅ FastFlags + No Textures aplicados")
