;; I read somewhere streaming is supposed to use less memory
(fn stream-file [filename]
  "Open a file as a read stream"
  (let [file-handle (assert (io.open filename :rb))]
    (fn []
      (let [char (file-handle:read 1)]
        (if (not= nil char) (char:byte)
            (do
              (file-handle:close)
              nil))))))

(fn get-compiler-options [filename]
  (let [config (require :bulb.config)]
    (vim.tbl_extend :keep config.cfg.compiler-options {: filename})))

(fn compile-file [filename]
  "Compile a file"
  (let [fennel (require :bulb.fennel)
        compiler-options (get-compiler-options filename)]
    (fennel.compile-stream (stream-file filename) compiler-options)))

(fn do-file [filename]
  "Evaluate a file"
  (let [fennel (require :bulb.fennel)
        compiler-options (get-compiler-options filename)]
    (fennel.dofile filename compiler-options)))

(fn setup-compiler []
  "Setup things that the compiler needs to run"
  (fn tap-macro-searcher []
    "Tap into the default fnl macro searcher to do caching"
    (if (not _G.__bulb_internal.macro_searcher_updated)
        (let [{: add-macro} (require :bulb.cache)
              fennel (require :bulb.fennel)
              _macro-searcher (. fennel.macro-searchers 1)
              tapped-searcher (fn [module-name]
                                (let [(result filename) (_macro-searcher module-name)]
                                  (add-macro filename module-name
                                             (string.dump result))
                                  (values result filename)))]
          (tset fennel.macro-searchers 1 tapped-searcher)
          (tset _G.__bulb_internal :macro_searcher_updated true))))

  (fn enable-debug []
    "Enable fennel debug mode"
    (let [fennel (require :bulb.fennel)]
      (if (not= debug.traceback fennel.traceback)
          (tset debug :traceback fennel.traceback))))

  ((. (require :bulb.lutil) :update-fnl-macro-rtp))
  (tap-macro-searcher)
  (enable-debug))

{: compile-file : do-file : setup-compiler}
