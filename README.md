# mvvm-fusion-demo

A Roblox project that shows the MVVM UI structure with Fusion 0.3, Knit 1.7, and Janitor 1.18.

## Setup

Install [Rokit](https://github.com/rojo-rbx/rokit), then run:

```bash
rokit install
lune run setup
```

The setup script installs the Rokit tools, installs the pesde packages from `pesde.lock`, and writes `sourcemap.json`.

## Build and sync

```bash
rojo build -o "mvvm-fusion-demo.rbxlx"
rojo serve
```

## UI structure

```
src/Client/
  Controllers/HUDController.luau      Knit controller. Mounts the HUD and connects the Shop button.
  Controllers/ShopController.luau     Knit controller. Makes the ViewModel and mounts the View.
  UI/Common/Button.luau               Base button. Scales up on hover and down on press.
  UI/HUD/                             HUD with a left-side buttons panel (View, ViewModel, story).
  UI/Shop/
    Shop.fusion/init.luau             View. Reads ViewModel state only.
    ShopViewModel.luau                ViewModel. Owns the Fusion scope and state.
    Shop.story.luau                   Story for a story viewer (for example UI Labs or Hoarcekat).
```
