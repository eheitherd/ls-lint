#------------------------------------------------------------------------------
# Defines tasks.

require! {
  path
  gulp
  'gulp-util' : {log, colors}
  'gulp-newer': newer
  'gulp-livescript': lsc
  'gulp-mocha': mocha
  del
  'vinyl-paths': paths
  'prelude-ls': {is-type, split, join, slice}
}

dir-lib = \lib
dir-testlib = \test/lib
products = [dir-lib, dir-testlib]

gulp.task \test <[ build build-test ]> ->
  gulp.src "#{dir-testlib}/test.js"
    .pipe mocha reporter: \spec

gulp.task \build ->
  gulp.src \src/**/*.ls
    .pipe newer dest: dir-lib, ext: \.js
    .pipe lsc!
    .pipe paths -> log-act \compile, it, dir-lib, \ls
    .pipe gulp.dest dir-lib

gulp.task \build-test ->
  gulp.src \test/src/**/*.ls
    .pipe newer dest: dir-testlib, ext: \.js
    .pipe lsc!
    .pipe paths -> log-act \compile, it, dir-testlib, \ls
    .pipe gulp.dest dir-testlib

gulp.task \clean ->
  del products
    .then -> log-act \delete it

info = colors.green
relpath = -> module.filename |> path.dirname |> path.relative _, it
nixpath = -> it |> (.replace /\\/g \/)
addslash = -> if (slice -1, it) is \/ then it else "#{it}/"
replace-ext = (file, ext) -> file.replace /\.[^\.]+$/, ".#{ext}"

log-act-main = (act, file, dest, ext) ->
  if is-type \Array file
    for each-file in file => log-act-main act, each-file, dest
  else
    target = if ext? then replace-ext file, ext else file
    msg = "#{act}: #{nixpath relpath target}"
    msg2 = if dest then " -> #{dest |> nixpath |> addslash}" else ''
    log info msg + msg2

log-act = ->
  log-act-main ...
  Promise.resolve!
