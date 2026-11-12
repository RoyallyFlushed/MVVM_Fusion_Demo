--[[

    DESC: A square shop card for one product. It is built on the Button component, so it
          accepts all Button props. Put it inside a holder frame in a layout.

--]]

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Button = require(ReplicatedStorage.Client.UI.Common.Button)
const ShopViewModel = require(ReplicatedStorage.Client.UI.Shop.ShopViewModel)
const NumberUtil = require(ReplicatedStorage.Shared.Modules.NumberUtil)
const Palette = require(ReplicatedStorage.Shared.Config.Palette)
const TableUtil = require(ReplicatedStorage.Shared.Modules.TableUtil)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children

--// Constants
const DEFAULT_PROPS = {
	Name = "ProductCard",
	Size = UDim2.fromScale(1, 1),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	AutoButtonColor = false,
	BackgroundColor3 = Palette.Colors.CARD_BACKGROUND,
	BorderSizePixel = 0,
	SizeScalar = 0.6,
	ButtonTweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	TextColor = Palette.Colors.TEXT,
	PriceColor = Palette.Colors.PRICE,
}
const CUSTOM_PROPS = { "Product", "TextColor", "PriceColor" }

--// Types
export type Props = {
	Product: ShopViewModel.ProductEntry,
	TextColor: Fusion.UsedAs<Color3>?,
	PriceColor: Fusion.UsedAs<Color3>?,
} & Button.Props
export type BaseType = Button.BaseType

return function(_props: Props): BaseType
	local props = TableUtil.Merge(DEFAULT_PROPS, _props) :: any
	local s = props.Scope
	local product: ShopViewModel.ProductEntry = props.Product

	-- Remove custom props from instance props
	local iprops: Button.Props = table.clone(props)
	for _, key in CUSTOM_PROPS do
		iprops[key] = nil
	end
	iprops[Children] = {
		s:New "UICorner" {
			CornerRadius = UDim.new(0, 12),
		},
		s:New "ImageLabel" {
			Name = "Icon",
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0.06),
			Size = UDim2.fromScale(0.64, 0.64),
			BackgroundColor3 = Palette.Colors.CARD_ICON_BACKGROUND,
			BorderSizePixel = 0,
			Image = product.Icon,
			ScaleType = Enum.ScaleType.Fit,

			[Children] = {
				s:New "UICorner" {
					CornerRadius = UDim.new(0.1, 0),
				},
			},
		},
		s:New "TextLabel" {
			Name = "ProductName",
			Position = UDim2.new(0, 8, 0.72, 0),
			Size = UDim2.new(1, -16, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansBold,
			Text = product.Name,
			TextColor3 = props.TextColor,
			TextSize = 16,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
		},
		s:New "TextLabel" {
			Name = "Price",
			Position = UDim2.new(0, 8, 0.86, 0),
			Size = UDim2.new(1, -16, 0, 16),
			BackgroundTransparency = 1,
			Font = Enum.Font.BuilderSansExtraBold,
			Text = `{NumberUtil.FormatWithCommas(product.Price)} Coins`,
			TextColor3 = props.PriceColor,
			TextSize = 15,
			TextTruncate = Enum.TextTruncate.AtEnd,
			TextXAlignment = Enum.TextXAlignment.Left,
		},
		props[Children],
	}
	return Button(iprops)
end
