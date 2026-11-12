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
	Description: string,
	Price: number,
	PriceText: string,
	Icon: string,
	LargeIcon: string,
	LayoutOrder: number,
}
export type SortMode = "Default" | "PriceAscending" | "PriceDescending" | "Name"
export type ViewModel = typeof(setmetatable({} :: self, ShopViewModel))
type self = {
	_Props: Props,
	Janitor: Janitor.Janitor,
	Scope: Fusion.Scope<typeof(Fusion)>,

	Products: Fusion.UsedAs<{ ProductEntry }>,
	SortMode: Fusion.Value<SortMode>,
	SortedProducts: Fusion.Computed<{ ProductEntry }>,
	IsEmpty: Fusion.Computed<boolean>,
	SelectedAssetId: Fusion.Value<number?>,
	SelectedProduct: Fusion.Computed<ProductEntry?>,
	WindowPosition: Fusion.Value<UDim2>,
	WindowPositionTween: Fusion.Tween<UDim2>,
	IsVisible: Fusion.Computed<boolean>,
}
type Props = {
	IsVisible: boolean?,
	Products: Fusion.UsedAs<{ ProductEntry }>,
	SlideTweenInfo: Fusion.UsedAs<TweenInfo>?,
}

--// Variables
local peek = Fusion.peek

-------------------------------------------------------------------------------------------------------
--// PRELOAD
-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
--// INTERNAL
-------------------------------------------------------------------------------------------------------

const SORT_COMPARATORS: { [SortMode]: (a: ProductEntry, b: ProductEntry) -> boolean } = {
	Default = function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end,
	PriceAscending = function(a, b)
		return if a.Price == b.Price then a.LayoutOrder < b.LayoutOrder else a.Price < b.Price
	end,
	PriceDescending = function(a, b)
		return if a.Price == b.Price then a.LayoutOrder < b.LayoutOrder else a.Price > b.Price
	end,
	Name = function(a, b)
		return a.Name:lower() < b.Name:lower()
	end,
}

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
	_self.SortMode = s:Value("Default" :: SortMode)
	_self.SortedProducts = s:Computed(function(use)
		const sorted = table.clone(use(_self.Products))
		table.sort(sorted, SORT_COMPARATORS[use(_self.SortMode)])
		return sorted
	end)
	_self.IsEmpty = s:Computed(function(use)
		return #use(_self.Products) == 0
	end)
	_self.SelectedAssetId = s:Value(nil :: number?)
	-- The selection is cleared when the selected product leaves the product list.
	_self.SelectedProduct = s:Computed(function(use): ProductEntry?
		const assetId = use(_self.SelectedAssetId)
		if assetId == nil then
			return nil
		end
		for _, product in use(_self.Products) do
			if product.AssetId == assetId then
				return product
			end
		end
		return nil
	end)
	_self.WindowPosition = s:Value(if props.IsVisible == true then SHOWN_POSITION else HIDDEN_POSITION)
	_self.WindowPositionTween = s:Tween(_self.WindowPosition, props.SlideTweenInfo or SLIDE_TWEEN_INFO)
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

function ShopViewModel.SelectProduct(self: ViewModel, product: ProductEntry): ()
	self.SelectedAssetId:set(product.AssetId)
end

function ShopViewModel.SetSortMode(self: ViewModel, sortMode: SortMode): ()
	self.SortMode:set(sortMode)
end

function ShopViewModel.ClearSelection(self: ViewModel): ()
	self.SelectedAssetId:set(nil)
end

function ShopViewModel.Toggle(self: ViewModel): ()
	if peek(self.WindowPosition) == SHOWN_POSITION then
		self:Hide()
	else
		self:Show()
	end
end

return ShopViewModel
