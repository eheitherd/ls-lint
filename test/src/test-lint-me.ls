require! {
  fs
  path
  'glob-all'
  chai: {expect}
  '../../lib/ls-lint': {lint}
  '../../lib/utils/monad-p': {monad-p: p, promisize-api}
  'prelude-ls': {each, count-by}
}

reform-path = (.replace /\\/g \/ ) . (path.relative './', _)
read-file = promisize-api fs.read-file _, \utf8, _
is-error = -> ((.fatal) or (.error)) it
lint-check = (~= true) . is-error . (count-by (.level)) . lint

module.exports = (...) ->
  describe 'lint me' ->
    glob-all.sync <[./*.ls?(on) ./**/src/**/*.ls]>
    |> each (file) ->
      it (reform-path file), (done) !->
        (read-file file) `p.'>>='` ->
          expect (lint-check it) .to.be.false
          done!
