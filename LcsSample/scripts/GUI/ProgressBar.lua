function Script:Draw(x,y,width,height)
	local gui = self.widget:GetGUI()
	local pos = self.widget:GetPosition(true)
	local sz = self.widget:GetSize(true)
	local scale = self.widget:GetGUI():GetScale()
	
	--Track
	gui:SetColor(0.2)
	gui:DrawRect(pos.x,pos.y,sz.width,sz.height)	
	
	--Progress indicator
	gui:SetColor(51/255/2,151/255/2,1/2)
	gui:SetColor(51/255/2*0.75,151/255/2*0.75,1/2*0.75,1,1)
	gui:DrawRect(pos.x,pos.y,sz.width*self.widget:GetProgress(),sz.height,0)
	
	--Outline
	gui:SetColor(0)
	gui:DrawRect(pos.x,pos.y,sz.width,sz.height,1)
	
end
