abbrev =
  nicolas: 'nico'
  christophe: 'chris'
  'jean-baptiste': 'J.B.'
  'jean-christophe': 'J.C.'
  baptiste: 'bapt'
  hadrien: 'hadri'
  'clément': 'clem'
  christopher: 'chris'

module.exports = (name) ->
  if name?
    return abbrev[name.toLowerCase().trim()] || name
