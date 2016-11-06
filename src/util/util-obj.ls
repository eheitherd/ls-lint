#------------------------------------------------------------------------------
# Provides functions for Object.

require! {
  'prelude-ls': {Obj, is-type, empty, compact, fold, keys}
}

export deep-merge = (a, ...bs) ->
  | empty compact bs  => a
  | otherwise         => merge-obj a, deep-merge ...bs

merge-obj = (a, b) ->
  (keys a) ++ (keys b)
  |> fold (merge-property b), a

merge-property = (src) ->
  (obj, key) -->
    a = obj[key]
    b = src[key]
    if b?
      if a? and is-object a and is-object b
        obj with {"#{key}": merge-obj a, b}
      else
        obj with {"#{key}": b}
    else
      obj

is-object = is-type 'Object'
