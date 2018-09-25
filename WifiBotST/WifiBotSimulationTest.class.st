Class {
	#name : #WifiBotSimulationTest,
	#superclass : #TestCase,
	#instVars : [
		'scenario'
	],
	#category : #'WifiBotST-Kernel-Test'
}

{ #category : #'setUp-tearDown' }
WifiBotSimulationTest >> setUp [ 
	super setUp.
	scenario := WifiBotSimulation new
]

{ #category : #'setUp-tearDown' }
WifiBotSimulationTest >> tearDown [ 
	super tearDown.
	scenario stop; hide
]

{ #category : #testing }
WifiBotSimulationTest >> testAdditionOfLightBulbs [ 
	| bulb |
	bulb := scenario addLightBulbAt: 100@100 color: Color green.
	self deny: bulb isNil.
	self assert: scenario arena lightBulbs = {bulb} asSet
	
]

{ #category : #testing }
WifiBotSimulationTest >> testAdditionOfRobotGivenAClass [
	| bot |
	bot :=  scenario addRobotInstanceOf: ObstacleAvoiderWifiBot atPosition: 100@100.
	self deny: bot isNil.
	self assert: bot class == ObstacleAvoiderWifiBot.
	self assert: scenario mission bots = {bot} asSet.
	self assert: (scenario arena submorphs includes:  bot body morph owner).
	self assert: (scenario robotInitialPositionsDict at: bot ) = (100@100)
]

{ #category : #testing }
WifiBotSimulationTest >> testAdditionOfRobotGivenAnInstance [
	| bot |
	bot := ObstacleAvoiderWifiBot morphic.
	scenario addRobot: bot atPosition: 100@100.
	self assert: scenario mission bots = {bot} asSet.
	self assert: (scenario arena submorphs includes:  bot body morph owner).
	self assert: (scenario robotInitialPositionsDict at: bot ) = (100@100)	
]

{ #category : #testing }
WifiBotSimulationTest >> testResetMovesRobotsToTheirInitialPositions [
	| initialCenter bot |
	scenario show.
	bot := scenario addRobotInstanceOf: ObstacleAvoiderWifiBot  atPosition: 100@100.
	bot forwardSpeed: 100.
	initialCenter := bot body morph centerInArena.
	self assert: initialCenter = (100@100).
	scenario start.
	(Delay forMilliseconds: 300) wait.
	scenario stop.
	self deny: bot body morph centerInArena = initialCenter.
	scenario reset.
	self assert: bot body morph centerInArena = initialCenter.
	

]

{ #category : #testing }
WifiBotSimulationTest >> testStartStop [
	self deny: scenario mission isRunning.
	scenario start.
	self assert: scenario mission isRunning.
	scenario stop.
	self deny: scenario mission isRunning.

]
