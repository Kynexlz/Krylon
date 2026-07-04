--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Configuration
local Config = {
    Themes = {
        ["Main"] = {
            Background = Color3.fromRGB(25, 25, 25),
            Accent = Color3.fromRGB(255, 255, 255),
            Text = Color3.fromRGB(255, 255, 255),
            ToggleOn = Color3.fromRGB(255, 255, 255),
            ToggleOff = Color3.fromRGB(100, 100, 100),
            Slider = Color3.fromRGB(255, 255, 255),
            KeyBind = Color3.fromRGB(150, 150, 150)
        },
        ["Purple"] = {
            Background = Color3.fromRGB(15, 15, 25),
            Accent = Color3.fromRGB(150, 50, 200),
            Text = Color3.fromRGB(200, 150, 255),
            ToggleOn = Color3.fromRGB(150, 50, 200),
            ToggleOff = Color3.fromRGB(80, 80, 120),
            Slider = Color3.fromRGB(150, 50, 200),
            KeyBind = Color3.fromRGB(100, 70, 150)
        },
        ["Yellow"] = {
            Background = Color3.fromRGB(30, 30, 20),
            Accent = Color3.fromRGB(255, 200, 50),
            Text = Color3.fromRGB(255, 230, 150),
            ToggleOn = Color3.fromRGB(255, 200, 50),
            ToggleOff = Color3.fromRGB(150, 120, 70),
            Slider = Color3.fromRGB(255, 200, 50),
            KeyBind = Color3.fromRGB(180, 140, 60)
        }
    },
    CurrentTheme = "Main"
}

--// UI Library
local UILib = {}
UILib.__index = UILib

function UILib.new()
    local self = setmetatable({}, UILib)
    
    -- Create ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "CustomHub"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Window
    self.MainWindow = Instance.new("Frame")
    self.MainWindow.Name = "MainWindow"
    self.MainWindow.Size = UDim2.new(0, 600, 0, 400)
    self.MainWindow.Position = UDim2.new(0.5, -300, 0.5, -200)
    self.MainWindow.BackgroundColor3 = Config.Themes[Config.CurrentTheme].Background
    self.MainWindow.BorderSizePixel = 0
    self.MainWindow.Parent = self.ScreenGui
    
    -- Corner radius for main window
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainWindow
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = Config.Themes[Config.CurrentTheme].Accent
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainWindow
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- Title Text
    self.TitleText = Instance.new("TextLabel")
    self.TitleText.Name = "TitleText"
    self.TitleText.Size = UDim2.new(1, -30, 1, 0)
    self.TitleText.Position = UDim2.new(0, 0, 0, 0)
    self.TitleText.BackgroundTransparency = 1
    self.TitleText.Text = "Custom Hub"
    self.TitleText.TextColor3 = Config.Themes[Config.CurrentTheme].Text
    self.TitleText.TextSize = 16
    self.TitleText.Font = Enum.Font.SourceSansBold
    self.TitleText.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleText.Parent = self.TitleBar
    
    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 30, 1, 0)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 0)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = "X"
    self.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseButton.TextSize = 16
    self.CloseButton.Font = Enum.Font.SourceSansBold
    self.CloseButton.Parent = self.TitleBar
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, 0, 0, 30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 30)
    self.TabContainer.BackgroundTransparency = 1
    self.TabContainer.Parent = self.MainWindow
    
    -- Content Container
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, 0, 1, -60)
    self.ContentContainer.Position = UDim2.new(0, 0, 0, 60)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.BorderSizePixel = 0
    self.ContentContainer.ScrollBarThickness = 6
    self.ContentContainer.Parent = self.MainWindow
    
    -- UIListLayout for content
    local contentList = Instance.new("UIListLayout")
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Padding = UDim.new(0, 5)
    contentList.Parent = self.ContentContainer
    
    -- UIPadding for content
    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingLeft = UDim.new(0, 10)
    contentPadding.PaddingRight = UDim.new(0, 10)
    contentPadding.PaddingTop = UDim.new(0, 10)
    contentPadding.Parent = self.ContentContainer
    
    -- Tabs storage
    self.Tabs = {}
    self.ActiveTab = nil
    
    -- Dragging functionality
    self:MakeDraggable()
    
    -- Close button functionality
    self.CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui.Enabled = false
    end)
    
    self.ScreenGui.Parent = PlayerGui
    
    return self
end

--// Draggable Function
function UILib:MakeDraggable()
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainWindow.Position
            
            input:CaptureGestureIfEnabled()
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            self.MainWindow.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

--// Create Tab
function UILib:CreateTab(name)
    local tab = {}
    
    -- Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name .. "Tab"
    tab.Button.Size = UDim2.new(0, 100, 1, 0)
    tab.Button.BackgroundColor3 = Config.Themes[Config.CurrentTheme].Accent
    tab.Button.BackgroundTransparency = 0.5
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = name
    tab.Button.TextColor3 = Config.Themes[Config.CurrentTheme].Text
    tab.Button.TextSize = 14
    tab.Button.Font = Enum.Font.SourceSans
    tab.Button.Parent = self.TabContainer
    
    -- Content Frame
    tab.Content = Instance.new("Frame")
    tab.Content.Name = name .. "Content"
    tab.Content.Size = UDim2.new(1, 0, 1, 0)
    tab.Content.BackgroundTransparency = 1
    tab.Content.Visible = false
    tab.Content.Parent = self.ContentContainer
    
    -- UIListLayout for tab content
    local tabList = Instance.new("UIListLayout")
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Padding = UDim.new(0, 5)
    tabList.Parent = tab.Content
    
    table.insert(self.Tabs, tab)
    
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(name)
    end)
    
    if #self.Tabs == 1 then
        self:SelectTab(name)
    end
    
    return tab
end

--// Select Tab
function UILib:SelectTab(name)
    for _, tab in ipairs(self.Tabs) do
        if tab.Button.Name == name .. "Tab" then
            tab.Content.Visible = true
            tab.Button.BackgroundTransparency = 0
        else
            tab.Content.Visible = false
            tab.Button.BackgroundTransparency = 0.5
        end
    end
    self.ActiveTab = name
end

--// Change Theme
function UILib:ChangeTheme(themeName)
    if not Config.Themes[themeName] then return end
    
    Config.CurrentTheme = themeName
    local theme = Config.Themes[themeName]
    
    -- Update MainWindow background
    self.MainWindow.BackgroundColor3 = theme.Background
    
    -- Update TitleBar
    self.TitleBar.BackgroundColor3 = theme.Accent
    self.TitleText.TextColor3 = theme.Text
    
    -- Update Tab Buttons
    for _, tab in ipairs(self.Tabs) do
        tab.Button.BackgroundColor3 = theme.Accent
        tab.Button.TextColor3 = theme.Text
    end
end

--// Create Button
function UILib:CreateButton(tab, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = Config.Themes[Config.CurrentTheme].Accent
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Config.Themes[Config.CurrentTheme].Text
    button.TextSize = 14
    button.Font = Enum.Font.SourceSans
    button.Parent = tab.Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    return button
end

--// Create Toggle
function UILib:CreateToggle(tab, text, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = tab.Content
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Config.Themes[Config.CurrentTheme].Text
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 40, 0, 20)
    toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
    toggleButton.BackgroundColor3 = default and Config.Themes[Config.CurrentTheme].ToggleOn or Config.Themes[Config.CurrentTheme].ToggleOff
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = ""
    toggleButton.Parent = toggleFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleButton
    
    local indicator = Instance.new("Frame")
    indicator.Name = "Indicator"
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(0, default and 20 or 2, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Parent = toggleButton
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 8)
    indicatorCorner.Parent = indicator
    
    local state = default or false
    
    local function updateToggle()
        state = not state
        toggleButton.BackgroundColor3 = state and Config.Themes[Config.CurrentTheme].ToggleOn or Config.Themes[Config.CurrentTheme].ToggleOff
        indicator.Position = UDim2.new(0, state and 20 or 2, 0.5, -8)
        
        if callback then
            callback(state)
        end
    end
    
    toggleButton.MouseButton1Click:Connect(updateToggle)
    
    return {
        SetValue = function(value)
            state = value
            toggleButton.BackgroundColor3 = state and Config.Themes[Config.CurrentTheme].ToggleOn or Config.Themes[Config.CurrentTheme].ToggleOff
            indicator.Position = UDim2.new(0, state and 20 or 2, 0.5, -8)
        end,
        GetValue = function()
            return state
        end
    }
end

--// Create Slider
function UILib:CreateSlider(tab, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = tab.Content
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. math.floor(default)
    label.TextColor3 = Config.Themes[Config.CurrentTheme].Text
    label.TextSize = 14
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBackground = Instance.new("Frame")
    sliderBackground.Name = "SliderBackground"
    sliderBackground.Size = UDim2.new(1, 0, 0, 10)
    sliderBackground.Position = UDim2.new(0, 0, 0, 30)
    sliderBackground.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBackground.BorderSizePixel = 0
    sliderBackground.Parent = sliderFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderBackground
    
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0
