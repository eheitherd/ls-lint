require! {
  chai: {expect}
  '../../lib/ls-lint': {lint}
}

rules-crlf =
  rules:
    end-of-line:
      level: \error
      value: \crlf

module.exports = (...) ->
  describe \eol (...) ->
    it 'LF <- LF' ->
      expect(lint 'a\nbb\nccc\n').to.eql []
    it 'LF <- CRLF' ->
      expect(lint 'a\r\nbb\nccc\r\n').to.eql [
        * line: 1
          rule: \end-of-line
          level: \error
          message: 'End of line should be LF.'
        * line: 3
          rule: \end-of-line
          level: \error
          message: 'End of line should be LF.' ]
    it 'CRLF <- CRLF' ->
      expect(lint 'a\r\nbb\r\nccc\r\n', rules-crlf).to.eql []
    it 'CRLF <- LF' ->
      expect(lint 'a\nbb\r\nccc\n', rules-crlf).to.eql [
        * line: 1
          rule: \end-of-line
          level: \error
          message: 'End of line should be CRLF.'
        * line: 3
          rule: \end-of-line
          level: \error
          message: 'End of line should be CRLF.' ]
    it 'no eol last' ->
      expect(lint 'a\nbb\nccc').to.eql [
        * line: 3
          rule: \eol-last
          level: \warning
          message: 'Last line needs single EOL.' ]
    it 'multiple eol last' ->
      expect(lint 'a\nbb\nccc\n\n').to.eql [
        * line: 4
          rule: \eol-last
          level: \warning
          message: 'Last line needs single EOL.' ]
