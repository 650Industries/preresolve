#!/usr/bin/env coffee

fs = require 'fs'
path = require 'path'

resolve = require 'resolve'
File = require 'vinyl'

preresolve = (file) ->
  """Takes a vinyl-like JS file object and transforms all the `require` statements
    in it into ones that have already been `require.resolve`d. This should make
    starting up faster."""

  basedir = path.resolve path.dirname file.path
  input = file.contents.toString 'utf-8'

  #output = input.replace /^([^"']*)\brequire\(([^\)]*)\)/g, (_fullMatch, before, toRequireExpr) ->
  output = input.replace /\brequire\(([^\)]*)\)/g, (fullMatch, toRequireExpr) ->
    try
      toRequire = eval(toRequireExpr)
      if resolve.isCore toRequire
        "require(#{ JSON.stringify toRequire })"
      else
        resolved = resolve.sync toRequire, { basedir: basedir }
        #console.error "INFO: #{ toRequireExpr } -> #{ resolved }"
        "require(#{ JSON.stringify ("./" + (path.relative basedir, resolved)) })"
    catch e
      console.error "#{ e.toString() }: Could not figure out what to do with `#{ toRequireExpr }`"
      fullMatch

  file.contents = new Buffer output, 'utf-8'
  file

preresolveFileWithName = (infile) ->
  pf = preresolve new File {
      cwd: process.cwd()
      base: path.dirname infile
      path: infile
      contents: fs.readFileSync infile
    }

  pf.contents.toString 'utf-8'

if require.main is module
  optimist = require 'optimist'

  for infile in optimist.argv._
    console.log preresolveFileWithName infile

preresolve.preresolveFileWithName = preresolveFileWithName

module.exports = preresolve


