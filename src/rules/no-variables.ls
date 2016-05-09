#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.

rule = \no-variables
message = "Should not rewrite variables."

require! {
  livescript: lsc
  'prelude-ls': {camelize}
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> Maybe {c: d}
module.exports = ({src, config}) ->
  level = config[camelize rule]

  if level isnt \ignore
    try
      lsc.compile src, const: true
      void
    catch e
      if result = e.message is /.*constant.* on line (\d+)/
        {rule, level, line: +result.1, message}
      else
        throw e
