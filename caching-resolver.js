// Generated by CoffeeScript 1.7.1
(function() {
  var path, resolve, _CACHE;

  resolve = require('resolve');

  path = require('path');

  _CACHE = {};

  module.exports = function(fp, basedir) {
    if (basedir == null) {
      basedir = path.resolve(path.dirname(fp));
    }
    if (_CACHE[fp] == null) {
      _CACHE[fp] = path.relative(basedir, resolve.sync(fp, {
        basedir: basedir
      }));
    }
    return _CACHE[fp];
  };

  module.exports._CACHE = _CACHE;

}).call(this);