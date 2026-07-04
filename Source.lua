--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

--// Variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Key System Configuration
local KeySystem = {
    Key = "custom_key_123", -- Anyone can change this
    ValidKeys = {
        "custom_key_123",
        "free_key_456",
        "open_source"
    },
    IsAuthorized = false
}

--// Theme Configuration
local Themes = {
    Default = {
        Background = Color3.fromRGB(30, 30, 30),
        Accent = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        ToggleOn = Color3.fromRGB(255, 255, 255),
        ToggleOff = Color3.fromRGB(100, 100, 100),
        Slider = Color3.fromRGB(255, 255, 255)
    },
    RedBlack = {
        Background = Color3.fromRGB(0, 0, 0),
        Accent = Color3.fromRGB(255, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        ToggleOn = Color3.fromRGB(255, 0, 0),
        ToggleOff = Color3.fromRGB(50, 50, 50),
        Slider = Color3.fromRGB(255, 0, 0)
    },
    LightBlue = {
        Background = Color3.fromRGB(240, 248, 255),
        Accent = Color3.fromRGB(173, 216, 230),
        Text = Color3.fromRGB(0, 0, 0),
        ToggleOn = Color3.fromRGB(173, 216, 230),
        ToggleOff = Color3.fromRGB(200, 200, 200),
        Slider = Color3.fromRGB(173, 216, 230)
    }
}

local CurrentTheme = Themes.Default

--// Utility Functions
local function CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

local function Tween(element, properties, time)
    time = time or 0.3
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(element, tweenInfo, properties)
    tween:Play()
    return tween
end

--// UI Creation Functions
local function CreateMainFrame()
    local screenGui = CreateElement("ScreenGui", {
        Name = "CustomHub",
        Parent = PlayerGui,
        ResetOnSpawn = false,
        Enabled = false
    })
    
    local mainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Parent = screenGui,
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = CurrentTheme.Background,
        BorderSizePixel = 0
    })
    
    local corner = CreateElement("UICorner", {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    local uiStroke = CreateElement("UIStroke", {
        Parent = mainFrame,
        Color = CurrentTheme.Accent,
        Thickness = 2
    })
    
    -- Title Bar
    local titleBar = CreateElement("Frame", {
        Name = "TitleBar",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 0.5,
        BackgroundColor3 = CurrentTheme.Accent
    })
    
    local titleText = CreateElement("TextLabel", {
        Name = "Title",
        Parent = titleBar,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "Custom Script Hub",
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        TextColor3 = CurrentTheme.Text,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Close Button
    local closeButton = CreateElement("TextButton", {
        Name = "CloseButton",
        Parent = titleBar,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        TextColor3 = CurrentTheme.Text
    })
    
    -- Theme Selector
    local themeSelector = CreateElement("TextButton", {
        Name = "ThemeSelector",
        Parent = titleBar,
        Size = UDim2.new(0, 80, 0, 20),
        Position = UDim2.new(1, -120, 0, 5),
        BackgroundColor3 = CurrentTheme.Background,
        Text = "Change Theme",
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = CurrentTheme.Text
    })
    
    local themeCorner = CreateElement("UICorner", {
        Parent = themeSelector,
        CornerRadius = UDim.new(0, 4)
    })
    
    -- Content Container
    local contentContainer = CreateElement("Frame", {
        Name = "ContentContainer",
        Parent = mainFrame,
        Size = UDim2.new(1, -20, 1, -40),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1
    })
    
    -- Scrollable Content
    local scrollFrame = CreateElement("ScrollingFrame", {
        Name = "ScrollFrame",
        Parent = contentContainer,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = CurrentTheme.Accent
    })
    
    local uiListLayout = CreateElement("UIListLayout", {
        Parent = scrollFrame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 10)
    })
    
    return screenGui, mainFrame, scrollFrame, themeSelector, closeButton
end

local function CreateKeySystemUI()
    local screenGui = CreateElement("ScreenGui", {
        Name = "KeySystem",
        Parent = PlayerGui,
        ResetOnSpawn = false
    })
    
    local mainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Parent = screenGui,
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100),
        BackgroundColor3 = CurrentTheme.Background,
        BorderSizePixel = 0
    })
    
    local corner = CreateElement("UICorner", {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    local uiStroke = CreateElement("UIStroke", {
        Parent = mainFrame,
        Color = CurrentTheme.Accent,
        Thickness = 2
    })
    
    local titleText = CreateElement("TextLabel", {
        Name = "Title",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Text = "Key System",
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        TextColor3 = CurrentTheme.Text
    })
    
    local keyInput = CreateElement("TextBox", {
        Name = "KeyInput",
        Parent = mainFrame,
        Size = UDim2.new(0, 300, 0, 30),
        Position = UDim2.new(0.5, -150, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        PlaceholderText = "Enter Key...",
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = CurrentTheme.Text,
        ClearTextOnFocus = false
    })
    
    local inputCorner = CreateElement("UICorner", {
        Parent = keyInput,
        CornerRadius = UDim.new(0, 4)
    })
    
    local submitButton = CreateElement("TextButton", {
        Name = "SubmitButton",
        Parent = mainFrame,
        Size = UDim2.new(0, 100, 0, 30),
        Position = UDim2.new(0.5, -50, 0, 100),
        BackgroundColor3 = CurrentTheme.Accent,
        Text = "Submit",
        Font = Enum.Font.SourceSansBold,
        TextSize = 16,
        TextColor3 = CurrentTheme.Text
    })
    
    local buttonCorner = CreateElement("UICorner", {
        Parent = submitButton,
        CornerRadius = UDim.new(0, 4)
    })
    
    local statusText = CreateElement("TextLabel", {
        Name = "StatusText",
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 1, -25),
        BackgroundTransparency = 1,
        Text = "",
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 50, 50)
    })
    
    return screenGui, keyInput, submitButton, statusText
end

local function CreateButton(parent, text, callback)
    local button = CreateElement("TextButton", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = CurrentTheme.Accent,
        Text = text,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = CurrentTheme.Text
    })
    
    local corner = CreateElement("UICorner", {
        Parent = button,
        CornerRadius = UDim.new(0, 4)
    })
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return button
end

local function CreateToggle(parent, text)
    local toggleContainer = CreateElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1
    })
    
    local label = CreateElement("TextLabel", {
        Parent = toggleContainer,
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = CurrentTheme.Text,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local toggleButton = CreateElement("Frame", {
        Parent = toggleContainer,
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0.5, -10),
        BackgroundColor3 = CurrentTheme.ToggleOff,
        BorderSizePixel = 0
    })
    
    local toggleCorner = CreateElement("UICorner", {
        Parent = toggleButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    local toggleIndicator = CreateElement("Frame", {
        Parent = toggleButton,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    })
    
    local indicatorCorner = CreateElement("UICorner", {
        Parent = toggleIndicator,
        CornerRadius = UDim.new(1, 0)
    })
    
    local toggled = false
    
    toggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        Tween(toggleButton, {BackgroundColor3 = toggled and CurrentTheme.ToggleOn or CurrentTheme.ToggleOff})
        Tween(toggleIndicator, {Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)})
    end)
    
    return toggleContainer, function() return toggled end
end

local function CreateSlider(parent, text, min, max, default)
    local sliderContainer = CreateElement("Frame", {
        Parent = parent,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1
    })
    
    local label = CreateElement("TextLabel", {
        Parent = sliderContainer,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = text .. ": " .. tostring(default),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = CurrentTheme.Text
    })
    
    local sliderBackground = CreateElement("Frame", {
        Parent = sliderContainer,
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0
    })
    
    local sliderCorner = CreateElement("UICorner", {
        Parent = sliderBackground,
        CornerRadius = UDim.new(0, 5)
    })
    
    local sliderFill = CreateElement("Frame", {
        Parent = sliderBackground,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = CurrentTheme.Slider,
        BorderSizePixel = 0
    })
    
    local fillCorner = CreateElement("UICorner", {
        Parent = sliderFill,
        CornerRadius = UDim.new(0, 5)
    })
    
    local sliderButton = CreateElement("TextButton", {
        Parent = sliderBackground,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        AutoButtonColor = false
    })
    
    local buttonCorner = CreateElement("UICorner", {
        Parent = sliderButton,
        CornerRadius = UDim.new(1, 0)
    })
    
    local dragging = false
    local value = default
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            local mousePos = UserInputService:GetMouseLocation()
            local relativePos = (mousePos.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X
            relativePos = math.clamp(relativePos, 0, 1)
            
            value = min + (relativePos * (max - min))
            label.Text = text .. ": " .. math.floor(value + 0.5)
            
            Tween(sliderFill, {Size = UDim2.new(relativePos, 0, 1, 0)})
