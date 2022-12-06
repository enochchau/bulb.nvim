# Nvim bulb fennel compiler

Just compiles everything in the Neovim config dir.

## How it works

Need to add runtimepaths to fennel.path and fennel.macro-path

1. Look for all fennel files in runtimepath
2. Compile all files then turn them into bytecode with string.dump
3. Generate a cache file that uses package.preload to preload all of these bytecode strings with loadstring.
4. Run the cache file on start

## Optimizations

1. Check timestamps to see if a file needs to be recompiled.
   For this we need a dependency graph for macros.
   We can generate the graph using a compiler plugin like hotpot.
   We can reuse the cache file to store module metadata (deps, modify time) on global object similar to packer.
2. Using luv async functions for fs operations.
3. Using worker threads to do parallel compilation

## TODO

1. store the bulb cache in a seperate preload file so that it doesn't
   add to the runtime when loading the general preload file
2. Parallel compilation
3. There's a way to load ftplugins from lua's `require`. might wanna look into that.
4. Do people lazy load parts of their configs?

## License

- `bulb/fennel.lua` is licensed under MIT. The License is included at `./FENNEL_LICENSE`.

The rest of this code is currently unlicensed.
