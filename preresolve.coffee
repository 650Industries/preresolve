#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'

resolve = require 'resolve'

preresolve = (infile) ->
  """Takes a file path to a JS file and transforms all the `require` statements
    in it into ones that have already been `require.resolve`d. This should make
    starting up faster."""

  basedir = path.resolve path.dirname infile
  input = fs.readFileSync infile, 'utf-8'

  output = input.replace /(^[^"'].*\b)require\(([^\)]*)\)/g, (_fullMatch, before, toRequireExpr) ->
    console.log require('util').inspect(arguments)
    console.log "toRequireExpr=#{ toRequireExpr }"
    toRequire = eval(toRequireExpr)
    if resolve.isCore toRequire
      "#{ before }require(#{ JSON.stringify toRequire })"
    else
      resolved = resolve.sync toRequire, { basedir: basedir }
      "#{ before }require(#{ JSON.stringify ("./" + (path.relative basedir, resolved)) })"
  output

if require.main is module
  optimist = require 'optimist'
  console.log preresolve optimist.argv._[0]

module.exports = preresolve
