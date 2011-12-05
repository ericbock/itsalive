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

describe "Cell", ->
	cell = {}

	beforeEach ->
		cell = new alive.Cell 1, 2

	it "should expose its coordinates", ->
		cell.should.have.property 'X', 1
		cell.should.have.property 'Y', 2

	it "should start out alive", ->
		cell.isAlive.should.be.true
	
	it "should die on die", ->
		cell.die()
		cell.isAlive.should.be.false

	it "should live on live", ->
		cell.die()
		cell.live()
		cell.isAlive.should.be.true
	
	describe "when alive", ->

		beforeEach ->
			cell.live()

		describe "with fewer than two neighbors", ->
			it "is doomed to die", ->
				cell.isDoomed(i).should.be.true for i in [0...2]
