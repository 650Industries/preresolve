#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'

resolve = require 'resolve'
File = require 'vinyl'

preresolve = (file) ->
  """Takes a vinyl-like JS file object and transforms all the `require` statements
    in it into ones that have already been `require.resolve`d. This should make
    starting up faster."""

  basedir = path.resolve path.dirname infile
  infile = file.path
  input = file.contents.toString 'utf-8'

  output = input.replace /^([^"]*\b)require\(([^\)]*)\)/g, (_fullMatch, before, toRequireExpr) ->
    toRequire = eval(toRequireExpr)
    if resolve.isCore toRequire
      "#{ before }require(#{ JSON.stringify toRequire })"
    else
      resolved = resolve.sync toRequire, { basedir: basedir }
      #console.error "INFO: #{ toRequireExpr } -> #{ resolved }"
      "#{ before }require(#{ JSON.stringify ("./" + (path.relative basedir, resolved)) })"

  new Buffer output, 'utf-8'

if require.main is module
  optimist = require 'optimist'
  infile = optimist.argv._[0]

  console.log (preresolve new File {
    cwd: process.cwd()
    base: path.dirname infile
    path: infile
    contents: fs.readFileSync infile
  }).toString 'utf-8'

module.exports = preresolve
