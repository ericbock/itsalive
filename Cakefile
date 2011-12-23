{ spawn } = require 'child_process'
{ print } = require 'util'
{ platform } = require 'os'

extify = (command) ->
	isWindows = (platform().indexOf 'win') is 0
	ext = if isWindows then '.cmd' else ''
	"#{command}#{ext}"

# thanks sstephenson
build = (watch, callback) ->
	command = extify 'coffee'
	if typeof watch is 'function'
		callback = watch
		watch = false
	args = ['-c', '-o', 'lib/', 'src/']
	args.unshift '-w' if watch

	coffee = spawn command, args
	coffee.stdout.on 'data', (data) -> print data.toString()
	coffee.stderr.on 'data', (data) -> print data.toString()
	coffee.on 'exit', (status) -> callback?() if status is 0

task 'build', 'compile CoffeeScript source files', ->
	build()

task 'test', 'test against the specs', ->
	command = extify 'jasmine-node'
	args = ['--coffee', 'spec/']
	jasmine = spawn command, args
	jasmine.stdout.on 'data', (data) -> print data.toString()
	jasmine.stderr.on 'data', (data) -> print data.toString()
