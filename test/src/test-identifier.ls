
module.exports = ->
  describe \identifier ->
    (require './identifier/test-identifier-class')!
    (require './identifier/test-identifier-property')!
    (require './identifier/test-identifier-function')!
    (require './identifier/test-identifier-variable')!
    (require './identifier/test-identifier-constant')!
