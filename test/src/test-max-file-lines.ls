require! {
  chai: {expect}
  '../../lib/ls-lint': {lint}
}

module.exports = (...) ->
  describe \max-filelines (...) ->
    it '100 lines' -> expect(lint \1\n * 100).to.eql []
    it '101 lines' -> expect(lint \1\n * 101).to.eql [
      * line: 101
        rule: \max-file-lines
        level: \warning
        message: 'Max number of lines allowed is 100.']
