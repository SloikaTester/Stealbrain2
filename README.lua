-- Настройки
local settings = {
    delayBeforeStart = 5,          -- Задержка перед началом (секунды)
    banMessage = "Ты использовал читы?",
    finalMessage = "BAN",
    chatSpamMessage = "lol",
    chatSpamCount = 3,            -- Количество повторений
    imageId = 134397257423789,    -- ID изображения для финала (ЧИСЛОМ без кавычек!)
    moveCharacter = true,         -- Переносить ли персонажа
    disableGui = true,            -- Отключать ли интерфейс
    blockExit = true              -- Блокировать ли выход
}

-- Основной код
local function CreateBanScreen()
    -- Получаем сервисы
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local StarterGui = game:GetService("StarterGui")
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local TweenService = game:GetService("TweenService")
    
    -- Ожидаем загрузку игрока
    local player = Players.LocalPlayer
    while not player do
        Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        player = Players.LocalPlayer
    end

    -- Функция для безопасного выполнения
    local function SafeCall(func, ...)
        local success, err = pcall(func, ...)
        if not success then
            warn("Ошибка: " .. tostring(err))
        end
    end

    -- Создаем черный экран
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BanScreen"
    screenGui.IgnoreGuiInset = true
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    -- Отключаем интерфейс
    if settings.disableGui then
        SafeCall(function()
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
        end)
    end

    -- Блокируем выход
    if settings.blockExit then
        SafeCall(function()
            local conn
            conn = game:GetService("GuiService").MenuOpened:Connect(function()
                game:GetService("GuiService"):CloseMenu()
            end)
        end)
    end

    -- Переносим персонажа
    if settings.moveCharacter then
        SafeCall(function()
            local character = player.Character
            if not character then
                player.CharacterAdded:Wait()
                character = player.Character
            end
            character:MoveTo(Vector3.new(0, -500, 0))
        end)
    end

    -- Отключаем звуки
    SafeCall(function()
        for _, sound in pairs(workspace:GetDescendants()) do
            if sound:IsA("Sound") then
                sound:Stop()
            end
        end
    end)

    -- Функция для анимированного текста
    local function AnimateText(label, text, speed)
        label.Text = ""
        for i = 1, #text do
            label.Text = string.sub(text, 1, i)
            task.wait(speed)
        end
    end

    -- Создаем текст
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -40, 0.5, 0)
    textLabel.Position = UDim2.new(0, 20, 0.25, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextSize = 32
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.Text = ""
    textLabel.TextWrapped = true
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.Parent = frame

    -- Основная последовательность
    coroutine.wrap(function()
        -- Начальная задержка
        task.wait(settings.delayBeforeStart)

        -- Анимация текста
        AnimateText(textLabel, "...", 0.2)
        task.wait(1)
        AnimateText(textLabel, settings.banMessage, 0.05)
        task.wait(2)
        AnimateText(textLabel, "...", 0.1)
        task.wait(1)
        AnimateText(textLabel, settings.finalMessage, 0.03)

        -- Спам в чат
        SafeCall(function()
            local chatEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if chatEvent then
                local sayMessage = chatEvent:FindFirstChild("SayMessageRequest") or chatEvent:FindFirstChild("SayMessage")
                if sayMessage then
                    for i = 1, settings.chatSpamCount do
                        sayMessage:FireServer(settings.chatSpamMessage, "All")
                        task.wait(0.5)
                    end
                end
            end
        end)

        -- Показываем изображение
        task.wait(2)
        textLabel:Destroy()
        
        local imageLabel = Instance.new("ImageLabel")
        imageLabel.Size = UDim2.new(1, 0, 1, 0)
        imageLabel.BackgroundColor3 = Color3.new(0, 0, 0)
        imageLabel.Image = "rbxassetid://"..tostring(settings.imageId)
        imageLabel.ScaleType = Enum.ScaleType.Fit
        imageLabel.Parent = frame

        -- Блокируем ввод
        SafeCall(function()
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    -- Блокируем все клавиши
                end
            end)
        end)
    end)()
end

-- Запускаем скрипт
CreateBanScreen()
