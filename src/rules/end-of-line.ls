#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \end-of-line
message = -> "End of line should be #{it}."

require! {
  'prelude-ls': {map, compact, camelize}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> Maybe [{c: d}]
module.exports = ({lines, config}) ->
  {level, value} = config[camelize rule]
  value-set = get-value-set value

  if level isnt \ignore and value-set
    lines
    |> map ->
      if it.eol? and it.eol isnt value-set.value
        {rule, it.line, level, message: message value-set.name}
    |> compact

get-value-set = ->
  | it is 'LF' or it is 'lf'      => {name: \LF, value: \\n}
  | it is 'CRLF' or it is 'crlf'  => {name: \CRLF, value: \\r\n}
  | otherwise                     => null
