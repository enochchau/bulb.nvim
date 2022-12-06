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
