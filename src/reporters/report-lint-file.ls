#------------------------------------------------------------------------------
# Reports lint results for single file.

require! {
  'prelude-ls': {each, map, filter, fold1, count-by}
  './report-utils': {level-mark, level-value, println}
}

# Reports lint results for single file to stdout,
#  and returns the totals of errors, warnings of this file.
#   String -> [a] -> {b: Int}
module.exports = (file, results = []) -->
  if results.length
    level-list =
      results
      |> map (.level)

    level-list
    |> fold1 (x, y) -> if level-value x > level-value y then x else y
    |> -> println "    #{level-mark it} #{file}"

    results
    |> each -> println "      #{format-lint-result it}"

    level-list
    |> filter -> (level-value it) > 0
    |> count-by (-> it)
  else
    println "    #{level-mark \ok} #{file}"
    {}

format-lint-result = ->
  place =
    | not it.line?    => ''
    | not it.column?  => " (#{it.line})"
    | _               => " (#{it.line}:#{it.column})"
  "#{level-mark it.level} #{it.message}#{place}"
