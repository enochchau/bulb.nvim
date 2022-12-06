(macro command [name command opts]
  (let [opts (or opts {})]
    `(vim.api.nvim_create_user_command ,name ,command ,opts)))

(macro lazy-req [module-name key]
  "Lazy load command functions by wrapping them in another function"
  `(fn [t#]
     ((. (require ,module-name) ,key) t#)))

(fn setup [user-config]
  "Setup bulb"
  (let [config (require :bulb.config)
        user-config (or user-config {})]
    ;; apply user configs
    (tset config :cfg (vim.tbl_deep_extend :keep user-config config.cfg))
    ;; create user commands
    (command :BulbCompile (lazy-req :bulb.headless :headless-compile)
             {:nargs "+" :complete :file})
    (command :BulbRun (lazy-req :bulb.headless :headless-run)
             {:nargs 1 :complete :file})
    (command :BulbPreload (lazy-req :bulb.cache :gen-preload-cache))
    (command :BulbClean (lazy-req :bulb.cache :clear-cache))
    (command :BulbOpen (lazy-req :bulb.cache :open-cache) {:nargs "?"})
    nil))

{: setup}
