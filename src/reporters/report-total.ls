#------------------------------------------------------------------------------
# Reportts total of lint errors.

require! {
  'prelude-ls': {map, fold, filter, join}
  './report-utils': {level-mark, worst-level, println}
}

# Reports the totals of errors, warnings to stdout.
#   [a] -> ())
module.exports = (results) ->
  pluraize = -> if it isnt 1 then 's' else ''

  file-num = results.length
  file-num-str = "#{file-num} file#{pluraize file-num}"

  sums = sum-up <[ fatal error warning ]> results

  result-mark-str = worst-mark sums
  result-str =
    sums
    |> map -> "#{it.1} #{it.0}#{pluraize it.1}"
    |> join ', '

  println "\n  #{result-mark-str} #{result-str} in #{file-num-str}.\n"

sum-up = (targets, results = []) -->
  count-up = (target) ->
    (count, {level}) -> count + if level is target then 1 else 0
  sum-file = (target) ->
    (count, {results = []}) -> fold (count-up target), count, results
  sum-all = (target) -> fold (sum-file target), 0

  targets
  |> map (target) -> [target, (sum-all target) results]

worst-mark = (result) ->
  result
  |> filter -> (it.1 > 0)
  |> map (.0)
  |> worst-level
  |> level-mark
