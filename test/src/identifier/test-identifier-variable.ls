require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

opts-constant =
  config:
    naming-conventions:
      level: \error
      value:
        variable: \chain-case
        constant: \ignore

module.exports = (...) ->
  describe 'variable' (...) ->
    it 'chain-case <- chain-case' ->
      expect(lint 'aa-aa = 1\n').to.eql []
    it 'chain-case <- camelCase' ->
      expect(lint 'aaAA = ->\n').to.eql [
        * line: 1
          column: 1
          rule: \naming-conventions
          level: \error
          message: "Variable 'aaAA' should be chain-case."]
    it 'chain-case <- 日本語' ->
      expect(lint '変数 = 1\n').to.eql []
    it 'chain-case <- chain-case in function' ->
      expect(lint '-> aa-aa = 1\n').to.eql []
    it 'chain-case <- camelCase in function' ->
      expect(lint '-> aaAA = 1\n').to.eql [
        * line: 1
          column: 4
          rule: \naming-conventions
          level: \error
          message: "Variable 'aaAA' should be chain-case."]
    it 'ignore constant chain-case <- SNAKE_CASE' ->
      expect(lint 'const AA_AA = 1\n', opts-constant).to.eql []
    it 'chain-case <- start with _' ->
      expect(lint '_aa = 1\n').to.eql []
    it 'chain-case <- end with _' ->
      expect(lint 'aa_ = 1\n').to.eql []
