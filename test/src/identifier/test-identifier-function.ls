require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

module.exports = (...)->
  describe 'function' (...) ->
    it 'chain-case <- chain-case' ->
      expect(lint 'function aa-aa then\n').to.eql []
    it 'chain-case <- camelCase' ->
      expect(lint 'function aaAA then\n').to.eql [
        * line: 1
          column: 10
          rule: \naming-conventions
          level: \error
          message: "Function 'aaAA' should be chain-case." ]
    it 'chain-case <- 日本語' ->
      expect(lint 'function 関数 then\n').to.eql []
    it 'with body' ->
      expect(lint 'function aa-aa\n  1\n').to.eql []
    it 'with generator' ->
      expect(lint 'function *aa-aa then\n').to.eql []
    it 'with generator 2' ->
      expect(lint 'function* aa-aa then\n').to.eql []
    it 'with comment' ->
      expect(lint 'function /* a */ * /* "" */ aa-aa then\n').to.eql []
