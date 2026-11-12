# Project conventions

- Do not add `--!strict` to files. The default nonstrict mode is fine.
- Name every Fusion scope variable `s`. Do not use `scope` as a local variable name.
- Follow the existing ViewModel structure exactly: create `local s = Fusion:scoped()`, declare state locals before `_self`, assign `_self` fields individually, then create and return a typed `object: ViewModel`.
- Keep the `PRELOAD`, `INTERNAL`, `INIT`, and `EXTERNAL` section layout in ViewModel modules, including empty sections.
- Keep UI data mapping in the controller; do not add a separate Model module unless the user explicitly requests a standalone Model module.
- Each UI lives in `src/Client/UI/<Name>/`: `<Name>.fusion/init.luau` (View), `<Name>ViewModel.luau`, and `<Name>.story.luau`. A `<Name>Controller` in `src/Client/Controllers/` mounts the View in a `ScreenGui`.
- Put a sub-component of a View in its own `<Part>.fusion.luau` file inside `<Name>.fusion/`. Put shared components in `src/Client/UI/Common/`.
- Build every button on `Common/Button`. A custom component merges its `DEFAULT_PROPS` with the props through `TableUtil.Merge`, removes its `CUSTOM_PROPS`, and passes the other props to the component under it. In a layout, put the button in a holder frame, so that the hover size tween does not move the layout.
- The only game packages are Fusion, Knit, and Janitor. Each ViewModel owns a `Janitor`: set `_self.Janitor = Janitor.new()`, then `_self.Scope = _self.Janitor:Add(s, "doCleanup", "Scope")`. Add other cleanup items to `self.Janitor`. `Destroy` calls `self.Janitor:Destroy()`, sets `self.Janitor = nil :: any`, and clears the metatable.
