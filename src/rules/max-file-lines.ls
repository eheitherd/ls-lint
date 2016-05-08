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

  if level isnt \ignore
    last-line = lines[* - 1]
    number-of-lines =
      | Str.empty last-line.src and not last-line.eol?  => lines.length - 1
      | otherwise                                       => lines.length
    if number-of-lines > value
      {rule, line: number-of-lines, level, message: message value}
