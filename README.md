# Bulb

Fair warning, I jus ripped this out of my dotfiles. Don't expect anything to stay the same.

Bulb is a Neovim plugin that allows you to seamlessly include Fennel in your configs.
You can require Fennel modules from Lua and visa-versa.

Bulb was originally made for use with a Makefile in Neovim's headless mode.
In that regard, it adheres more closely to the compile -> run cycle rather
than automatic compilation provided by other Neovim Fennel plugins.
You have to recompile your files yourself, but that means there is zero
overhead at start time.

## Installation

With [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use "ec965/bulb.nvim"
```

## Usage

Put this at the top of your `init.lua`.

```lua
require("bulb").setup()
```

If you use [impatient.nvim](https://github.com/lewis6991/impatient.nvim)
you can put it right after that.

```lua
require('impatient')
require("bulb").setup()
```

Bulb can bootstrap itself.
The preload file will be automatically generated if it's missing.

You should regenerate the preload file yourself after editing your files
by running `:BulbPreload`.

### Commands

- `BulbPreload` - generate the module preload file.
- `BulbClean` - remove the module preload file.
- `BulbOpen <module-name>` - open the preload file at the module specified. If no module name is given, the file is just opened.
- `BulbRun <filename>` - compile and run a Fennel file, results are printed to stdout.
- `BulbCompile <input> <output>` - compile an input file to the output. If no output is specified, the results are printed to stdout.

`BulbRun` and `BulbCompile` were originally created to be run in headless mode.
You can use Neovim as a Fennel compiler like so:

```bash
# evaluate a fennel file
nvim --headless -c "BulbRun $INPUT" +q
# compile a fennel file
nvim --headless -c "BulbCompile $INPUT $OUTPUT" +q
```

### Configuration

```lua
-- default configuration
require("ec965/bulb.nvim") {
   ["compiler-options"] = { 
      compilerEnv = _G
      -- you can add any valid compiler settings for the fennel compiler
   },
   ["cache-path"] = vim.fn.stdpath "cache" .. "/bulbcache.lua",
}
```

## How it works

1. Looks for all the Fennel files in your config directory (`~/.config/nvim` or whatever `stdpath('config')` resolves to).
2. Compiles them into a module preload file that uses `package.preload`.
3. Loads the preload file at startup.

You have to manually recreate the preload file everytime you update your configs.
This is a worthy trade off.
Most other Fennel plugins will load the entire fennel compiler on startup
which takes a fair amount of time.
Bulb only loads the bare minimum it needs, the Fennel compiler is only loaded
when a compilation command is called.
