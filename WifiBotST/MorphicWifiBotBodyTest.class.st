Class {
	#name : #MorphicWifiBotBodyTest,
	#superclass : #AbstractWifiBotBodyTest,
	#instVars : [
		'obstacle',
		'arena'
	],
	#category : #'WifiBotST-Kernel-Test'
}

{ #category : #'setUp-tearDown' }
MorphicWifiBotBodyTest >> botBodyClass [
	^ MorphicWifiBotBody
]

{ #category : #accessing }
MorphicWifiBotBodyTest >> botMorph [
	^ botBody morph
]

{ #category : #'setUp-tearDown' }
MorphicWifiBotBodyTest >> openBotBodyInArena [
	botBody openIn: arena
]

{ #category : #'setUp-tearDown' }
MorphicWifiBotBodyTest >> setUp [
	super setUp.
	arena := RectangleMorph new.
	arena
		color: Color yellow;
		width: World width;
		height: World height.
	arena openInWorld.
	obstacle := RectangleMorph new.
	self openBotBodyInArena.
	arena addMorph: obstacle
]

{ #category : #'setUp-tearDown' }
MorphicWifiBotBodyTest >> tearDown [
	botBody delete.
	obstacle delete.
	arena delete
]

{ #category : #running }
MorphicWifiBotBodyTest >> testBatteryLevelDecrease [
	| firstBatteryLevel lastBatteryLevel |
	firstBatteryLevel := botBody batteryLevel.
	self assert: firstBatteryLevel = 255.
	botBody forwardSpeed: 0 rotationSpeed: 60.
	1000 timesRepeat: [botBody commitActuatorValues].
	lastBatteryLevel := botBody batteryLevel.
	self assert: lastBatteryLevel < firstBatteryLevel.
	self assert: (lastBatteryLevel closeTo: 245)
]

{ #category : #running }
MorphicWifiBotBodyTest >> testCenter [
	| expectedCenter |
	expectedCenter := 100 @ 100.
	botBody centerInArena: expectedCenter.
	self assert: botBody centerInArena = expectedCenter
]

{ #category : #running }
MorphicWifiBotBodyTest >> testDoNotMoveIfBatteryEmpty [
	| initialPosition |
	botBody batteryLevel: 0.
	initialPosition := 400 @ 400.
	botBody positionInArena: initialPosition.
	botBody forwardSpeed: 10 rotationSpeed: 0.
	10 timesRepeat: [botBody commitActuatorValues].
	self assert: botBody positionInArena = initialPosition
]

{ #category : #running }
MorphicWifiBotBodyTest >> testFarObstacleSensing [
	| botPosition distanceToObstacleTop |
	botPosition := 400 @ 400.
	botBody positionInArena: botPosition.
	obstacle width: self botMorph width.
	distanceToObstacleTop := 150 + obstacle height.
	obstacle position: botPosition - (0 @ distanceToObstacleTop).
	self assert: botBody distanceToLeftObstacles = 150.
	self assert: botBody distanceToRightObstacles = 150.
	obstacle position: obstacle position - (0 @ 1).
	self assert: botBody distanceToLeftObstacles = 150.
	self assert: botBody distanceToRightObstacles = 150
]

{ #category : #running }
MorphicWifiBotBodyTest >> testHorizontalObstacleSensing [
	| distanceToObstacle |
	obstacle width: self botMorph width;
		 height: self botMorph width.
	botBody positionInArena: 400 @ 400.
	botBody heading: 90.
	distanceToObstacle := 100.
	obstacle top: self botMorph boundsInWorld top.
	obstacle left: self botMorph boundsInWorld right + distanceToObstacle.
	self assert: botBody distanceToLeftObstacles = distanceToObstacle.
	self assert: botBody distanceToRightObstacles = distanceToObstacle.
	botBody heading: -90.
	obstacle right: self botMorph boundsInWorld left - distanceToObstacle.
	self assert: botBody distanceToLeftObstacles = distanceToObstacle.
	self assert: botBody distanceToRightObstacles = distanceToObstacle
]

{ #category : #running }
MorphicWifiBotBodyTest >> testLeftObstacleSensing [
	| botPosition obstacleInitialPosition |
	botPosition := 400 @ 400.
	botBody positionInArena: botPosition.
	self assert: botBody distanceToLeftObstacles = 150.
	self assert: botBody distanceToRightObstacles = 150.
	obstacle width: self botMorph width / 4.
	obstacleInitialPosition := botPosition - (0 @ obstacle height).
	10
		to: 150
		by: 10
		do: [:deltaY | 
			obstacle position: obstacleInitialPosition - (0 @ deltaY).
			self assert: botBody distanceToLeftObstacles = deltaY.
			self assert: botBody distanceToRightObstacles = 150]
]

{ #category : #running }
MorphicWifiBotBodyTest >> testMaxWheelSpeedForMaxForwardSpeed [
	| expectedWheelSpeed |
	botBody forwardSpeed: botBody maxForwardSpeed rotationSpeed: 0.
	expectedWheelSpeed := botBody maxWheelSpeed.
	self
		assert: (botBody wheelSpeeds
				allSatisfy: [:speed | speed = expectedWheelSpeed])
]

{ #category : #running }
MorphicWifiBotBodyTest >> testMoveForward [
	| currentPosition |
	botBody forwardSpeed: 100 rotationSpeed: 0.
	currentPosition := 200.0 @ 200.0.
	botBody positionInArena: currentPosition.
	10
		timesRepeat: [botBody commitActuatorValues.
			"By default the bot moves towards the top"
			currentPosition := currentPosition - (0 @ 20).
			Processor yield.
			self assert: botBody positionInArena = currentPosition]
]

{ #category : #running }
MorphicWifiBotBodyTest >> testMoveWhileTurningAt: rotationSpeed [ 
	| originPosition currentHeading |
	botBody forwardSpeed: 50 rotationSpeed: rotationSpeed * 5. "botBody morph speedRatio."
	originPosition := 100 @ 100.
	botBody positionInArena: originPosition.
	currentHeading := 0 asFloat.
	40
		timesRepeat: [botBody commitActuatorValues.
			currentHeading := currentHeading + rotationSpeed.
			self assert: (botBody heading - currentHeading) abs < (1 / 10)].
	self assert: (botBody positionInArena x - originPosition x) abs <= 2.
	self assert: (botBody positionInArena y - originPosition y) abs <= 2
]

{ #category : #running }
MorphicWifiBotBodyTest >> testNearObstacleSensing [
	| botPosition |
	botPosition := 400 @ 400.
	botBody positionInArena: botPosition.
	obstacle width: self botMorph width.
	obstacle position: botPosition - (0 @ obstacle height).
	self assert: botBody distanceToLeftObstacles = 0.
	self assert: botBody distanceToRightObstacles = 0.
	obstacle position: botPosition.
	self assert: botBody distanceToLeftObstacles = 150.
	self assert: botBody distanceToRightObstacles = 150
]

{ #category : #running }
MorphicWifiBotBodyTest >> testPositionSensing [
	| originPosition expectedRelativePositions theoriticalRelativePositions |
	originPosition := 400 @ 400.
	botBody positionInArena: originPosition.
	self assert: botBody currentPositionRelativeToOrigin = (0 @ 0).
	theoriticalRelativePositions := {-50 @ 0. -50 @ 50. 0 @ 50. 0 @ 0}.
	expectedRelativePositions := theoriticalRelativePositions
				collect: [:position | 
					botBody forwardSpeed: 0 rotationSpeed: -450.
					"A rotation speed of value -450 leads to changing the
					heading by -90"
					botBody commitActuatorValues.
					position + botBody positionInArena - originPosition].
	self assert: botBody currentPositionRelativeToOrigin = (0 @ 0).
	expectedRelativePositions
		do: [:position | 
			botBody forwardSpeed: 0 rotationSpeed: -450.
			botBody commitActuatorValues.
			"A forward speed of value 250 leads to move by 50"
			botBody forwardSpeed: 250 rotationSpeed: 0.
			botBody commitActuatorValues.
			self assert: botBody currentPositionRelativeToOrigin = position]
]

{ #category : #running }
MorphicWifiBotBodyTest >> testRightObstacleSensing [
	| obstacleInitialBottom botBoundsInWorld |
	botBody positionInArena: 400 @ 400.
	self assert: botBody distanceToLeftObstacles = 150.
	self assert: botBody distanceToRightObstacles = 150.
	obstacle width: self botMorph width / 2.
	botBoundsInWorld := self botMorph boundsInWorld.
	obstacle right: botBoundsInWorld right.
	obstacle bottom: botBoundsInWorld top.
	obstacleInitialBottom := obstacle bottom.
	10
		to: 150
		by: 10
		do: [:deltaY | 
			obstacle bottom: obstacleInitialBottom - deltaY.
			self assert: botBody distanceToLeftObstacles = 150.
			self assert: botBody distanceToRightObstacles = deltaY]
]

{ #category : #running }
MorphicWifiBotBodyTest >> testTurnOnItself [
	| originCenter |
	botBody forwardSpeed: 0 rotationSpeed: 10.
	botBody positionInArena: 100 @ 100.
	originCenter := botBody centerInArena.
	40 timesRepeat: 
			[botBody commitActuatorValues.
			self assert: (botBody centerInArena x - originCenter x) abs <= 2.
			self assert: (botBody centerInArena y - originCenter y) abs <= 2]
]

{ #category : #running }
MorphicWifiBotBodyTest >> testTurnToLeft [
	self testMoveWhileTurningAt: -90
]

{ #category : #running }
MorphicWifiBotBodyTest >> testTurnToRight [
	self testMoveWhileTurningAt: 90
]

{ #category : #running }
MorphicWifiBotBodyTest >> testVerticallObstacleSensing [
	| distanceToObstacle |
	obstacle width: self botMorph width;
		 height: self botMorph width.
	botBody positionInArena: 400 @ 400.
	distanceToObstacle := 100.
	botBody heading: 0.
	obstacle bottom: self botMorph boundsInWorld top - distanceToObstacle.
	obstacle left: self botMorph boundsInWorld left.
	self assert: botBody distanceToLeftObstacles = distanceToObstacle.
	self assert: botBody distanceToRightObstacles = distanceToObstacle.
	botBody heading: 180.
	obstacle top: self botMorph boundsInWorld bottom + distanceToObstacle.
	self assert: botBody distanceToLeftObstacles = distanceToObstacle.
	self assert: botBody distanceToRightObstacles = distanceToObstacle
]

{ #category : #running }
MorphicWifiBotBodyTest >> testWheelSpeedsEqualOnForwardMove [
	| expectedWheelSpeed |
	botBody forwardSpeed: 10 rotationSpeed: 0.
	expectedWheelSpeed := botBody wheelSpeeds anyOne.
	self assert: (botBody wheelSpeeds 
				allSatisfy: [:speed | speed = expectedWheelSpeed])
]
