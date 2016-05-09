#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.
#   *-spacing

require! {
  'prelude-ls': {is-type, map, fold, compact}
  './spacing/brackets-spacing'
  './spacing/arrow-spacing'
}

# Verifies and returns the result. See ls-lint.lson
#   {a :b} -> Maybe [{c: d}]
module.exports = ({tokens, config}) ->
  check-spacing =
    [
      brackets-spacing {type: \parentheses, start: \(, end: \)}
      brackets-spacing {type: \braces, start: \{, end: \}}
      brackets-spacing {type: \brackets, start: \[, end: \]}
      arrow-spacing
    ]
    |> map (<| config)
    |> get-checker

  tokens
  |> fold (check-sequence check-spacing), {result: []}
  |> (.result)
  |> compact

check-sequence = (check-spacing, {pre, post, result}, next) -->
  if pre?
    if post `is-equal-pos` next and not post.spaced? and is-optional post
      {pre, post: next, result}
    else
      next-result = result ++ check-spacing pre, post, next
      {pre: post, post: next, result: next-result}
  else
    {pre: next, post: next, result}

get-checker = (rule-modules) ->
  (pre, post, next) ->
    rule-modules
    |> map -> it pre, post, next
    |> fold (++), []

is-equal-pos = (a, b) ->
  a.3 is b.3 and a.4 is b.4

is-optional = -> not (it.0 is \ID or it.0 is \STRNUM)
