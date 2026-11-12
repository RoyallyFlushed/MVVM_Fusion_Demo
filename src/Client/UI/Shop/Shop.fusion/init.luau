
--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const Button = require(ReplicatedStorage.Client.UI.Common.Button)
const ShopViewModel = require(script.Parent.ShopViewModel)
const ProductCard = require(script["ProductCard.fusion"])
const ViewportScale = require(ReplicatedStorage.Client.Modules.ViewportScale)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children
const OnEvent = Fusion.OnEvent

type Props = {
	ViewModel: ShopViewModel.ViewModel,
}

--// Constants
const CARD_SIZE = 132
const CARD_GAP = 10
const COLUMNS = 4
const VISIBLE_ROWS = 3
const SCROLLBAR_GUTTER = 12
-- Space around the cards so that a hovered card is not clipped by the scrolling frame.
const HOVER_ROOM = 6
const HEADER_HEIGHT = 78
const EDGE_PADDING = 18
const CLOSE_BUTTON_SIZE = 42
const CONTENT_WIDTH = HOVER_ROOM + COLUMNS * CARD_SIZE + (COLUMNS - 1) * CARD_GAP + SCROLLBAR_GUTTER
const CONTENT_HEIGHT = HOVER_ROOM * 2 + VISIBLE_ROWS * CARD_SIZE + (VISIBLE_ROWS - 1) * CARD_GAP
const PANEL_WIDTH = CONTENT_WIDTH + EDGE_PADDING * 2
const PANEL_HEIGHT = HEADER_HEIGHT + CONTENT_HEIGHT + EDGE_PADDING
-- The part of the viewport that the panel can fill when it shrinks to fit a small screen.
const VIEWPORT_FILL = 0.9

return function(props: Props): Frame
	const vm = props.ViewModel
	const s = vm.Scope

	return s:New "Frame" {
		Name = "Shop",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = vm.WindowPositionTween,
		Size = UDim2.fromOffset(PANEL_WIDTH, PANEL_HEIGHT),
		BackgroundColor3 = Color3.fromRGB(32, 32, 36),
		BorderSizePixel = 0,
		Visible = vm.IsVisible,

		[Children] = {
			s:New "UIScale" {
				Scale = ViewportScale.Fit(s, Vector2.new(PANEL_WIDTH, PANEL_HEIGHT), VIEWPORT_FILL),
			},
			s:New "UICorner" {
				CornerRadius = UDim.new(0, 18),
			},
			s:New "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = Color3.fromRGB(70, 70, 78),
				Thickness = 3,
			},
			s:New "TextLabel" {
				Name = "Title",
				Position = UDim2.fromOffset(24, 18),
				Size = UDim2.new(1, -82, 0, 42),
				BackgroundTransparency = 1,
				Font = Enum.Font.BuilderSansExtraBold,
				Text = "SHOP",
				TextColor3 = Color3.new(1, 1, 1),
				TextSize = 30,
				TextXAlignment = Enum.TextXAlignment.Left,
			},
			Button {
				Scope = s,
				Name = "Close",
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(1, -(EDGE_PADDING + CLOSE_BUTTON_SIZE / 2), 0, EDGE_PADDING + CLOSE_BUTTON_SIZE / 2),
				Size = UDim2.fromOffset(CLOSE_BUTTON_SIZE, CLOSE_BUTTON_SIZE),
				AutoButtonColor = false,
				BackgroundColor3 = Color3.fromRGB(198, 70, 58),
				BorderSizePixel = 0,

				[OnEvent "Activated"] = function()
					vm:Hide()
				end,

				[Children] = {
					s:New "UICorner" {
						CornerRadius = UDim.new(0.26, 0),
					},
					s:New "TextLabel" {
						Name = "Label",
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						Font = Enum.Font.BuilderSansBold,
						Text = "×",
						TextColor3 = Color3.new(1, 1, 1),
						TextScaled = true,
					},
				},
			},
			s:New "ScrollingFrame" {
				Name = "Content",
				Position = UDim2.fromOffset(EDGE_PADDING, HEADER_HEIGHT),
				Size = UDim2.fromOffset(CONTENT_WIDTH, CONTENT_HEIGHT),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(),
				ScrollBarThickness = 6,
				ScrollBarImageColor3 = Color3.fromRGB(110, 110, 120),
				ScrollingDirection = Enum.ScrollingDirection.Y,

				[Children] = {
					s:New "UIListLayout" {
						FillDirection = Enum.FillDirection.Horizontal,
						Wraps = true,
						Padding = UDim.new(0, CARD_GAP),
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
					},
					s:New "UIPadding" {
						PaddingTop = UDim.new(0, HOVER_ROOM),
						PaddingBottom = UDim.new(0, HOVER_ROOM),
						PaddingLeft = UDim.new(0, HOVER_ROOM),
						PaddingRight = UDim.new(0, SCROLLBAR_GUTTER),
					},
					s:ForValues(vm.Products, function(_, s, product: ShopViewModel.ProductEntry)
						-- The holder keeps the layout still while the card size tweens.
						return s:New "Frame" {
							Name = product.Name,
							LayoutOrder = product.LayoutOrder,
							Size = UDim2.fromOffset(CARD_SIZE, CARD_SIZE),
							BackgroundTransparency = 1,

							[Children] = {
								ProductCard {
									Scope = s,
									Product = product,
								},
							},
						}
					end),
				},
			},
		},
	} :: Frame
end
