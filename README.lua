local function CreateBlackScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BlackScreenGui"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(0.8, 0, 0.2, 0)
    textLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "ЧИТ ВЫЙДЕТ ПОЗЖЕ"
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextWrapped = true
    textLabel.Parent = frame
    
    local function updateTextSize()
        local viewportSize = workspace.CurrentCamera.ViewportSize
        local scale = math.min(viewportSize.X, viewportSize.Y) / 400
        textLabel.TextSize = 28 * scale
    end
    
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateTextSize)
    updateTextSize()
    
    screenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    return screenGui
end

local function MuteAllSounds()
    while true do
        task.wait(0.1)
        
        for _, sound in pairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
                sound.Playing = false
            end
        end
        
        local soundService = game:GetService("SoundService")
        for _, sound in pairs(soundService:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
                sound.Playing = false
            end
        end
        
        for _, sound in pairs(game:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
                sound.Playing = false
            end
        end
    end
end

if not _G.BlackScreenInjected then
    _G.BlackScreenInjected = true
    
    if game:GetService("Players").LocalPlayer then
        CreateBlackScreen()
        
        coroutine.wrap(MuteAllSounds)()
    else
        game:GetService("Players").PlayerAdded:Connect(function(player)
            if player == game:GetService("Players").LocalPlayer then
                CreateBlackScreen()
                coroutine.wrap(MuteAllSounds)()
            end
        end)
    end
    
    game.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Sound") then
            spawn(function()
                wait(0.05)
                descendant.Volume = 0
                descendant.Playing = false
            end)
        end
    end)
end
