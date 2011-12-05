sinon = require 'sinon'
should = require 'should'
alive = require '../gameOfLife'

describe "Conway's Game of Life", ->
	game = {}

	beforeEach ->
		game = new alive.Game

	describe "when first created", ->
		it "should have no cells", ->
			game.should.have.property('cells').with.length 0
	
	it "should add a cell to cells", ->
		cell = {0, 0}
		game.addCell(cell)
		game.cells.should.have.length 1
