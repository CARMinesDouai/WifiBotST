"
A WifiBotSimulation is a facility class to manage simple a graphical 2D simulation.

Instance Variables
	arena:		<ArenaWithLightBulbs>
	mission:		<WifiBotMission>
	robotInitialPositionsDict:		<Dictionary of Points>
	window:		<SystemWindow>

arena
	- Arena where bots bodies move and act

mission
	- It is the engine that drives the simulation

robotInitialPositionsDict
	- Dicationary of initial positions of robots in arena. Robots are put back to there initial positions on every reset.

window
	- SystemWindow which contains the arena.

"
Class {
	#name : #WifiBotSimulation,
	#superclass : #Object,
	#instVars : [
		'arena',
		'mission',
		'window',
		'robotInitialPositionsDict'
	],
	#category : #'WifiBotStMorphicSimulation-Kernel'
}

{ #category : #'initialize-release' }
WifiBotSimulation >> addLightBulbAt: aPoint color: aColor [
	^self arena addLightBulbAt: aPoint color: aColor 
]

{ #category : #'initialize-release' }
WifiBotSimulation >> addObstacleAt: aPoint width: width height:  height [
	^self arena addObstacleAt: aPoint width: width height:  height 
]

{ #category : #'initialize-release' }
WifiBotSimulation >> addRobot: bot atPosition: aPoint [
	self robotInitialPositionsDict at: bot put: aPoint.
	bot body openIn: self arena.
	bot body centerInArena: aPoint
]

{ #category : #'initialize-release' }
WifiBotSimulation >> addRobotInstanceOf: robotClass atPosition: aPoint [
	|bot|
	bot := robotClass morphic.
	self addRobot: bot atPosition: aPoint.
	^bot
]

{ #category : #accessing }
WifiBotSimulation >> arena [
	^ arena
]

{ #category : #accessing }
WifiBotSimulation >> arena: anObject [
	arena := anObject
]

{ #category : #'initialize-release' }
WifiBotSimulation >> arenaClass [
	^ArenaWithLightBulbs

]

{ #category : #displaying }
WifiBotSimulation >> deleteWindow [
	self window ifNil: [ ^ self ].
	(self window)
		makeClosable;
		delete
]

{ #category : #displaying }
WifiBotSimulation >> hide [
	self stop.
	self deleteWindow
]

{ #category : #'initialize-release' }
WifiBotSimulation >> initialize [
	super initialize.
	self robotInitialPositionsDict: IdentityDictionary new.
	self mission: self missionClass new.
	self arena: self arenaClass new.
	self arena mission: self mission.
	(self arena)
		close;
		width: 1000;
		height: 600.

]

{ #category : #accessing }
WifiBotSimulation >> mission [
	^ mission
]

{ #category : #accessing }
WifiBotSimulation >> mission: anObject [
	mission := anObject
]

{ #category : #'initialize-release' }
WifiBotSimulation >> missionClass [
	^WifiBotMission
]

{ #category : #'initialize-release' }
WifiBotSimulation >> moveRobotsToInitialPositions [
	self robotInitialPositionsDict keysAndValuesDo: [:robot :initialPosition|
		robot body centerInArena: initialPosition]
]

{ #category : #running }
WifiBotSimulation >> reset [
	self moveRobotsToInitialPositions
]

{ #category : #accessing }
WifiBotSimulation >> robotInitialPositionsDict [
	^ robotInitialPositionsDict
]

{ #category : #accessing }
WifiBotSimulation >> robotInitialPositionsDict: anObject [
	robotInitialPositionsDict := anObject
]

{ #category : #accessing }
WifiBotSimulation >> robots [
	^self robotInitialPositionsDict keys
]

{ #category : #displaying }
WifiBotSimulation >> show [
	self deleteWindow.
	self window: (self arena openInWindowLabeled: self windowLabel).
	self window position: self windowInitialPosition.
	(self window) makeUnclosable
]

{ #category : #running }
WifiBotSimulation >> start [
	(self mission) start
]

{ #category : #running }
WifiBotSimulation >> stop [
	(self mission) stop.

]

{ #category : #accessing }
WifiBotSimulation >> window [
	^ window
]

{ #category : #accessing }
WifiBotSimulation >> window: anObject [
	window := anObject
]

{ #category : #displaying }
WifiBotSimulation >> windowInitialPosition [
	^100 @ 100
]

{ #category : #displaying }
WifiBotSimulation >> windowLabel [
	^ self className
]
