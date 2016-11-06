require! {
  fs
  path
  'glob-all'
  chai: {expect}
  '../../lib/ls-lint': {lint}
  'prelude-ls': {each, count-by}
}

reform-path = ->
  it
  |> path.relative './', _
  |> (.replace /\\/g \/)

module.exports = (...) ->
  describe 'lint me' ->
    glob-all.sync <[./*.ls?(on) ./**/src/**/*.ls]>
    |> each (file) ->
      it (reform-path file), ->
        fs.read-file-sync file, encoding: \utf8
        |> lint
        |> count-by (.level)
        |> (.error)
        |> (~= true)
        |> -> expect it .to.be.false
