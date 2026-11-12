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

-- Stories can set this to preview another screen size. Nil uses the real viewport.
const sizeOverride = moduleScope:Value(nil :: Vector2?)
const effectiveSize = moduleScope:Computed(function(use: Fusion.Use): Vector2
	return use(sizeOverride) or use(viewportSize)
end)

moduleScope:Hydrate(camera) {
	[Out "ViewportSize"] = viewportSize,
}

--// Class
const ViewportScale = {}
ViewportScale.ViewportSize = effectiveSize

--- Makes all scales use `size` in place of the real viewport size. Nil removes the override.
--- Use this only in stories, and remove the override when the story unmounts.
function ViewportScale.SetOverride(size: Vector2?): ()
	sizeOverride:set(size)
end

--- Returns the viewport height divided by the reference height, not less than `minScale`
function ViewportScale.Rem(s: Fusion.Scope<typeof(Fusion)>, minScale: number?): Fusion.Computed<number>
	return s:Computed(function(use: Fusion.Use)
		const size: Vector2 = use(effectiveSize)
		return math.max(size.Y / REFERENCE_HEIGHT, minScale or 0)
	end)
end

--- Returns a scale that keeps `designSize` inside `fillRatio` of the viewport. The scale grows
--- with the viewport height above the reference height, and it shrinks only to fit.
function ViewportScale.Fit(
	s: Fusion.Scope<typeof(Fusion)>,
	designSize: Fusion.UsedAs<Vector2>,
	fillRatio: number
): Fusion.Computed<number>
	return s:Computed(function(use: Fusion.Use)
		const size: Vector2 = use(effectiveSize)
		const design: Vector2 = use(designSize)
		const fitScale = math.min(size.X * fillRatio / design.X, size.Y * fillRatio / design.Y)
		return math.min(fitScale, math.max(size.Y / REFERENCE_HEIGHT, 1))
	end)
end

return ViewportScale
