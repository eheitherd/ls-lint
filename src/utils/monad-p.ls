#------------------------------------------------------------------------------
# Provides promise monad

require! 'prelude-ls': {map}

pure-p = return-p = Promise~resolve
fail-p = Promise~reject

fmap-p = (f, p) --> p.then f
bind-p = (p, f) --> p.then f
ap-p = (pf, p) --> pf.then (f) -> p.then f
kcom-p = (f, g) --> (x) -> (f x).then g

catch-p = (p, f) --> p.catch f

seq-p = Promise~all
map-m-p = (f, l) --> seq-p map f, l

monad-p =
  pure: pure-p
  return: return-p
  fail: fail-p
  fmap: fmap-p
  bind: bind-p
  catch: catch-p
  seq: seq-p
  map-m: map-m-p
  '<$>': fmap-p
  '>>=': bind-p
  '<*>': ap-p
  '>=>': kcom-p

promisize = (f, a) --> new Promise (d, c) -> f d, c, a

promisize-api = (f, a) --> new Promise (d, c) ->
  err, data <- f a
  unless err then d data else c err

export
  pure-p, return-p, fail-p
  fmap-p, bind-p, ap-p, kcom-p, catch-p, seq-p, map-m-p
  monad-p
  promisize, promisize-api
