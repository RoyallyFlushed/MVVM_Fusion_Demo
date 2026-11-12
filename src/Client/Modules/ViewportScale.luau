--[[

    DESC: Gives UIScale values that follow the camera viewport size. The UI is designed for
          a viewport height of 1080 px, the same reference as Rem in find-the-limiteds.

--]]

--// Services
const ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
const Fusion = require(ReplicatedStorage.Packages.Fusion)
const Out = Fusion.Out

--// Constants
const REFERENCE_HEIGHT = 1080

--// Variables
const camera = workspace.CurrentCamera :: Camera
const moduleScope = Fusion:scoped()
const viewportSize = moduleScope:Value(camera.ViewportSize)

moduleScope:Hydrate(camera) {
	[Out "ViewportSize"] = viewportSize,
}

--// Class
const ViewportScale = {}
ViewportScale.ViewportSize = viewportSize

--- Returns the viewport height divided by the reference height, not less than `minScale`
function ViewportScale.Rem(s: Fusion.Scope<typeof(Fusion)>, minScale: number?): Fusion.Computed<number>
	return s:Computed(function(use: Fusion.Use)
		const size: Vector2 = use(viewportSize)
		return math.max(size.Y / REFERENCE_HEIGHT, minScale or 0)
	end)
end

--- Returns a scale that keeps `designSize` inside `fillRatio` of the viewport. The scale grows
--- with the viewport height above the reference height, and it shrinks only to fit.
function ViewportScale.Fit(
	s: Fusion.Scope<typeof(Fusion)>,
	designSize: Vector2,
	fillRatio: number
): Fusion.Computed<number>
	return s:Computed(function(use: Fusion.Use)
		const size: Vector2 = use(viewportSize)
		const fitScale = math.min(size.X * fillRatio / designSize.X, size.Y * fillRatio / designSize.Y)
		return math.min(fitScale, math.max(size.Y / REFERENCE_HEIGHT, 1))
	end)
end

return ViewportScale
