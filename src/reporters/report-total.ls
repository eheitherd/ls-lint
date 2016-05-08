#------------------------------------------------------------------------------
# Reportts total of lint errors.

require! {
  'prelude-ls': {map, fold, lists-to-obj, keys, join, sum}
  './report-utils': {level-mark, level-value, println}
}

# Reports the totals of errors, warnings to stdout.
#   [{a: Int}] -> undefined
module.exports = (list-of-totals) ->
  file-num = list-of-totals.length
  file-num-str = "#{file-num} file#{if file-num isnt 1 then 's' else ''}"

  list-of-totals
  |> sum-up <[ fatal error warning ]>
  |> ->
    result-mark-str = worst-mark it
    result-str =
      it
      |> keys
      |> map (level) ->
        num = it[level]
        "#{num} #{level}#{if num isnt 1 then 's' else ''}"
      |> join ', '
    "\n  #{result-mark-str} #{result-str} in #{file-num-str}."
  |> println

sum-up = (targets, results) -->
  targets
  |> map (target) ->
    results
    |> map (.[target] ? 0)
    |> sum
  |> lists-to-obj targets

worst-mark = (result) ->
  result
  |> keys
  |> fold do
    (worst, level) ->
      if result[level] > 0 and (level-value level) > (level-value worst)
        level
      else
        worst
    'ok'
  |> level-mark
