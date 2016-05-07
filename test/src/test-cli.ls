require! {
  'child_process': {execFile}
  chai: {expect}
  '../../package.json': my-package
}

module.exports = (...)->
  describe \cli (...) ->
    it 'no arguments' (done) ->
      args = <[ ./bin/ls-lint ]>
      error, stdout, stderr <- execFile \node, args, timeout: 3000
      expect stdout .to.have.string 'Usage: ls-lint [options]'
      done!
    it '-V' (done) ->
      args = <[ ./bin/ls-lint -V ]>
      error, stdout, stderr <- execFile \node, args, timeout: 3000
      expect stdout .to.have.string my-package.version
      done!
    it '-h' (done) ->
      args = <[ ./bin/ls-lint -h ]>
      error, stdout, stderr <- execFile \node, args, timeout: 3000
      expect stdout .to.have.string 'Usage: ls-lint [options]'
      done!
    it '1 file' (done) ->
      args = <[ ./bin/ls-lint src/ls-lint.ls ]>
      error, stdout, stderr <- execFile \node, args, timeout: 3000
      expect stdout .to.have.match /src\/ls-lint\.ls[\s\S]+in 1 file\./
      done!
    it '2 files' (done) ->
      args = <[ ./bin/ls-lint src/index.ls src/ls-lint.ls ]>
      error, stdout, stderr <- execFile \node, args, timeout: 3000
      expect stdout .to.have.string ' in 2 files'
      done!
