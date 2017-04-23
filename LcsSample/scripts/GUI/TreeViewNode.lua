function Script:Start()
	self.widget:Hide()
	
	--Find the parent treeview widget
	local parent = self.widget:GetParent()
	while parent~=nil do
		local widgettype = FileSystem:StripAll(parent:GetScript())
		if widgettype=="TreeView" then
			self.owner = parent
			break
		elseif widgettype~="TreeViewNode" then
			Debug:Error("TreeView widgets can only have TreeViewNodes as children.")
		end
		parent = parent:GetParent()
	end
	if self.owner==nil then
		Debug:Error("TreeViewNode must have a TreeView in the parent hierarchy.")
	end
end

function Script:Expand()
	self.owner.script.visiblenodes = nil
	self.owner:Redraw()
end

function Script:Collapse()
	self.owner.script.visiblenodes = nil
	self.owner:Redraw()	
end
