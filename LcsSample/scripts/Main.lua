import "Scripts/LCS/MapHook.lua"

--Initialize Steamworks (optional)
Steamworks:Initialize()

--Create a window
local window = Window:Create(
	"LcsSample",
	0,0,
	System:GetProperty("screenwidth","1024"),
	System:GetProperty("screenheight","768"), 
	Window.Titlebar)

window:HideMouse()

--Create the graphics context
local context=Context:Create(window,0)
if context==nil then return end

--Font
local font = Font:Load("Fonts/arial.ttf", 22 )
context:SetFont(font)
font:Release()

--Create a world
local world=World:Create()
world:SetLightQuality((System:GetProperty("lightquality","1")))

--Map
LcsLoadMap("Maps/start.map","start.json")
LcsLoad()

showstats = false
while	not window:KeyDown(Key.Escape) 
		and not window:Closed() do
	
	Time:Update()
	
	EventManager:update()
	world:Update()
	world:Render()
		
	context:SetBlendMode(Blend.Alpha)
	context:Sync(true)
	
end

LcsSave()