require! 'prelude-ls': {each}

<[
  test-common
  test-indent
  test-max-line-length
  test-eol
  test-identifier

  test-cli
  test-lint-me
]>
|> each -> (require "./#{it}")!
