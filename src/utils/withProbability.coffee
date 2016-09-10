module.exports = (proba, fn) ->
  if proba < 0 || proba > 1
    throw new Error("invalid probability")

  if Math.random() < proba
    fn()
