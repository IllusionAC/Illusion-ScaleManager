--!strict
-- IllusionScaleManager.luau
--[[-------------------------------------------
///////////////////////////////////////////////
\\       	 Illusion's ScaleManager		 \\
//	    A Better TextScaled Alternative		 //
\\                By Illusion                \\
///////////////////////////////////////////////
-------------------------------------------]]--

export type ScaledText = {
	TextLabel: TextLabel,
	UIScale: UIScale,
	BaseWidth: number,
	Connection: RBXScriptConnection?,
	CameraConnection: RBXScriptConnection?,

	Update: (self: ScaledText) -> (),
	Destroy: (self: ScaledText) -> (),
}

const DEFAULT_BASE_WIDTH = 1920

local function bindViewport(self: ScaledText)
	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end

	local camera = workspace.CurrentCamera
	if not camera then return end

	self.Connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		self:Update()
	end)
end

local ActiveManagers: {[TextLabel]: ScaledText} = {}
local ScaleManager = {}

--[[ 
For Optimal results, it is recommended that the TextLabel has the following properties: 
	textLabel.Parent:IsA("GuiObject") == true; 
	Size == Udim2.new(0.5, 0, 0.5, 0); 
	Position == Udim2.new(0.5, 0, 0.5, 0); 
	AnchorPoint == Vector2.new(0.5, 0.5); 
	TextScaled == false; 
	BackgroundTransparency == 1 
]]--
function ScaleManager.new(textLabel: TextLabel, baseWidth: number?): ScaledText
	local existing = ActiveManagers[textLabel]
	if existing then existing:Destroy() end

	local existingScale = textLabel:FindFirstChildOfClass("UIScale")

	local self = {
		TextLabel = textLabel,
		UIScale = existingScale or Instance.new("UIScale"),
		BaseWidth = if baseWidth and baseWidth > 0 then baseWidth else DEFAULT_BASE_WIDTH,
		Connection = nil,
		CameraConnection = nil,
	} :: ScaledText

	self.UIScale.Parent = textLabel

	function self:Update()
		local camera = workspace.CurrentCamera
		if not camera then return end
		
		self.UIScale.Scale = camera.ViewportSize.X / self.BaseWidth
	end

	function self:Destroy()
		if self.Connection then
			self.Connection:Disconnect()
			self.Connection = nil
		end

		if self.CameraConnection then
			self.CameraConnection:Disconnect()
			self.CameraConnection = nil
		end

		if ActiveManagers[self.TextLabel] == self then ActiveManagers[self.TextLabel] = nil end
		if existingScale == nil then self.UIScale:Destroy() end
	end

	self:Update()
	bindViewport(self)

	self.CameraConnection = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		bindViewport(self)
		self:Update()
	end)

	textLabel.Destroying:Once(function()
		self:Destroy()
	end)

	ActiveManagers[textLabel] = self

	return self
end

return ScaleManager
