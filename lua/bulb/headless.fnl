(fn has-headless []
  (= 0 #(vim.api.nvim_list_uis)))

(fn print-stdout [msg]
  "Print a message to stdout when running in headless mode"
  (let [msg (vim.fn.split msg "\n")]
    (vim.fn.writefile msg :/dev/stdout)))

;; functions for commands in headless mode
;; they also support not being headless

(fn headless-compile [t]
  "Command for compiling a file in headless mode"
  (let [{: compile-file : setup-compiler} (require :bulb.compiler)
        {: write-file} (require :bulb.fs)
        (in-path out-path) (unpack t.fargs)]
    (setup-compiler)
    (assert in-path "Missing input path")
    (let [output (compile-file in-path)]
      (if (not= nil out-path) (write-file out-path output)
          (has-headless) (print-stdout output)
          (print output)))))

(fn headless-run [t]
  "Command for running a file in headless mode"
  (let [{: do-file : setup-compiler} (require :bulb.compiler)
        fennel (require :bulb.fennel)
        in-path t.args]
    (setup-compiler)
    (assert in-path "Missing input path")
    (let [output (do-file in-path)]
      ;; seperate input from dofile stdout with a newline
      (print "\n")
      (if (has-headless)
          (print-stdout (fennel.view output))
          (print (fennel.view output))))))

{: headless-compile : headless-run}
