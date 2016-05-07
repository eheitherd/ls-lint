require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

test-rules =
  rules:
    arrow-spacing:
      level: \warning
      value:
        before: false
        after:  false

module.exports = (...)->
  describe 'arrow' (...) ->
    it '(a = -> 1) <- (a = -> 1)' ->
      expect(lint 'a = -> 1\n').to.eql []
    it '(a = -> 1) <- (a = ->1)' ->
      expect(lint 'a = ->1\n').to.eql [
        * line: 1
          column: 5
          rule: \arrow-spacing
          level: \warning
          message: 'A space is necessary after an arrow.'
        ]
    it '(a = -> 1) <- (a =-> 1)' ->
      expect(lint 'a =-> 1\n').to.eql [
        * line: 1
          column: 4
          rule: \arrow-spacing
          level: \warning
          message: 'A space is necessary before an arrow.'
        ]
    it '(a = -> 1) <- (a =->1)' ->
      expect(lint 'a =->1\n').to.eql [
        * line: 1
          column: 4
          rule: \arrow-spacing
          level: \warning
          message: 'Spaces is necessary around an arrow.'
        ]
    it '(a = -> 1) <- a(->)' ->
      expect(lint 'a(->)\n').to.eql []
    it '(a = -> 1) <- a(->1)' ->
      expect(lint 'a(->1)\n').to.eql [
        * line: 1
          column: 3
          rule: \arrow-spacing
          level: \warning
          message: 'A space is necessary after an arrow.'
        ]
    it '(a =->1) <- (a =->1)' ->
      expect(lint 'a =->1\n' test-rules).to.eql []
    it '(a = -> 1) <- (a = ->1)' ->
      expect(lint 'a = ->1\n' test-rules).to.eql [
        * line: 1
          column: 5
          rule: \arrow-spacing
          level: \warning
          message: 'No space is necessary before an arrow.'
        ]
    it '(a = -> 1) <- (a =-> 1)' ->
      expect(lint 'a =-> 1\n' test-rules).to.eql [
        * line: 1
          column: 4
          rule: \arrow-spacing
          level: \warning
          message: 'No space is necessary after an arrow.'
        ]
    it '(a = -> 1) <- (a = -> 1)' ->
      expect(lint 'a = -> 1\n' test-rules).to.eql [
        * line: 1
          column: 5
          rule: \arrow-spacing
          level: \warning
          message: 'No spaces is necessary around an arrow.'
        ]
    it '(a =->1) <- a(->)' ->
      expect(lint 'a(->)\n' test-rules).to.eql []
    it '(a = -> 1) <- a(-> 1)' ->
      expect(lint 'a(-> 1)\n' test-rules).to.eql [
        * line: 1
          column: 3
          rule: \arrow-spacing
          level: \warning
          message: 'No space is necessary after an arrow.'
        ]
