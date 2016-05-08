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

module.exports = (...) ->
  describe 'arrow' (...) ->
    it 'b:true a:true <= (a) -> 1' ->
      expect(lint '(a) -> 1\n').to.eql []
    it 'b:true a:true <= (a) ->1' ->
      expect(lint '(a) ->1\n').to.eql [
        * line: 1
          column: 5
          rule: \arrow-spacing
          level: \warning
          message: 'A space is necessary after an arrow.'
        ]
    it 'b:true a:true <= (a)-> 1' ->
      expect(lint '(a)-> 1\n').to.eql [
        * line: 1
          column: 4
          rule: \arrow-spacing
          level: \warning
          message: 'A space is necessary before an arrow.'
        ]
    it 'b:true a:true <= (a)->1' ->
      expect(lint '(a)->1\n').to.eql [
        * line: 1
          column: 4
          rule: \arrow-spacing
          level: \warning
          message: 'Spaces is necessary around an arrow.'
        ]
    it 'b:true a:true <= (->)' ->
      expect(lint '(->)\n').to.eql []
    it 'b:true a:true <= (->1)' ->
      expect(lint '(->1)\n').to.eql [
        * line: 1
          column: 2
          rule: \arrow-spacing
          level: \warning
          message: 'A space is necessary after an arrow.'
        ]
    it 'b:true a:true <= [->]' ->
      expect(lint '[->]\n').to.eql []
    it 'b:true a:true <= {a: ->}' ->
      expect(lint '{a: ->}\n').to.eql []
    it 'b:false a:false <= (a)->1' ->
      expect(lint '(a)->1\n' test-rules).to.eql []
    it 'b:false a:false <= (a)->1' ->
      expect(lint '(a) ->1\n' test-rules).to.eql [
        * line: 1
          column: 5
          rule: \arrow-spacing
          level: \warning
          message: 'No space is necessary before an arrow.'
        ]
    it 'b:false a:false <= (a)-> 1' ->
      expect(lint '(a)-> 1\n' test-rules).to.eql [
        * line: 1
          column: 4
          rule: \arrow-spacing
          level: \warning
          message: 'No space is necessary after an arrow.'
        ]
    it 'b:false a:false <= (a) -> 1' ->
      expect(lint '(a) -> 1\n' test-rules).to.eql [
        * line: 1
          column: 5
          rule: \arrow-spacing
          level: \warning
          message: 'No spaces is necessary around an arrow.'
        ]
    it 'b:false a:false <= (->)' ->
      expect(lint '(->)\n' test-rules).to.eql []
    it 'b:false a:false <= (-> 1)' ->
      expect(lint '(-> 1)\n' test-rules).to.eql [
        * line: 1
          column: 2
          rule: \arrow-spacing
          level: \warning
          message: 'No space is necessary after an arrow.'
        ]
    it 'b:false a:false <= [->]' ->
      expect(lint '[->]\n' test-rules).to.eql []
    it 'b:false a:false <= {a: ->}' ->
      expect(lint '{a: ->}\n' test-rules).to.eql []
