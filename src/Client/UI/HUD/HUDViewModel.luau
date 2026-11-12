--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Janitor = require(ReplicatedStorage.Packages.Janitor)

--// Class
local HUDViewModel = {}
HUDViewModel.__index = HUDViewModel

--// Types
export type ViewModel = typeof(setmetatable({} :: self, HUDViewModel))
type self = {
	_Props: Props,
	Janitor: Janitor.Janitor,
	Scope: Fusion.Scope<typeof(Fusion)>,
}
type Props = {
	ToggleShop: () -> (),
}

-------------------------------------------------------------------------------------------------------
--// PRELOAD
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
--// INTERNAL
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
--// INIT
-------------------------------------------------------------------------------------------------------

function HUDViewModel.new(props: Props): ViewModel
	local s = Fusion:scoped()

	local _self = {}
	_self._Props = props
	_self.Janitor = Janitor.new()
	_self.Scope = _self.Janitor:Add(s, "doCleanup", "Scope")

	local self: self = _self
	local object: ViewModel = setmetatable(self, HUDViewModel)
	return object
end

function HUDViewModel.Destroy(self: ViewModel): ()
	self.Janitor:Destroy()
	self.Janitor = nil :: any
	(setmetatable :: any)(self, nil)
end

-------------------------------------------------------------------------------------------------------
--// EXTERNAL
-------------------------------------------------------------------------------------------------------

function HUDViewModel.ToggleShop(self: ViewModel): ()
	self._Props.ToggleShop()
end

return HUDViewModel
