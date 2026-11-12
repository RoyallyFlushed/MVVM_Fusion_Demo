--!strict

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)

--// Class
local ShopViewModel = {}
ShopViewModel.__index = ShopViewModel

--// Types
export type ViewModel = typeof(setmetatable({} :: self, ShopViewModel))
type self = {
	_Props: Props,
	Scope: Fusion.Scope<typeof(Fusion)>,

	IsVisible: Fusion.Value<boolean>,
}
type Props = {
	IsVisible: boolean?,
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

function ShopViewModel.new(props: Props): ViewModel
	local s = Fusion:scoped()
	local isVisible = s:Value(props.IsVisible == true)

	local _self = {}
	_self._Props = props
	_self.Scope = s

	_self.IsVisible = isVisible

	local self: self = _self
	local object: ViewModel = setmetatable(self, ShopViewModel)
	return object
end

function ShopViewModel.Destroy(self: ViewModel): ()
	self.Scope:doCleanup()
	setmetatable(self :: any, nil)
end

-------------------------------------------------------------------------------------------------------
--// EXTERNAL
-------------------------------------------------------------------------------------------------------

function ShopViewModel.Show(self: ViewModel): ()
	self.IsVisible:set(true)
end

function ShopViewModel.Hide(self: ViewModel): ()
	self.IsVisible:set(false)
end

function ShopViewModel.Toggle(self: ViewModel): ()
	const peekBoolean = Fusion.peek :: (Fusion.UsedAs<boolean>) -> boolean
	const isVisible = peekBoolean(self.IsVisible)
	self.IsVisible:set(not isVisible)
end

return ShopViewModel
