#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \eol-last
message = "Last line needs single EOL."

require! {
  'prelude-ls': {last, camelize, Str}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> Maybe [{c: d}]
module.exports = ({lines, config}) ->
  level = config[camelize rule]

  if level isnt \ignore
    last-line = last lines
    if last-line and (Str.empty last-line.src or not last-line.eol?)
      {rule, last-line.line, level, message}
