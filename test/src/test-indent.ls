require! {
  chai: {expect}
  '../../lib/ls-lint': {lint}
}

rules-tab =
  indent:
    level: \error
    value: \tab

module.exports = (...) ->
  describe \indent (...) ->
    describe 'shouled be 2 spaces' (...) ->
      it '2 space' -> expect(lint '->\n  ->\n    ->\n').to.eql []
      it '4 space' ->
        expect(lint '->\n    ->\n        ->\n').to.eql [
          * line: 2
            column: 5
            rule: \indent
            level: \error
            message: 'Indent should be 2 spaces.'
          * line: 3
            column: 9
            rule: \indent
            level: \error
            message: 'Indent should be 2 spaces.' ]
      it 'tab' ->
        expect(lint '->\n\t->\n\t\t->\n').to.eql [
          * line: 2
            column: 2
            rule: \indent
            level: \error
            message: 'Indent should be 2 spaces.'
          * line: 3
            column: 3
            rule: \indent
            level: \error
            message: 'Indent should be 2 spaces.' ]
    describe 'shouled be tab' (...) ->
      it 'tab' ->
        expect(lint '->\n\t->\n\t\t->\n', rules: rules-tab).to.eql []
      it '1 space' ->
        expect(lint '->\n ->\n  ->\n', rules: rules-tab).to.eql [
          * line: 2
            column: 2
            rule: \indent
            level: \error
            message: 'Indent should be tab.'
          * line: 3
            column: 3
            rule: \indent
            level: \error
            message: 'Indent should be tab.' ]
