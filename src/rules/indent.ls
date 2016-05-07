#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \indent
message = -> "Indent should be #{it}."

require! {
  'prelude-ls': {filter, reject, map, compact, camelize}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> Maybe [{c: d}]
module.exports = ({tokens, lines, rules}) ->
  {level, value} = rules[camelize rule]

  if level isnt \ignore
    tokens
    |> filter (.0 is \INDENT)
    |> reject (.1 is 0)
    |> map verify lines, level, value
    |> compact

verify = (lines, level, value, token) -->
  char = lines[token.2].src.charAt token.3 - token.1
  result = do
    if value is 'tab'
      token.1 is 1 and char is \\t
    else
      token.1 is value and char is ' '

  unless result
    [line, column] = [token.2 + 1, token.3 + 1]
    {rule, line, column, level, message: message get-value-str value}

get-value-str = ->
  | it is \tab  => it
  | it is 1     => "1 space"
  | _           => "#{it} spaces"
