Class {
	#name : #WifiBotSimulationTest,
	#superclass : #TestCase,
	#instVars : [
		'sim'
	],
	#category : #'WifiBotStMorphicSimulation-Kernel-Test'
}

{ #category : #'setUp-tearDown' }
WifiBotSimulationTest >> setUp [ 
	super setUp.
	sim := WifiBotSimulation new
]

{ #category : #'setUp-tearDown' }
WifiBotSimulationTest >> tearDown [ 
	super tearDown.
	sim stop; hide
]

{ #category : #testing }
WifiBotSimulationTest >> testAdditionOfLightBulbs [ 
	| bulb |
	bulb := sim addLightBulbAt: 100@100 color: Color green.
	self deny: bulb isNil.
	self assertCollection: sim arena lightBulbs hasSameElements: {bulb}
	
]

{ #category : #testing }
WifiBotSimulationTest >> testAdditionOfRobotGivenAClass [
	| bot |
	bot :=  sim addRobotInstanceOf: ObstacleAvoiderWifiBot atPosition: 100@100.
	self deny: bot isNil.
	self assert: bot class == ObstacleAvoiderWifiBot.
	self assertCollection: sim mission bots hasSameElements: {bot}.
	self assert: (sim arena submorphs includes:  bot body morph owner).
	self assert: (sim robotInitialPositionsDict at: bot) equals: (100@100)
]

{ #category : #testing }
WifiBotSimulationTest >> testAdditionOfRobotGivenAnInstance [
	| bot |
	bot := ObstacleAvoiderWifiBot morphic.
	sim addRobot: bot atPosition: 100@100.
	self assertCollection: sim mission bots hasSameElements: {bot}.
	self assert: (sim arena submorphs includes:  bot body morph owner).
	self assert: (sim robotInitialPositionsDict at: bot ) equals: (100@100)	
]

{ #category : #testing }
WifiBotSimulationTest >> testResetMovesRobotsToTheirInitialPositions [
	| initialCenter bot |
	sim show.
	initialCenter := 300@300.
	bot := sim addRobotInstanceOf: ObstacleAvoiderWifiBot  atPosition: 300@300.
	bot forwardSpeed: 100.
	self assert: bot body morph centerInArena equals: initialCenter.
	sim start.
	(Delay forMilliseconds: 300) wait.
	sim stop.
	self deny: bot body morph centerInArena equals: initialCenter.
	sim window position: sim window position + 200.
	sim reset.
	self assert: bot body morph centerInArena equals: initialCenter.
	self assert: bot body morph heading equals: 0.
	

]

{ #category : #testing }
WifiBotSimulationTest >> testStartStop [
	self deny: sim mission isRunning.
	sim start.
	self assert: sim mission isRunning.
	sim stop.
	self deny: sim mission isRunning.

]
