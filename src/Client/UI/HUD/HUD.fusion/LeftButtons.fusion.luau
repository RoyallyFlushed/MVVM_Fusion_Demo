--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const HUDViewModel = require(ReplicatedStorage.Client.UI.HUD.HUDViewModel)
const HUDButton = require(script.Parent["HUDButton.fusion"])
const ViewportScale = require(ReplicatedStorage.Client.Modules.ViewportScale)

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children
const OnEvent = Fusion.OnEvent

--// Constants
const BUTTON_SIZE = 96
-- A phone viewport is about 390 px high. This limit keeps the button at 48 px or more.
const MIN_SCALE = 0.5

type Props = {
	ViewModel: HUDViewModel.ViewModel,
}

return function(props: Props): Frame
	const vm = props.ViewModel
	const s = vm.Scope

	return s:New "Frame" {
		Name = "LeftButtons",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 16, 0.5, 0),
		Size = UDim2.fromOffset(BUTTON_SIZE, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,

		[Children] = {
			s:New "UIScale" {
				Scale = ViewportScale.Rem(s, MIN_SCALE),
			},
			s:New "UIListLayout" {
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
			},
			-- The holder keeps the layout still while the button size tweens.
			s:New "Frame" {
				Name = "ButtonHolder",
				LayoutOrder = 1,
				Size = UDim2.fromOffset(BUTTON_SIZE, BUTTON_SIZE),
				BackgroundTransparency = 1,

				[Children] = {
					HUDButton {
						Scope = s,
						Name = "Shop",
						Icon = "🛒",
						Text = "SHOP",

						[OnEvent "Activated"] = function()
							vm:ToggleShop()
						end,
					},
				},
			},
		},
	} :: Frame
end
