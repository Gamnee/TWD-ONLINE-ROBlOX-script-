local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--------------------------------------------------------------------
-- 📌 0. ระบบภาษา (Language Translation Table)
--------------------------------------------------------------------
local CurrentLanguage = "TH"

local LangText = {
    TH = {
        HubTitle = "Gane inwza",
        TabMain = "หน้าหลัก",
        TabOther = "ตั้งค่าอื่นๆ",
        TabTeleport = "เทเลพอร์ต",
        ESP = "แสดงตำแหน่งผู้เล่น",
        VehicleESP = "แสดงตำแหน่งยานพาหนะ",
        Fullbright = "สว่างเต็มที่",
        Aimlock = "ล็อกเป้าหมาย",
        HighJump = "กระโดดสูง",
        JumpPower = "ความสูงการกระโดด",
        MenuTheme = "ธีมเมนู",
        TargetPart = "ส่วนเป้าหมาย",
        FOVColor = "สีวงกลม FOV",
        FOVRadius = "รัศมีวงกลม FOV",
        FOVThickness = "ความหนาวงกลม FOV",
        Head = "ศีรษะ",
        Torso = "ลำตัว",
        LangToggle = "ภาษา",
        MenuKey = "ปุ่มซ่อน/แสดงเมนู",
        ESPColor = "สีไฮไลท์ศัตรู"
    },
    EN = {
        HubTitle = "Gane inwza",
        TabMain = "Main",
        TabOther = "Other",
        TabTeleport = "Teleport",
        ESP = "Player ESP",
        VehicleESP = "Vehicle ESP",
        Fullbright = "Fullbright",
        Aimlock = "Aimlock",
        HighJump = "High Jump",
        JumpPower = "Jump Power",
        MenuTheme = "Menu Theme",
        TargetPart = "Target Part",
        FOVColor = "FOV Color",
        FOVRadius = "FOV Radius",
        FOVThickness = "FOV Thickness",
        Head = "Head",
        Torso = "Torso",
        LangToggle = "Language",
        MenuKey = "Menu Toggle Key",
        ESPColor = "ESP Highlight Color"
    }
}

--------------------------------------------------------------------
-- 📌 1. ตารางตั้งค่าระบบ (Settings & Features Table)
--------------------------------------------------------------------
local Settings = {
    TargetPart = "Head",
    FOVRadius = 150,
    FOVThickness = 2,
    FOVColor = Color3.fromRGB(255, 255, 255),
    JumpPowerVal = 100,
    MenuToggleKey = Enum.KeyCode.Period,
    ESPHighlightMode = "Red"
}

local Features = {
    ESP = { Enabled = false, Key = Enum.KeyCode.G },
    VehicleESP = { Enabled = false, Key = Enum.KeyCode.J },
    Fullbright = { Enabled = false, Key = Enum.KeyCode.N },
    TargetLock = { Enabled = false, Key = Enum.KeyCode.P },
    HighJump = { Enabled = false, Key = Enum.KeyCode.T }
}

-- รายชื่อสถานที่สำหรับเทเลพอร์ต
local TeleportLocations = {
    {
        Name = "Woodbury",
        CFrame = CFrame.new(
            5422.83496,
            121.690323,
            845.045776,
            -0.93676883,
            4.93270811e-08,
            -0.349948823,
            2.50095535e-08,
            1,
            7.40077155e-08,
            0.349948823,
            6.05760562e-08,
            -0.93676883
        ),
        Color = Color3.fromRGB(255, 215, 0)
    },

    {
        Name = "Prison",
        CFrame = CFrame.new(
            5410.80664,
            133.174713,
            -3000.37769,
            0.726467907,
            -4.40537313e-08,
            0.687200427,
            -1.15541052e-08,
            1,
            7.63204113e-08,
            -0.687200427,
            -6.33843129e-08,
            0.726467907
        ),
        Color = Color3.fromRGB(255, 215, 0)
    },

    {
        Name = "Alexandria",
        CFrame = CFrame.new(
            294.89,
            116.93,
            -3882.18,
            0.95680666,
            9.53678807e-08,
            0.290724993,
            -8.17336243e-08,
            1,
            -5.90406835e-08,
            -0.290724993,
            3.27285115e-08,
            0.95680666
        ),
        Color = Color3.fromRGB(255, 215, 0)
    },

    {
        Name = "Terminus",
        CFrame = CFrame.new(646.30, 199.54, -394.81),
        Color = Color3.fromRGB(255, 215, 0)
    },

    {
        Name = "Motel",
        CFrame = CFrame.new(
            1708.67249,
            202.765594,
            -1383.53186,
            -0.129178688,
            -8.15396906e-09,
            -0.991621315,
            1.25935751e-09,
            1,
            -8.38692316e-09,
            0.991621315,
            -2.33221753e-09,
            -0.129178688
        ),
        Color = Color3.fromRGB(255, 255, 255)
    },

    {
        Name = "Big Spot",
        CFrame = CFrame.new(
            1812.80127,
            241.352448,
            1038.34009,
            0.0501040928,
            -7.84629535e-08,
            -0.998744011,
            -4.46389947e-08,
            1,
            -8.0801037e-08,
            0.998744011,
            4.86313887e-08,
            0.0501040928
        ),
        Color = Color3.fromRGB(255, 255, 255)
    },

    {
        Name = "Satellite Outpost",
        CFrame = CFrame.new(
            -1949.0907,
            293.467255,
            874.993469,
            -0.626684666,
            3.98794171e-08,
            -0.779272974,
            2.88530888e-09,
            1,
            4.88548189e-08,
            0.779272974,
            2.83681203e-08,
            -0.626684666
        ),
        Color = Color3.fromRGB(255, 255, 255)
    },

    {
        Name = "Keep Out!",
        CFrame = CFrame.new(
            4907.73682,
            125.037056,
            -5001.58057,
            -0.998003185,
            -3.08994719e-09,
            -0.0631632134,
            3.46047635e-09,
            1,
            -1.03596904e-07,
            0.0631632134,
            -1.0360862e-07,
            -0.998003185
        ),
        Color = Color3.fromRGB(255, 255, 255)
    },

    {
        Name = "PD",
        CFrame = CFrame.new(
            4812.92334,
            123.837395,
            -1070.66711,
            0.999272466,
            1.90916261e-08,
            -0.0381381847,
            -2.14410338e-08,
            1,
            -6.11934823e-08,
            0.0381381847,
            6.19666807e-08,
            0.999272466
        ),
        Color = Color3.fromRGB(255, 255, 255)
    }
}

_G.FriendColor = Color3.fromRGB(0, 150, 255)
_G.VehicleColor = Color3.fromRGB(255, 170, 0)
_G.UseTeamColor = false

--------------------------------------------------------------------
-- 📌 ESP COLOR
--------------------------------------------------------------------
local function getEnemyColor()
    local mode = Settings.ESPHighlightMode

    if mode == "Red" then
        return Color3.fromRGB(255, 0, 0)

    elseif mode == "Gold" then
        return Color3.fromRGB(255, 215, 0)

    elseif mode == "White" then
        return Color3.fromRGB(255, 255, 255)

    elseif mode == "Black" then
        return Color3.fromRGB(15, 15, 15)

    elseif mode == "Rainbow" then
        local hue = (tick() % 3) / 3
        return Color3.fromHSV(hue, 1, 1)
    end

    return Color3.fromRGB(255, 0, 0)
end

--------------------------------------------------------------------
-- 📌 FIX: สีศัตรูจะไม่โดน TeamColor บังคับเป็นสีฟ้า
--------------------------------------------------------------------
local function getESPColor(v)
    if v == LocalPlayer then
        return Color3.fromRGB(255, 255, 255)
    end

    return getEnemyColor()
end

--------------------------------------------------------------------
-- 📌 High Jump Original Values
--------------------------------------------------------------------
local originalJumpPower = 50
local originalUseJumpPower = true
local hasSavedOriginalJump = false

local function saveOriginalValues(humanoid)
    if not humanoid or not humanoid:IsA("Humanoid") or hasSavedOriginalJump then
        return
    end

    local success, useJumpPower, jumpPower = pcall(function()
        return humanoid.UseJumpPower, humanoid.JumpPower
    end)

    if success and typeof(useJumpPower) == "boolean" and typeof(jumpPower) == "number" then
        originalUseJumpPower = useJumpPower
        originalJumpPower = jumpPower > 0 and jumpPower or 50
    else
        originalUseJumpPower = true
        originalJumpPower = 50
    end

    hasSavedOriginalJump = true
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
FOVFrame.Size = UDim2.new(
    0,
    Settings.FOVRadius * 2,
    0,
    Settings.FOVRadius * 2
)
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
    FOVFrame.Size = UDim2.new(
        0,
        Settings.FOVRadius * 2,
        0,
        Settings.FOVRadius * 2
    )

    FOVStroke.Thickness = Settings.FOVThickness
    FOVStroke.Color = Settings.FOVColor
    FOVStroke.Enabled = Settings.FOVThickness > 0
    FOVFrame.Visible = Features.TargetLock.Enabled
end

--------------------------------------------------------------------
-- 📌 3. PLAYER ESP
--------------------------------------------------------------------
if game.CoreGui:FindFirstChild("ESP") then
    game.CoreGui.ESP:Destroy()
end

local ESPHolder = Instance.new("Folder")
ESPHolder.Name = "ESP"
ESPHolder.Parent = game.CoreGui

local NameTagTemplate = Instance.new("BillboardGui")
NameTagTemplate.Name = "NameTag"
NameTagTemplate.Size = UDim2.new(0, 200, 0, 50)
NameTagTemplate.AlwaysOnTop = true
NameTagTemplate.StudsOffset = Vector3.new(0, 1.8, 0)

local Tag = Instance.new("TextLabel")
Tag.Name = "Tag"
Tag.BackgroundTransparency = 1
Tag.Position = UDim2.new(0, -50, 0, 0)
Tag.Size = UDim2.new(0, 300, 0, 20)
Tag.TextSize = 15
Tag.TextColor3 = Color3.new(1, 1, 1)
Tag.TextStrokeColor3 = Color3.new(0, 0, 0)
Tag.TextStrokeTransparency = 0.4
Tag.Font = Enum.Font.SourceSansBold
Tag.Parent = NameTagTemplate

--------------------------------------------------------------------
-- 📌 FIXED ESP
-- สีเดียวกันทั้ง Highlight และชื่อ
--------------------------------------------------------------------
local function updateESP()
    for _, v in pairs(Players:GetPlayers()) do

        if v.Character then

            local head = v.Character:FindFirstChild("Head")

            if v ~= LocalPlayer then

                -- สีจากเมนู ESP Color
                local color = getESPColor(v)

                ----------------------------------------------------
                -- Highlight
                ----------------------------------------------------
                local highlight = v.Character:FindFirstChild("GetReal")

                if Features.ESP.Enabled then

                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "GetReal"
                        highlight.Adornee = v.Character
                        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        highlight.Parent = v.Character
                    end

                    -- สี Highlight
                    highlight.FillColor = color
                    highlight.OutlineColor = color

                    highlight.FillTransparency = 0.45
                    highlight.OutlineTransparency = 0

                    highlight.Enabled = true

                else

                    if highlight then
                        highlight.Enabled = false
                    end

                end

                ----------------------------------------------------
                -- Name ESP
                ----------------------------------------------------
                local vHolder = ESPHolder:FindFirstChild(v.Name)

                if not vHolder then
                    vHolder = Instance.new("Folder")
                    vHolder.Name = v.Name
                    vHolder.Parent = ESPHolder
                end

                local nameTag = vHolder:FindFirstChild(
                    v.Name .. "NameTag"
                )

                if Features.ESP.Enabled and head then

                    if not nameTag then
                        nameTag = NameTagTemplate:Clone()
                        nameTag.Name = v.Name .. "NameTag"
                        nameTag.Parent = vHolder
                    end

                    nameTag.Adornee = head

                    nameTag.Tag.Text = v.Name

                    -- สีชื่อ = สี Highlight
                    nameTag.Tag.TextColor3 = color

                    nameTag.Enabled = true

                else

                    if nameTag then
                        nameTag.Enabled = false
                    end

                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.05) do
        if Features.ESP.Enabled then
            updateESP()
        end
    end
end)

--------------------------------------------------------------------
-- 📌 Vehicle ESP
--------------------------------------------------------------------
if game.CoreGui:FindFirstChild("VehicleESP") then
    game.CoreGui.VehicleESP:Destroy()
end

local VehicleHolder = Instance.new("Folder")
VehicleHolder.Name = "VehicleESP"
VehicleHolder.Parent = game.CoreGui

local VehicleTagTemplate = Instance.new("BillboardGui")
VehicleTagTemplate.Name = "VehicleTag"
VehicleTagTemplate.Size = UDim2.new(0, 200, 0, 50)
VehicleTagTemplate.AlwaysOnTop = true
VehicleTagTemplate.StudsOffset = Vector3.new(0, 2, 0)

local VTag = Instance.new("TextLabel")
VTag.Name = "Tag"
VTag.BackgroundTransparency = 1
VTag.Position = UDim2.new(0, -50, 0, 0)
VTag.Size = UDim2.new(0, 300, 0, 20)
VTag.TextSize = 15
VTag.TextColor3 = _G.VehicleColor
VTag.TextStrokeColor3 = Color3.new(0, 0, 0)
VTag.TextStrokeTransparency = 0.3
VTag.Font = Enum.Font.SourceSansBold
VTag.Parent = VehicleTagTemplate

local cachedSeats = {}

local function trackSeat(seat)
    if seat:IsA("VehicleSeat") and not table.find(cachedSeats, seat) then
        table.insert(cachedSeats, seat)
    end
end

for _, obj in pairs(Workspace:GetDescendants()) do
    trackSeat(obj)
end

Workspace.DescendantAdded:Connect(trackSeat)

Workspace.DescendantRemoving:Connect(function(obj)

    local index = table.find(cachedSeats, obj)

    if index then
        table.remove(cachedSeats, index)

        local tagGui = VehicleHolder:FindFirstChild(
            obj:GetDebugId()
        )

        if tagGui then
            tagGui:Destroy()
        end
    end
end)

local function updateVehicleESP()

    if not Features.VehicleESP.Enabled then

        for _, child in pairs(VehicleHolder:GetChildren()) do
            child.Enabled = false
        end

        return
    end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild(
        "HumanoidRootPart"
    )

    for i = #cachedSeats, 1, -1 do

        local seat = cachedSeats[i]

        if not seat or not seat.Parent then

            table.remove(cachedSeats, i)

        else

            local vehicleModel = seat.Parent

            if not Players:GetPlayerFromCharacter(vehicleModel) then

                local debugId = seat:GetDebugId()

                local tagGui = VehicleHolder:FindFirstChild(
                    debugId
                )

                if not tagGui then

                    tagGui = VehicleTagTemplate:Clone()
                    tagGui.Name = debugId
                    tagGui.Adornee = seat
                    tagGui.Parent = VehicleHolder

                end

                local distanceStr = ""

                if myRoot then

                    local dist = math.floor(
                        (myRoot.Position - seat.Position).Magnitude
                    )

                    distanceStr = " [" .. tostring(dist) .. "m]"

                end

                tagGui.Tag.Text =
                    "🚗 " .. vehicleModel.Name .. distanceStr

                tagGui.Enabled = true
            end
        end
    end
end

task.spawn(function()

    while task.wait(0.2) do

        if Features.VehicleESP.Enabled then
            updateVehicleESP()
        end

    end

end)

--------------------------------------------------------------------
-- 📌 Fullbright
--------------------------------------------------------------------
local function setBright()

    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false

    Lighting.OutdoorAmbient =
        Color3.fromRGB(255, 255, 255)

    Lighting.Ambient =
        Color3.fromRGB(255, 255, 255)
end

RunService.RenderStepped:Connect(function()

    if Features.Fullbright.Enabled then
        setBright()
    end

end)

--------------------------------------------------------------------
-- 📌 Aimlock
--------------------------------------------------------------------
local currentTarget = nil

local function getClosestTarget()

    local closestCharacter = nil

    local shortestDistance =
        Settings.FOVRadius

    local screenCenter = Vector2.new(
        Camera.ViewportSize.X / 2,
        Camera.ViewportSize.Y / 2
    )

    for _, player in pairs(Players:GetPlayers()) do

        if player ~= LocalPlayer
            and player.Character then

            local targetPartObj =
                player.Character:FindFirstChild(
                    Settings.TargetPart
                )

            local humanoid =
                player.Character:FindFirstChildOfClass(
                    "Humanoid"
                )

            if targetPartObj
                and humanoid
                and humanoid.Health > 0 then

                local screenPos, onScreen =
                    Camera:WorldToViewportPoint(
                        targetPartObj.Position
                    )

                if onScreen then

                    local target2D = Vector2.new(
                        screenPos.X,
                        screenPos.Y
                    )

                    local dist =
                        (target2D - screenCenter).Magnitude

                    if dist < shortestDistance then

                        shortestDistance = dist

                        closestCharacter =
                            player.Character

                    end
                end
            end
        end
    end

    return closestCharacter
end

RunService.RenderStepped:Connect(function()

    if Features.TargetLock.Enabled then

        currentTarget = getClosestTarget()

        if currentTarget then

            local part =
                currentTarget:FindFirstChild(
                    Settings.TargetPart
                )

            if part then

                Camera.CFrame =
                    CFrame.new(
                        Camera.CFrame.Position,
                        part.Position
                    )

            end
        end
    end

end)

--------------------------------------------------------------------
-- 📌 High Jump
--------------------------------------------------------------------
RunService.Stepped:Connect(function()

    local char = LocalPlayer.Character

    if char then

        local humanoid =
            char:FindFirstChildOfClass("Humanoid")

        if humanoid then

            saveOriginalValues(humanoid)

            if Features.HighJump.Enabled then

                humanoid.UseJumpPower = true

                if humanoid.JumpPower
                    ~= Settings.JumpPowerVal then

                    humanoid.JumpPower =
                        Settings.JumpPowerVal

                end

            else

                if humanoid.JumpPower
                    == Settings.JumpPowerVal then

                    humanoid.UseJumpPower =
                        originalUseJumpPower

                    humanoid.JumpPower =
                        originalJumpPower

                end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(char)

    hasSavedOriginalJump = false

    local humanoid =
        char:WaitForChild("Humanoid")

    task.wait(0.5)

    saveOriginalValues(humanoid)

end)

if LocalPlayer.Character then

    local humanoid =
        LocalPlayer.Character:FindFirstChildOfClass(
            "Humanoid"
        )

    if humanoid then
        saveOriginalValues(humanoid)
    end
end

--------------------------------------------------------------------
-- 📌 4. สร้างหน้าต่าง GUI Hub หลัก
--------------------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GaneInwzaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

--------------------------------------------------------------------
-- Chat Head
--------------------------------------------------------------------
local ChatHead = Instance.new("TextButton")

ChatHead.Name = "ChatHead"

ChatHead.Size =
    UDim2.new(0, 48, 0, 48)

ChatHead.Position =
    UDim2.new(0, 30, 0.5, -24)

ChatHead.BackgroundColor3 =
    Color3.fromRGB(20, 20, 28)

ChatHead.Text = "G"

ChatHead.TextColor3 =
    Color3.fromRGB(255, 45, 85)

ChatHead.TextSize = 24
ChatHead.Font = Enum.Font.GothamBold

ChatHead.Active = true
ChatHead.Draggable = true
ChatHead.Parent = ScreenGui

Instance.new("UICorner", ChatHead).CornerRadius =
    UDim.new(1, 0)

local ChatHeadStroke = Instance.new("UIStroke")

ChatHeadStroke.Color =
    Color3.fromRGB(255, 45, 85)

ChatHeadStroke.Thickness = 2.5

ChatHeadStroke.Parent = ChatHead

--------------------------------------------------------------------
-- MainFrame
--------------------------------------------------------------------
local MainFrame = Instance.new("Frame")

MainFrame.Name = "MainFrame"

MainFrame.Size =
    UDim2.new(0, 560, 0, 400)

MainFrame.Position =
    UDim2.new(0.5, -280, 0.5, -200)

MainFrame.BackgroundColor3 =
    Color3.fromRGB(18, 18, 24)

MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

MainFrame.Active = true
MainFrame.Draggable = true

MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius =
    UDim.new(0, 10)

ChatHead.MouseButton1Click:Connect(function()

    MainFrame.Visible =
        not MainFrame.Visible

end)

--------------------------------------------------------------------
-- Minimize
--------------------------------------------------------------------
local MinimizeBtn = Instance.new("TextButton")

MinimizeBtn.Size =
    UDim2.new(0, 26, 0, 26)

MinimizeBtn.Position =
    UDim2.new(1, -62, 0, 10)

MinimizeBtn.BackgroundColor3 =
    Color3.fromRGB(45, 45, 60)

MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.GothamBold

MinimizeBtn.Parent = MainFrame

Instance.new("UICorner", MinimizeBtn).CornerRadius =
    UDim.new(0, 4)

MinimizeBtn.MouseButton1Click:Connect(function()

    MainFrame.Visible = false
    ChatHead.Visible = true

end)

--------------------------------------------------------------------
-- Close
--------------------------------------------------------------------
local CloseBtn = Instance.new("TextButton")

CloseBtn.Size =
    UDim2.new(0, 26, 0, 26)

CloseBtn.Position =
    UDim2.new(1, -30, 0, 10)

CloseBtn.BackgroundColor3 =
    Color3.fromRGB(200, 40, 40)

CloseBtn.Text = "X"

CloseBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold

CloseBtn.Parent = MainFrame

Instance.new("UICorner", CloseBtn).CornerRadius =
    UDim.new(0, 4)

CloseBtn.MouseButton1Click:Connect(function()

    Features.ESP.Enabled = false
    Features.VehicleESP.Enabled = false
    Features.Fullbright.Enabled = false
    Features.TargetLock.Enabled = false
    Features.HighJump.Enabled = false

    updateESP()
    updateVehicleESP()

    if game.CoreGui:FindFirstChild("ESP") then
        game.CoreGui.ESP:Destroy()
    end

    if game.CoreGui:FindFirstChild("VehicleESP") then
        game.CoreGui.VehicleESP:Destroy()
    end

    ScreenGui:Destroy()

    if PlayerGui:FindFirstChild("FOVCircleGui") then
        PlayerGui.FOVCircleGui:Destroy()
    end

end)

--------------------------------------------------------------------
-- Sidebar
--------------------------------------------------------------------
local Sidebar = Instance.new("Frame")

Sidebar.Size =
    UDim2.new(0, 150, 1, 0)

Sidebar.BackgroundColor3 =
    Color3.fromRGB(14, 14, 18)

Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

--------------------------------------------------------------------
-- Title
--------------------------------------------------------------------
local TitleLabel = Instance.new("TextLabel")

TitleLabel.Name = "TitleLabel"

TitleLabel.Size =
    UDim2.new(1, -20, 0, 40)

TitleLabel.Position =
    UDim2.new(0, 15, 0, 10)

TitleLabel.BackgroundTransparency = 1

TitleLabel.Text =
    LangText[CurrentLanguage].HubTitle

TitleLabel.TextColor3 =
    Color3.fromRGB(255, 255, 255)

TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold

TitleLabel.TextXAlignment =
    Enum.TextXAlignment.Left

TitleLabel.Parent = Sidebar

--------------------------------------------------------------------
-- Main Container
--------------------------------------------------------------------
local MainContainer = Instance.new("ScrollingFrame")

MainContainer.Name = "MainContainer"

MainContainer.Size =
    UDim2.new(1, -165, 1, -50)

MainContainer.Position =
    UDim2.new(0, 155, 0, 45)

MainContainer.BackgroundTransparency = 1
MainContainer.BorderSizePixel = 0

MainContainer.ScrollBarThickness = 4
MainContainer.Visible = true

MainContainer.Parent = MainFrame

local MainUIList = Instance.new("UIListLayout")

MainUIList.SortOrder =
    Enum.SortOrder.LayoutOrder

MainUIList.Padding =
    UDim.new(0, 8)

MainUIList.Parent = MainContainer

--------------------------------------------------------------------
-- Other Container
--------------------------------------------------------------------
local OtherContainer = Instance.new("ScrollingFrame")

OtherContainer.Name = "OtherContainer"

OtherContainer.Size =
    UDim2.new(1, -165, 1, -50)

OtherContainer.Position =
    UDim2.new(0, 155, 0, 45)

OtherContainer.BackgroundTransparency = 1
OtherContainer.BorderSizePixel = 0

OtherContainer.ScrollBarThickness = 4
OtherContainer.Visible = false

OtherContainer.Parent = MainFrame

local OtherUIList = Instance.new("UIListLayout")

OtherUIList.SortOrder =
    Enum.SortOrder.LayoutOrder

OtherUIList.Padding =
    UDim.new(0, 8)

OtherUIList.Parent = OtherContainer

--------------------------------------------------------------------
-- Teleport Container
--------------------------------------------------------------------
local TeleportContainer = Instance.new("ScrollingFrame")

TeleportContainer.Name =
    "TeleportContainer"

TeleportContainer.Size =
    UDim2.new(1, -165, 1, -50)

TeleportContainer.Position =
    UDim2.new(0, 155, 0, 45)

TeleportContainer.BackgroundTransparency = 1
TeleportContainer.BorderSizePixel = 0

TeleportContainer.ScrollBarThickness = 4
TeleportContainer.Visible = false

TeleportContainer.Parent = MainFrame

local TeleportUIList = Instance.new("UIListLayout")

TeleportUIList.SortOrder =
    Enum.SortOrder.LayoutOrder

TeleportUIList.Padding =
    UDim.new(0, 8)

TeleportUIList.Parent = TeleportContainer

--------------------------------------------------------------------
-- Tabs
--------------------------------------------------------------------
local tabButtonReferences = {}

local function createTabButton(
    nameKey,
    order,
    targetContainer
)

    local TabBtn =
        Instance.new("TextButton")

    TabBtn.Name =
        "TabBtn_" .. nameKey

    TabBtn.Size =
        UDim2.new(1, -20, 0, 36)

    TabBtn.Position =
        UDim2.new(
            0,
            10,
            0,
            55 + (order * 42)
        )

    TabBtn.BackgroundColor3 =
        targetContainer.Visible
        and Color3.fromRGB(38, 38, 50)
        or Color3.fromRGB(20, 20, 26)

    TabBtn.Text =
        LangText[CurrentLanguage]["Tab" .. nameKey]

    TabBtn.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    TabBtn.TextSize = 13
    TabBtn.Font = Enum.Font.GothamBold

    TabBtn.Parent = Sidebar

    Instance.new("UICorner", TabBtn).CornerRadius =
        UDim.new(0, 6)

    table.insert(
        tabButtonReferences,
        {
            Btn = TabBtn,
            Key = "Tab" .. nameKey
        }
    )

    TabBtn.MouseButton1Click:Connect(function()

        MainContainer.Visible =
            targetContainer == MainContainer

        OtherContainer.Visible =
            targetContainer == OtherContainer

        TeleportContainer.Visible =
            targetContainer == TeleportContainer

        for _, child in pairs(
            Sidebar:GetChildren()
        ) do

            if child:IsA("TextButton")
                and child ~= TitleLabel
                and child.Name ~= "LangBtn" then

                child.BackgroundColor3 =
                    Color3.fromRGB(20, 20, 26)

            end
        end

        TabBtn.BackgroundColor3 =
            Color3.fromRGB(38, 38, 50)

    end)
end

createTabButton(
    "Main",
    0,
    MainContainer
)

createTabButton(
    "Other",
    1,
    OtherContainer
)

createTabButton(
    "Teleport",
    2,
    TeleportContainer
)

--------------------------------------------------------------------
-- Feature Variables
--------------------------------------------------------------------
local listeningFeature = nil
local listeningMenuKey = false
local localizedLabels = {}

--------------------------------------------------------------------
-- Feature Row
--------------------------------------------------------------------
local function createFeatureRow(
    featureKey,
    textKey,
    parentContainer
)

    local data = Features[featureKey]

    local Row = Instance.new("Frame")

    Row.Size =
        UDim2.new(1, -10, 0, 45)

    Row.BackgroundColor3 =
        Color3.fromRGB(26, 26, 34)

    Row.Parent = parentContainer

    Instance.new("UICorner", Row).CornerRadius =
        UDim.new(0, 6)

    local Label = Instance.new("TextLabel")

    Label.Size =
        UDim2.new(1, -150, 1, 0)

    Label.Position =
        UDim2.new(0, 12, 0, 0)

    Label.BackgroundTransparency = 1

    Label.Text =
        LangText[CurrentLanguage][textKey]

    Label.TextColor3 =
        Color3.fromRGB(220, 220, 230)

    Label.TextSize = 13
    Label.Font = Enum.Font.GothamSemibold

    Label.TextXAlignment =
        Enum.TextXAlignment.Left

    Label.Parent = Row

    table.insert(
        localizedLabels,
        {
            Label = Label,
            Key = textKey
        }
    )

    local KeyBtn =
        Instance.new("TextButton")

    KeyBtn.Size =
        UDim2.new(0, 65, 0, 26)

    KeyBtn.Position =
        UDim2.new(1, -125, 0.5, -13)

    KeyBtn.BackgroundColor3 =
        Color3.fromRGB(38, 38, 50)

    KeyBtn.Text =
        data.Key
        and ("[" .. data.Key.Name .. "]")
        or "[None]"

    KeyBtn.TextColor3 =
        Color3.fromRGB(180, 180, 200)

    KeyBtn.TextSize = 11
    KeyBtn.Font = Enum.Font.GothamBold

    KeyBtn.Parent = Row

    Instance.new("UICorner", KeyBtn).CornerRadius =
        UDim.new(0, 4)

    local SwitchBG =
        Instance.new("TextButton")

    SwitchBG.Size =
        UDim2.new(0, 44, 0, 22)

    SwitchBG.Position =
        UDim2.new(1, -54, 0.5, -11)

    SwitchBG.BackgroundColor3 =
        data.Enabled
        and Color3.fromRGB(255, 45, 85)
        or Color3.fromRGB(50, 50, 60)

    SwitchBG.Text = ""
    SwitchBG.AutoButtonColor = false

    SwitchBG.Parent = Row

    Instance.new("UICorner", SwitchBG).CornerRadius =
        UDim.new(1, 0)

    local Dot = Instance.new("Frame")

    Dot.Size =
        UDim2.new(0, 16, 0, 16)

    Dot.Position =
        data.Enabled
        and UDim2.new(1, -19, 0.5, -8)
        or UDim2.new(0, 3, 0.5, -8)

    Dot.BackgroundColor3 =
        Color3.fromRGB(255, 255, 255)

    Dot.Parent = SwitchBG

    Instance.new("UICorner", Dot).CornerRadius =
        UDim.new(1, 0)

    local function updateSwitchVisual(state)

        data.Enabled = state

        if state then

            SwitchBG.BackgroundColor3 =
                Color3.fromRGB(255, 45, 85)

            Dot:TweenPosition(
                UDim2.new(1, -19, 0.5, -8),
                "Out",
                "Quad",
                0.15,
                true
            )

            if featureKey == "ESP" then
                updateESP()
            end

            if featureKey == "VehicleESP" then
                updateVehicleESP()
            end

        else

            SwitchBG.BackgroundColor3 =
                Color3.fromRGB(50, 50, 60)

            Dot:TweenPosition(
                UDim2.new(0, 3, 0.5, -8),
                "Out",
                "Quad",
                0.15,
                true
            )

            if featureKey == "ESP" then
                updateESP()
            end

            if featureKey == "VehicleESP" then
                updateVehicleESP()
            end

        end

        updateFOVCircle()

    end

    SwitchBG.MouseButton1Click:Connect(function()

        updateSwitchVisual(
            not data.Enabled
        )

    end)

    KeyBtn.MouseButton1Click:Connect(function()

        if listeningFeature == nil
            and not listeningMenuKey then

            listeningFeature = {
                KeyBtn = KeyBtn,
                FeatureKey = featureKey
            }

            KeyBtn.Text = "..."
            KeyBtn.TextColor3 =
                Color3.fromRGB(255, 200, 0)

        end

    end)

    data.ToggleVisual =
        updateSwitchVisual
end

--------------------------------------------------------------------
-- Slider
--------------------------------------------------------------------
local sliderReferences = {}

local function createSlider(
    titleKey,
    minVal,
    maxVal,
    defaultVal,
    callback,
    parentContainer
)

    local SliderRow =
        Instance.new("Frame")

    SliderRow.Size =
        UDim2.new(1, -10, 0, 50)

    SliderRow.BackgroundColor3 =
        Color3.fromRGB(26, 26, 34)

    SliderRow.Parent =
        parentContainer

    Instance.new("UICorner", SliderRow).CornerRadius =
        UDim.new(0, 6)

    local SLabel =
        Instance.new("TextLabel")

    SLabel.Size =
        UDim2.new(1, -24, 0, 20)

    SLabel.Position =
        UDim2.new(0, 12, 0, 4)

    SLabel.BackgroundTransparency = 1

    SLabel.Text =
        LangText[CurrentLanguage][titleKey]
        .. ": "
        .. tostring(defaultVal)

    SLabel.TextColor3 =
        Color3.fromRGB(200, 200, 210)

    SLabel.TextSize = 12
    SLabel.Font = Enum.Font.GothamSemibold

    SLabel.TextXAlignment =
        Enum.TextXAlignment.Left

    SLabel.Parent =
        SliderRow

    table.insert(
        sliderReferences,
        {
            Label = SLabel,
            Key = titleKey,
            CurrentVal = defaultVal
        }
    )

    local SliderBar =
        Instance.new("Frame")

    SliderBar.Size =
        UDim2.new(1, -24, 0, 6)

    SliderBar.Position =
        UDim2.new(0, 12, 0, 32)

    SliderBar.BackgroundColor3 =
        Color3.fromRGB(45, 45, 60)

    SliderBar.Parent =
        SliderRow

    Instance.new("UICorner", SliderBar).CornerRadius =
        UDim.new(1, 0)

    local SliderFill =
        Instance.new("Frame")

    local startPct =
        (defaultVal - minVal)
        / (maxVal - minVal)

    SliderFill.Size =
        UDim2.new(startPct, 0, 1, 0)

    SliderFill.BackgroundColor3 =
        Color3.fromRGB(255, 45, 85)

    SliderFill.Parent =
        SliderBar

    Instance.new("UICorner", SliderFill).CornerRadius =
        UDim.new(1, 0)

    local dragging = false

    local function updateInput(input)

        local posX =
            input.Position.X
            - SliderBar.AbsolutePosition.X

        local pct =
            math.clamp(
                posX / SliderBar.AbsoluteSize.X,
                0,
                1
            )

        SliderFill.Size =
            UDim2.new(pct, 0, 1, 0)

        local value =
            math.floor(
                minVal
                + (pct * (maxVal - minVal))
            )

        SLabel.Text =
            LangText[CurrentLanguage][titleKey]
            .. ": "
            .. tostring(value)

        for _, sRef in ipairs(
            sliderReferences
        ) do

            if sRef.Label == SLabel then
                sRef.CurrentVal = value
            end

        end

        callback(value)

    end

    SliderBar.InputBegan:Connect(function(input)

        if input.UserInputType
            == Enum.UserInputType.MouseButton1 then

            dragging = true
            updateInput(input)

        end

    end)

    UserInputService.InputEnded:Connect(function(input)

        if input.UserInputType
            == Enum.UserInputType.MouseButton1 then

            dragging = false

        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if dragging
            and input.UserInputType
            == Enum.UserInputType.MouseMovement then

            updateInput(input)

        end

    end)
end

--------------------------------------------------------------------
-- 📌 เพิ่ม Features ลง Main
--------------------------------------------------------------------
createFeatureRow(
    "ESP",
    "ESP",
    MainContainer
)

createFeatureRow(
    "VehicleESP",
    "VehicleESP",
    MainContainer
)

createFeatureRow(
    "Fullbright",
    "Fullbright",
    MainContainer
)

createFeatureRow(
    "TargetLock",
    "Aimlock",
    MainContainer
)

createFeatureRow(
    "HighJump",
    "HighJump",
    MainContainer
)

createSlider(
    "JumpPower",
    50,
    350,
    Settings.JumpPowerVal,
    function(val)
        Settings.JumpPowerVal = val
    end,
    MainContainer
)

--------------------------------------------------------------------
-- 📌 Teleport
--------------------------------------------------------------------
for _, loc in ipairs(
    TeleportLocations
) do

    local TpBtn =
        Instance.new("TextButton")

    TpBtn.Size =
        UDim2.new(1, -10, 0, 36)

    TpBtn.BackgroundColor3 =
        Color3.fromRGB(28, 28, 38)

    TpBtn.Text =
        loc.Name

    TpBtn.TextColor3 =
        loc.Color

    TpBtn.TextSize = 13
    TpBtn.Font = Enum.Font.GothamSemibold

    TpBtn.Parent =
        TeleportContainer

    Instance.new("UICorner", TpBtn).CornerRadius =
        UDim.new(0, 6)

    TpBtn.MouseButton1Click:Connect(function()

        local character =
            LocalPlayer.Character

        if character
            and character:FindFirstChild(
                "HumanoidRootPart"
            ) then

            character.HumanoidRootPart.CFrame =
                loc.CFrame

        end

    end)
end

--------------------------------------------------------------------
-- 📌 5. Other
--------------------------------------------------------------------
local LangRow =
    Instance.new("Frame")

LangRow.Size =
    UDim2.new(1, -10, 0, 45)

LangRow.BackgroundColor3 =
    Color3.fromRGB(26, 26, 34)

LangRow.Parent =
    OtherContainer

Instance.new("UICorner", LangRow).CornerRadius =
    UDim.new(0, 6)

local LangLabelRef =
    Instance.new("TextLabel")

LangLabelRef.Size =
    UDim2.new(0, 150, 1, 0)

LangLabelRef.Position =
    UDim2.new(0, 12, 0, 0)

LangLabelRef.BackgroundTransparency = 1

LangLabelRef.Text =
    LangText[CurrentLanguage].LangToggle

LangLabelRef.TextColor3 =
    Color3.fromRGB(220, 220, 230)

LangLabelRef.TextSize = 13
LangLabelRef.Font =
    Enum.Font.GothamSemibold

LangLabelRef.TextXAlignment =
    Enum.TextXAlignment.Left

LangLabelRef.Parent =
    LangRow

table.insert(
    localizedLabels,
    {
        Label = LangLabelRef,
        Key = "LangToggle"
    }
)

local LangBtn =
    Instance.new("TextButton")

LangBtn.Size =
    UDim2.new(0, 110, 0, 26)

LangBtn.Position =
    UDim2.new(1, -120, 0.5, -13)

LangBtn.BackgroundColor3 =
    Color3.fromRGB(38, 38, 50)

LangBtn.Text =
    (CurrentLanguage == "TH")
    and "ไทย"
    or "English"

LangBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

LangBtn.TextSize = 11
LangBtn.Font =
    Enum.Font.GothamBold

LangBtn.Parent =
    LangRow

Instance.new("UICorner", LangBtn).CornerRadius =
    UDim.new(0, 4)

--------------------------------------------------------------------
-- Menu Key
--------------------------------------------------------------------
local MenuKeyRow =
    Instance.new("Frame")

MenuKeyRow.Size =
    UDim2.new(1, -10, 0, 45)

MenuKeyRow.BackgroundColor3 =
    Color3.fromRGB(26, 26, 34)

MenuKeyRow.Parent =
    OtherContainer

Instance.new("UICorner", MenuKeyRow).CornerRadius =
    UDim.new(0, 6)

local MenuKeyLabel =
    Instance.new("TextLabel")

MenuKeyLabel.Size =
    UDim2.new(0, 150, 1, 0)

MenuKeyLabel.Position =
    UDim2.new(0, 12, 0, 0)

MenuKeyLabel.BackgroundTransparency = 1

MenuKeyLabel.Text =
    LangText[CurrentLanguage].MenuKey

MenuKeyLabel.TextColor3 =
    Color3.fromRGB(220, 220, 230)

MenuKeyLabel.TextSize = 13
MenuKeyLabel.Font =
    Enum.Font.GothamSemibold

MenuKeyLabel.TextXAlignment =
    Enum.TextXAlignment.Left

MenuKeyLabel.Parent =
    MenuKeyRow

table.insert(
    localizedLabels,
    {
        Label = MenuKeyLabel,
        Key = "MenuKey"
    }
)

local MenuKeyBtn =
    Instance.new("TextButton")

MenuKeyBtn.Size =
    UDim2.new(0, 110, 0, 26)

MenuKeyBtn.Position =
    UDim2.new(1, -120, 0.5, -13)

MenuKeyBtn.BackgroundColor3 =
    Color3.fromRGB(38, 38, 50)

MenuKeyBtn.Text =
    "[" .. Settings.MenuToggleKey.Name .. "]"

MenuKeyBtn.TextColor3 =
    Color3.fromRGB(180, 180, 200)

MenuKeyBtn.TextSize = 11
MenuKeyBtn.Font =
    Enum.Font.GothamBold

MenuKeyBtn.Parent =
    MenuKeyRow

Instance.new("UICorner", MenuKeyBtn).CornerRadius =
    UDim.new(0, 4)

MenuKeyBtn.MouseButton1Click:Connect(function()

    if listeningFeature == nil
        and not listeningMenuKey then

        listeningMenuKey = true

        MenuKeyBtn.Text = "..."

        MenuKeyBtn.TextColor3 =
            Color3.fromRGB(255, 200, 0)

    end

end)

--------------------------------------------------------------------
-- 📌 ESP Color
--------------------------------------------------------------------
local ESPColorRow =
    Instance.new("Frame")

ESPColorRow.Size =
    UDim2.new(1, -10, 0, 45)

ESPColorRow.BackgroundColor3 =
    Color3.fromRGB(26, 26, 34)

ESPColorRow.Parent =
    OtherContainer

Instance.new("UICorner", ESPColorRow).CornerRadius =
    UDim.new(0, 6)

local ESPColorLabel =
    Instance.new("TextLabel")

ESPColorLabel.Size =
    UDim2.new(0, 150, 1, 0)

ESPColorLabel.Position =
    UDim2.new(0, 12, 0, 0)

ESPColorLabel.BackgroundTransparency = 1

ESPColorLabel.Text =
    LangText[CurrentLanguage].ESPColor

ESPColorLabel.TextColor3 =
    Color3.fromRGB(220, 220, 230)

ESPColorLabel.TextSize = 13
ESPColorLabel.Font =
    Enum.Font.GothamSemibold

ESPColorLabel.TextXAlignment =
    Enum.TextXAlignment.Left

ESPColorLabel.Parent =
    ESPColorRow

table.insert(
    localizedLabels,
    {
        Label = ESPColorLabel,
        Key = "ESPColor"
    }
)

local espColorModes = {
    "Red",
    "Gold",
    "White",
    "Black",
    "Rainbow"
}

local espColorIndex = 1

local ESPColorBtn =
    Instance.new("TextButton")

ESPColorBtn.Size =
    UDim2.new(0, 110, 0, 26)

ESPColorBtn.Position =
    UDim2.new(1, -120, 0.5, -13)

ESPColorBtn.BackgroundColor3 =
    Color3.fromRGB(38, 38, 50)

ESPColorBtn.Text =
    Settings.ESPHighlightMode

ESPColorBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

ESPColorBtn.TextSize = 11
ESPColorBtn.Font =
    Enum.Font.GothamBold

ESPColorBtn.Parent =
    ESPColorRow

Instance.new("UICorner", ESPColorBtn).CornerRadius =
    UDim.new(0, 4)

ESPColorBtn.MouseButton1Click:Connect(function()

    espColorIndex =
        espColorIndex % #espColorModes + 1

    Settings.ESPHighlightMode =
        espColorModes[espColorIndex]

    ESPColorBtn.Text =
        Settings.ESPHighlightMode

    -- อัปเดตทั้ง Highlight และชื่อทันที
    if Features.ESP.Enabled then
        updateESP()
    end

end)

--------------------------------------------------------------------
-- 📌 Menu Theme
--------------------------------------------------------------------
local ThemeRow =
    Instance.new("Frame")

ThemeRow.Size =
    UDim2.new(1, -10, 0, 45)

ThemeRow.BackgroundColor3 =
    Color3.fromRGB(26, 26, 34)

ThemeRow.Parent =
    OtherContainer

Instance.new("UICorner", ThemeRow).CornerRadius =
    UDim.new(0, 6)

local ThemeLabel =
    Instance.new("TextLabel")

ThemeLabel.Size =
    UDim2.new(0, 150, 1, 0)

ThemeLabel.Position =
    UDim2.new(0, 12, 0, 0)

ThemeLabel.BackgroundTransparency = 1

ThemeLabel.Text =
    LangText[CurrentLanguage].MenuTheme

ThemeLabel.TextColor3 =
    Color3.fromRGB(220, 220, 230)

ThemeLabel.TextSize = 13
ThemeLabel.Font =
    Enum.Font.GothamSemibold

ThemeLabel.TextXAlignment =
    Enum.TextXAlignment.Left

ThemeLabel.Parent =
    ThemeRow

table.insert(
    localizedLabels,
    {
        Label = ThemeLabel,
        Key = "MenuTheme"
    }
)

local themesList = {

    {
        NameTH = "ดำ",
        NameEN = "Black",

        MainColor =
            Color3.fromRGB(18, 18, 24),

        SideColor =
            Color3.fromRGB(14, 14, 18),

        RowColor =
            Color3.fromRGB(26, 26, 34),

        TextColor =
            Color3.fromRGB(220, 220, 230)
    },

    {
        NameTH = "ขาว",
        NameEN = "White",

        MainColor =
            Color3.fromRGB(235, 235, 240),

        SideColor =
            Color3.fromRGB(210, 210, 215),

        RowColor =
            Color3.fromRGB(255, 255, 255),

        TextColor =
            Color3.fromRGB(30, 30, 35)
    },

    {
        NameTH = "ทองสว่าง",
        NameEN = "Gold",

        MainColor =
            Color3.fromRGB(45, 38, 15),

        SideColor =
            Color3.fromRGB(28, 23, 8),

        RowColor =
            Color3.fromRGB(65, 55, 22),

        TextColor =
            Color3.fromRGB(255, 240, 200)
    }

}

local currentThemeIndex = 1

local ThemeBtn =
    Instance.new("TextButton")

ThemeBtn.Size =
    UDim2.new(0, 110, 0, 26)

ThemeBtn.Position =
    UDim2.new(1, -120, 0.5, -13)

ThemeBtn.BackgroundColor3 =
    Color3.fromRGB(38, 38, 50)

ThemeBtn.Text =
    (CurrentLanguage == "TH")
    and themesList[currentThemeIndex].NameTH
    or themesList[currentThemeIndex].NameEN

ThemeBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

ThemeBtn.TextSize = 11
ThemeBtn.Font =
    Enum.Font.GothamBold

ThemeBtn.Parent =
    ThemeRow

Instance.new("UICorner", ThemeBtn).CornerRadius =
    UDim.new(0, 4)

--------------------------------------------------------------------
-- Target Part
--------------------------------------------------------------------
local DropdownRow =
    Instance.new("Frame")

DropdownRow.Size =
    UDim2.new(1, -10, 0, 45)

DropdownRow.BackgroundColor3 =
    Color3.fromRGB(26, 26, 34)

DropdownRow.Parent =
    OtherContainer

Instance.new("UICorner", DropdownRow).CornerRadius =
    UDim.new(0, 6)

local TargetLabel =
    Instance.new("TextLabel")

TargetLabel.Size =
    UDim2.new(0, 150, 1, 0)

TargetLabel.Position =
    UDim2.new(0, 12, 0, 0)

TargetLabel.BackgroundTransparency = 1

TargetLabel.Text =
    LangText[CurrentLanguage].TargetPart

TargetLabel.TextColor3 =
    Color3.fromRGB(220, 220, 230)

TargetLabel.TextSize = 13
TargetLabel.Font =
    Enum.Font.GothamSemibold

TargetLabel.TextXAlignment =
    Enum.TextXAlignment.Left

TargetLabel.Parent =
    DropdownRow

table.insert(
    localizedLabels,
    {
        Label = TargetLabel,
        Key = "TargetPart"
    }
)

local TargetBtn =
    Instance.new("TextButton")

TargetBtn.Size =
    UDim2.new(0, 110, 0, 26)

TargetBtn.Position =
    UDim2.new(1, -120, 0.5, -13)

TargetBtn.BackgroundColor3 =
    Color3.fromRGB(38, 38, 50)

TargetBtn.Text =
    LangText[CurrentLanguage][
        Settings.TargetPart == "Head"
        and "Head"
        or "Torso"
    ]

TargetBtn.TextColor3 =
    Color3.fromRGB(255, 255, 255)

TargetBtn.TextSize = 11
TargetBtn.Font =
    Enum.Font.GothamBold

TargetBtn.Parent =
    DropdownRow

Instance.new("UICorner", TargetBtn).CornerRadius =
    UDim.new(0, 4)

--------------------------------------------------------------------
-- Language UI
--------------------------------------------------------------------
local function updateLanguageUI()

    TitleLabel.Text =
        LangText[CurrentLanguage].HubTitle

    for _, tRef in ipairs(
        tabButtonReferences
    ) do

        tRef.Btn.Text =
            LangText[CurrentLanguage][
                tRef.Key
            ]

    end

    for _, lRef in ipairs(
        localizedLabels
    ) do

        lRef.Label.Text =
            LangText[CurrentLanguage][
                lRef.Key
            ]

    end

    for _, sRef in ipairs(
        sliderReferences
    ) do

        local baseKey = sRef.Key

        sRef.Label.Text =
            LangText[CurrentLanguage][baseKey]
            .. ": "
            .. tostring(sRef.CurrentVal)

    end

    local activeTheme =
        themesList[currentThemeIndex]

    ThemeBtn.Text =
        (CurrentLanguage == "TH")
        and activeTheme.NameTH
        or activeTheme.NameEN

    if Settings.TargetPart == "Head" then

        TargetBtn.Text =
            LangText[CurrentLanguage].Head

    else

        TargetBtn.Text =
            LangText[CurrentLanguage].Torso

    end

    LangBtn.Text =
        (CurrentLanguage == "TH")
        and "ไทย"
        or "English"

end

LangBtn.MouseButton1Click:Connect(function()

    CurrentLanguage =
        (CurrentLanguage == "TH")
        and "EN"
        or "TH"

    updateLanguageUI()

end)

--------------------------------------------------------------------
-- Theme Colors
--------------------------------------------------------------------
local function updateAllThemeColors(
    selectedTheme
)

    MainFrame.BackgroundColor3 =
        selectedTheme.MainColor

    Sidebar.BackgroundColor3 =
        selectedTheme.SideColor

    local function applyThemeToContainer(
        container
    )

        for _, child in pairs(
            container:GetChildren()
        ) do

            if child:IsA("Frame") then

                child.BackgroundColor3 =
                    selectedTheme.RowColor

                for _, subChild in pairs(
                    child:GetChildren()
                ) do

                    if subChild:IsA("TextLabel") then

                        subChild.TextColor3 =
                            selectedTheme.TextColor

                    end
                end
            end
        end
    end

    applyThemeToContainer(
        MainContainer
    )

    applyThemeToContainer(
        OtherContainer
    )

    applyThemeToContainer(
        TeleportContainer
    )

end

ThemeBtn.MouseButton1Click:Connect(function()

    currentThemeIndex =
        currentThemeIndex % #themesList + 1

    local selectedTheme =
        themesList[currentThemeIndex]

    ThemeBtn.Text =
        (CurrentLanguage == "TH")
        and selectedTheme.NameTH
        or selectedTheme.NameEN

    updateAllThemeColors(
        selectedTheme
    )

end)

--------------------------------------------------------------------
-- Target Part Button
--------------------------------------------------------------------
TargetBtn.MouseButton1Click:Connect(function()

    if Settings.TargetPart == "Head" then

        Settings.TargetPart =
            "HumanoidRootPart"

        TargetBtn.Text =
            LangText[CurrentLanguage].Torso

    else

        Settings.TargetPart =
            "Head"

        TargetBtn.Text =
            LangText[CurrentLanguage].Head

    end

end)

--------------------------------------------------------------------
-- FOV Color
--------------------------------------------------------------------
local ColorRow =
    Instance.new("Frame")

ColorRow.Size =
    UDim2.new(1, -10, 0, 45)

ColorRow.BackgroundColor3 =
    Color3.fromRGB(26, 26, 34)

ColorRow.Parent =
    OtherContainer

Instance.new("UICorner", ColorRow).CornerRadius =
    UDim.new(0, 6)

local ColorLabel =
    Instance.new("TextLabel")

ColorLabel.Size =
    UDim2.new(0, 150, 1, 0)

ColorLabel.Position =
    UDim2.new(0, 12, 0, 0)

ColorLabel.BackgroundTransparency = 1

ColorLabel.Text =
    LangText[CurrentLanguage].FOVColor

ColorLabel.TextColor3 =
    Color3.fromRGB(220, 220, 230)

ColorLabel.TextSize = 13
ColorLabel.Font =
    Enum.Font.GothamSemibold

ColorLabel.TextXAlignment =
    Enum.TextXAlignment.Left

ColorLabel.Parent =
    ColorRow

table.insert(
    localizedLabels,
    {
        Label = ColorLabel,
        Key = "FOVColor"
    }
)

local colorsList = {

    {
        Name = "White",
        Color = Color3.fromRGB(
            255,
            255,
            255
        )
    },

    {
        Name = "Red",
        Color = Color3.fromRGB(
            255,
            50,
            50
        )
    },

    {
        Name = "Green",
        Color = Color3.fromRGB(
            50,
            255,
            50
        )
    },

    {
        Name = "Blue",
        Color = Color3.fromRGB(
            50,
            150,
            255
        )
    },

    {
        Name = "Yellow",
        Color = Color3.fromRGB(
            255,
            255,
            50
        )
    },

    {
        Name = "Pink",
        Color = Color3.fromRGB(
            255,
            105,
            180
        )
    }

}

local currentColorIndex = 1

local ColorBtn =
    Instance.new("TextButton")

ColorBtn.Size =
    UDim2.new(0, 110, 0, 26)

ColorBtn.Position =
    UDim2.new(1, -120, 0.5, -13)

ColorBtn.BackgroundColor3 =
    Color3.fromRGB(38, 38, 50)

ColorBtn.Text =
    colorsList[currentColorIndex].Name

ColorBtn.TextColor3 =
    colorsList[currentColorIndex].Color

ColorBtn.TextSize = 11
ColorBtn.Font =
    Enum.Font.GothamBold

ColorBtn.Parent =
    ColorRow

Instance.new("UICorner", ColorBtn).CornerRadius =
    UDim.new(0, 4)

ColorBtn.MouseButton1Click:Connect(function()

    currentColorIndex =
        currentColorIndex % #colorsList + 1

    local selected =
        colorsList[currentColorIndex]

    ColorBtn.Text =
        selected.Name

    ColorBtn.TextColor3 =
        selected.Color

    Settings.FOVColor =
        selected.Color

    updateFOVCircle()

end)

--------------------------------------------------------------------
-- FOV Radius
--------------------------------------------------------------------
createSlider(
    "FOVRadius",
    50,
    400,
    Settings.FOVRadius,
    function(val)

        Settings.FOVRadius =
            val

        updateFOVCircle()

    end,
    OtherContainer
)

--------------------------------------------------------------------
-- FOV Thickness
--------------------------------------------------------------------
createSlider(
    "FOVThickness",
    0,
    10,
    Settings.FOVThickness,
    function(val)

        Settings.FOVThickness =
            val

        updateFOVCircle()

    end,
    OtherContainer
)

--------------------------------------------------------------------
-- 📌 6. ระบบ Hotkey
--------------------------------------------------------------------
UserInputService.InputBegan:Connect(
    function(input, gameProcessed)

        if gameProcessed then
            return
        end

        ------------------------------------------------------------
        -- Menu Key Listening
        ------------------------------------------------------------
        if listeningMenuKey then

            if input.UserInputType
                == Enum.UserInputType.Keyboard then

                local newKey =
                    input.KeyCode

                if newKey
                    ~= Enum.KeyCode.Unknown then

                    Settings.MenuToggleKey =
                        newKey

                    MenuKeyBtn.Text =
                        "[" .. newKey.Name .. "]"

                    MenuKeyBtn.TextColor3 =
                        Color3.fromRGB(
                            180,
                            180,
                            200
                        )

                end

                listeningMenuKey = false

            end

            return
        end

        ------------------------------------------------------------
        -- Feature Key Listening
        ------------------------------------------------------------
        if listeningFeature then

            if input.UserInputType
                == Enum.UserInputType.Keyboard then

                local featureData =
                    Features[
                        listeningFeature.FeatureKey
                    ]

                if input.KeyCode
                    == Enum.KeyCode.Backspace

                    or input.KeyCode
                    == Enum.KeyCode.Delete then

                    featureData.Key = nil

                    listeningFeature.KeyBtn.Text =
                        "[None]"

                    listeningFeature.KeyBtn.TextColor3 =
                        Color3.fromRGB(
                            150,
                            150,
                            150
                        )

                else

                    local newKey =
                        input.KeyCode

                    if newKey
                        ~= Enum.KeyCode.Unknown then

                        featureData.Key =
                            newKey

                        listeningFeature.KeyBtn.Text =
                            "[" .. newKey.Name .. "]"

                        listeningFeature.KeyBtn.TextColor3 =
                            Color3.fromRGB(
                                180,
                                180,
                                200
                            )

                    end
                end

                listeningFeature = nil

            end

            return
        end

        ------------------------------------------------------------
        -- Menu Toggle
        ------------------------------------------------------------
        if input.KeyCode
            == Settings.MenuToggleKey then

            local newState =
                not MainFrame.Visible

            MainFrame.Visible =
                newState

            ChatHead.Visible =
                newState

            return
        end

        ------------------------------------------------------------
        -- Feature Hotkeys
        ------------------------------------------------------------
        if input.UserInputType
            == Enum.UserInputType.Keyboard then

            for _, featureData in pairs(
                Features
            ) do

                if featureData.Key
                    and input.KeyCode
                    == featureData.Key then

                    featureData.ToggleVisual(
                        not featureData.Enabled
                    )

                    break
                end

            end
        end
    end
)
