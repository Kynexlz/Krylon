-- Kryon Executor
-- Modern Roblox executor with Delta-style UI

local Kryon = {}
Kryon.__index = Kryon

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Player
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local CONFIG = {
    Name = "Kryon",
    Version = "1.0",
    Theme = {
        Primary = Color3.fromRGB(30, 30, 35),
        Secondary = Color3.fromRGB(45, 45, 55),
        Accent = Color3.fromRGB(0, 170, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(180, 180, 190)
    }
}

-- Main UI
function Kryon:CreateUI()
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KryonExecutor"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 400, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    MainFrame.BackgroundColor3 = CONFIG.Theme.Primary
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- Rounded corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame
    
    -- Shadow
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(20, 20, 25)
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = CONFIG.Theme.Secondary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 12)
    TitleBarCorner.Parent = TitleBar
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "TitleText"
    TitleText.Size = UDim2.new(1, -120, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = CONFIG.Name .. " Executor v" .. CONFIG.Version
    TitleText.TextColor3 = CONFIG.Theme.Text
    TitleText.TextSize = 18
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = CONFIG.Theme.Text
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    -- Minimize Button
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -75, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 190, 60)
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = CONFIG.Theme.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TitleBar
    
    -- Side Tab
    local SideTab = Instance.new("Frame")
    SideTab.Name = "SideTab"
    SideTab.Size = UDim2.new(0, 60, 1, -40)
    SideTab.Position = UDim2.new(0, 0, 0, 40)
    SideTab.BackgroundColor3 = CONFIG.Theme.Secondary
    SideTab.BorderSizePixel = 0
    SideTab.Parent = MainFrame
    
    -- Side Tab Corner
    local SideTabCorner = Instance.new("UICorner")
    SideTabCorner.CornerRadius = UDim.new(0, 0)
    SideTabCorner.Parent = SideTab
    
    -- Editor Container
    local EditorContainer = Instance.new("Frame")
    EditorContainer.Name = "EditorContainer"
    EditorContainer.Size = UDim2.new(1, -60, 1, -40)
    EditorContainer.Position = UDim2.new(0, 60, 0, 40)
    EditorContainer.BackgroundColor3 = CONFIG.Theme.Primary
    EditorContainer.BorderSizePixel = 0
    EditorContainer.Parent = MainFrame
    
    -- Script Editor
    local ScriptEditor = Instance.new("TextBox")
    ScriptEditor.Name = "ScriptEditor"
    ScriptEditor.Size = UDim2.new(1, -20, 1, -80)
    ScriptEditor.Position = UDim2.new(0, 10, 0, 10)
    ScriptEditor.BackgroundColor3 = CONFIG.Theme.Secondary
    ScriptEditor.BackgroundTransparency = 0.3
    ScriptEditor.Text = "-- Kryon Executor\n-- Write your script here\n\nprint(\"Hello from Kryon!\")"
    ScriptEditor.TextColor3 = CONFIG.Theme.Text
    ScriptEditor.TextSize = 16
    ScriptEditor.Font = Enum.Font.Code
    ScriptEditor.TextWrapped = true
    ScriptEditor.TextXAlignment = Enum.TextXAlignment.Left
    ScriptEditor.TextYAlignment = Enum.TextYAlignment.Top
    ScriptEditor.ClearTextOnFocus = false
    ScriptEditor.MultiLine = true
    ScriptEditor.Parent = EditorContainer
    
    -- Editor Corner
    local EditorCorner = Instance.new("UICorner")
    EditorCorner.CornerRadius = UDim.new(0, 8)
    EditorCorner.Parent = ScriptEditor
    
    -- Bottom Button Container
    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Name = "ButtonContainer"
    ButtonContainer.Size = UDim2.new(1, -20, 0, 50)
    ButtonContainer.Position = UDim2.new(0, 10, 1, -55)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = EditorContainer
    
    -- UIListLayout for buttons
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.FillDirection = Enum.FillDirection.Horizontal
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = ButtonContainer
    
    -- Execute Button
    local ExecuteButton = Instance.new("TextButton")
    ExecuteButton.Name = "ExecuteButton"
    ExecuteButton.Size = UDim2.new(0, 100, 1, 0)
    ExecuteButton.BackgroundColor3 = CONFIG.Theme.Accent
    ExecuteButton.Text = "Execute"
    ExecuteButton.TextColor3 = CONFIG.Theme.Text
    ExecuteButton.TextSize = 14
    ExecuteButton.Font = Enum.Font.GothamBold
    ExecuteButton.Parent = ButtonContainer
    
    local ExecuteCorner = Instance.new("UICorner")
    ExecuteCorner.CornerRadius = UDim.new(0, 8)
    ExecuteCorner.Parent = ExecuteButton
    
    -- Save Button
    local SaveButton = Instance.new("TextButton")
    SaveButton.Name = "SaveButton"
    SaveButton.Size = UDim2.new(0, 100, 1, 0)
    SaveButton.BackgroundColor3 = CONFIG.Theme.Secondary
    SaveButton.Text = "Save"
    SaveButton.TextColor3 = CONFIG.Theme.Text
    SaveButton.TextSize = 14
    SaveButton.Font = Enum.Font.GothamBold
    SaveButton.Parent = ButtonContainer
    
    local SaveCorner = Instance.new("UICorner")
    SaveCorner.CornerRadius = UDim.new(0, 8)
    SaveCorner.Parent = SaveButton
    
    -- Clear Button
    local ClearButton = Instance.new("TextButton")
    ClearButton.Name = "ClearButton"
    ClearButton.Size = UDim2.new(0, 100, 1, 0)
    ClearButton.BackgroundColor3 = CONFIG.Theme.Secondary
    ClearButton.Text = "Clear"
    ClearButton.TextColor3 = CONFIG.Theme.Text
    ClearButton.TextSize = 14
    ClearButton.Font = Enum.Font.GothamBold
    ClearButton.Parent = ButtonContainer
    
    local ClearCorner = Instance.new("UICorner")
    ClearCorner.CornerRadius = UDim.new(0, 8)
    ClearCorner.Parent = ClearButton
    
    -- Paste Button
    local PasteButton = Instance.new("TextButton")
    PasteButton.Name = "PasteButton"
    PasteButton.Size = UDim2.new(0, 100, 1, 0)
    PasteButton.BackgroundColor3 = CONFIG.Theme.Secondary
    PasteButton.Text = "Paste"
    PasteButton.TextColor3 = CONFIG.Theme.Text
    PasteButton.TextSize = 14
    PasteButton.Font = Enum.Font.GothamBold
    PasteButton.Parent = ButtonContainer
    
    local PasteCorner = Instance.new("UICorner")
    PasteCorner.CornerRadius = UDim.new(0, 8)
    PasteCorner.Parent = PasteButton
    
    -- Side Tab Buttons
    local SideButtons = {
        {Name = "Home", Icon = "🏠"},
        {Name = "Scripts", Icon = "📜"},
        {Name = "Settings", Icon = "⚙️"}
    }
    
    for i, btnData in ipairs(SideButtons) do
        local SideButton = Instance.new("TextButton")
        SideButton.Name = btnData.Name .. "Button"
        SideButton.Size = UDim2.new(1, -10, 0, 40)
        SideButton.Position = UDim2.new(0, 5, 0, (i - 1) * 50 + 10)
        SideButton.BackgroundColor3 = CONFIG.Theme.Secondary
        SideButton.BackgroundTransparency = 0.5
        SideButton.Text = btnData.Icon
        SideButton.TextColor3 = CONFIG.Theme.Text
        SideButton.TextSize = 20
        SideButton.Font = Enum.Font.GothamBold
        SideButton.Parent = SideTab
        
        local SideButtonCorner = Instance.new("UICorner")
        SideButtonCorner.CornerRadius = UDim.new(0, 8)
        SideButtonCorner.Parent = SideButton
    end
    
    -- Drag functionality
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input:CaptureGesture()
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- Button functions
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        task.wait(0.1)
        MainFrame.Visible = true
    end)
    
    ExecuteButton.MouseButton1Click:Connect(function()
        local script = ScriptEditor.Text
        if script and script ~= "" then
            local success, err = pcall(function()
                loadstring(script)()
            end)
            if not success then
                warn("Execution error:", err)
            end
        end
    end)
    
    SaveButton.MouseButton1Click:Connect(function()
        -- In a real executor, this would save to a file
        print("Saving script:", ScriptEditor.Text)
    end)
    
    ClearButton.MouseButton1Click:Connect(function()
        ScriptEditor.Text = ""
    end)
    
    PasteButton.MouseButton1Click:Connect(function()
        -- In a real executor, this would paste from clipboard
        -- For demo purposes, we'll just add some text
        ScriptEditor.Text = ScriptEditor.Text .. "-- Pasted script\nprint(\"Pasted!\")"
    end)
    
    return ScreenGui
end

-- Initialize executor
function Kryon:Init()
    local ui = self:CreateUI()
    return ui
end

return Kryon
