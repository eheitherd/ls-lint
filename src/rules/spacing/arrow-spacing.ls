#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \arrow-spacing
message = [
  'A space is necessary before an arrow.'
  'No space is necessary before an arrow.'
  'A space is necessary after an arrow.'
  'No space is necessary after an arrow.'
  'Spaces is necessary around an arrow.'
  'No spaces is necessary around an arrow.'
]

require! {
  'prelude-ls': {camelize, map}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> ({c: d} -> {c: d} -> {c: d} -> Maybe {e: f})
module.exports = (rules) ->
  {level, value} = rules[camelize rule]

  if level isnt \ignore
    # return function to lint
    #   {a: b} -> {a: b} -> {a: b} -> Maybe {c: d}
    (pre, post, next) ->
      if post.0 is \-> or post.0 is \<-
        before-spacing =
          | pre.0 isnt \)PARAM  => value.before
          | pre.spaced?         => true
          | otherwise           => false
        after-spacing =
          | next.0 is /\)|\]|}/ => value.after
          | post.spaced?        => true
          | otherwise           => false

        get-message before-spacing, after-spacing, value
        |> map ->
          {rule, line: post.2 + 1, column: post.3 + 1, level, message: it}
  else
    # need no to check
    ->

get-message = (before-spacing, after-spacing, value) ->
  match-before = before-spacing is value.before
  match-after = after-spacing is value.after
  before-ng = not match-before and match-after
  after-ng = match-before and not match-after
  both-ng = not match-before and not match-after

  switch
  | before-ng and value.before                    => [message.0]
  | before-ng and not value.before                => [message.1]
  | after-ng and value.after                      => [message.2]
  | after-ng and not value.after                  => [message.3]
  | both-ng and value.before and value.after      => [message.4]
  | both-ng and not (value.before or value.after) => [message.5]
  | both-ng and value.before and not value.after  => [message.0, message.3]
  | both-ng and not value.before and value.after  => [message.1, message.2]
  | otherwise                                     => []
