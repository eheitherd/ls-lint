require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

opts-camel =
  config:
    naming-conventions:
      level: \error
      value: property: \camelCase

opts-snake =
  config:
    naming-conventions:
      level: \error
      value: property: \snake_case

module.exports = (...) ->
  describe 'property' (...) ->
    it 'chain-case <- chain-case' ->
      expect(lint 'aa-aa: 1\n').to.eql []
    it 'chain-case <- PascalCase' ->
      expect(lint 'AaAa: 1\n').to.eql [
        * line: 1
          column: 1
          rule: \naming-conventions
          level: \error
          message: "Property 'AaAa' should be chain-case."]
    it 'chain-case <- UPPERCASE' ->
      expect(lint 'AAAA: 1\n').to.eql [
        * line: 1
          column: 1
          rule: \naming-conventions
          level: \error
          message: "Property 'AAAA' should be chain-case."]
    it 'chain-case <- lowercase' ->
      expect(lint 'aaaa: 1\n').to.eql []
    it 'chain-case <- snake_case' ->
      expect(lint 'aa_aa: 1\n').to.eql [
        * line: 1
          column: 1
          rule: \naming-conventions
          level: \error
          message: "Property 'aa_aa' should be chain-case."]
    it 'chain-case <- SNAKE_CASE' ->
      expect(lint 'AA_AA: 1\n').to.eql [
        * line: 1
          column: 1
          rule: \naming-conventions
          level: \error
          message: "Property 'AA_AA' should be chain-case."]
    it 'chain-case <- 日本語' ->
      expect(lint 'プロパティ* 1\n').to.eql []

    it 'camelCase <- camelCase' ->
      expect(lint 'aaAa: 1\n', opts-camel).to.eql []
    it 'camelCase <- chain-case' ->
      expect(lint 'aa-aa: 1\n', opts-camel).to.eql [
        * line: 1
          column: 1
          rule: \naming-conventions
          level: \error
          message: "Property 'aa-aa' should be camelCase."]

    it 'snake_case <- snake_case' ->
      expect(lint 'aa_aa: 1\n', opts-snake).to.eql []
    it 'snake_case <- chain-case' ->
      expect(lint 'aa-aa: 1\n', opts-snake).to.eql [
        * line: 1
          column: 1
          rule: \naming-conventions
          level: \error
          message: "Property 'aa-aa' should be snake_case."]
