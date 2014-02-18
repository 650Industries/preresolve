resolve = require 'resolve'
path = require 'path'

_CACHE = {}

module.exports = (fp, basedir) ->
  basedir ?= path.resolve path.dirname fp
  unless _CACHE[fp]?
    _CACHE[fp] = path.relative basedir, resolve.sync(fp, { basedir: basedir })
  _CACHE[fp]

module.exports._CACHE = _CACHE

