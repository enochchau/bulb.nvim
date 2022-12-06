(fn write-file [filename contents]
  "write a file to disk"
  (let [file (assert (io.open filename :w))]
    (file:write contents)
    (file:close)))

(fn get-fnl-files [...]
  "Find all the fnl files that match the pattern form a list of paths"
  (fn find-fnl [path]
    "Find files under the path that have the `.fnl` extension"
    (vim.fs.find #(not= nil (string.match $1 "%.fnl$"))
                 {:type :file :limit math.huge : path}))

  (accumulate [files [] _ path (ipairs [...])]
    (do
      (each [_ file (ipairs (find-fnl path))]
        (table.insert files file))
      files)))

{: write-file : get-fnl-files}
