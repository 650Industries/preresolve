#!/usr/bin/env node
(function() {
  var File, fs, infile, optimist, path, preresolve, preresolveFileWithName, resolve, _i, _len, _ref;

  fs = require('fs');

  path = require('path');

  resolve = require('resolve');

  File = require('vinyl');

  preresolve = function(file) {
    "Takes a vinyl-like JS file object and transforms all the `require` statements\nin it into ones that have already been `require.resolve`d. This should make\nstarting up faster.";
    var basedir, input, output;
    basedir = path.resolve(path.dirname(file.path));
    input = file.contents.toString('utf-8');
    output = input.replace(/\brequire\(([^\)]*)\)/g, function(fullMatch, toRequireExpr) {
      var e, resolved, toRequire;
      try {
        toRequire = eval(toRequireExpr);
        if (resolve.isCore(toRequire)) {
          return "require(" + (JSON.stringify(toRequire)) + ")";
        } else {
          resolved = resolve.sync(toRequire, {
            basedir: basedir
          });
          return "require(" + (JSON.stringify("./" + (path.relative(basedir, resolved)))) + ")";
        }
      } catch (_error) {
        e = _error;
        console.error("" + (e.toString()) + ": Could not figure out what to do with `" + toRequireExpr + "`");
        return fullMatch;
      }
    });
    file.contents = new Buffer(output, 'utf-8');
    return file;
  };

  preresolveFileWithName = function(infile) {
    var pf;
    pf = preresolve(new File({
      cwd: process.cwd(),
      base: path.dirname(infile),
      path: infile,
      contents: fs.readFileSync(infile)
    }));
    return pf.contents.toString('utf-8');
  };

  if (require.main === module) {
    optimist = require('optimist');
    _ref = optimist.argv._;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      infile = _ref[_i];
      console.log(preresolveFileWithName(infile));
    }
  }

  preresolve.preresolveFileWithName = preresolveFileWithName;

  module.exports = preresolve;

}).call(this);
