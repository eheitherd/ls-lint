require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

module.exports = (...) ->
  describe 'class' (...) ->
    it 'PascalCase <- PascalCase' ->
      expect(lint 'class AaAa\n').to.eql []
    it 'PascalCase <- UPPERCASE' ->
      expect(lint 'class AAAA\n').to.eql []
    it 'PascalCase <- lowercase' ->
      expect(lint 'class aaaa\n').to.eql [
        * line: 1
          column: 7
          rule: \naming-conventions
          level: \error
          message: "Class 'aaaa' should be PascalCase."]
    it 'PascalCase <- chain-case' ->
      expect(lint 'class aa-aa\n').to.eql [
        * line: 1
          column: 7
          rule: \naming-conventions
          level: \error
          message: "Class 'aa-aa' should be PascalCase."]
    it 'PascalCase <- snake_case' ->
      expect(lint 'class aa_aa\n').to.eql [
        * line: 1
          column: 7
          rule: \naming-conventions
          level: \error
          message: "Class 'aa_aa' should be PascalCase."]
    it 'PascalCase <- SNAKE_CASE' ->
      expect(lint 'class AA_AA\n').to.eql [
        * line: 1
          column: 7
          rule: \naming-conventions
          level: \error
          message: "Class 'AA_AA' should be PascalCase."]
    it 'PascalCase <- 日本語' ->
      expect(lint 'class クラス\n').to.eql []
