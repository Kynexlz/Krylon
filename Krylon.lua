-- Kryon Executor UI
-- Modern Delta-style interface

local Kryon = {}
Kryon.__index = Kryon

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KryonExecutor"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

-- Main Window
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.Size = UDim2.new(0, 500, 0, 350)
MainWindow.Position = UDim2.new(0.5, -250, 0.5, -175)
MainWindow.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainWindow.BorderSizePixel = 0
MainWindow.Active = true
MainWindow.Draggable = true
MainWindow.Parent = ScreenGui

-- Window Corner Radius
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainWindow

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainWindow

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 100, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "Kryon"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Accent Line
local AccentLine = Instance.new("Frame")
AccentLine.Name = "AccentLine"
AccentLine.Size = UDim2.new(0, 4, 1, 0)
AccentLine.Position = UDim2.new(0, 0, 0, 0)
AccentLine.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TopBar

-- Side Tab
local SideTab = Instance.new("Frame")
SideTab.Name = "SideTab"
SideTab.Size = UDim2.new(0, 40, 1, -30)
SideTab.Position = UDim2.new(0, 0, 0, 30)
SideTab.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
SideTab.BorderSizePixel = 0
SideTab.Parent = MainWindow

local SideTabCorner = Instance.new("UICorner")
SideTabCorner.CornerRadius = UDim.new(0, 8)
SideTabCorner.Parent = SideTab

-- Tab Buttons
local tabs = {"Execute", "ScriptHub", "Settings"}
local tabButtons = {}

for i, tabName in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Name = tabName .. "Tab"
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 40)
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.Gotham
    btn.Text = tabName
    btn.TextColor3 = Color3.fromRGB(150, 150, 160)
    btn.TextSize = 12
    btn.Parent = SideTab
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 160)}):Play()
    end)
    
    table.insert(tabButtons, btn)
end

-- Active Tab Indicator
local ActiveIndicator = Instance.new("Frame")
ActiveIndicator.Name = "ActiveIndicator"
ActiveIndicator.Size = UDim2.new(1, 0, 0, 40)
ActiveIndicator.Position = UDim2.new(0, 0, 0, 0)
ActiveIndicator.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
ActiveIndicator.BorderSizePixel = 0
ActiveIndicator.Parent = SideTab

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -40, 1, -30)
ContentContainer.Position = UDim2.new(0, 40, 0, 30)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainWindow

-- Execute Tab
local ExecuteTab = Instance.new("Frame")
ExecuteTab.Name = "ExecuteTab"
ExecuteTab.Size = UDim2.new(1, 0, 1, 0)
ExecuteTab.BackgroundTransparency = 1
ExecuteTab.Visible = true
ExecuteTab.Parent = ContentContainer

-- Script Box
local ScriptBox = Instance.new("TextBox")
ScriptBox.Name = "ScriptBox"
ScriptBox.Size = UDim2.new(1, -20, 1, -100)
ScriptBox.Position = UDim2.new(0, 10, 0, 10)
ScriptBox.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
ScriptBox.BorderSizePixel = 0
ScriptBox.Font = Enum.Font.Code
ScriptBox.Text = ""
ScriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
ScriptBox.TextSize = 14
ScriptBox.TextXAlignment = Enum.TextXAlignment.Left
ScriptBox.TextYAlignment = Enum.TextYAlignment.Top
ScriptBox.ClearTextOnFocus = false
ScriptBox.MultiLine = true
ScriptBox.Parent = ExecuteTab

local ScriptBoxCorner = Instance.new("UICorner")
ScriptBoxCorner.CornerRadius = UDim.new(0, 6)
ScriptBoxCorner.Parent = ScriptBox

-- Buttons
local buttonNames = {"Execute", "Save", "Clear", "Paste"}
local buttons = {}

for i, btnName in ipairs(buttonNames) do
    local btn = Instance.new("TextButton")
    btn.Name = btnName .. "Button"
    btn.Size = UDim2.new(0, 80, 0, 30)
    btn.Position = UDim2.new(0, 10 + (i - 1) * 90, 1, -40)
    btn.BackgroundColor3 = Color3.fromRGB(0, 120, 210)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.Text = btnName
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Parent = ExecuteTab
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 140, 230)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 120, 210)}):Play()
    end)
    
    table.insert(buttons, btn)
end

-- Button Functions
buttons[1].MouseButton1Click:Connect(function()
    -- Execute
    local script = ScriptBox.Text
    if script ~= "" then
        loadstring(script)()
    end
end)

buttons[2].MouseButton1Click:Connect(function()
    -- Save (would integrate with your executor's file saving)
    print("Save functionality would be handled by executor")
end)

buttons[3].MouseButton1Click:Connect(function()
    -- Clear
    ScriptBox.Text = ""
end)

buttons[4].MouseButton1Click:Connect(function()
    -- Paste
    ScriptBox.Text = game:GetService("UserInputService"):GetPlatform() == Enum.Platform.Windows and 
        game:GetService("CoreGui").StarterGui:WaitForChild("StarterGui").Parent:FindFirstChildWhichIsA("TextBox") and 
        game:GetService("CoreGui").StarterGui:WaitForChild("StarterGui").Parent:FindFirstChildWhichIsA("TextBox").Text or 
        ""
end)

-- Tab Switching
for i, btn in ipairs(tabButtons) do
    btn.MouseButton1Click:Connect(function()
        -- Hide all tabs
        for _, tab in ipairs(ContentContainer:GetChildren()) do
            if tab:IsA("Frame") then
                tab.Visible = false
            end
        end
        
        -- Show selected tab
        local targetTab = ContentContainer:FindFirstChild(btn.Name:gsub("Tab$", ""))
        if targetTab then
            targetTab.Visible = true
        end
        
        -- Move indicator
        TweenService:Create(ActiveIndicator, TweenInfo.new(0.3), {Position = UDim2.new(0, 0, 0, (i - 1) * 40)}):Play()
    end)
end

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Font = Enum.Font.Gotham
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.TextSize = 16
CloseButton.Parent = TopBar

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Toggle Key (Right Control)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        MainWindow.Visible = not MainWindow.Visible
    end
end)

-- Initialize
tabButtons[1].MouseButton1Click:Connect()

return Kryon
