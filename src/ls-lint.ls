#------------------------------------------------------------------------------
# Provides lint function.

require! {
  livescript: lsc
  'prelude-ls': {Obj, empty, map, compact, flatten, reject, split, sort-with}
  './load-rules'
  './load-rule-modules'
}

# Lints LiveScript source.
#    String -> ({a: b}) -> [c]
export lint = (src, opts = {}) ->
  try
    lint-target = Obj.map (<| src), {tokens: lsc.lex, lsc.ast}
  catch e
    result = /(.*) on line (\d+)|(.*)/.exec e.message
    if result.1
      message = result.1
      line = +result.2
    else
      message = result.3
      line = void
    return [{rule: \compile, level: \fatal, line, message}]

  lint-target <<< {src, lines: (restruct-src src), rules: (load-rules opts)}

  <[ ./rules/*.js ]>
  |> load-rule-modules
  |> map (<| lint-target)
  |> flatten
  |> compact
  |> reject Obj.empty
  |> sort-with (x, y) ->
    | x.line > y.line   => 1
    | x.line < y.line   => -1
    | _                 => compare-column x, y

# Returns list of {line(Number), src, eol}
#   String -> [{a: b}]
restruct-src = ->
  it
  |> split /(\r?\n)/
  |> restruct-src-line 1

# Returns list of {line(Number), src, eol} from [src, eol, src, ...].
# Does recursively.
#    Int -> [a] -> [{b: c}]
restruct-src-line = (line, [src, eol, ...cs]) -->
  [{line, src, eol}] ++ if empty cs then [] else restruct-src-line line + 1, cs

compare-column = (x, y) ->
  | x.column? and not y.column?   => -1
  | not x.column? and y.column?   => 1
  | not (x.column? and y.column?) => 0
  | _                             => x.column - y.column
