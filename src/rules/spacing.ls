#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.
#   *-spacing

require! {
  'prelude-ls': {is-type, map, fold, compact}
  './spacing/arrow-spacing'
}

# Verifies and returns the result. See ls-lint.lson
#   {a :b} -> Maybe [{c: d}]
module.exports = ({tokens, rules}) ->
  check-spacing =
    [
      arrow-spacing
    ]
    |> map (<| rules)
    |> get-checker

  tokens
  |> fold (check-sequence check-spacing), {result: []}
  |> (.result)
  |> compact

check-sequence = (check-spacing, {pre, post, result}, next) -->
  if pre?
    join-pre = post `is-equal-pos` pre and pre.spaced? and not post.spaced?
    join-next = post `is-equal-pos` next and not post.spaced?
    if join-pre or join-next
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
