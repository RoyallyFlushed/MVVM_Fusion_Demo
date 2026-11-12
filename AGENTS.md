# Project conventions

- Name every Fusion scope variable `s`. Do not use `scope` as a local variable name.
- Follow the existing ViewModel structure exactly: create `local s = Fusion:scoped()`, declare state locals before `_self`, assign `_self` fields individually, then create and return a typed `object: ViewModel`.
- Keep the `PRELOAD`, `INTERNAL`, `INIT`, and `EXTERNAL` section layout in ViewModel modules, including empty sections.
- Keep UI data mapping in the controller; do not add a separate Model module unless the user explicitly requests a standalone Model module.
- Each UI lives in `src/Client/UI/<Name>/`: `<Name>.fusion/init.luau` (View), `<Name>ViewModel.luau`, and `<Name>.story.luau`. A `<Name>Controller` in `src/Client/Controllers/` mounts the View in a `ScreenGui`.
- The only game packages are Fusion and Knit. Clean up through the ViewModel's Fusion scope.
