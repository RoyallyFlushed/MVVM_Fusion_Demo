-- Lune script to set up the project: installs tools and packages, then refreshes the sourcemap

--// Libraries //--
local process = require("@lune/process")

--------------------------------------------------------------------------------
--// Utility Functions //--
--------------------------------------------------------------------------------

--- Spawns a child process and inherits stdio; exits on failure if `fatal` is true
local function runCmd(cmd, args, opts, fatal)
	local result = process.exec(cmd, args, opts)
	if not result.ok and fatal then
		print(cmd .. " failed with code: " .. result.code)
		process.exit(result.code)
	end
	return result
end

--------------------------------------------------------------------------------
--// Functions //--
--------------------------------------------------------------------------------

--- Installs exactly what is recorded in pesde.lock.
--- To change a version, edit pesde.toml, run `pesde install`, and commit both files.
local function runPesdeInstall()
	runCmd("pesde", { "install", "--locked" }, { stdio = "inherit", shell = true }, true)
end

--------------------------------------------------------------------------------
--// Workflow //--
--------------------------------------------------------------------------------

-- 1. Install rokit tools if not already installed
runCmd("rokit", { "install" }, { stdio = "inherit", shell = true }, true)

-- 2. Install pesde packages
runPesdeInstall()

-- 3. Refresh sourcemap
runCmd(
	"rojo",
	{ "sourcemap", "default.project.json", "--output", "sourcemap.json" },
	{ stdio = "inherit", shell = true },
	true
)
