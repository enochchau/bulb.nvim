# Nvim bulb fennel compiler

This was extracted from my own dotfiles. It's still really alpha.
More documentation is coming soon.

A Fennel compiler plugin with zero overhead.

## Installation

With [Packer](https://github.com/wbthomason/packer.nvim)

```lua
use {"ec965/bulb.nvim", run = ":BulbPreload"}
```

## Usage

Put this at the top of your `init.lua`.

```lua
require("ec965/bulb.nvim").setup()
```

If you use [impatient.nvim](https://github.com/lewis6991/impatient.nvim)
you can put it right after that.

```lua
require('impatient')
require("ec965/bulb.nvim").setup()
```

Bulb can bootstrap itself.
The preload file will be automatically generated if it's missing.

You should regenerate the preload file yourself after editing your files.

### Commands

- `BulbPreload` - generate the module preload file.
- `BulbClear` - remove the module preload file.
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

## License

- `bulb/fennel.lua` is licensed under MIT. The License is included at `./FENNEL_LICENSE`.

The rest of this code is currently unlicensed.

## TODO

1. store the bulb cache in a seperate preload file so that it doesn't
   add to the runtime when loading the general preload file
2. Parallel compilation
3. There's a way to load ftplugins from lua's `require`. might wanna look into that.
4. Do people lazy load parts of their configs?

### Optimizations

1. Check timestamps to see if a file needs to be recompiled.
   For this we need a dependency graph for macros.
   We can generate the graph using a compiler plugin like hotpot.
   We can reuse the cache file to store module metadata (deps, modify time) on global object similar to packer.
2. Using luv async functions for fs operations.
3. Using worker threads to do parallel compilation
