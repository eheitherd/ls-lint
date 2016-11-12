#------------------------------------------------------------------------------
# Lints required files.

require! {
  'glob-all'
  fs
  './utils/monad-p': {monad-p:p, promisize-api}
  './ls-lint'
}

# Lints required files.
#   [String] -> a -> Promise
module.exports = (paths, opts) ->
  read-file = promisize-api fs~read-file _, \utf8, _
  ls-lint-p = p.return . ls-lint.lint _, opts
  lint-file = read-file `p.'>=>'` ls-lint-p
  lint-result = (f) -> (lint-file f) `p.'>>='` -> p.return {file:f, results:it}

  async-glob = promisize-api glob-all
  lint-files = p.map-m lint-result

  paths |> (async-glob `p.'>=>'` lint-files)
