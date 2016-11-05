#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \naming-conventions
message = (type, name, value) -> "#{type} '#{name}' should be #{value}."

require! {
  'prelude-ls': {map, filter, pairs-to-obj, any, Obj, camelize, capitalize}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> ({c: d} -> Maybe {e: f})
module.exports = (config) ->
  {level, value} = config[camelize rule]

  if level isnt \ignore
    naming-rules = parse-rules value

    # return function to lint
    #   {a: b} -> Maybe [{c: d}]
    (id) ->
      naming-rule = naming-rules[id.type]
      unless any (<| id.name), naming-rule.func
        {
          rule
          line: id.line + 1
          column: id.column + 1
          level
          message: message (capitalize id.type), id.name, naming-rule.value
        }
  else
    # need no to check
    ->

#   {a: b} -> {a: {c: b, d: [(String -> Bool)]}}
parse-rules = ->
  it
  |> Obj.map (value) -> {value, func: get-checkers value}

get-checkers = (value) ->
  if value is \ignore
    [-> true]
  else
    [is-pascal, is-camel, is-chain, is-snake, is-upper-snake]
    |> filter (<| value)

is-non-ascii = (is /[^\x01-\x7e]/)
is-quoted = (is /^".*"$|^'.*'$/)
is-ignore = -> is-non-ascii it or is-quoted it
is-pascal = -> is-ignore it or it is /^_*[A-Z][A-Za-z0-9]*_*$/
is-camel = -> is-ignore it or it is /^_*[a-z][A-Za-z0-9]*_*$/
is-chain = -> is-ignore it or it is /^_*[a-z][a-z0-9-]*_*$/
is-snake = -> is-ignore it or it is /^[a-z_][a-z0-9_]*$/
is-upper-snake = -> is-ignore it or it is /^[A-Z_][A-Z0-9_]*$/
