#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \eol-last
message = "Last line needs single EOL."

require! {
  'prelude-ls': {at, camelize, Str}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> Maybe [{c: d}]
module.exports = ({lines, rules}) ->
  level = rules[camelize rule]

  if level isnt \ignore
    last1 = at -1 lines
    last2 = at -2 lines

    unless Str.empty last1.src or last1.eol?
      {rule, last1.line, level, message}
    else if Str.empty last2.src
      {rule, last2.line, level, message}
