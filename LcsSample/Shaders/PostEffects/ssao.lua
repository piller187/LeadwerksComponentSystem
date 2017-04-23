Script.bluriterations=2
Script.downsample=2

--Called once at start
function Script:Start()
	
	--Load this script's shaders
	self.shader = {}
	self.shader[0] = Shader:Load("Shaders/PostEffects/Utility/ssao.shader")
	self.shader[1] = Shader:Load("Shaders/PostEffects/Utility/ssaoblend.shader")
	self.shader.blurx = Shader:Load("Shaders/PostEffects/Utility/hblur.shader")
	self.shader.blury = Shader:Load("Shaders/PostEffects/Utility/vblur.shader")
	
end

--Called each time the camera is rendered
function Script:Render(camera,context,buffer,depth,diffuse,normals,emission)
	
	--Check if downsample buffers match current resolution
	if self.buffer~=nil then
		if buffer:GetWidth()~=self.w or buffer:GetHeight()~=self.h then
			if self.buffer then
				self.buffer:Release()
				self.buffer=nil
			end
		end
	end
	
	--Create downsample buffers if they don't exist
	if self.buffer==nil then
			self.w=buffer:GetWidth()
			self.h=buffer:GetHeight()
			self.buffer=Buffer:Create(self.w/1,self.h/1,1,0)
			self.buffer:GetColorTexture():SetFilter(Texture.Smooth)
	end
	
	if self.blurbuffer==nil then
		self.blurbuffer = {}
		self.blurbuffer[0] = Buffer:Create(self.w/self.downsample,self.h/self.downsample,1,0)
		self.blurbuffer[0]:GetColorTexture():SetFilter(Texture.Smooth)
		self.blurbuffer[1] = Buffer:Create(self.w/self.downsample,self.h/self.downsample,1,0)
		self.blurbuffer[1]:GetColorTexture():SetFilter(Texture.Smooth)
	end
	
	if self.texture then self.texture:Bind(10) end
	
	--Perform SSAO pass
	self.buffer:Enable()
	if self.shader[0] then self.shader[0]:Enable() end
	context:DrawImage(diffuse,0,0,self.buffer:GetWidth(),self.buffer:GetHeight())
	if self.shader[0] then self.shader[0]:Disable() end
	
	local image = self.buffer:GetColorTexture()
	local i
	
	for i=1,self.bluriterations do
		
		--Perform horizontal blur
		self.blurbuffer[0]:Enable()
		if self.shader.blurx then self.shader.blurx:Enable() end
		context:DrawImage(image,0,0,self.blurbuffer[0]:GetWidth(),self.blurbuffer[0]:GetHeight())
		
		--Perform vertical blur
		self.blurbuffer[1]:Enable()
		if self.shader.blury then self.shader.blury:Enable() end
		context:DrawImage(self.blurbuffer[0]:GetColorTexture(),0,0,self.blurbuffer[1]:GetWidth(),self.blurbuffer[1]:GetHeight())
		image = self.blurbuffer[1]:GetColorTexture()
		
	end

	--Draw the SSAO image mixed with the original image
	buffer:Enable()
	if self.shader[1] then self.shader[1]:Enable() end
	diffuse:Bind(1)
	context:DrawImage(self.buffer:GetColorTexture(),0,0,buffer:GetWidth(),buffer:GetHeight())
	context:DrawImage(self.blurbuffer[1]:GetColorTexture(),0,0,buffer:GetWidth(),buffer:GetHeight())
	--context:SetBlendMode(Blend.Solid)
	
end

--Called when the effect is detached or the camera is deleted
function Script:Detach()
	
	--Release shaders
	for index,o in pairs(self.shader) do
		o:Release()
	end
	self.shader = nil
	
	--Release buffers
	if self.buffer then
		self.buffer:Release()
		self.buffer=nil
	end
	
end
