# BeeGame

A Godot game about Beeees.

## Setup (once per machine)

GDScript is formatted automatically with the [GDQuest GDScript Formatter](https://github.com/GDQuest/GDScript-formatter). The repo already contains everything project-side:

- the Godot add-on (`addons/GDQuest_GDScript_formatter/`), enabled in `project.godot`
- `.editorconfig`, which turns on format on save for everyone and excludes `addons/`
- a pre-commit hook in `.githooks/` that rejects unformatted `.gd` files

What each machine needs:

1. **The `gdscript-formatter` program, callable by that name.**
2. **The Godot add-on pointed at the program.** Restart Godot after installing, then make sure the plugin is ticked under Project Settings → Plugins. If the add-on can't find the formatter, set its Formatter Path in Editor Settings. On macOS use the full path: Godot started from the Dock doesn't see the shell's PATH.
3. **Git hooks turned on:** `git config core.hooksPath .githooks`. Git never turns on hooks from a repository by itself, so every clone needs this once. If the formatter isn't found, the hook only warns and lets the commit through.

## Formatting by hand

- In Godot: Ctrl+Alt+I (macOS: Cmd+Alt+I) formats the current script.
- In a terminal: `gdscript-formatter .` formats everything, `gdscript-formatter --check .` only reports, `gdscript-formatter lint .` runs the linter. `addons/` is excluded via `.editorconfig`.
