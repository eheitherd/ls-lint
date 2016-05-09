#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \max-file-lines
message = -> "Max number of lines allowed is #{it}."

require! {
  'prelude-ls': {camelize, Str}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> Maybe {c: d}
module.exports = ({lines, rules}) ->
  {level, value} = rules[camelize rule]

  if level isnt \ignore and lines.length > value
    {rule, line: lines.length, level, message: message value}
