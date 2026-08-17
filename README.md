local UserInputService=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")
local Players=game:GetService("Players")
local Lighting=game:GetService("Lighting")

local LocalPlayer=Players.LocalPlayer
local Camera=Workspace.CurrentCamera
local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")

--------------------------------------------------------------------
-- LANGUAGE
--------------------------------------------------------------------

local CurrentLanguage="TH"

local LangText={
TH={
HubTitle="Gane inwza",TabMain="หน้าหลัก",TabOther="ตั้งค่าอื่นๆ",TabTeleport="เทเลพอร์ต",
ESP="แสดงตำแหน่งผู้เล่น",VehicleESP="แสดงตำแหน่งยานพาหนะ",Fullbright="สว่างเต็มที่",
Aimlock="ล็อกเป้าหมาย",HighJump="กระโดดสูง",JumpPower="ความสูงการกระโดด",
MenuTheme="ธีมเมนู",TargetPart="ส่วนเป้าหมาย",FOVColor="สีวงกลม FOV",
FOVRadius="รัศมีวงกลม FOV",FOVThickness="ความหนาวงกลม FOV",Head="ศีรษะ",
Torso="ลำตัว",LangToggle="ภาษา",MenuKey="ปุ่มซ่อน/แสดงเมนู",ESPColor="สีไฮไลท์ศัตรู",
StatusDisplay="แสดงสถานะ",VehicleList="รถ",PlayerList="ผู้เล่น",
NoVehicles="ไม่พบรถ",NoPlayers="ไม่พบผู้เล่น"
},
EN={
HubTitle="Gane inwza",TabMain="Main",TabOther="Other",TabTeleport="Teleport",
ESP="Player ESP",VehicleESP="Vehicle ESP",Fullbright="Fullbright",
Aimlock="Aimlock",HighJump="High Jump",JumpPower="Jump Power",
MenuTheme="Menu Theme",TargetPart="Target Part",FOVColor="FOV Color",
FOVRadius="FOV Radius",FOVThickness="FOV Thickness",Head="Head",
Torso="Torso",LangToggle="Language",MenuKey="Menu Toggle Key",
ESPColor="ESP Highlight Color",StatusDisplay="Status Display",
VehicleList="Vehicles",PlayerList="Players",
NoVehicles="No vehicles",NoPlayers="No players"
}}

--------------------------------------------------------------------
-- SETTINGS
--------------------------------------------------------------------

local Settings={
TargetPart="Head",
FOVRadius=250,
FOVThickness=3,
FOVColor=Color3.fromRGB(255,255,255),
JumpPowerVal=100,
MenuToggleKey=Enum.KeyCode.Period,
ESPHighlightMode="Red",
StatusDisplayEnabled=true
}

local Features={
ESP={Enabled=false,Key=Enum.KeyCode.G},
VehicleESP={Enabled=false,Key=Enum.KeyCode.J},
Fullbright={Enabled=false,Key=Enum.KeyCode.N},
TargetLock={Enabled=false,Key=Enum.KeyCode.P},
HighJump={Enabled=false,Key=Enum.KeyCode.T}
}

_G.FriendColor=Color3.fromRGB(0,150,255)
_G.VehicleColor=Color3.fromRGB(255,170,0)
_G.UseTeamColor=false

--------------------------------------------------------------------
-- TELEPORT LOCATIONS
--------------------------------------------------------------------

local YellowLocations={
{Name="King County",CFrame=CFrame.new(-3235.45,188.79,4728.39)},
{Name="Hilltop",CFrame=CFrame.new(-499798,223.28,-441.94)},
{Name="Sanctuary",CFrame=CFrame.new(-5250.66,167.27,-3621.97)},
{Name="Woodbury",CFrame=CFrame.new(5422.83496,121.690323,845.045776,-0.93676883,4.93270811e-08,-0.349948823,2.50095535e-08,1,7.40077155e-08,0.349948823,6.05760562e-08,-0.93676883)},
{Name="Prison",CFrame=CFrame.new(5410.80664,133.174713,-3000.37769,0.726467907,-4.40537313e-08,0.687200427,-1.15541052e-08,1,7.63204113e-08,-0.687200427,-6.33847629e-08,0.726467907)},
{Name="Alexandria",CFrame=CFrame.new(294.89,116.93,-3882.18,0.95680666,9.53678807e-08,0.290724993,-8.17336243e-08,1,-5.90406835e-08,-0.290724993,3.27285115e-08,0.95680666)},
{Name="Terminus",CFrame=CFrame.new(646.30,199.54,-394.81)}
}

local WhiteLocations={
{Name="Airport",CFrame=CFrame.new(3338.46,143.08,3531.80)},
{Name="Farmhouse",CFrame=CFrame.new(3434.85,141.66,5581.14)},
{Name="Hospital",CFrame=CFrame.new(-2323.73,174.51,5059.67)},
{Name="Motel",CFrame=CFrame.new(1708.67249,202.765594,-1383.53186,-0.129178688,-8.15396906e-09,-0.991621315,1.25935751e-09,1,-8.38692316e-09,0.991621315,-2.33221753e-09,-0.129178688)},
{Name="Big Spot",CFrame=CFrame.new(1812.80127,241.352448,1038.34009,0.0501040928,-7.84629535e-08,-0.998744011,-4.46389947e-08,1,-8.0801037e-08,0.998744011,4.86313887e-08,0.0501040928)},
{Name="Satellite Outpost",CFrame=CFrame.new(-1949.0907,293.467255,874.993469,-0.626684666,3.98794171e-08,-0.779272974,2.88530888e-09,1,4.88548189e-08,0.779272974,2.83681203e-08,-0.626684666)},
{Name="Keep Out!",CFrame=CFrame.new(4907.73682,125.037056,-5001.58057,-0.998003185,-3.08994719e-09,-0.0631632134,3.46047635e-09,1,-1.03596904e-07,0.0631632134,-1.0360862e-07,-0.998003185)},
{Name="PD",CFrame=CFrame.new(4812.92334,123.837395,-1070.66711,0.999272466,1.90916261e-08,-0.0381381847,-2.14410338e-08,1,-6.11934823e-08,0.0381381847,6.19666807e-08,0.999272466)}
}

--------------------------------------------------------------------
-- ESP COLOR
--------------------------------------------------------------------

local function getEnemyColor()
local m=Settings.ESPHighlightMode
if m=="Red" then return Color3.fromRGB(255,0,0)
elseif m=="Gold" then return Color3.fromRGB(255,215,0)
elseif m=="White" then return Color3.fromRGB(255,255,255)
elseif m=="Black" then return Color3.fromRGB(15,15,15)
elseif m=="Rainbow" then return Color3.fromHSV((tick()%3)/3,1,1)
end
return Color3.fromRGB(255,0,0)
end

local function getESPColor(player)
if player==LocalPlayer then return Color3.fromRGB(0,150,255) end
return getEnemyColor()
end

--------------------------------------------------------------------
-- JUMP
--------------------------------------------------------------------

local originalJumpPower=50
local originalUseJumpPower=true
local hasSavedOriginalJump=false

local function saveOriginalValues(humanoid)
if not humanoid or not humanoid:IsA("Humanoid") or hasSavedOriginalJump then return end
local ok,usePower,power=pcall(function()
return humanoid.UseJumpPower,humanoid.JumpPower
end)
if ok and typeof(usePower)=="boolean" and typeof(power)=="number" then
originalUseJumpPower=usePower
originalJumpPower=power>0 and power or 50
else
originalUseJumpPower=true
originalJumpPower=50
end
hasSavedOriginalJump=true
end

--------------------------------------------------------------------
-- FOV
--------------------------------------------------------------------

if PlayerGui:FindFirstChild("FOVCircleGui") then
PlayerGui.FOVCircleGui:Destroy()
end

local FOVGui=Instance.new("ScreenGui")
FOVGui.Name="FOVCircleGui"
FOVGui.ResetOnSpawn=false
FOVGui.IgnoreGuiInset=true
FOVGui.Parent=PlayerGui

local FOVFrame=Instance.new("Frame")
FOVFrame.Name="CircleFrame"
FOVFrame.AnchorPoint=Vector2.new(.5,.5)
FOVFrame.Position=UDim2.new(.5,0,.5,0)
FOVFrame.Size=UDim2.new(0,Settings.FOVRadius*2,0,Settings.FOVRadius*2)
FOVFrame.BackgroundTransparency=1
FOVFrame.Visible=false
FOVFrame.Parent=FOVGui

local FOVStroke=Instance.new("UIStroke")
FOVStroke.Thickness=Settings.FOVThickness
FOVStroke.Color=Settings.FOVColor
FOVStroke.Transparency=.15
FOVStroke.Parent=FOVFrame

local FOVCorner=Instance.new("UICorner")
FOVCorner.CornerRadius=UDim.new(1,0)
FOVCorner.Parent=FOVFrame

local function updateFOVCircle()
FOVFrame.Size=UDim2.new(0,Settings.FOVRadius*2,0,Settings.FOVRadius*2)
FOVStroke.Thickness=Settings.FOVThickness
FOVStroke.Color=Settings.FOVColor
FOVStroke.Enabled=Settings.FOVThickness>0
FOVFrame.Visible=Features.TargetLock.Enabled
end

--------------------------------------------------------------------
-- PLAYER ESP
--------------------------------------------------------------------

if game.CoreGui:FindFirstChild("ESP") then game.CoreGui.ESP:Destroy() end

local ESPHolder=Instance.new("Folder")
ESPHolder.Name="ESP"
ESPHolder.Parent=game.CoreGui

local NameTagTemplate=Instance.new("BillboardGui")
NameTagTemplate.Name="NameTag"
NameTagTemplate.Size=UDim2.new(0,200,0,50)
NameTagTemplate.AlwaysOnTop=true
NameTagTemplate.StudsOffset=Vector3.new(0,2.2,0)

local Tag=Instance.new("TextLabel")
Tag.Name="Tag"
Tag.BackgroundTransparency=1
Tag.Position=UDim2.new(0,-50,0,0)
Tag.Size=UDim2.new(0,300,0,20)
Tag.TextSize=15
Tag.TextColor3=Color3.new(1,1,1)
Tag.TextStrokeColor3=Color3.new(0,0,0)
Tag.TextStrokeTransparency=.2
Tag.Font=Enum.Font.SourceSansBold
Tag.Parent=NameTagTemplate

local function updateESP()
for _,player in ipairs(Players:GetPlayers()) do
local char=player.Character
if char then
local head=char:FindFirstChild("Head")
local color=getESPColor(player)
local highlight=char:FindFirstChild("GaneInwzaHighlight")

if Features.ESP.Enabled then
if not highlight then
highlight=Instance.new("Highlight")
highlight.Name="GaneInwzaHighlight"
highlight.Adornee=char
highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
highlight.Parent=char
end
highlight.FillColor=color
highlight.OutlineColor=color
highlight.FillTransparency=.45
highlight.OutlineTransparency=0
highlight.Enabled=true
elseif highlight then
highlight.Enabled=false
end

local holder=ESPHolder:FindFirstChild(tostring(player.UserId))
if not holder then
holder=Instance.new("Folder")
holder.Name=tostring(player.UserId)
holder.Parent=ESPHolder
end

local nameTag=holder:FindFirstChild("PlayerNameTag")

if Features.ESP.Enabled and head then
if not nameTag then
nameTag=NameTagTemplate:Clone()
nameTag.Name="PlayerNameTag"
nameTag.Parent=holder
end
nameTag.Adornee=head
nameTag.Tag.Text=player.Name
nameTag.Tag.TextColor3=color
nameTag.Enabled=true
elseif nameTag then
nameTag.Enabled=false
end
end
end
end

task.spawn(function()
while task.wait(.05) do
if Features.ESP.Enabled then updateESP() end
end
end)

--------------------------------------------------------------------
-- VEHICLE ESP
--------------------------------------------------------------------

if game.CoreGui:FindFirstChild("VehicleESP") then
game.CoreGui.VehicleESP:Destroy()
end

local VehicleHolder=Instance.new("Folder")
VehicleHolder.Name="VehicleESP"
VehicleHolder.Parent=game.CoreGui

local VehicleTagTemplate=Instance.new("BillboardGui")
VehicleTagTemplate.Name="VehicleTag"
VehicleTagTemplate.Size=UDim2.new(0,200,0,50)
VehicleTagTemplate.AlwaysOnTop=true
VehicleTagTemplate.StudsOffset=Vector3.new(0,2,0)

local VTag=Instance.new("TextLabel")
VTag.Name="Tag"
VTag.BackgroundTransparency=1
VTag.Position=UDim2.new(0,-50,0,0)
VTag.Size=UDim2.new(0,300,0,20)
VTag.TextSize=15
VTag.TextColor3=_G.VehicleColor
VTag.TextStrokeColor3=Color3.new(0,0,0)
VTag.TextStrokeTransparency=.3
VTag.Font=Enum.Font.SourceSansBold
VTag.Parent=VehicleTagTemplate

local cachedSeats={}

local function trackSeat(obj)
if obj:IsA("VehicleSeat") and not table.find(cachedSeats,obj) then
table.insert(cachedSeats,obj)
end
end

for _,obj in ipairs(Workspace:GetDescendants()) do trackSeat(obj) end
Workspace.DescendantAdded:Connect(trackSeat)

local function updateVehicleESP()
if not Features.VehicleESP.Enabled then
for _,v in ipairs(VehicleHolder:GetChildren()) do
if v:IsA("BillboardGui") then v.Enabled=false end
end
return
end

local char=LocalPlayer.Character
local root=char and char:FindFirstChild("HumanoidRootPart")

for i=#cachedSeats,1,-1 do
local seat=cachedSeats[i]
if not seat or not seat.Parent then
table.remove(cachedSeats,i)
else
local model=seat:FindFirstAncestorOfClass("Model")
if model and not Players:GetPlayerFromCharacter(model) then
local id=seat:GetDebugId()
local tagGui=VehicleHolder:FindFirstChild(id)

if not tagGui then
tagGui=VehicleTagTemplate:Clone()
tagGui.Name=id
tagGui.Adornee=seat
tagGui.Parent=VehicleHolder
end

local dist=""
if root then
dist=" ["..math.floor((root.Position-seat.Position).Magnitude).."m]"
end

tagGui.Tag.Text="🚗 "..model.Name..dist
tagGui.Enabled=true
end
end
end
end

task.spawn(function()
while task.wait(.2) do
if Features.VehicleESP.Enabled then updateVehicleESP() end
end
end)

--------------------------------------------------------------------
-- FULLBRIGHT
--------------------------------------------------------------------

local function setBright()
Lighting.Brightness=2
Lighting.ClockTime=14
Lighting.FogEnd=100000
Lighting.GlobalShadows=false
Lighting.OutdoorAmbient=Color3.fromRGB(255,255,255)
Lighting.Ambient=Color3.fromRGB(255,255,255)
end

RunService.RenderStepped:Connect(function()
if Features.Fullbright.Enabled then setBright() end
end)

--------------------------------------------------------------------
-- AIMLOCK
--------------------------------------------------------------------

local currentTarget=nil

local function getClosestTarget()
local closest=nil
local shortest=Settings.FOVRadius
local center=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2)

for _,player in ipairs(Players:GetPlayers()) do
if player~=LocalPlayer and player.Character then
local part=player.Character:FindFirstChild(Settings.TargetPart)
local hum=player.Character:FindFirstChildOfClass("Humanoid")

if part and hum and hum.Health>0 then
local pos,onScreen=Camera:WorldToViewportPoint(part.Position)
if onScreen then
local dist=(Vector2.new(pos.X,pos.Y)-center).Magnitude
if dist<shortest then
shortest=dist
closest=player.Character
end
end
end
end
end
return closest
end

RunService.RenderStepped:Connect(function()
if Features.TargetLock.Enabled then
currentTarget=getClosestTarget()
if currentTarget then
local part=currentTarget:FindFirstChild(Settings.TargetPart)
if part then
Camera.CFrame=CFrame.new(Camera.CFrame.Position,part.Position)
end
end
end
end)

--------------------------------------------------------------------
-- HIGH JUMP
--------------------------------------------------------------------

RunService.Stepped:Connect(function()
local char=LocalPlayer.Character
local hum=char and char:FindFirstChildOfClass("Humanoid")

if hum then
saveOriginalValues(hum)

if Features.HighJump.Enabled then
hum.UseJumpPower=true
if hum.JumpPower~=Settings.JumpPowerVal then
hum.JumpPower=Settings.JumpPowerVal
end
elseif hum.JumpPower==Settings.JumpPowerVal then
hum.UseJumpPower=originalUseJumpPower
hum.JumpPower=originalJumpPower
end
end
end)

LocalPlayer.CharacterAdded:Connect(function(char)
hasSavedOriginalJump=false
local hum=char:WaitForChild("Humanoid")
task.wait(.5)
saveOriginalValues(hum)
end)

if LocalPlayer.Character then
local hum=LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
if hum then saveOriginalValues(hum) end
end

--------------------------------------------------------------------
-- GUI
--------------------------------------------------------------------

local ScreenGui=Instance.new("ScreenGui")
ScreenGui.Name="GaneInwzaHub"
ScreenGui.ResetOnSpawn=false
ScreenGui.Parent=PlayerGui

--------------------------------------------------------------------
-- THEME SYSTEM
--------------------------------------------------------------------

local themesList={
{
NameTH="ดำ",NameEN="Black",
MainColor=Color3.fromRGB(17,17,23),
SideColor=Color3.fromRGB(12,12,17),
RowColor=Color3.fromRGB(27,27,36),
ButtonColor=Color3.fromRGB(34,34,45),
HoverColor=Color3.fromRGB(43,43,56),
TextColor=Color3.fromRGB(235,235,242),
SubText=Color3.fromRGB(170,170,185)
},
{
NameTH="ขาว",NameEN="White",
MainColor=Color3.fromRGB(232,233,238),
SideColor=Color3.fromRGB(210,211,218),
RowColor=Color3.fromRGB(246,246,249),
ButtonColor=Color3.fromRGB(220,221,228),
HoverColor=Color3.fromRGB(205,206,214),
TextColor=Color3.fromRGB(28,28,35),
SubText=Color3.fromRGB(80,80,90)
},
{
NameTH="ทอง",NameEN="Gold",
MainColor=Color3.fromRGB(42,35,16),
SideColor=Color3.fromRGB(27,22,9),
RowColor=Color3.fromRGB(61,51,20),
ButtonColor=Color3.fromRGB(76,64,27),
HoverColor=Color3.fromRGB(92,77,32),
TextColor=Color3.fromRGB(255,241,195),
SubText=Color3.fromRGB(210,190,135)
},
{
NameTH="แดงเข้ม",NameEN="Crimson",
MainColor=Color3.fromRGB(30,14,20),
SideColor=Color3.fromRGB(20,9,14),
RowColor=Color3.fromRGB(48,21,29),
ButtonColor=Color3.fromRGB(63,27,37),
HoverColor=Color3.fromRGB(78,32,44),
TextColor=Color3.fromRGB(255,225,232),
SubText=Color3.fromRGB(205,160,172)
}
}

local currentThemeIndex=1
local Theme=themesList[currentThemeIndex]

--------------------------------------------------------------------
-- CHAT HEAD
--------------------------------------------------------------------

local ChatHead=Instance.new("TextButton")
ChatHead.Name="ChatHead"
ChatHead.Size=UDim2.new(0,48,0,48)
ChatHead.Position=UDim2.new(0,30,.5,-24)
ChatHead.BackgroundColor3=Theme.MainColor
ChatHead.Text="G"
ChatHead.TextColor3=Color3.fromRGB(255,45,85)
ChatHead.TextSize=23
ChatHead.Font=Enum.Font.Gotham
ChatHead.Active=true
ChatHead.Draggable=true
ChatHead.Parent=ScreenGui

Instance.new("UICorner",ChatHead).CornerRadius=UDim.new(1,0)

local ChatHeadStroke=Instance.new("UIStroke")
ChatHeadStroke.Color=Color3.fromRGB(255,45,85)
ChatHeadStroke.Thickness=2
ChatHeadStroke.Parent=ChatHead

--------------------------------------------------------------------
-- MAIN FRAME
--------------------------------------------------------------------

local MainFrame=Instance.new("Frame")
MainFrame.Name="MainFrame"
MainFrame.Size=UDim2.new(0,560,0,400)
MainFrame.Position=UDim2.new(.5,-280,.5,-200)
MainFrame.BackgroundColor3=Theme.MainColor
MainFrame.BorderSizePixel=0
MainFrame.ClipsDescendants=true
MainFrame.Active=true
MainFrame.Draggable=true
MainFrame.Parent=ScreenGui

Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,10)

--------------------------------------------------------------------
-- STATUS DISPLAY
--------------------------------------------------------------------

local StatusGui=Instance.new("Frame")
StatusGui.Name="StatusDisplay"
StatusGui.Size=UDim2.new(0,150,0,160)
StatusGui.Position=UDim2.new(1,-160,0,10)
StatusGui.BackgroundTransparency=1
StatusGui.Visible=false
StatusGui.Parent=ScreenGui

local StatusLayout=Instance.new("UIListLayout")
StatusLayout.SortOrder=Enum.SortOrder.LayoutOrder
StatusLayout.Padding=UDim.new(0,3)
StatusLayout.Parent=StatusGui

local statusRows={}
local statusDefinitions={
{Key="ESP",Text="ESP"},
{Key="VehicleESP",Text="Vehicle ESP"},
{Key="Fullbright",Text="Fullbright"},
{Key="TargetLock",Text="Aimlock"},
{Key="HighJump",Text="High Jump"}
}

for _,info in ipairs(statusDefinitions) do
local row=Instance.new("Frame")
row.Name="Status_"..info.Key
row.Size=UDim2.new(1,0,0,20)
row.BackgroundColor3=Color3.fromRGB(15,15,18)
row.BackgroundTransparency=.2
row.BorderSizePixel=0
row.Visible=false
row.Parent=StatusGui
Instance.new("UICorner",row).CornerRadius=UDim.new(0,5)

local dot=Instance.new("Frame")
dot.Size=UDim2.new(0,8,0,8)
dot.Position=UDim2.new(0,7,.5,-4)
dot.BackgroundColor3=Color3.fromRGB(60,255,100)
dot.BorderSizePixel=0
dot.Parent=row
Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

local label=Instance.new("TextLabel")
label.Size=UDim2.new(1,-25,1,0)
label.Position=UDim2.new(0,22,0,0)
label.BackgroundTransparency=1
label.Text=info.Text
label.TextColor3=Color3.fromRGB(235,235,235)
label.TextSize=11
label.Font=Enum.Font.GothamBold
label.TextXAlignment=Enum.TextXAlignment.Left
label.Parent=row

statusRows[info.Key]=row
end

local function updateStatusDisplay()
if not Settings.StatusDisplayEnabled then
StatusGui.Visible=false
return
end

local count=0
for _,info in ipairs(statusDefinitions) do
local enabled=Features[info.Key] and Features[info.Key].Enabled
statusRows[info.Key].Visible=enabled
if enabled then count+=1 end
end
StatusGui.Visible=count>0
end

--------------------------------------------------------------------
-- TOP BUTTONS
--------------------------------------------------------------------

local MinimizeBtn=Instance.new("TextButton")
MinimizeBtn.Size=UDim2.new(0,26,0,26)
MinimizeBtn.Position=UDim2.new(1,-62,0,10)
MinimizeBtn.BackgroundColor3=Theme.ButtonColor
MinimizeBtn.Text="-"
MinimizeBtn.TextColor3=Theme.TextColor
MinimizeBtn.TextSize=14
MinimizeBtn.Font=Enum.Font.GothamBold
MinimizeBtn.Parent=MainFrame
Instance.new("UICorner",MinimizeBtn).CornerRadius=UDim.new(0,5)

local CloseBtn=Instance.new("TextButton")
CloseBtn.Size=UDim2.new(0,26,0,26)
CloseBtn.Position=UDim2.new(1,-30,0,10)
CloseBtn.BackgroundColor3=Color3.fromRGB(200,40,40)
CloseBtn.Text="X"
CloseBtn.TextColor3=Color3.new(1,1,1)
CloseBtn.TextSize=12
CloseBtn.Font=Enum.Font.GothamBold
CloseBtn.Parent=MainFrame
Instance.new("UICorner",CloseBtn).CornerRadius=UDim.new(0,5)

ChatHead.MouseButton1Click:Connect(function()
MainFrame.Visible=not MainFrame.Visible
ChatHead.Visible=not MainFrame.Visible
end)

MinimizeBtn.MouseButton1Click:Connect(function()
MainFrame.Visible=false
ChatHead.Visible=true
end)

--------------------------------------------------------------------
-- SIDEBAR
--------------------------------------------------------------------

local Sidebar=Instance.new("Frame")
Sidebar.Size=UDim2.new(0,150,1,0)
Sidebar.BackgroundColor3=Theme.SideColor
Sidebar.BorderSizePixel=0
Sidebar.Parent=MainFrame

local TitleLabel=Instance.new("TextLabel")
TitleLabel.Name="TitleLabel"
TitleLabel.Size=UDim2.new(1,-20,0,45)
TitleLabel.Position=UDim2.new(0,12,0,8)
TitleLabel.BackgroundTransparency=1
TitleLabel.Text="Gane inwza"
TitleLabel.TextColor3=Color3.fromRGB(255,55,95)
TitleLabel.TextSize=21
TitleLabel.Font=Enum.Font.GothamBlack
TitleLabel.TextXAlignment=Enum.TextXAlignment.Left
TitleLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
TitleLabel.TextStrokeTransparency=.55
TitleLabel.Parent=Sidebar

--------------------------------------------------------------------
-- CONTAINERS
--------------------------------------------------------------------

local function makeContainer(name)
local c=Instance.new("ScrollingFrame")
c.Name=name
c.Size=UDim2.new(1,-165,1,-50)
c.Position=UDim2.new(0,155,0,45)
c.BackgroundTransparency=1
c.BorderSizePixel=0
c.ScrollBarThickness=4
c.CanvasSize=UDim2.new(0,0,0,0)
c.AutomaticCanvasSize=Enum.AutomaticSize.Y
c.Visible=false
c.Parent=MainFrame
local l=Instance.new("UIListLayout")
l.SortOrder=Enum.SortOrder.LayoutOrder
l.Padding=UDim.new(0,8)
l.Parent=c
return c
end

local MainContainer=makeContainer("MainContainer")
local OtherContainer=makeContainer("OtherContainer")
local TeleportContainer=makeContainer("TeleportContainer")
MainContainer.Visible=true

--------------------------------------------------------------------
-- TAB BUTTONS
--------------------------------------------------------------------

local tabButtonReferences={}

local function createTabButton(nameKey,order,target)
local b=Instance.new("TextButton")
b.Name="TabBtn_"..nameKey
b.Size=UDim2.new(1,-20,0,36)
b.Position=UDim2.new(0,10,0,55+order*42)
b.BackgroundColor3=target.Visible and Theme.HoverColor or Theme.ButtonColor
b.Text=LangText[CurrentLanguage]["Tab"..nameKey]
b.TextColor3=Theme.TextColor
b.TextSize=13
b.Font=Enum.Font.GothamBold
b.Parent=Sidebar
Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)

table.insert(tabButtonReferences,{Btn=b,Key="Tab"..nameKey})

b.MouseButton1Click:Connect(function()
MainContainer.Visible=target==MainContainer
OtherContainer.Visible=target==OtherContainer
TeleportContainer.Visible=target==TeleportContainer

for _,x in ipairs(Sidebar:GetChildren()) do
if x:IsA("TextButton") and x~=CloseBtn and x~=MinimizeBtn then
if x.Name:sub(1,7)=="TabBtn_" then
x.BackgroundColor3=Theme.ButtonColor
end
end
end

b.BackgroundColor3=Theme.HoverColor
end)
end

createTabButton("Main",0,MainContainer)
createTabButton("Other",1,OtherContainer)
createTabButton("Teleport",2,TeleportContainer)

--------------------------------------------------------------------
-- FEATURE ROW
--------------------------------------------------------------------

local listeningFeature=nil
local listeningMenuKey=false
local localizedLabels={}

local function createFeatureRow(featureKey,textKey,parent)
local data=Features[featureKey]

local row=Instance.new("Frame")
row.Size=UDim2.new(1,-10,0,45)
row.BackgroundColor3=Theme.RowColor
row.Parent=parent
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

local label=Instance.new("TextLabel")
label.Size=UDim2.new(1,-150,1,0)
label.Position=UDim2.new(0,12,0,0)
label.BackgroundTransparency=1
label.Text=LangText[CurrentLanguage][textKey]
label.TextColor3=Theme.TextColor
label.TextSize=13
label.Font=Enum.Font.GothamSemibold
label.TextXAlignment=Enum.TextXAlignment.Left
label.Parent=row
table.insert(localizedLabels,{Label=label,Key=textKey})

local key=Instance.new("TextButton")
key.Size=UDim2.new(0,65,0,26)
key.Position=UDim2.new(1,-125,.5,-13)
key.BackgroundColor3=Theme.ButtonColor
key.Text=data.Key and "["..data.Key.Name.."]" or "[None]"
key.TextColor3=Theme.SubText
key.TextSize=11
key.Font=Enum.Font.GothamBold
key.Parent=row
Instance.new("UICorner",key).CornerRadius=UDim.new(0,4)

local switch=Instance.new("TextButton")
switch.Size=UDim2.new(0,44,0,22)
switch.Position=UDim2.new(1,-54,.5,-11)
switch.BackgroundColor3=data.Enabled and Color3.fromRGB(255,45,85) or Theme.ButtonColor
switch.Text=""
switch.AutoButtonColor=false
switch.Parent=row
Instance.new("UICorner",switch).CornerRadius=UDim.new(1,0)

local dot=Instance.new("Frame")
dot.Size=UDim2.new(0,16,0,16)
dot.Position=data.Enabled and UDim2.new(1,-19,.5,-8) or UDim2.new(0,3,.5,-8)
dot.BackgroundColor3=Color3.new(1,1,1)
dot.Parent=switch
Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)

local function updateSwitch(state)
data.Enabled=state
switch.BackgroundColor3=state and Color3.fromRGB(255,45,85) or Theme.ButtonColor
dot:TweenPosition(state and UDim2.new(1,-19,.5,-8) or UDim2.new(0,3,.5,-8),"Out","Quad",.15,true)

if featureKey=="ESP" then updateESP() end
if featureKey=="VehicleESP" then updateVehicleESP() end
updateFOVCircle()
updateStatusDisplay()
end

switch.MouseButton1Click:Connect(function()
updateSwitch(not data.Enabled)
end)

key.MouseButton1Click:Connect(function()
if not listeningFeature and not listeningMenuKey then
listeningFeature={KeyBtn=key,FeatureKey=featureKey}
key.Text="..."
key.TextColor3=Color3.fromRGB(255,200,0)
end
end)

data.ToggleVisual=updateSwitch
end

--------------------------------------------------------------------
-- SLIDER
--------------------------------------------------------------------

local sliderReferences={}

local function createSlider(titleKey,minVal,maxVal,defaultVal,callback,parent)
local row=Instance.new("Frame")
row.Size=UDim2.new(1,-10,0,50)
row.BackgroundColor3=Theme.RowColor
row.Parent=parent
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

local label=Instance.new("TextLabel")
label.Size=UDim2.new(1,-24,0,20)
label.Position=UDim2.new(0,12,0,4)
label.BackgroundTransparency=1
label.Text=LangText[CurrentLanguage][titleKey]..": "..defaultVal
label.TextColor3=Theme.TextColor
label.TextSize=12
label.Font=Enum.Font.GothamSemibold
label.TextXAlignment=Enum.TextXAlignment.Left
label.Parent=row

local ref={Label=label,Key=titleKey,CurrentVal=defaultVal}
table.insert(sliderReferences,ref)

local bar=Instance.new("Frame")
bar.Size=UDim2.new(1,-24,0,6)
bar.Position=UDim2.new(0,12,0,32)
bar.BackgroundColor3=Theme.ButtonColor
bar.Parent=row
Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

local fill=Instance.new("Frame")
fill.Size=UDim2.new((defaultVal-minVal)/(maxVal-minVal),0,1,0)
fill.BackgroundColor3=Color3.fromRGB(255,45,85)
fill.Parent=bar
Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

local dragging=false

local function update(input)
local pct=math.clamp((input.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
fill.Size=UDim2.new(pct,0,1,0)
local value=math.floor(minVal+pct*(maxVal-minVal))
ref.CurrentVal=value
label.Text=LangText[CurrentLanguage][titleKey]..": "..value
callback(value)
end

bar.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then
dragging=true
update(input)
end
end)

UserInputService.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
end)

UserInputService.InputChanged:Connect(function(input)
if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then update(input) end
end)
end

--------------------------------------------------------------------
-- MAIN FEATURES
--------------------------------------------------------------------

createFeatureRow("ESP","ESP",MainContainer)
createFeatureRow("VehicleESP","VehicleESP",MainContainer)
createFeatureRow("Fullbright","Fullbright",MainContainer)
createFeatureRow("TargetLock","Aimlock",MainContainer)
createFeatureRow("HighJump","HighJump",MainContainer)

createSlider("JumpPower",50,350,Settings.JumpPowerVal,function(v)
Settings.JumpPowerVal=v
end,MainContainer)

--------------------------------------------------------------------
-- STATIC TELEPORT BUTTON
--------------------------------------------------------------------

local function createTeleportButton(name,cframe,textColor)
local b=Instance.new("TextButton")
b.Size=UDim2.new(1,-10,0,36)
b.BackgroundColor3=Theme.RowColor
b.Text=name
b.TextColor3=textColor
b.TextSize=13
b.Font=Enum.Font.GothamSemibold
b.Parent=TeleportContainer
Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)

b.MouseButton1Click:Connect(function()
local char=LocalPlayer.Character
local root=char and char:FindFirstChild("HumanoidRootPart")
if root then root.CFrame=cframe end
end)

return b
end

local function createTeleportHeader(text,color)
local l=Instance.new("TextLabel")
l.Size=UDim2.new(1,-10,0,26)
l.BackgroundTransparency=1
l.Text=text
l.TextColor3=color
l.TextSize=12
l.Font=Enum.Font.GothamBold
l.TextXAlignment=Enum.TextXAlignment.Left
l.Parent=TeleportContainer
return l
end

createTeleportHeader("★ Main Locations",Color3.fromRGB(255,215,0))

for _,loc in ipairs(YellowLocations) do
createTeleportButton(loc.Name,loc.CFrame,Color3.fromRGB(255,215,0))
end

createTeleportHeader("★ Other Locations",Color3.fromRGB(235,235,240))

for _,loc in ipairs(WhiteLocations) do
createTeleportButton(loc.Name,loc.CFrame,Color3.fromRGB(255,255,255))
end

--------------------------------------------------------------------
-- DYNAMIC TELEPORT
-- COLLAPSIBLE VEHICLE / PLAYER LIST
--------------------------------------------------------------------

local DynamicPrefix="__DynamicTeleport_"
local vehiclesExpanded=false
local playersExpanded=false

local function getRoot()
local char=LocalPlayer.Character
return char and char:FindFirstChild("HumanoidRootPart")
end

local function distanceFromMe(pos)
local root=getRoot()
if not root then return math.huge end
return (root.Position-pos).Magnitude
end

local function teleportToPart(part)
local root=getRoot()
if root and part and part:IsA("BasePart") then
root.CFrame=part.CFrame+Vector3.new(0,3,0)
end
end

local function clearDynamic()
for _,child in ipairs(TeleportContainer:GetChildren()) do
if child.Name:sub(1,#DynamicPrefix)==DynamicPrefix then
child:Destroy()
end
end
end

local function collectVehicles()
local list={}
local seen={}

for _,obj in ipairs(Workspace:GetDescendants()) do
if obj:IsA("VehicleSeat") then
local model=obj:FindFirstAncestorOfClass("Model")
if model and not seen[model] then
local part=model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart",true)
if part then
seen[model]=true
table.insert(list,{Model=model,Part=part,Distance=distanceFromMe(part.Position)})
end
end
end
end

table.sort(list,function(a,b)
return a.Distance<b.Distance
end)

local result={}
for i=1,math.min(10,#list) do
result[i]=list[i]
end

return result
end

local function collectPlayers()
local list={}

for _,player in ipairs(Players:GetPlayers()) do
if player~=LocalPlayer then
local char=player.Character
local root=char and char:FindFirstChild("HumanoidRootPart")
if root then
table.insert(list,{
Player=player,
Root=root,
Distance=distanceFromMe(root.Position)
})
end
end
end

table.sort(list,function(a,b)
return a.Distance<b.Distance
end)

return list
end

local function dynamicButton(name,text,color,callback)
local b=Instance.new("TextButton")
b.Name=DynamicPrefix..name
b.Size=UDim2.new(1,-10,0,36)
b.BackgroundColor3=Theme.RowColor
b.Text=text
b.TextColor3=color
b.TextSize=12
b.Font=Enum.Font.GothamSemibold
b.Parent=TeleportContainer
Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
b.MouseButton1Click:Connect(callback)
return b
end

local function dynamicHeader(name,text,color,expanded)
local b=Instance.new("TextButton")
b.Name=DynamicPrefix..name
b.Size=UDim2.new(1,-10,0,38)
b.BackgroundColor3=Theme.ButtonColor
b.Text=(expanded and "▼ " or "▶ ")..text
b.TextColor3=color
b.TextSize=13
b.Font=Enum.Font.GothamBold
b.TextXAlignment=Enum.TextXAlignment.Left
b.Parent=TeleportContainer
Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
return b
end

local function updateDynamicTeleportUI()
clearDynamic()

----------------------------------------------------------------
-- VEHICLES
----------------------------------------------------------------

local vehicles=collectVehicles()

local vehicleHeader=dynamicHeader(
"VehicleHeader",
"🚗 "..LangText[CurrentLanguage].VehicleList.."  •  "..#vehicles.." คันใกล้สุด",
Color3.fromRGB(255,190,50),
vehiclesExpanded
)

vehicleHeader.MouseButton1Click:Connect(function()
vehiclesExpanded=not vehiclesExpanded
updateDynamicTeleportUI()
end)

if vehiclesExpanded then
if #vehicles==0 then
dynamicButton("NoVehicles",LangText[CurrentLanguage].NoVehicles,Color3.fromRGB(150,150,160),function()end)
else
for i,vehicle in ipairs(vehicles) do
local dist=math.floor(vehicle.Distance)
dynamicButton(
"Vehicle_"..i,
"🚗 "..vehicle.Model.Name.."  ["..dist.."m]",
Color3.fromRGB(255,170,0),
function()
teleportToPart(vehicle.Part)
end
)
end
end
end

----------------------------------------------------------------
-- PLAYERS
----------------------------------------------------------------

local players=collectPlayers()

local playerHeader=dynamicHeader(
"PlayerHeader",
"👤 "..LangText[CurrentLanguage].PlayerList.."  •  "..#players.." คน",
Color3.fromRGB(245,245,250),
playersExpanded
)

playerHeader.MouseButton1Click:Connect(function()
playersExpanded=not playersExpanded
updateDynamicTeleportUI()
end)

if playersExpanded then
if #players==0 then
dynamicButton("NoPlayers",LangText[CurrentLanguage].NoPlayers,Color3.fromRGB(150,150,160),function()end)
else
for i,info in ipairs(players) do
local dist=math.floor(info.Distance)
dynamicButton(
"Player_"..i,
"👤 @"..info.Player.Name.."  ["..dist.."m]",
Color3.fromRGB(255,255,255),
function()
teleportToPart(info.Root)
end
)
end
end
end
end

task.spawn(function()
while task.wait(.75) do
if TeleportContainer.Visible then
updateDynamicTeleportUI()
end
end
end)

--------------------------------------------------------------------
-- OTHER SETTINGS
--------------------------------------------------------------------

local function createSettingRow(parent,labelText)
local row=Instance.new("Frame")
row.Size=UDim2.new(1,-10,0,45)
row.BackgroundColor3=Theme.RowColor
row.Parent=parent
Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

local label=Instance.new("TextLabel")
label.Size=UDim2.new(0,150,1,0)
label.Position=UDim2.new(0,12,0,0)
label.BackgroundTransparency=1
label.Text=labelText
label.TextColor3=Theme.TextColor
label.TextSize=13
label.Font=Enum.Font.GothamSemibold
label.TextXAlignment=Enum.TextXAlignment.Left
label.Parent=row

return row,label
end

--------------------------------------------------------------------
-- LANGUAGE
--------------------------------------------------------------------

local LangRow,LangLabelRef=createSettingRow(
OtherContainer,
LangText[CurrentLanguage].LangToggle
)
table.insert(localizedLabels,{Label=LangLabelRef,Key="LangToggle"})

local LangBtn=Instance.new("TextButton")
LangBtn.Size=UDim2.new(0,110,0,26)
LangBtn.Position=UDim2.new(1,-120,.5,-13)
LangBtn.BackgroundColor3=Theme.ButtonColor
LangBtn.Text="ไทย"
LangBtn.TextColor3=Theme.TextColor
LangBtn.TextSize=11
LangBtn.Font=Enum.Font.GothamBold
LangBtn.Parent=LangRow
Instance.new("UICorner",LangBtn).CornerRadius=UDim.new(0,4)

--------------------------------------------------------------------
-- STATUS
--------------------------------------------------------------------

local StatusRow,StatusLabel=createSettingRow(
OtherContainer,
LangText[CurrentLanguage].StatusDisplay
)
table.insert(localizedLabels,{Label=StatusLabel,Key="StatusDisplay"})

local StatusBtn=Instance.new("TextButton")
StatusBtn.Size=UDim2.new(0,110,0,26)
StatusBtn.Position=UDim2.new(1,-120,.5,-13)
StatusBtn.BackgroundColor3=Theme.ButtonColor
StatusBtn.Text="ON"
StatusBtn.TextColor3=Color3.fromRGB(70,255,100)
StatusBtn.TextSize=11
StatusBtn.Font=Enum.Font.GothamBold
StatusBtn.Parent=StatusRow
Instance.new("UICorner",StatusBtn).CornerRadius=UDim.new(0,4)

local function updateStatusButton()
StatusBtn.Text=Settings.StatusDisplayEnabled and "ON" or "OFF"
StatusBtn.TextColor3=Settings.StatusDisplayEnabled
and Color3.fromRGB(70,255,100)
or Theme.SubText
end

StatusBtn.MouseButton1Click:Connect(function()
Settings.StatusDisplayEnabled=not Settings.StatusDisplayEnabled
updateStatusButton()
updateStatusDisplay()
end)

--------------------------------------------------------------------
-- MENU KEY
--------------------------------------------------------------------

local MenuKeyRow,MenuKeyLabel=createSettingRow(
OtherContainer,
LangText[CurrentLanguage].MenuKey
)
table.insert(localizedLabels,{Label=MenuKeyLabel,Key="MenuKey"})

local MenuKeyBtn=Instance.new("TextButton")
MenuKeyBtn.Size=UDim2.new(0,110,0,26)
MenuKeyBtn.Position=UDim2.new(1,-120,.5,-13)
MenuKeyBtn.BackgroundColor3=Theme.ButtonColor
MenuKeyBtn.Text="["..Settings.MenuToggleKey.Name.."]"
MenuKeyBtn.TextColor3=Theme.SubText
MenuKeyBtn.TextSize=11
MenuKeyBtn.Font=Enum.Font.GothamBold
MenuKeyBtn.Parent=MenuKeyRow
Instance.new("UICorner",MenuKeyBtn).CornerRadius=UDim.new(0,4)

MenuKeyBtn.MouseButton1Click:Connect(function()
if not listeningFeature and not listeningMenuKey then
listeningMenuKey=true
MenuKeyBtn.Text="..."
MenuKeyBtn.TextColor3=Color3.fromRGB(255,200,0)
end
end)

--------------------------------------------------------------------
-- ESP COLOR
--------------------------------------------------------------------

local ESPColorRow,ESPColorLabel=createSettingRow(
OtherContainer,
LangText[CurrentLanguage].ESPColor
)
table.insert(localizedLabels,{Label=ESPColorLabel,Key="ESPColor"})

local espColorModes={"Red","Gold","White","Black","Rainbow"}
local espColorIndex=1

local ESPColorBtn=Instance.new("TextButton")
ESPColorBtn.Size=UDim2.new(0,110,0,26)
ESPColorBtn.Position=UDim2.new(1,-120,.5,-13)
ESPColorBtn.BackgroundColor3=Theme.ButtonColor
ESPColorBtn.Text=Settings.ESPHighlightMode
ESPColorBtn.TextColor3=getEnemyColor()
ESPColorBtn.TextSize=11
ESPColorBtn.Font=Enum.Font.GothamBold
ESPColorBtn.Parent=ESPColorRow
Instance.new("UICorner",ESPColorBtn).CornerRadius=UDim.new(0,4)

ESPColorBtn.MouseButton1Click:Connect(function()
espColorIndex=espColorIndex%#espColorModes+1
Settings.ESPHighlightMode=espColorModes[espColorIndex]
ESPColorBtn.Text=Settings.ESPHighlightMode
ESPColorBtn.TextColor3=getEnemyColor()
updateESP()
end)

--------------------------------------------------------------------
-- THEME
--------------------------------------------------------------------

local ThemeRow,ThemeLabel=createSettingRow(
OtherContainer,
LangText[CurrentLanguage].MenuTheme
)
table.insert(localizedLabels,{Label=ThemeLabel,Key="MenuTheme"})

local ThemeBtn=Instance.new("TextButton")
ThemeBtn.Size=UDim2.new(0,110,0,26)
ThemeBtn.Position=UDim2.new(1,-120,.5,-13)
ThemeBtn.BackgroundColor3=Theme.ButtonColor
ThemeBtn.Text=Theme.NameTH
ThemeBtn.TextColor3=Theme.TextColor
ThemeBtn.TextSize=11
ThemeBtn.Font=Enum.Font.GothamBold
ThemeBtn.Parent=ThemeRow
Instance.new("UICorner",ThemeBtn).CornerRadius=UDim.new(0,4)

--------------------------------------------------------------------
-- TARGET PART
--------------------------------------------------------------------

local TargetRow,TargetLabel=createSettingRow(
OtherContainer,
LangText[CurrentLanguage].TargetPart
)
table.insert(localizedLabels,{Label=TargetLabel,Key="TargetPart"})

local TargetBtn=Instance.new("TextButton")
TargetBtn.Size=UDim2.new(0,110,0,26)
TargetBtn.Position=UDim2.new(1,-120,.5,-13)
TargetBtn.BackgroundColor3=Theme.ButtonColor
TargetBtn.Text=LangText[CurrentLanguage].Head
TargetBtn.TextColor3=Theme.TextColor
TargetBtn.TextSize=11
TargetBtn.Font=Enum.Font.GothamBold
TargetBtn.Parent=TargetRow
Instance.new("UICorner",TargetBtn).CornerRadius=UDim.new(0,4)

TargetBtn.MouseButton1Click:Connect(function()
if Settings.TargetPart=="Head" then
Settings.TargetPart="HumanoidRootPart"
TargetBtn.Text=LangText[CurrentLanguage].Torso
else
Settings.TargetPart="Head"
TargetBtn.Text=LangText[CurrentLanguage].Head
end
end)

--------------------------------------------------------------------
-- FOV COLOR
--------------------------------------------------------------------

local ColorRow,ColorLabel=createSettingRow(
OtherContainer,
LangText[CurrentLanguage].FOVColor
)
table.insert(localizedLabels,{Label=ColorLabel,Key="FOVColor"})

local colorsList={
{Name="White",Color=Color3.fromRGB(255,255,255)},
{Name="Red",Color=Color3.fromRGB(255,50,50)},
{Name="Green",Color=Color3.fromRGB(50,255,50)},
{Name="Blue",Color=Color3.fromRGB(50,150,255)},
{Name="Yellow",Color=Color3.fromRGB(255,255,50)},
{Name="Pink",Color=Color3.fromRGB(255,105,180)}
}

local currentColorIndex=1

local ColorBtn=Instance.new("TextButton")
ColorBtn.Size=UDim2.new(0,110,0,26)
ColorBtn.Position=UDim2.new(1,-120,.5,-13)
ColorBtn.BackgroundColor3=Theme.ButtonColor
ColorBtn.Text=colorsList[1].Name
ColorBtn.TextColor3=colorsList[1].Color
ColorBtn.TextSize=11
ColorBtn.Font=Enum.Font.GothamBold
ColorBtn.Parent=ColorRow
Instance.new("UICorner",ColorBtn).CornerRadius=UDim.new(0,4)

ColorBtn.MouseButton1Click:Connect(function()
currentColorIndex=currentColorIndex%#colorsList+1
local selected=colorsList[currentColorIndex]
ColorBtn.Text=selected.Name
ColorBtn.TextColor3=selected.Color
Settings.FOVColor=selected.Color
updateFOVCircle()
end)

--------------------------------------------------------------------
-- FOV SLIDERS
--------------------------------------------------------------------

createSlider("FOVRadius",50,600,Settings.FOVRadius,function(v)
Settings.FOVRadius=v
updateFOVCircle()
end,OtherContainer)

createSlider("FOVThickness",0,10,Settings.FOVThickness,function(v)
Settings.FOVThickness=v
updateFOVCircle()
end,OtherContainer)

--------------------------------------------------------------------
-- APPLY THEME
--------------------------------------------------------------------

local function applyTheme()
Theme=themesList[currentThemeIndex]

MainFrame.BackgroundColor3=Theme.MainColor
Sidebar.BackgroundColor3=Theme.SideColor
ChatHead.BackgroundColor3=Theme.MainColor

TitleLabel.TextColor3=Color3.fromRGB(255,55,95)

local containers={MainContainer,OtherContainer,TeleportContainer}

for _,container in ipairs(containers) do
for _,child in ipairs(container:GetChildren()) do
if child:IsA("Frame") then
child.BackgroundColor3=Theme.RowColor
elseif child:IsA("TextButton") then
child.BackgroundColor3=Theme.RowColor
end

for _,sub in ipairs(child:GetChildren()) do
if sub:IsA("TextLabel") then
if sub.Name~="Tag" then
sub.TextColor3=Theme.TextColor
end
elseif sub:IsA("TextButton") then
sub.BackgroundColor3=Theme.ButtonColor
end
end
end
end

for _,child in ipairs(Sidebar:GetChildren()) do
if child:IsA("TextButton") and child.Name:sub(1,7)=="TabBtn_" then
child.BackgroundColor3=Theme.ButtonColor
child.TextColor3=Theme.TextColor
end
end

for _,ref in ipairs(localizedLabels) do
ref.Label.TextColor3=Theme.TextColor
end

MinimizeBtn.BackgroundColor3=Theme.ButtonColor
MinimizeBtn.TextColor3=Theme.TextColor
MenuKeyBtn.BackgroundColor3=Theme.ButtonColor
LangBtn.BackgroundColor3=Theme.ButtonColor
StatusBtn.BackgroundColor3=Theme.ButtonColor
ESPColorBtn.BackgroundColor3=Theme.ButtonColor
ThemeBtn.BackgroundColor3=Theme.ButtonColor
TargetBtn.BackgroundColor3=Theme.ButtonColor
ColorBtn.BackgroundColor3=Theme.ButtonColor

updateStatusButton()

if TeleportContainer.Visible then
updateDynamicTeleportUI()
end
end

ThemeBtn.MouseButton1Click:Connect(function()
currentThemeIndex=currentThemeIndex%#themesList+1
Theme=themesList[currentThemeIndex]
ThemeBtn.Text=CurrentLanguage=="TH" and Theme.NameTH or Theme.NameEN
applyTheme()
end)

--------------------------------------------------------------------
-- LANGUAGE UPDATE
--------------------------------------------------------------------

local function updateLanguageUI()
TitleLabel.Text=LangText[CurrentLanguage].HubTitle

for _,ref in ipairs(tabButtonReferences) do
ref.Btn.Text=LangText[CurrentLanguage][ref.Key]
end

for _,ref in ipairs(localizedLabels) do
ref.Label.Text=LangText[CurrentLanguage][ref.Key]
end

for _,ref in ipairs(sliderReferences) do
ref.Label.Text=LangText[CurrentLanguage][ref.Key]..": "..ref.CurrentVal
end

ThemeBtn.Text=CurrentLanguage=="TH" and Theme.NameTH or Theme.NameEN
LangBtn.Text=CurrentLanguage=="TH" and "ไทย" or "English"

TargetBtn.Text=Settings.TargetPart=="Head"
and LangText[CurrentLanguage].Head
or LangText[CurrentLanguage].Torso

if TeleportContainer.Visible then
updateDynamicTeleportUI()
end
end

LangBtn.MouseButton1Click:Connect(function()
CurrentLanguage=CurrentLanguage=="TH" and "EN" or "TH"
updateLanguageUI()
end)

--------------------------------------------------------------------
-- HOTKEYS
--------------------------------------------------------------------

UserInputService.InputBegan:Connect(function(input,gameProcessed)
if gameProcessed then return end

if listeningMenuKey then
if input.UserInputType==Enum.UserInputType.Keyboard then
if input.KeyCode~=Enum.KeyCode.Unknown then
Settings.MenuToggleKey=input.KeyCode
MenuKeyBtn.Text="["..input.KeyCode.Name.."]"
MenuKeyBtn.TextColor3=Theme.SubText
end
listeningMenuKey=false
end
return
end

if listeningFeature then
if input.UserInputType==Enum.UserInputType.Keyboard then
local data=Features[listeningFeature.FeatureKey]

if input.KeyCode==Enum.KeyCode.Backspace or input.KeyCode==Enum.KeyCode.Delete then
data.Key=nil
listeningFeature.KeyBtn.Text="[None]"
listeningFeature.KeyBtn.TextColor3=Theme.SubText
else
if input.KeyCode~=Enum.KeyCode.Unknown then
data.Key=input.KeyCode
listeningFeature.KeyBtn.Text="["..input.KeyCode.Name.."]"
listeningFeature.KeyBtn.TextColor3=Theme.SubText
end
end

listeningFeature=nil
end
return
end

if input.KeyCode==Settings.MenuToggleKey then
local state=not MainFrame.Visible
MainFrame.Visible=state
ChatHead.Visible=not state
return
end

if input.UserInputType==Enum.UserInputType.Keyboard then
for _,data in pairs(Features) do
if data.Key and input.KeyCode==data.Key then
data.ToggleVisual(not data.Enabled)
break
end
end
end
end)

--------------------------------------------------------------------
-- CLOSE
--------------------------------------------------------------------

CloseBtn.MouseButton1Click:Connect(function()
for _,data in pairs(Features) do
data.Enabled=false
end

if game.CoreGui:FindFirstChild("ESP") then
game.CoreGui.ESP:Destroy()
end

if game.CoreGui:FindFirstChild("VehicleESP") then
game.CoreGui.VehicleESP:Destroy()
end

if PlayerGui:FindFirstChild("FOVCircleGui") then
PlayerGui.FOVCircleGui:Destroy()
end

ScreenGui:Destroy()
end)

--------------------------------------------------------------------
-- START
--------------------------------------------------------------------

updateFOVCircle()
updateESP()
updateStatusDisplay()
applyTheme()

print("Gane Inwza Hub Loaded")
print("FOV Radius:",Settings.FOVRadius)
print("ESP Color:",Settings.ESPHighlightMode)
