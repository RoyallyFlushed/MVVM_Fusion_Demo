--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Janitor = require(ReplicatedStorage.Packages.Janitor)

--// Constants
const SLIDE_TWEEN_INFO = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
const SHOWN_POSITION = UDim2.fromScale(0.5, 0.5)
const HIDDEN_POSITION = UDim2.fromScale(0.5, 1.5)

--// Class
local ShopViewModel = {}
ShopViewModel.__index = ShopViewModel

--// Types
export type ProductEntry = {
	AssetId: number,
	Name: string,
	Price: number,
	Icon: string,
	LayoutOrder: number,
}
export type ViewModel = typeof(setmetatable({} :: self, ShopViewModel))
type self = {
	_Props: Props,
	Janitor: Janitor.Janitor,
	Scope: Fusion.Scope<typeof(Fusion)>,

	Products: Fusion.UsedAs<{ ProductEntry }>,
	IsEmpty: Fusion.Computed<boolean>,
	WindowPosition: Fusion.Value<UDim2>,
	WindowPositionTween: Fusion.Tween<UDim2>,
	IsVisible: Fusion.Computed<boolean>,
}
type Props = {
	IsVisible: boolean?,
	Products: Fusion.UsedAs<{ ProductEntry }>,
}

--// Variables
local peek = Fusion.peek

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
	local _self = {}
	_self._Props = props
	_self.Janitor = Janitor.new()
	_self.Scope = _self.Janitor:Add(s, "doCleanup", "Scope")

	_self.Products = props.Products
	_self.IsEmpty = s:Computed(function(use)
		return #use(_self.Products) == 0
	end)
	_self.WindowPosition = s:Value(if props.IsVisible == true then SHOWN_POSITION else HIDDEN_POSITION)
	_self.WindowPositionTween = s:Tween(_self.WindowPosition, SLIDE_TWEEN_INFO)
	_self.IsVisible = s:Computed(function(use)
		return use(_self.WindowPositionTween) ~= HIDDEN_POSITION
	end)

	local self: self = _self
	local object: ViewModel = setmetatable(self, ShopViewModel)
	return object
end

function ShopViewModel.Destroy(self: ViewModel): ()
	self.Janitor:Destroy()
	self.Janitor = nil :: any
	(setmetatable :: any)(self, nil)
end

-------------------------------------------------------------------------------------------------------
--// EXTERNAL
-------------------------------------------------------------------------------------------------------

function ShopViewModel.Show(self: ViewModel): ()
	self.WindowPosition:set(SHOWN_POSITION)
end

function ShopViewModel.Hide(self: ViewModel): ()
	self.WindowPosition:set(HIDDEN_POSITION)
end

function ShopViewModel.Toggle(self: ViewModel): ()
	if peek(self.WindowPosition) == SHOWN_POSITION then
		self:Hide()
	else
		self:Show()
	end
end

return ShopViewModel
