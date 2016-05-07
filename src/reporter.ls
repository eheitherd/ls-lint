#------------------------------------------------------------------------------
# Provides functions whitch reports results or errors to the console.

require! {
  'prelude-ls': {each, map, filter, fold, fold1, lists-to-obj, keys, join, sum}
}

# Reports lint results for single file to stdout,
#  and returns the totals of errors, warnings of this file.
#   String -> [a] -> {b: Int}
export report-lint-results = (file, results = []) -->
  ok-totals = {fatal: 0, error: 0, warning: 0}

  if results.length
    level-list =
      results
      |> map (.level)

    level-list
    |> fold1 (x, y) -> if level-value x > level-value y then x else y
    |> -> println "    #{mark it} #{file}"

    results
    |> each -> println "      #{format-lint-result it}"

    level-list
    |> filter -> (level-value it) > 0
    |> fold do
      (result, level) -> result with {"#{level}": result[level] + 1}
      ok-totals
  else
    println "    #{mark \ok} #{file}"
    ok-totals

# Reports the totals of errors, warnings to stdout, and exits this process.
#   [{a: Int}] -> undefined
export report-total-result = (list-of-totals)->
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

  process.exit 0

# Reports error to stderr, and exits this process.
#   {a: b} -> undefined
export report-error = ->
  it
  |> (.toString!)
  |> -> "\n  #{mark \fatal} #{it}"
  |> printerrln

  process.exit 1  # TODO: move to cli.ls

format-lint-result = ->
  place =
    | not it.line?    => ''
    | not it.column?  => " (#{it.line})"
    | _               => " (#{it.line}:#{it.column})"
  "#{mark it.level} #{it.message}#{place}"

sum-up = (targets, results) -->
  targets
  |> map (target)->
    results
    |> map (.[target])
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
  |> mark

#colors
red = -> "\x1b[31m#{it}\x1b[39m"
green = -> "\x1b[32m#{it}\x1b[39m"
yellow = -> "\x1b[33m#{it}\x1b[39m"
magenta = -> "\x1b[35m#{it}\x1b[39m"
grey = -> "\x1b[90m#{it}\x1b[39m"

mark = ->
  switch it
  | \fatal    => magenta '☠'
  | \error    => red '✗'
  | \warning  => yellow '☞'
  | \ok       => green '✓'
  | _         => grey '⁇'

level-value = ->
  switch it
  | \fatal    => 3
  | \error    => 2
  | \warning  => 1
  | \ok       => 0
  | _         => -1

# aliases
print = -> process.stdout.write it
println = -> print "#{it}\n"
printerr = -> process.stderr.write it
printerrln = -> printerr "#{it}\n"
