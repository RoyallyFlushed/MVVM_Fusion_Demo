--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Modules
const HUDViewModel = require(script.Parent.HUDViewModel)
const LeftButtons = require(script["LeftButtons.fusion"])

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Children = Fusion.Children

type Props = {
	ViewModel: HUDViewModel.ViewModel,
}

return function(props: Props): Frame
	const vm = props.ViewModel
	const s = vm.Scope

	return s:New "Frame" {
		Name = "HUD",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,

		[Children] = {
			LeftButtons {
				ViewModel = vm,
			},
		},
	} :: Frame
end
