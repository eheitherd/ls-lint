require! {
  'child_process': {exec-file}
  chai: {expect}
  '../../package.json': my-package
}

module.exports = (...) ->
  describe \cli (...) ->
    it 'no arguments' (done) ->
      args = <[ ./bin/ls-lint ]>
      error, stdout, stderr <- exec-file \node, args, timeout: 3000
      expect stdout .to.have.string 'Usage: ls-lint [options]'
      done!
    it '-v' (done) ->
      args = <[ ./bin/ls-lint -v ]>
      error, stdout, stderr <- exec-file \node, args, timeout: 3000
      expect stdout .to.have.string my-package.version
      done!
    it '-h' (done) ->
      args = <[ ./bin/ls-lint -h ]>
      error, stdout, stderr <- exec-file \node, args, timeout: 3000
      expect stdout .to.have.string 'Usage: ls-lint'
      done!
    it '1 file' (done) ->
      args = <[ ./bin/ls-lint src/ls-lint.ls ]>
      error, stdout, stderr <- exec-file \node, args, timeout: 3000
      expect stdout .to.have.match /src\/ls-lint\.ls[\s\S]+in 1 file\./
      done!
    it '2 files' (done) ->
      args = <[ ./bin/ls-lint src/index.ls src/ls-lint.ls ]>
      error, stdout, stderr <- exec-file \node, args, timeout: 3000
      expect stdout .to.have.string ' in 2 files'
      done!
    it '-c' (done) ->
      args = <[ ./bin/ls-lint -c test/assets/test.lson test/assets/test.ls]>
      error, stdout, stderr <- exec-file \node, args, timeout: 3000
      expect stdout .to.have.string '0 fatals, 0 errors, 0 warnings in 1 file'
      done!
