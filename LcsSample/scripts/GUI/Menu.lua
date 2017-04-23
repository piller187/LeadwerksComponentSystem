--Styles
if Style==nil then Style={} end
if Style.Label==nil then Style.Label={} end
Style.Label.Left=0
Style.Label.Center=16
Style.Label.Right=8
Style.Label.VCenter=32

--[[
Const LABEL_LEFT=0
Const LABEL_FRAME=1
Const LABEL_SUNKENFRAME=2
Const LABEL_SEPARATOR=3
Const LABEL_RIGHT=8
Const LABEL_CENTER=16
]]

function Script:Start()
	local gui = self.widget:GetGUI()
	
	--Detect type of GUI
	local guiwindow = gui:GetWindow()
	if guiwindow~=nil then
		self.window = Window:Create("",0,0,100,100,guiwindow,Window.Hidden)
	end
end

function Script:Detach()
	
end

function Script:Draw(x,y,width,height)
	local gui = self.widget:GetGUI()
	local pos = self.widget:GetPosition(true)
	local sz = self.widget:GetSize(true)
	local scale = gui:GetScale()
	local text = self.widget:GetText()
	
	if text~="" then
		local style=0
		if self:bitand(self.widget:GetStyle(),Style.Label.Left) then style = style + Text.Left end
		if self:bitand(self.widget:GetStyle(),Style.Label.Center) then style = style + Text.Center end
		if self:bitand(self.widget:GetStyle(),Style.Label.Right) then style = style + Text.Right end
		if self:bitand(self.widget:GetStyle(),Style.Label.VCenter) then style = style + Text.VCenter end
		gui:SetColor(0.7,0.7,0.7)
		gui:DrawText(text,pos.x,pos.y,sz.width,sz.height,style)	
	end
end

function Script:bitand(set, flag)
	return set % (2*flag) >= flag
end
