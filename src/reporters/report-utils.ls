#------------------------------------------------------------------------------
# Provedes utility functions for reporters.

require! 'prelude-ls': {fold}

#colors
red = -> "\x1b[31m#{it}\x1b[39m"
green = -> "\x1b[32m#{it}\x1b[39m"
yellow = -> "\x1b[33m#{it}\x1b[39m"
magenta = -> "\x1b[35m#{it}\x1b[39m"
grey = -> "\x1b[90m#{it}\x1b[39m"

# marks of levels
level-mark = ->
  switch it
  | \fatal    => magenta '☠'
  | \error    => red '✗'
  | \warning  => yellow '☞'
  | \ok       => green '✓'
  | _         => grey '⁇'

# values of levels
level-value = ->
  switch it
  | \fatal    => 3
  | \error    => 2
  | \warning  => 1
  | \ok       => 0
  | _         => -1

# worse level
worse-level = (a, b) -> if (level-value a) > (level-value b) then a else b
worst-level = fold worse-level, \ok

# aliases
print = -> process.stdout.write it
println = -> print "#{it}\n"
printerr = -> process.stderr.write it
printerrln = -> printerr "#{it}\n"

export
  red
  green
  yellow
  magenta
  grey
  level-mark
  level-value
  worse-level
  worst-level
  print
  println
  printerr
  printerrln
