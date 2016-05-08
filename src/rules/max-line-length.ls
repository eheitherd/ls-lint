#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \max-line-length
message = -> "Max line length should be #{it}."

require! {
  'prelude-ls': {map, compact, camelize}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> Maybe [{c: d}]
module.exports = ({lines, rules}) ->
  {level, value} = rules[camelize rule]

  if level isnt \ignore
    lines
    |> map ->
      if it.src.length > value
        {rule, it.line, level, message: message value}
    |> compact
