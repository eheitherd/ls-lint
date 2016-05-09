require! {
  chai: {expect}
  '../../lib/ls-lint': {lint}
}

opts-test =
  config:
    no-variables: \ignore

module.exports = (...) ->
  describe \no-variables (...) ->
    it 'no rewrite' ->
      expect(lint 'a = 1\n').to.eql []
    it 'rewrite' ->
      expect(lint 'a = 1\na = 2\n').to.eql [
        * line: 2
          rule: \no-variables
          level: \warning
          message: 'Should not rewrite variables.']
    it 'ignore' ->
      expect(lint 'a = 1\na = 2\n', opts-test).to.eql []
