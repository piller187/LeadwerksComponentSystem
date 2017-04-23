--- LCS end ---------------------------------------
import "Scripts/LCS/MapHook.lua"
--- LCS end ---------------------------------------

--Initialize Steamworks (optional)
Steamworks:Initialize()

--Initialize analytics (optional).  Create an account at www.gameamalytics.com to get your game keys
--[[if DEBUG==false then
	Analytics:SetKeys("GAME_KEY_xxxxxxxxx", "SECRET_KEY_xxxxxxxxx")
	Analytics:Enable()
end]]

--Set the application title
title="LcsSample"

--Create a window
local windowstyle = Window.Titlebar
if System:GetProperty("fullscreen")=="1" then windowstyle=windowstyle+Window.FullScreen end
window=Window:Create(title,0,0,System:GetProperty("screenwidth","1024"),System:GetProperty("screenheight","768"),windowstyle)
window:HideMouse()

--Create the graphics context
context=Context:Create(window,0)
if context==nil then return end

--Create a world
world=World:Create()
world:SetLightQuality((System:GetProperty("lightquality","1")))

--Load a map
local mapfile = System:GetProperty("map","Maps/start.map")

--- LCS begin -------------------------------------
LcsLoadMap(mapfile,"LcsSample.json")
--- LCS end ---------------------------------------

prevmapname = FileSystem:StripAll(changemapname)

--Send analytics event
Analytics:SendProgressEvent("Start",prevmapname)
showstats = false
while window:KeyDown(Key.Escape)==false do
	
	--If window has been closed, end the program
	if window:Closed() then break end
	
	--Handle map change
	if changemapname~=nil then
		
		--Pause the clock
		Time:Pause()
		
		--Pause garbage collection
		System:GCSuspend()		
		
		--Clear all entities
		world:Clear()
		
		--Send analytics event
		Analytics:SendProgressEvent("Complete",prevmapname)
		
		--Load the next map
		
		--- LCS begin -------------------------------------
		LcsLoadMap(changemapname,"LcsSample.json") 
		--- LCS end ---------------------------------------
		
		prevmapname = changemapname
		
		--Send analytics event
		Analytics:SendProgressEvent("Start",prevmapname)
		
		--Resume garbage collection
		System:GCResume()
		
		--Resume the clock
		Time:Resume()
		
		changemapname = nil
	end	
	
	--Update the app timing
	Time:Update()
	
	--Update the world
	world:Update()
	
	--Render the world
	world:Render()
		
	--Render statistics
	context:SetBlendMode(Blend.Alpha)
	--Toggle statistics on and off
	if (window:KeyHit(Key.F11)) then showstats = not showstats end
	if showstats then
		context:SetColor(1,1,1,1)
		context:DrawText("FPS: "..Math:Round(Time:UPS()),2,2)
	end
	
	--Refresh the screen
	context:Sync(true)
	
end