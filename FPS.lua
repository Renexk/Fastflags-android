-- ULTRA NO TEXTURES + FAST LOAD (Delta Executor)
-- Quita TODAS las texturas. Teclas y mundo grises. Cielo intacto.

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Calidad mínima
pcall(function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- Lighting optimizado (NO tocamos el cielo)
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 1.5
pcall(function()
    Lighting.Technology = Enum.Technology.Compatibility
end)

-- Desactivar efectos de Lighting (excepto Sky)
for _, v in pairs(Lighting:GetChildren()) do
    if not v:IsA("Sky") then
        if v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect") 
        or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Atmosphere") then
            v.Enabled = false
        end
    end
end

-- Función que elimina TODAS las texturas
local function stripTextures(obj)
    -- Partes normales → plástico gris sin brillo
    if obj:IsA("BasePart") then
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
        obj.CastShadow = false
        -- Forzar color gris si no tiene
        if obj.Color == Color3.new(1,1,1) or obj.Color == Color3.new(0,0,0) then
            obj.Color = Color3.fromRGB(160, 160, 160)
        end
    end

    -- MeshParts → quitar textura completamente
    if obj:IsA("MeshPart") then
        obj.TextureID = ""
        obj.Material = Enum.Material.Plastic
        obj.Reflectance = 0
        obj.CastShadow = false
    end

    -- Decals y Textures → desaparecen
    if obj:IsA("Decal") or obj:IsA("Texture") then
        obj.Transparency = 1
        pcall(function() obj:Destroy() end)
    end

    -- SurfaceAppearance (texturas modernas) → destruir
    if obj:IsA("SurfaceAppearance") then
        pcall(function() obj:Destroy() end)
    end

    -- Partículas, trails, humo, fuego, etc.
    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") 
    or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Beam") then
        obj.Enabled = false
        pcall(function() obj:Destroy() end)
    end

    -- SpecialMeshes
    if obj:IsA("SpecialMesh") then
        obj.TextureId = ""
    end
end

-- Aplicar a TODO el workspace ahora
for _, v in pairs(Workspace:GetDescendants()) do
    stripTextures(v)
end

-- Aplicar a todo lo que se cargue después (cuando avanzas)
Workspace.DescendantAdded:Connect(function(obj)
    task.wait() -- pequeño delay para que el objeto exista
    stripTextures(obj)
end)

-- Optimizar tu personaje
local function cleanCharacter(char)
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        stripTextures(v)
    end
end

if LocalPlayer.Character then
    cleanCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(cleanCharacter)

-- Optimizar otros jugadores
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        cleanCharacter(char)
    end)
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer and plr.Character then
        cleanCharacter(plr.Character)
    end
end

-- Terrain más liviano
local terrain = Workspace:FindFirstChildOfClass("Terrain")
if terrain then
    terrain.WaterWaveSize = 0
    terrain.WaterWaveSpeed = 0
    terrain.WaterReflectance = 0
    terrain.WaterTransparency = 1
end

print("✅ TODAS las texturas eliminadas. Teclas grises. Carga más rápida activada.")
