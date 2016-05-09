require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

opts-snake =
  config:
    naming-conventions:
      level: \error
      value:
        variable: \chain-case
        constant: \SNAKE_CASE

module.exports = (...) ->
  describe 'constant' (...) ->
    it 'chain-case <- chain-case' ->
      expect(lint 'const aa-aa = 1\n').to.eql []
    it 'SNAKE_CASE <- SNAKE_CASE' ->
      expect(lint 'const AA_AA = 1\n', opts-snake).to.eql []
    it 'SNAKE_CASE <- UPPERCASE' ->
      expect(lint 'const AAAAA = 1\n', opts-snake).to.eql []
    it 'SNAKE_CASE <- chain-case' ->
      expect(lint 'const aa-aa = 1\n', opts-snake).to.eql [
        * line: 1
          column: 7
          rule: \naming-conventions
          level: \error
          message: "Constant 'aa-aa' should be SNAKE_CASE."]
    it 'multiple definition per line' ->
      expect(lint 'const aa-aa = 1, bB = 2\n', opts-snake).to.eql [
        * line: 1
          column: 7
          rule: \naming-conventions
          level: \error
          message: "Constant 'aa-aa' should be SNAKE_CASE."
        * line: 1
          column: 18
          rule: \naming-conventions
          level: \error
          message: "Constant 'bB' should be SNAKE_CASE."]
    it 'multiple line' ->
      expect(lint 'const\n  a = 1\n  b = 2\n    c = 3\n', opts-snake).to.eql [
        * line: 2
          column: 3
          rule: \naming-conventions
          level: \error
          message: "Constant 'a' should be SNAKE_CASE."
        * line: 3
          column: 3
          rule: \naming-conventions
          level: \error
          message: "Constant 'b' should be SNAKE_CASE."
        * line: 4
          column: 5
          rule: \naming-conventions
          level: \error
          message: "Constant 'c' should be SNAKE_CASE."]
