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
	{ Map="Maps/start.map", JSON="LcsSample.json" },
	{ Map="Maps/second.map", JSON="LcsSample.json" },
	{ Map="Maps/messages.map", JSON="messages.json" },
	{ Map="Maps/docsample_1.map", JSON="docsample_1.json" } }
local map = 3

LcsLoadMap(mapfiles[map].Map,mapfiles[map].JSON)

showstats = false
while	not window:KeyDown(Key.Escape) 
		and not window:Closed() do
	
	--Handle map change
	if map ~= 3 and window:KeyHit(Key.M) then
		
		Time:Pause()
		System:GCSuspend()		
		world:Clear()

		map = map + 1
		if map == 4 then  map = 1 end
		LcsLoadMap(mapfiles[map].Map,mapfiles[map].JSON) 
		
		System:GCResume()
		Time:Resume()
		
	end	
	
	Time:Update()
	world:Update()
	world:Render()
		
	context:SetBlendMode(Blend.Alpha)
	
	context:SetColor(Vec4(0,0,0,1))
	if map ~= 3 then
		local text = "Press M to switch map"
		context:DrawText( text, 
			(context:GetWidth()-font:GetTextWidth(text))/2,
			context:GetHeight()-font:GetHeight()-4 )
	end
	
	if (window:KeyHit(Key.F11)) then showstats = not showstats end
	if showstats then
		context:SetColor(1,1,1,1)
		context:DrawText("FPS: "..Math:Round(Time:UPS()),2,2)
	end
	
	context:Sync(true)
	
end