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

--Maps
local mapfiles = {
	"Maps/start.map",
	"Maps/second.map" }
local map = 1

LcsLoadMap(mapfiles[map],"LcsSample.json")

showstats = false
while	not window:KeyDown(Key.Escape) 
		and not window:Closed() do
	
	--Handle map change
	if window:KeyHit(Key.M) then
		
		Time:Pause()
		System:GCSuspend()		
		world:Clear()

		if map == 1 then map = 2 else map = 1 end
		LcsLoadMap(mapfiles[map],"LcsSample.json") 
		
		System:GCResume()
		Time:Resume()
		
	end	
	
	Time:Update()
	world:Update()
	world:Render()
		
	context:SetBlendMode(Blend.Alpha)
	
	context:SetColor(Vec4(0,0,0,1))
	local text = "Press M to switch map"
	context:DrawText( text, 
		(context:GetWidth()-font:GetTextWidth(text))/2,
		context:GetHeight()-font:GetHeight()-4 )
	
	if (window:KeyHit(Key.F11)) then showstats = not showstats end
	if showstats then
		context:SetColor(1,1,1,1)
		context:DrawText("FPS: "..Math:Round(Time:UPS()),2,2)
	end
	
	context:Sync(true)
	
end