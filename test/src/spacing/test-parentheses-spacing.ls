require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

test-rules =
  rules:
    parentheses-spacing:
      level: \warning
      value: true

module.exports = (...) ->
  describe 'pharentheses' (...) ->
    it 'no need <= (1 + 1)' ->
      expect(lint '(1 + 1)\n').to.eql []
    it 'no need <= ( 1 + 1)' ->
      expect(lint '( 1 + 1)\n').to.eql [
        * line: 1
          column: 3
          rule: \parentheses-spacing
          level: \warning
          message: 'No space is necessary inside parentheses.'
        ]
    it 'no need <= (1 + 1 )' ->
      expect(lint '(1 + 1 )\n').to.eql [
        * line: 1
          column: 8
          rule: \parentheses-spacing
          level: \warning
          message: 'No space is necessary inside parentheses.'
        ]
    it 'need <= ( 1 + 1 )' ->
      expect(lint '( 1 + 1 )\n', test-rules).to.eql []
    it 'need <= ( 1 + 1)' ->
      expect(lint '( 1 + 1)\n', test-rules).to.eql [
        * line: 1
          column: 8
          rule: \parentheses-spacing
          level: \warning
          message: 'Spaces are necessary inside parentheses.'
        ]
    it 'need <= (1 + 1 )' ->
      expect(lint '(1 + 1 )\n', test-rules).to.eql [
        * line: 1
          column: 2
          rule: \parentheses-spacing
          level: \warning
          message: 'Spaces are necessary inside parentheses.'
        ]
