#------------------------------------------------------------------------------
# Reports lint results for single file.

require! {
  'prelude-ls': {each, map, fold}
  './report-utils': {level-mark, worst-level, println}
}

# Reports lint results for single file to stdout,
#   String -> [a] -> ()
module.exports = (file, results = []) -->
  results
  |> map (.level)
  |> worst-level
  |> -> println "    #{level-mark it} #{file}"

  results
  |> each -> println "      #{format-lint-result file,it}"

format-lint-result = (file,it)->
  place =
    | not it.line?    => ''
    | not it.column?  => " (#{file}:#{it.line})"
    | _               => " (#{file}:#{it.line}:#{it.column})"
  "#{level-mark it.level} #{it.message}#{place}"
