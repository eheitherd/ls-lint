require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

test-rules =
  rules:
    braces-spacing:
      level: \warning
      value: true

module.exports = (...) ->
  describe 'braces' (...) ->
    it 'no need <= {a: 1}' ->
      expect(lint '{a: 1}\n').to.eql []
    it 'no need <= { a: 1}' ->
      expect(lint '{ a: 1}\n').to.eql [
        * line: 1
          column: 3
          rule: \braces-spacing
          level: \warning
          message: 'No space is necessary inside braces.'
        ]
    it 'no need <= {a: 1 }' ->
      expect(lint '{a: 1 }\n').to.eql [
        * line: 1
          column: 7
          rule: \braces-spacing
          level: \warning
          message: 'No space is necessary inside braces.'
        ]
    it 'need <= { a: 1 }' ->
      expect(lint '{ a: 1 }\n', test-rules).to.eql []
    it 'need <= { a: 1}' ->
      expect(lint '{ a: 1}\n', test-rules).to.eql [
        * line: 1
          column: 7
          rule: \braces-spacing
          level: \warning
          message: 'Spaces are necessary inside braces.'
        ]
    it 'need <= {a: 1 }' ->
      expect(lint '{a: 1 }\n', test-rules).to.eql [
        * line: 1
          column: 2
          rule: \braces-spacing
          level: \warning
          message: 'Spaces are necessary inside braces.'
        ]
