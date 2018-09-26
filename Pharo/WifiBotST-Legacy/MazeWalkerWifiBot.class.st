Class {
	#name : #MazeWalkerWifiBot,
	#superclass : #SimpleReactiveWifiBot,
	#instVars : [
		'state'
	],
	#category : #'WifiBotST-Legacy-BotExamples'
}

{ #category : #examples }
MazeWalkerWifiBot class >> example [
	"self example"

	| bot arena mission |
	bot := self morphic.
	arena := ArenaForMorphicWifiBot new.
	mission := WifiBotMission new.
	arena mission: mission.
	arena openInWorld.
	bot body openIn: arena.
	arena addMorph: RectangleMorph new.
	arena openInWorld.
	^ mission
]

{ #category : #stepping }
MazeWalkerWifiBot >> computeActuatorValues [
	"Move forward or avoid obstacles"

	self perform: state.
	self updateState
]

{ #category : #stepping }
MazeWalkerWifiBot >> forwardSpeedOnObstacle [ 
	^ 0
]

{ #category : #stepping }
MazeWalkerWifiBot >> goForwardAndAvoidObstacles [
	self body distanceToLeftObstacles < self minDistanceToIgnoreObstacles
		ifTrue: [^ self body forwardSpeed: self forwardSpeedOnObstacle rotationSpeed: self rotationSpeedOnLeftObstacle].
	self body distanceToRightObstacles < self minDistanceToIgnoreObstacles
		ifTrue: [^ self body forwardSpeed: self forwardSpeedOnObstacle rotationSpeed: self rotationSpeedOnRightObstacle].
	self body forwardSpeed: self forwardSpeed rotationSpeed: self rotationSpeed
	

]

{ #category : #stepping }
MazeWalkerWifiBot >> initialize [
	super initialize.
	state := self states first.
	self forwardSpeed: 30
]

{ #category : #stepping }
MazeWalkerWifiBot >> minDistanceToIgnoreObstacles [
	^ 30
]

{ #category : #stepping }
MazeWalkerWifiBot >> rotationSpeedOnLeftObstacle [
	^ 15
]

{ #category : #stepping }
MazeWalkerWifiBot >> rotationSpeedOnRightObstacle [
	^ self rotationSpeedOnLeftObstacle 
]

{ #category : #stepping }
MazeWalkerWifiBot >> states [
	^#(
				#goForwardAndAvoidObstacles
				#turnLeft
				#turnRightIfObstacle
			)
]

{ #category : #stepping }
MazeWalkerWifiBot >> turnLeft [
	self body forwardSpeed: 0 rotationSpeed: -90

]

{ #category : #stepping }
MazeWalkerWifiBot >> turnRightIfObstacle [
	(self body distanceToLeftObstacles < self minDistanceToIgnoreObstacles
		or: [self body distanceToRightObstacles < self minDistanceToIgnoreObstacles])
		ifTrue: [^ self body forwardSpeed: 0 rotationSpeed: 90].

]

{ #category : #stepping }
MazeWalkerWifiBot >> updateState [
	|  indexOfCurrentState indexOfNextState |
	indexOfCurrentState := self states indexOf: state.
	indexOfNextState := indexOfCurrentState + 1.
	indexOfNextState > self states size ifTrue: [indexOfNextState := 1].
	state := self states at: indexOfNextState
]
