#------------------------------------------------------------------------------
# Provides promise monad

pure-p = return-p = Promise~resolve
fail-p = Promise~reject

fmap-p = (f, p) --> p.then f
bind-p = (p, f) --> p.then f
ap-p = (pf, p) --> pf.then (f) -> p.then f

catch-p = (p, f) --> p.catch f

monad-p =
  pure: pure-p
  return: return-p
  fmap: fmap-p
  bind: bind-p
  '<$>': fmap-p
  '>>=': bind-p
  '<*>': ap-p

promisize = (f, a) --> new Promise (d, c) -> f d, c, a

promisize-api = (f, a) --> new Promise (d, c) ->
  err, data <- f a
  unless err then d data else c err

export
  pure-p, return-p, fail-p
  fmap-p, bind-p, ap-p, catch-p
  monad-p,
  promisize, promisize-api
