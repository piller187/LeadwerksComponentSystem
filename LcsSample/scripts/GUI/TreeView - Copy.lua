if Style==nil then Style = {} end
if Style.Treeview==nil then Style.Treeview = {} end
Style.Treeview.Multiselect = 1
Style.Treeview.Checkboxes = 2
Style.Treeview.DragAndDrop = 4

Script.itemheight = 18
Script.itemindent = 20
Script.sliderwidth = 20
Script.textposition = 14
Script.itemspacing = 4

function Script:Start()
	local gui = self.widget:GetGUI()
	local sz = self.widget:GetSize(true)
	local scale = gui:GetScale()
	
	--self.widget:Collapse()
	self.selectednodes = {}
	
	self.image = {}
	self.image.expand = gui:LoadImage("Scripts/GUI/expand.tex")
	self.image.collapse = gui:LoadImage("Scripts/GUI/collapse.tex")
	self.color = {}
	self.color.background = Vec4(0.2,0.2,0.2,1)
	self.color.foreground = Vec4(0.7,0.7,0.7,1)
	self.color.border = Vec4(0,0,0,1)
	
	self.slider = {}
	
	--Vertical slider
	self.slider[0] = Widget:Create(sz.width-self.sliderwidth*scale,0,self.sliderwidth,sz.height,self.widget)
	self.slider[0]:SetScript("Scripts/GUI/Slider.lua")
	self.slider[0]:SetStyle(Style.Slider.Vertical + Style.Slider.Scrollbar)
	self.slider[0]:SetAlignment(0,1,1,1)
	self.slider[0]:Hide()
	self.slider[0].script.owner = self
	self.slider[0].script.sliderincrements=self.itemheight * scale
	
	--Horizontal slider
	self.slider[1] = Widget:Create(0,sz.height-self.sliderwidth*scale,sz.width-self.sliderwidth,self.sliderwidth,self.widget)
	self.slider[1]:SetScript("Scripts/GUI/Slider.lua")
	self.slider[1]:SetStyle(Style.Slider.Horizontal + Style.Slider.Scrollbar)
	self.slider[1]:SetAlignment(1,1,0,1)
	self.slider[1]:Hide()
	self.slider[1].script.owner = self
	self.slider[1].script.sliderincrements=self.itemheight * scale
end

function Script:UpdateSliders(widget)
	local gui = self.widget:GetGUI()
	local pos = self.widget:GetPosition(true)
	local sz = self.widget:GetSize(true)
	local scale = self.widget:GetGUI():GetScale()
	local style = self.widget:GetStyle()
	local showscrollbar0 = false
	local showscrollbar1 = false
	lsz = self.widget:GetSize(false)
	
	if #self.visiblenodes * self.itemheight * scale > sz.y then
		showscrollbar0 = true
		lsz.width = lsz.width - self.sliderwidth
		sz.width = sz.width - self.sliderwidth * scale
	end
	
	if self.maxnodewidth>sz.width then
		showscrollbar1 = true
		lsz.height = lsz.height - self.sliderwidth
		sz.height = sz.height - self.sliderwidth * scale
	end
	
	if not showscrollbar0 then
		if #self.visiblenodes * self.itemheight * scale > sz.y then
			showscrollbar0 = true
			lsz.width = lsz.width - self.sliderwidth
			sz.width = sz.width - self.sliderwidth * scale
		end	
	end
	
	--Vertical scrolling	
	if showscrollbar0 then
		self.slider[0]:SetRange(sz.height,#self.visiblenodes * self.itemheight * scale)
		--[[if framecaret then
			if self.currentline * lh - self.slider[0]:GetSliderValue()>height then
				self.slider[0]:SetSliderValue(-height + self.currentline * lh)
			elseif (self.currentline-1) * lh - self.slider[0]:GetSliderValue() < 0 then
				self.slider[0]:SetSliderValue((self.currentline-1) * lh)
			end
		end
		if textheight - self.slider[0]:GetSliderValue() < height then
			self.slider[0]:SetSliderValue(textheight - height)
		end]]
		self.slider[0]:SetLayout(lsz.width,0,self.sliderwidth,lsz.height)			
		self.slider[0]:Show()
	else
		self.slider[0]:SetSliderValue(0)
		self.slider[0]:Hide()
	end
	
	--Horizontal scrolling
	--local lh = gui:GetLineHeight()*self.linespacing
	if showscrollbar1 then--self.maxlinewidth>sz.width then
		self.slider[1]:SetRange(sz.width,self.maxnodewidth)
		--[[if framecaret then
			if self:GetCaretCoord()-self.slider[1]:GetSliderValue()>width then
				self.slider[1]:SetSliderValue( self:GetCaretCoord() - width)
			elseif self:GetCaretCoord()-self.slider[1]:GetSliderValue() < 0 then
				self.slider[1]:SetSliderValue(self:GetCaretCoord())
			end
		end
		if self.maxlinewidth-self.slider[1]:GetSliderValue() < width then
			self.slider[1]:SetSliderValue(self.maxlinewidth - width)
		end]]
		--self.slider[1]:SetRange(width,self.maxlinewidth)
		self.slider[1]:SetLayout(0,lsz.height,lsz.width,self.sliderwidth)
		self.slider[1]:Show()
	else
		self.slider[1]:SetSliderValue(0)
		self.slider[1]:Hide()
	end
	
end

function Script:UpdateSlider(widget)
	--if widget == self.slider[0] then
		--self.offset.y = widget:GetSliderValue()
		self.widget:Redraw()
	--end
end

function Script:Resize()
	self:UpdateSliders()
end

function Script:MouseWheel(movement)
	if self.slider[0]:Hidden()==false then
		if movement>0 then
			self.slider[0].script:KeyDown(Key.Down)
		else
			self.slider[0].script:KeyDown(Key.Up)
		end
	end
end

function Script:Draw()
	local gui = self.widget:GetGUI()
	local pos = self.widget:GetPosition(true)
	local sz = self.widget:GetSize(true)
	local scale = self.widget:GetGUI():GetScale()
	local style = self.widget:GetStyle()
	
	--Update table of visible nodes
	if self.visiblenodes==nil then
		self:UpdateNodes(self.widget)
		self:UpdateSliders()
	end
	
	if self.slider[0]:Hidden()==false then sz.x = sz.x - self.sliderwidth * scale end
	if self.slider[1]:Hidden()==false then sz.y = sz.y - self.sliderwidth * scale end
	
	gui:SetClipRegion(pos.x,pos.y,sz.width,sz.height)
	
	--Draw background
	gui:SetColor(self.color.background.r,self.color.background.g,self.color.background.b,self.color.background.a)
	gui:DrawRect(pos.x,pos.y,sz.width,sz.height)
	
	--Draw nodes
	local n,img,text
	for n=1,#self.visiblenodes do
		text = self.visiblenodes[n].widget:GetText()
		
		if self.selectednodes[n] then
			gui:SetColor(51/255/2,151/255/2,1/2)
			gui:DrawRect(-self.slider[1]:GetSliderValue() - 2*scale + 12*scale + pos.x + 2*scale + self.visiblenodes[n].indent, -self.slider[0]:GetSliderValue() + pos.y + 2*scale + scale*self.itemheight*(n-1) - 2*scale,gui:GetTextWidth(text)+4*scale,(self.itemheight - self.itemspacing + 4) * scale)
		end
		
		gui:SetColor(self.color.foreground.r,self.color.foreground.g,self.color.foreground.b,self.color.foreground.a)
		gui:DrawText(text,-self.slider[1]:GetSliderValue() + pos.x + self.textposition * scale + self.visiblenodes[n].indent * scale, -self.slider[0]:GetSliderValue() + pos.y + 2*scale + scale*self.itemheight*(n-1),gui:GetTextWidth(text),(self.itemheight - self.itemspacing) * scale)
		
		if self.visiblenodes[n].widget:CountChildren()>0 then
			if self.visiblenodes[n].widget:Collapsed() then
				img = self.image.expand
			else
				img = self.image.collapse
			end
			gui:DrawImage(img,-self.slider[1]:GetSliderValue() + pos.x + 2*scale + self.visiblenodes[n].indent, -self.slider[0]:GetSliderValue() + pos.y + 2*scale + scale*self.itemheight*(n-1))
			
			if scale * self.itemheight*(n-1) - self.slider[0]:GetSliderValue() > sz.height then
				break
			end
			
		end
	end
	
	--Draw border
	gui:SetColor(self.color.border.r,self.color.border.g,self.color.border.b,self.color.border.a)
	gui:DrawRect(pos.x,pos.y,sz.width,sz.height,1)
end

function Script:GetNodeAtPosition(y)
	local item = math.ceil(y / (self.itemheight * self.widget:GetGUI():GetScale()))
	if item<1 then return nil end
	if item>#self.visiblenodes then return nil end
	return item
end

function Script:MouseDown(button,x,y)
	x = x + self.slider[1]:GetSliderValue()	
	y = y + self.slider[0]:GetSliderValue()
	local n
	local scale = self.widget:GetGUI():GetScale()
	if button==Mouse.Left then
		local nodeindex = self:GetNodeAtPosition(y)
		if nodeindex~=nil then
			if x < (self.textposition + self.visiblenodes[nodeindex].indent) * scale then
				if x > self.visiblenodes[nodeindex].indent * scale then
					if self.visiblenodes[nodeindex].widget:Collapsed() then
						self.visiblenodes[nodeindex].widget:Expand()
						--EventQueue:Emit(Event.WidgetOpen,self.widget,0,0,0,0,0,self.visiblenodes[nodeindex].widget)
					else
						self.visiblenodes[nodeindex].widget:Collapse()
						--EventQueue:Emit(Event.WidgetClose,self.widget,0,0,0,0,0,self.visiblenodes[nodeindex].widget)
					end
				end
			else
				if self.shiftpressed~=true and self.ctrlpressed~=true then
					local key,value
					for key,value in pairs(self.selectednodes) do
						EventQueue:Emit(Event.WidgetDeselect,self.widget,0,0,0,0,0,self.visiblenodes[nodeindex].widget)
					end
					self.selectednodes = {}
				end
				if nodeindex~=nil then
					if self.ctrlpressed==true then
						if self.selectednodes[nodeindex]~=true then
							self:ScrollToNode(nodeindex)
						end
						self.selectednodes[nodeindex]=not self.selectednodes[nodeindex]
						if self.selectednodes[nodeindex] then
							self.lasttouchednode = nodeindex
						end
						if self.selectednodes[nodeindex] then
							EventQueue:Emit(Event.WidgetSelect,self.widget,0,0,0,0,0,self.visiblenodes[nodeindex].widget)
						else
							EventQueue:Emit(Event.WidgetDeselect,self.widget,0,0,0,0,0,self.visiblenodes[nodeindex].widget)
						end
					else
						self.selectednodes[nodeindex]=true				
						if self.shiftpressed==true and self.lasttouchednode~=nil then
							local n
							local iterator=1
							if self.lasttouchednode>nodeindex then iterator=-1 end
							for n=self.lasttouchednode,nodeindex,iterator do
								if self.selectednodes[n]~=true then
									self.selectednodes[n]=true
									EventQueue:Emit(Event.WidgetSelect,self.widget,0,0,0,0,0,self.visiblenodes[n].widget)
								end
							end
						end
						self:ScrollToNode(nodeindex)
						self.lasttouchednode = nodeindex
					end
					self.widget:Redraw()
				end
			end
		end
	elseif button==Mouse.Right then
		local nodeindex = self:GetNodeAtPosition(y)
		if nodeindex~=nil then
			EventQueue:Emit(Event.WidgetMenu,self.widget,0,0,0,0,0,self.visiblenodes[nodeindex].widget)
		end
	end
end

function Script:KeyUp(key)
	if key==Key.Shift then
		self.shiftpressed=false
	elseif key==Key.Control then
		self.ctrlpressed=false
	end
end

function Script:KeyDown(key)
	if key==Key.Down then
		if self.lasttouchednode~=nil then
			if self.lasttouchednode<#self.visiblenodes then
				if self.shiftpressed~=true then self.selectednodes = {} end
				self.selectednodes[self.lasttouchednode + 1] = true
				self.lasttouchednode = self.lasttouchednode + 1
				self:ScrollToNode(self.lasttouchednode)
				self.widget:Redraw()
			end
		end
	elseif key==Key.Up then
		if self.lasttouchednode~=nil then
			if self.lasttouchednode>1 then
				if self.shiftpressed~=true then self.selectednodes = {} end
				self.selectednodes[self.lasttouchednode - 1] = true
				self.lasttouchednode = self.lasttouchednode - 1
				self:ScrollToNode(self.lasttouchednode)
				self.widget:Redraw()
			end
		end
	elseif key==Key.Right then
		if self.lasttouchednode~=nil then
			if self.visiblenodes[self.lasttouchednode].widget:Collapsed() and self.visiblenodes[self.lasttouchednode].widget:CountChildren()>0 then
				self.visiblenodes[self.lasttouchednode].widget:Expand()
				--EventQueue:Emit(Event.WidgetOpen,self.widget,0,0,0,0,0,self.visiblenodes[self.lasttouchednode].widget)
				self.visiblenodes = nil
				self.widget:Redraw()
			else
				self:KeyDown(Key.Down)
			end
		end
	elseif key==Key.Left then
		if self.lasttouchednode~=nil then
			if self.visiblenodes[self.lasttouchednode].widget:Collapsed()==false and self.visiblenodes[self.lasttouchednode].widget:CountChildren()>0 then
				self.visiblenodes[self.lasttouchednode].widget:Collapse()
				--EventQueue:Emit(Event.WidgetClose,self.widget,0,0,0,0,0,self.visiblenodes[self.lasttouchednode].widget)
				self.visiblenodes = nil
				self.widget:Redraw()
			else
				self:KeyDown(Key.Up)
			end
		end
	elseif key==Key.Shift then
		--if self:bitand(Style.Treeview.Multiselect,self.widget:GetStyle()) then
			self.shiftpressed=true
		--end
	elseif key==Key.Control then
		--if self:bitand(Style.Treeview.Multiselect,self.widget:GetStyle()) then
			self.ctrlpressed=true
		--end
	end
end

function Script:ScrollToNode(nodeindex)
	if not self.slider[0]:Hidden() then
		local sz = self.widget:GetSize(true)
		local offset = self.slider[0]:GetSliderValue()
		local scale = self.widget:GetGUI():GetScale()
		local y = nodeindex * self.itemheight * scale - offset
		if y - self.itemheight * scale < 0 then
			self.slider[0]:SetSliderValue((nodeindex-1) * self.itemheight * scale)
		elseif y + self.itemheight * scale > sz.height then
			self.slider[0]:SetSliderValue((nodeindex+1) * self.itemheight * scale - sz.height)
		end
	end
end

function Script:DoubleClick(button,x,y)
	x = x + self.slider[1]:GetSliderValue()
	y = y + self.slider[0]:GetSliderValue()
	if button==Mouse.Left then
		local nodeindex = self:GetNodeAtPosition(y)
		if nodeindex~=nil then
			EventQueue:Emit(Event.WidgetAction,self.widget,0,0,0,0,0,self.visiblenodes[nodeindex].widget)
			--[[if self.visiblenodes[nodeindex].widget:Collapsed() then
				self.visiblenodes[nodeindex].widget:Expand()
			else
				self.visiblenodes[nodeindex].widget:Collapse()
			end
			self.visiblenodes = nil
			self.widget:Redraw()]]
		end
	end
end

--Place nodes into a linear list
function Script:UpdateNodes(node,indent)
	if indent==nil then
		indent=0
		self.maxnodewidth = 0
	end
	
	if self.visiblenodes==nil then
		self.visiblenodes = {}
	end
	
	local n
	local count = node:CountChildren()
	local subnode
	local gui = self.widget:GetGUI()
	local scale = gui:GetScale()
	
	for n=0,count-1 do
		subnode = node:GetChild(n)
		if subnode~=self.slider[0] and subnode~=self.slider[1] then			
			self.maxnodewidth = math.max(self.maxnodewidth, (indent + self.textposition + 2) * scale + gui:GetTextWidth(subnode:GetText()))
			self.visiblenodes[#self.visiblenodes+1] = {}
			self.visiblenodes[#self.visiblenodes].widget = subnode
			self.visiblenodes[#self.visiblenodes].indent = indent
			if subnode:Collapsed()==false then
				self:UpdateNodes(subnode,indent+self.itemindent)
			end
		end
	end
end
