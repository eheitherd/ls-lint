require! {
  chai: {expect}
  '../../../lib/ls-lint': {lint}
}

test-opts =
  config:
    brackets-spacing:
      level: \warning
      value: true

module.exports = (...) ->
  describe 'brackets' (...) ->
    it 'no need <= [1, 2]' ->
      expect(lint '[1, 2]\n').to.eql []
    it 'no need <= [ 1, 2]' ->
      expect(lint '[ 1, 2]\n').to.eql [
        * line: 1
          column: 3
          rule: \brackets-spacing
          level: \warning
          message: 'No space is necessary inside brackets.'
        ]
    it 'no need <= [1, 2 ]' ->
      expect(lint '[1, 2 ]\n').to.eql [
        * line: 1
          column: 7
          rule: \brackets-spacing
          level: \warning
          message: 'No space is necessary inside brackets.'
        ]
    it 'need <= [ 1, 2 ]' ->
      expect(lint '[ 1, 2 ]\n', test-opts).to.eql []
    it 'need <= [ 1, 2]' ->
      expect(lint '[ 1, 2]\n', test-opts).to.eql [
        * line: 1
          column: 7
          rule: \brackets-spacing
          level: \warning
          message: 'Spaces are necessary inside brackets.'
        ]
    it 'need <= [1, 2 ]' ->
      expect(lint '[1, 2 ]\n', test-opts).to.eql [
        * line: 1
          column: 2
          rule: \brackets-spacing
          level: \warning
          message: 'Spaces are necessary inside brackets.'
        ]
