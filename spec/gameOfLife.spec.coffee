sinon = require 'sinon'
should = require 'should'
alive = require '../gameOfLife'

describe "Conway's Game of Life", ->
	game = {}

	describe "when first created", ->
		beforeEach ->
			game = new alive.Game

		it "should have no cells", ->
			game.should.have.property('cells').with.length 0
