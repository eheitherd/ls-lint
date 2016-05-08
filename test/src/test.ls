require! 'prelude-ls': {each}

<[
  test-common
  test-indent
  test-max-line-length
  test-max-file-lines
  test-eol
  test-spacing
  test-no-variables
  test-identifier
  test-cli
  test-lint-me
]>
|> each -> (require "./#{it}")!
