require! {
  chai: {expect}
  '../../lib/ls-lint': {lint}
}

module.exports = (...) ->
  describe \common (...) ->
    it 'compile error' ->
      expect(lint '(').to.eql [
        * line: 1
          rule: \compile
          level: \fatal
          message: 'missing `)`']
    it 'order' ->
      expect(lint 'class aa\r\n\t->\r\n\ta_a: ->\r\n[]').to.eql [
        * line: 1
          column: 7
          rule: \naming-conventions
          level: \error
          message: "Class 'aa' should be PascalCase."
        * line: 1
          rule: \end-of-line
          level: \error
          message: 'End of line should be LF.'
        * line: 2
          column: 2
          rule: \indent
          level: \error
          message: 'Indent should be 2 spaces.'
        * line: 2
          rule: \end-of-line
          level: \error
          message: 'End of line should be LF.'
        * line: 3
          column: 2
          rule: \naming-conventions
          level: \error
          message: "Property 'a_a' should be chain-case."
        * line: 3
          rule: \end-of-line
          level: \error
          message: 'End of line should be LF.'
        * line: 4
          rule: \eol-last
          level: \warning
          message: 'Last line needs single EOL.']
