# mvvm-fusion-demo

A Roblox project that shows the MVVM UI structure with Fusion 0.3 and Knit 1.7.

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
  Controllers/ShopController.luau     Knit controller. Makes the ViewModel and mounts the View.
  UI/Shop/
    Shop.fusion/init.luau             View. Reads ViewModel state only.
    ShopViewModel.luau                ViewModel. Owns the Fusion scope and state.
    Shop.story.luau                   Story for a story viewer (for example UI Labs or Hoarcekat).
```
