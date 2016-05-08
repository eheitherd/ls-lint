require! {
  chai: {expect}
  '../../lib/ls-lint': {lint}
}

length79 = '
abcdefghijklmnopqrstuvwxyz: abcdefghijklmnopqrstuvwxyz: abcdefghijklmnopqrstuvw
\n
'
length80 = '
abcdefghijklmnopqrstuvwxyz: abcdefghijklmnopqrstuvwxyz: abcdefghijklmnopqrstuvw
x\n
'

module.exports = (...) ->
  describe \max-line-length (...) ->
    it 'length is 79' -> expect(lint length79).to.eql []
    it 'length is 80' -> expect(lint length80).to.eql [
      * line: 1
        rule: \max-line-length
        level: \warning
        message: 'Max line length should be 79.']
