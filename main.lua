local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--------------------------------------------------------------------
-- 📌 1. ตารางตั้งค่าระบบ (Settings & Features Table)
--------------------------------------------------------------------
local Settings = {
    TargetPart = "Head",       
    FOVRadius = 150,            
    FOVThickness = 2,            
    FOVColor = Color3.fromRGB(255, 255, 255),
    JumpPowerVal = 100,
    BackgroundImageId = "rbxassetid://6031094678" -- เปลี่ยนเลข Decal ID รูปภาพพื้นหลังตรงนี้ได้ตามต้องการ
}

local Features = {
    ESP = { Enabled = false, Key = Enum.KeyCode.G },
    VehicleESP = { Enabled = false, Key = Enum.KeyCode.J },
    Fullbright = { Enabled = false, Key = Enum.KeyCode.N },
    TargetLock = { Enabled = false, Key = Enum.KeyCode.P },
    HighJump = { Enabled = false, Key = Enum.KeyCode.T }
}

-- สีสำหรับ ESP
_G.FriendColor  = Color3.fromRGB(0, 150, 255)
_G.EnemyColor   = Color3.fromRGB(255, 0, 0)
_G.VehicleColor = Color3.fromRGB(255, 170, 0)
_G.UseTeamColor = true

local originalJumpPower = 50
local originalJumpHeight = 7.2
local originalUseJumpPower = true

local function saveOriginalValues(humanoid)
    if humanoid then
        originalUseJumpPower = humanoid.UseJumpPower
        originalJumpPower = humanoid.JumpPower
        originalJumpHeight = humanoid.JumpHeight
    end
end

--------------------------------------------------------------------
-- 📌 2. สร้าง UI FOV Circle
--------------------------------------------------------------------
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("FOVCircleGui") then
    PlayerGui.FOVCircleGui:Destroy()
end

local FOVGui = Instance.new("ScreenGui")
FOVGui.Name = "FOVCircleGui"
FOVGui.ResetOnSpawn = false
FOVGui.Parent = PlayerGui

local FOVFrame = Instance.new("Frame")
FOVFrame.Name = "CircleFrame"
FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
FOVFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
FOVFrame.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
FOVFrame.BackgroundTransparency = 1
FOVFrame.Visible = false
FOVFrame.Parent = FOVGui

local FOVStroke = Instance.new("UIStroke")
FOVStroke.Thickness = Settings.FOVThickness
FOVStroke.Color = Settings.FOVColor
FOVStroke.Transparency = 0.3
FOVStroke.Parent = FOVFrame

local FOVCorner = Instance.new("UICorner")
FOVCorner.CornerRadius = UDim.new(1, 0)
FOVCorner.Parent = FOVFrame

local function updateFOVCircle()
    FOVFrame.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
    FOVStroke.Thickness = Settings.FOVThickness
    FOVStroke.Color = Settings.FOVColor
    FOVStroke.Enabled = (Settings.FOVThickness > 0)
    FOVFrame.Visible = Features.TargetLock.Enabled
end

--------------------------------------------------------------------
-- 📌 3. ฟังก์ชันการทำงานของฟีเจอร์ต่างๆ (ESP, Aimlock, Fullbright, etc.)
--------------------------------------------------------------------
if game.CoreGui:FindFirstChild("ESP") then game.CoreGui.ESP:Destroy() end
local ESPHolder = Instance.new("Folder", game.CoreGui)
ESPHolder.Name = "ESP"

local NameTagTemplate = Instance.new("BillboardGui")
NameTagTemplate.Name = "NameTag"
NameTagTemplate.Size = UDim2.new(0, 200, 0, 50)
NameTagTemplate.AlwaysOnTop = true
NameTagTemplate.StudsOffset = Vector3.new(0, 1.8, 0)

local Tag = Instance.new("TextLabel", NameTagTemplate)
Tag.Name = "Tag"
Tag.BackgroundTransparency = 1
Tag.Position = UDim2.new(0, -50, 0, 0)
Tag.Size = UDim2.new(0, 300, 0, 20)
Tag.TextSize = 15
Tag.TextColor3 = Color3.new(1, 1, 1)
Tag.TextStrokeColor3 = Color3.new(0, 0, 0)
Tag.TextStrokeTransparency = 0.4
Tag.Font = Enum.Font.SourceSansBold

local function getESPColor(v)
    if _G.UseTeamColor and v.TeamColor then
        return v.TeamColor.Color
    elseif LocalPlayer.TeamColor and v.TeamColor and (LocalPlayer.TeamColor == v.TeamColor) then
        return _G.FriendColor
    else
        return _G.EnemyColor
    end
end

local function updateESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character then
            local color = getESPColor(v)
            local head = v.Character:FindFirstChild("Head")

            if v ~= LocalPlayer then
                local highlight = v.Character:FindFirstChild("GetReal")
                if Features.ESP.Enabled then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.RobloxLocked = true
                        highlight.Name = "GetReal"
                        highlight.Adornee = v.Character
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = v.Character
                    end
                    highlight.FillColor = color
                    highlight.Enabled = true
                else
                    if highlight then highlight.Enabled = false end
                end
            end

            local vHolder = ESPHolder:FindFirstChild(v.Name)
            if not vHolder then
                vHolder = Instance.new("Folder", ESPHolder)
                vHolder.Name = v.Name
            end

            local nameTag = vHolder:FindFirstChild(v.Name .. "NameTag")
            if Features.ESP.Enabled and head then
                if not nameTag then
                    nameTag = NameTagTemplate:Clone()
                    nameTag.Name = v.Name .. "NameTag"
                    nameTag.Parent = vHolder
                end
                nameTag.Adornee = head
                nameTag.Tag.Text = v.Name
                nameTag.Tag.TextColor3 = color
                nameTag.Enabled = true
            else
                if nameTag then nameTag.Enabled = false end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.1) do
        if Features.ESP.Enabled then updateESP() end
    end
end)

if game.CoreGui:FindFirstChild("VehicleESP") then game.CoreGui.VehicleESP:Destroy() end
local VehicleHolder = Instance.new("Folder", game.CoreGui)
VehicleHolder.Name = "VehicleESP"

local VehicleTagTemplate = Instance.new("BillboardGui")
VehicleTagTemplate.Name = "VehicleTag"
VehicleTagTemplate.Size = UDim2.new(0, 200, 0, 50)
VehicleTagTemplate.AlwaysOnTop = true
VehicleTagTemplate.StudsOffset = Vector3.new(0, 2, 0)

local VTag = Instance.new("TextLabel", VehicleTagTemplate)
VTag.Name = "Tag"
VTag.BackgroundTransparency = 1
VTag.Position = UDim2.new(0, -50, 0, 0)
VTag.Size = UDim2.new(0, 300, 0, 20)
VTag.TextSize = 15
VTag.TextColor3 = _G.VehicleColor
VTag.TextStrokeColor3 = Color3.new(0, 0, 0)
VTag.TextStrokeTransparency = 0.3
VTag.Font = Enum.Font.SourceSansBold

local cachedSeats = {}
local function trackSeat(seat)
    if seat:IsA("VehicleSeat") and not table.find(cachedSeats, seat) then
        table.insert(cachedSeats, seat)
    end
end
for _, obj in pairs(Workspace:GetDescendants()) do trackSeat(obj) end
Workspace.DescendantAdded:Connect(trackSeat)

local function updateVehicleESP()
    if not Features.VehicleESP.Enabled then
        for _, child in pairs(VehicleHolder:GetChildren()) do child.Enabled = false end
        return
    end
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")

    for i = #cachedSeats, 1, -1 do
        local seat = cachedSeats[i]
        if not seat or not seat.Parent then
            table.remove(cachedSeats, i)
        else
            local vehicleModel = seat.Parent
            if not Players:GetPlayerFromCharacter(vehicleModel) then
                local debugId = seat:GetDebugId()
                local tagGui = VehicleHolder:FindFirstChild(debugId)
                if not tagGui then
                    tagGui = VehicleTagTemplate:Clone()
                    tagGui.Name = debugId
                    tagGui.Adornee = seat
                    tagGui.Parent = VehicleHolder
                end
                local distanceStr = ""
                if myRoot then
                    local dist = math.floor((myRoot.Position - seat.Position).Magnitude)
                    distanceStr = " [" .. tostring(dist) .. "m]"
                end
                tagGui.Tag.Text = "🚗 " .. vehicleModel.Name .. distanceStr
                tagGui.Enabled = true
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.2) do
        if Features.VehicleESP.Enabled then updateVehicleESP() end
    end
end)

RunService.RenderStepped:Connect(function()
    if Features.Fullbright.Enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    end
end)

local function getClosestTarget()
    local closestCharacter = nil
    local shortestDistance = Settings.FOVRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetPartObj = player.Character:FindFirstChild(Settings.TargetPart)
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetPartObj and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPartObj.Position)
                if onScreen then
                    local target2D = Vector2.new(screenPos.X, screenPos.Y)
                    local dist = (target2D - screenCenter).Magnitude
                    if dist < shortestDistance then
                        shortestDistance = dist
                        closestCharacter = player.Character
                    end
                end
            end
        end
    end
    return closestCharacter
end

RunService.RenderStepped:Connect(function()
    if Features.TargetLock.Enabled then
        local currentTarget = getClosestTarget()
        if currentTarget then
            local part = currentTarget:FindFirstChild(Settings.TargetPart)
            if part then Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position) end
        end
    end
end)

RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if Features.HighJump.Enabled then
                humanoid.UseJumpPower = true
                if humanoid.JumpPower ~= Settings.JumpPowerVal then humanoid.JumpPower = Settings.JumpPowerVal end
            else
                humanoid.UseJumpPower = originalUseJumpPower
                humanoid.JumpPower = originalJumpPower
                humanoid.JumpHeight = originalJumpHeight
            end
        end
    end
end)

if LocalPlayer.Character then saveOriginalValues(LocalPlayer.Character:FindFirstChildOfClass("Humanoid")) end
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    saveOriginalValues(char:WaitForChild("Humanoid"))
end)

--------------------------------------------------------------------
-- 📌 4. สร้างหน้าต่าง GUI หลัก + Chat Head "X" + ระบบแยกแท็บซ้าย 2 อัน
--------------------------------------------------------------------
if PlayerGui:FindFirstChild("GaneInwzaHub") then PlayerGui.GaneInwzaHub:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GaneInwzaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ปุ่มตัว X (Chat Head)
local ChatHead = Instance.new("TextButton")
ChatHead.Name = "ChatHead"
ChatHead.Size = UDim2.new(0, 48, 0, 48)
ChatHead.Position = UDim2.new(0, 30, 0.5, -24)
ChatHead.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ChatHead.Text = "X"
ChatHead.TextColor3 = Color3.fromRGB(255, 45, 85)
ChatHead.TextSize = 24
ChatHead.Font = Enum.Font.GothamBold
ChatHead.Active = true
ChatHead.Draggable = true
ChatHead.Parent = ScreenGui
Instance.new("UICorner", ChatHead).CornerRadius = UDim.new(1, 0)
local ChatHeadStroke = Instance.new("UIStroke")
ChatHeadStroke.Color = Color3.fromRGB(255, 45, 85)
ChatHeadStroke.Thickness = 2.5
ChatHeadStroke.Parent = ChatHead

-- หน้าต่างหลัก (MainFrame)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 560, 0, 400)
MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

ChatHead.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- 🖼️ รูปภาพพื้นหลังเมนูหลัก (Image Background)
local BgImage = Instance.new("ImageLabel")
BgImage.Name = "BackgroundImage"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = Settings.BackgroundImageId
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ImageTransparency = 0.4 -- ปรับความโปร่งใสของรูปพื้นหลังได้ที่นี่ (0 = ชัดสุด, 1 = ใสล่องหน)
BgImage.ZIndex = 0
BgImage.Parent = MainFrame

-- เงาทับหลังรูปเพื่อให้เมนูกลืนกับข้อความอ่านง่าย
local BgOverlay = Instance.new("Frame")
BgOverlay.Size = UDim2.new(1, 0, 1, 0)
BgOverlay.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
BgOverlay.BackgroundTransparency = 0.3
BgOverlay.ZIndex = 0
BgOverlay.Parent = MainFrame

-- แถบ Sidebar ด้านซ้าย
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
Sidebar.BackgroundTransparency = 0.2
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 1
Sidebar.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 40)
TitleLabel.Position = UDim2.new(0, 15, 0, 15)
TitleLabel.BackgroundTransparency = 1
TitleLabel.ZIndex = 2
TitleLabel.Text = "Gane inwza"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Sidebar

--------------------------------------------------------------------
-- 📌 5. สร้าง Container แยกหน้า (Main Hacks & Menu Theme)
--------------------------------------------------------------------
local ContainerMain = Instance.new("ScrollingFrame")
ContainerMain.Name = "ContainerMain"
ContainerMain.Size = UDim2.new(1, -165, 1, -20)
ContainerMain.Position = UDim2.new(0, 155, 0, 10)
ContainerMain.BackgroundTransparency = 1
ContainerMain.BorderSizePixel = 0
ContainerMain.ScrollBarThickness = 4
ContainerMain.Visible = true
ContainerMain.ZIndex = 2
ContainerMain.Parent = MainFrame

local UIList1 = Instance.new("UIListLayout")
UIList1.SortOrder = Enum.SortOrder.LayoutOrder
UIList1.Padding = UDim.new(0, 8)
UIList1.Parent = ContainerMain

local ContainerTheme = Instance.new("ScrollingFrame")
ContainerTheme.Name = "ContainerTheme"
ContainerTheme.Size = UDim2.new(1, -165, 1, -20)
ContainerTheme.Position = UDim2.new(0, 155, 0, 10)
ContainerTheme.BackgroundTransparency = 1
ContainerTheme.BorderSizePixel = 0
ContainerTheme.ScrollBarThickness = 4
ContainerTheme.Visible = false
ContainerTheme.ZIndex = 2
ContainerTheme.Parent = MainFrame

local UIList2 = Instance.new("UIListLayout")
UIList2.SortOrder = Enum.SortOrder.LayoutOrder
UIList2.Padding = UDim.new(0, 8)
UIList2.Parent = ContainerTheme

-- ปุ่มสลับแท็บที่ Sidebar
local function createTabButton(name, posY, targetContainer)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, -20, 0, 38)
    TabBtn.Position = UDim2.new(0, 10, 0, posY)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TabBtn.BackgroundTransparency = 0.5
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
    TabBtn.TextSize = 13
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.ZIndex = 2
    TabBtn.Parent = Sidebar
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        ContainerMain.Visible = false
        ContainerTheme.Visible = false
        targetContainer.Visible = true
    end)
end

createTabButton("🔥 Main Hacks", 70, ContainerMain)
createTabButton("🎨 Menu Theme", 116, ContainerTheme)

local listeningFeature = nil

-- ฟังก์ชันสร้างแถวฟีเจอร์สำหรับหน้าหลัก
local function createFeatureRow(featureKey, displayName)
    local data = Features[featureKey]
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, -10, 0, 45)
    Row.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    Row.BackgroundTransparency = 0.3
    Row.ZIndex = 2
    Row.Parent = ContainerMain
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -150, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.ZIndex = 2
    Label.Text = displayName
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local KeyBtn = Instance.new("TextButton")
    KeyBtn.Size = UDim2.new(0, 65, 0, 26)
    KeyBtn.Position = UDim2.new(1, -125, 0.5, -13)
    KeyBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
    KeyBtn.ZIndex = 2
    KeyBtn.Text = data.Key and ("[" .. data.Key.Name .. "]") or "[None]"
    KeyBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    KeyBtn.TextSize = 11
    KeyBtn.Font = Enum.Font.GothamBold
    KeyBtn.Parent = Row
    Instance.new("UICorner", KeyBtn).CornerRadius = UDim.new(0, 4)

    local SwitchBG = Instance.new("TextButton")
    SwitchBG.Size = UDim2.new(0, 44, 0, 22)
    SwitchBG.Position = UDim2.new(1, -54, 0.5, -11)
    SwitchBG.BackgroundColor3 = data.Enabled and Color3.fromRGB(255, 45, 85) or Color3.fromRGB(50, 50, 60)
    SwitchBG.ZIndex = 2
    SwitchBG.Text = ""
    SwitchBG.AutoButtonColor = false
    SwitchBG.Parent = Row
    Instance.new("UICorner", SwitchBG).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = data.Enabled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.ZIndex = 2
    Dot.Parent = SwitchBG
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    SwitchBG.MouseButton1Click:Connect(function()
        data.Enabled = not data.Enabled
        if data.Enabled then
            SwitchBG.BackgroundColor3 = Color3.fromRGB(255, 45, 85)
            Dot:TweenPosition(UDim2.new(1, -19, 0.5, -8), "Out", "Quad", 0.15, true)
        else
            SwitchBG.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            Dot:TweenPosition(UDim2.new(0, 3, 0.5, -8), "Out", "Quad", 0.15, true)
        end
        updateFOVCircle()
    end)

    KeyBtn.MouseButton1Click:Connect(function()
        if listeningFeature == nil then
            listeningFeature = { KeyBtn = KeyBtn, FeatureKey = featureKey }
            KeyBtn.Text = "..."
            KeyBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
        end
    end)
end

local function createSlider(title, minVal, maxVal, defaultVal, callback, parentContainer)
    local SliderRow = Instance.new("Frame")
    SliderRow.Size = UDim2.new(1, -10, 0, 50)
    SliderRow.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    SliderRow.BackgroundTransparency = 0.3
    SliderRow.ZIndex = 2
    SliderRow.Parent = parentContainer
    Instance.new("UICorner", SliderRow).CornerRadius = UDim.new(0, 6)

    local SLabel = Instance.new("TextLabel")
    SLabel.Size = UDim2.new(1, -24, 0, 20)
    SLabel.Position = UDim2.new(0, 12, 0, 4)
    SLabel.BackgroundTransparency = 1
    SLabel.ZIndex = 2
    SLabel.Text = title .. ": " .. tostring(defaultVal)
    SLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    SLabel.TextSize = 12
    SLabel.Font = Enum.Font.GothamSemibold
    SLabel.TextXAlignment = Enum.TextXAlignment.Left
    SLabel.Parent = SliderRow

    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -24, 0, 6)
    SliderBar.Position = UDim2.new(0, 12, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    SliderBar.ZIndex = 2
    SliderBar.Parent = SliderRow
    Instance.new("UICorner", SliderBar).CornerRadius = UDim.new(1, 0)

    local SliderFill = Instance.new("Frame")
    local startPct = (defaultVal - minVal) / (maxVal - minVal)
    SliderFill.Size = UDim2.new(startPct, 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 45, 85)
    SliderFill.ZIndex = 2
    SliderFill.Parent = SliderBar
    Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function updateInput(input)
        local posX = input.Position.X - SliderBar.AbsolutePosition.X
        local pct = math.clamp(posX / SliderBar.AbsoluteSize.X, 0, 1)
        SliderFill.Size = UDim2.new(pct, 0, 1, 0)
        local value = math.floor(minVal + (pct * (maxVal - minVal)))
        SLabel.Text = title .. ": " .. tostring(value)
        callback(value)
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true updateInput(input) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateInput(input) end
    end)
end

-- เพิ่มฟีเจอร์ลงในหน้า Main Hacks
createFeatureRow("ESP", "Player ESP")
createFeatureRow("VehicleESP", "Vehicle ESP")
createFeatureRow("Fullbright", "Fullbright")
createFeatureRow("TargetLock", "Aimlock")
createFeatureRow("HighJump", "High Jump")

createSlider("Jump Power (ความสูงกระโดด)", 50, 350, Settings.JumpPowerVal, function(val)
    Settings.JumpPowerVal = val
end, ContainerMain)

--------------------------------------------------------------------
-- 📌 6. ฟีเจอร์ตกแต่งธีมและเปลี่ยนรูปพื้นหลัง (อยู่ในแท็บ Menu Theme)
--------------------------------------------------------------------
local ThemeHeader = Instance.new("TextLabel")
ThemeHeader.Size = UDim2.new(1, -10, 0, 30)
ThemeHeader.BackgroundTransparency = 1
ThemeHeader.ZIndex = 2
ThemeHeader.Text = "🎨 Background Themes"
ThemeHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
ThemeHeader.TextSize = 14
ThemeHeader.Font = Enum.Font.GothamBold
ThemeHeader.TextXAlignment = Enum.TextXAlignment.Left
ThemeHeader.Parent = ContainerTheme

-- ปุ่มเลือกสไตล์รูปภาพพื้นหลังสำเร็จรูปเท่ๆ
local bgPresets = {
    {Name = "Cyberpunk City", Id = "rbxassetid://6031094678"},
    {Name = "Dark Nebula", Id = "rbxassetid://6023426915"},
    {Name = "Abstract Waves", Id = "rbxassetid://6023426985"},
    {Name = "Gaming Glow", Id = "rbxassetid://6034688975"}
}

for _, preset in ipairs(bgPresets) do
    local PresetBtn = Instance.new("TextButton")
    PresetBtn.Size = UDim2.new(1, -10, 0, 40)
    PresetBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    PresetBtn.BackgroundTransparency = 0.3
    PresetBtn.ZIndex = 2
    PresetBtn.Text = "🖼️ Theme: " .. preset.Name
    PresetBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
    PresetBtn.TextSize = 12
    PresetBtn.Font = Enum.Font.GothamSemibold
    PresetBtn.Parent = ContainerTheme
    Instance.new("UICorner", PresetBtn).CornerRadius = UDim.new(0, 6)

    PresetBtn.MouseButton1Click:Connect(function()
        BgImage.Image = preset.Id
    end)
end

-- ตัวปรับความโปร่งใสของรูปพื้นหลัง
createSlider("Background Opacity", 0, 10, 4, function(val)
    BgImage.ImageTransparency = val / 10
end, ContainerTheme)

--------------------------------------------------------------------
-- 📌 7. Aimlock Target & FOV Settings (หน้า Main Hacks เพิ่มเติม)
--------------------------------------------------------------------
local DropdownRow = Instance.new("Frame")
DropdownRow.Size = UDim2.new(1, -10, 0, 45)
DropdownRow.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
DropdownRow.BackgroundTransparency = 0.3
DropdownRow.ZIndex = 2
DropdownRow.Parent = ContainerMain

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(0, 150, 1, 0)
TargetLabel.Position = UDim2.new(0, 12, 0, 0)
TargetLabel.BackgroundTransparency = 1
TargetLabel.ZIndex = 2
TargetLabel.Text = "Target Part:"
TargetLabel.TextColor3 = Color3.fromRGB(220, 220, 230)
TargetLabel.TextSize = 13
TargetLabel.Font = Enum.Font.GothamSemibold
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = DropdownRow

local TargetBtn = Instance.new("TextButton")
TargetBtn.Size = UDim2.new(0, 110, 0, 26)
TargetBtn.Position = UDim2.new(1, -120, 0.5, -13)
TargetBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 50)
TargetBtn.ZIndex = 2
TargetBtn.Text = "Head (ศีรษะ)"
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.TextSize = 11
TargetBtn.Font = Enum.Font.GothamBold
TargetBtn.Parent = DropdownRow
Instance.new("UICorner", TargetBtn).CornerRadius = UDim.new(0, 4)

TargetBtn.MouseButton1Click:Connect(function()
    if Settings.TargetPart == "Head" then
        Settings.TargetPart = "HumanoidRootPart"
        TargetBtn.Text = "Torso (ลำตัว)"
    else
        Settings.TargetPart = "Head"
        TargetBtn.Text = "Head (ศีรษะ)"
    end
end)

createSlider("FOV Radius (รัศมี)", 50, 400, Settings.FOVRadius, function(val)
    Settings.FOVRadius = val
    updateFOVCircle()
end, ContainerMain)

createSlider("FOV Thickness (ความหนา)", 0, 10, Settings.FOVThickness, function(val)
    Settings.FOVThickness = val
    updateFOVCircle()
end, ContainerMain)

--------------------------------------------------------------------
-- 📌 8. ระบบ Hotkey & กดปุ่ม . ซ่อน/แสดง UI ทั้งหมด
--------------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if listeningFeature then
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local featureData = Features[listeningFeature.FeatureKey]
            if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
                featureData.Key = nil
                listeningFeature.KeyBtn.Text = "[None]"
                listeningFeature.KeyBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
            else
                local newKey = input.KeyCode
                if newKey ~= Enum.KeyCode.Unknown then
                    featureData.Key = newKey
                    listeningFeature.KeyBtn.Text = "[" .. newKey.Name .. "]"
                    listeningFeature.KeyBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
                end
            end
            listeningFeature = nil
        end
        return
    end

    if input.KeyCode == Enum.KeyCode.Period then
        local newState = not MainFrame.Visible
        MainFrame.Visible = newState
        ChatHead.Visible = newState
        return
    end

    if input.UserInputType == Enum.UserInputType.Keyboard then
        for _, featureData in pairs(Features) do
            if featureData.Key and input.KeyCode == featureData.Key then
                featureData.Enabled = not featureData.Enabled
                updateFOVCircle()
                break
            end
        end
    end
end)
