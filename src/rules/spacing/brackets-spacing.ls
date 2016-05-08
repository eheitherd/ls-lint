#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

get-rule = -> "#{it}-spacing"
get-message = (type, value) ->
  "#{if value then 'Spaces are' else 'No space is'} necessary inside #{type}."

require! {
  'prelude-ls': {camelize}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> {c: d} -> ({e: f} -> {e: f} -> {e: f} -> Maybe {g: h})
module.exports = (brackets, rules) -->
  {type, start, end} = brackets
  rule = get-rule type
  {level, value} = rules[camelize rule]
  message = get-message type, value

  if level isnt \ignore
    # return function to lint
    #   {a: b} -> {a: b} -> {a: b} -> Maybe {c: d}
    (pre, post, next) ->
      if (pre.0.endsWith start) or (post.0.startsWith end)
        # If .spaced is undefined, it should equal false.
        if not pre.eol and not pre.spaced isnt not value
          {rule, line: post.2 + 1, column: post.3 + 1, level, message}
  else
    # need no to check
    ->
