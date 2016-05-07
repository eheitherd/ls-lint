require! {
  fs
  path
  glob
  chai: {expect}
  '../../lib/ls-lint': {lint}
  'prelude-ls': {each}
}

reform-path = ->
  it
  |> path.relative './', _
  |> (.replace /\\/g \/)

module.exports = (...)->
  describe 'lint me' (done) ->
    glob.sync './**/*.ls?(on)'
    |> each (file)->
      src = fs.readFileSync file, encoding: \utf8
      it (reform-path file), -> expect(lint src).to.eql []
