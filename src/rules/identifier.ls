#------------------------------------------------------------------------------
# Verifies whether the source is obeying the following rule.
#   naming-conventions

require! {
  'prelude-ls': {Str, is-type, map, fold, filter, flatten, dasherize}
  './identifier/naming-conventions'
}

# Verifies and returns the result. See ls-lint.lson
#   {a: b} -> Maybe [{c: d}]
module.exports = ({tokens, ast, lines, rules}) ->
  fold-deep (get-identifier tokens, lines), ast
  |> filter (.type?)
  |> map (naming-conventions rules)
  |> flatten

# Verifies each identifier
#   {a: b} -> [c]
get-identifier = (tokens, lines, obj) -->
  switch
    # class
    case obj.title?
      [make-id lines, \class, obj.title]
    # property
    case obj.key? and obj.val?
      [make-id lines, \property, obj.key]
    # function
    case obj.params? and obj.body? and obj.name?
      [make-func lines, \function, obj]
    # variable, constant
    case obj.left?.value? and obj.left.value isnt \void and obj.left.line?
      type = if obj.const then \constant else \variable
      [make-id lines, type, obj.left]
    default
      []

make-id = (lines, type, obj) -->
  name = get-name lines, obj.line - 1, obj.column
  {line: obj.line - 1, obj.column, type, name}

# find func-name from "function /* */ * /* */ func-name"
make-func = (lines, type, obj) -->
  lines[obj.line - 1].src
  |> ->
    if obj.line is obj.body.line
      it |> Str.take obj.body.column
    else
      it
  |> Str.drop obj.column
  |> ->
    name = obj.name
    chain-name = dasherize name
    camel-index = it.lastIndexOf name
    chain-index = it.lastIndexOf chain-name
    if camel-index < chain-index
      {line: obj.line - 1, column: chain-index, type, name:  chain-name}
    else if 0 <= camel-index
      {line: obj.line - 1, column: camel-index, type, name}
    else
      {}

# Support 'prop', "prop"
get-name = (lines, line, column) -->
  lines[line].src
  |> Str.drop column
  |> -> (it is /".*"|'.*'|(?:[\w-]|[^\x01-\x7e])+/)?.0 ? ''

# This function takes a lot of time, because AST is very large.
#   ({a: b} -> [c]) -> {a: b} -> [c]
fold-deep = (func, obj) -->
  if is-type \Object obj
    obj
    # 'values' isn't used because ..
    #   * Result of livescript.ast has many inherited methods and properties.
    #   * Object.keys is higher-speed than for .. in which is used by 'values'.
    |> Object.keys
    |> map -> obj[it]
    |> filter -> is-type \Object it or is-type \Array it
    |> map fold-deep func
    |> fold (++), func obj
  else if is-type \Array obj
    obj
    |> filter -> is-type \Object it or is-type \Array it
    |> map fold-deep func
    |> fold (++), []
  else
    []
