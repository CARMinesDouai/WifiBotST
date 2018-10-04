"
A MorphicWifiBotBody is a morphic (graphic) based simulation of the WifiBot.

Instance Variables
	forwardSpeed:		<Integer>
	morph:		<WifiBotMorph>
	rotationSpeed:		<Integer>

forwardSpeed
	- speed at which the wifibot moves forward. Negative values are for backward moves.

morph
	- morph materializing the bot on the display screen

rotationSpeed
	- speed at which the wifibot turns on it self. Positive values are for turning to the right. Negative onces are for turning to the left

"
Class {
	#name : #MorphicWifiBotBody,
	#superclass : #WifiBotBody,
	#instVars : [
		'morph',
		'forwardSpeed',
		'rotationSpeed',
		'batteryLevel',
		'originPositionInWorld',
		'rotationOnly',
		'lastCenter'
	],
	#classVars : [
		'DefaultScaleFactor'
	],
	#category : #'WifiBotStMorphicSimulation-Kernel'
}

{ #category : #running }
MorphicWifiBotBody >> basicAct [
	self morph forwardSpeed: self forwardSpeed
		rotationSpeed: self rotationSpeed.
	self decreaseBatteryLevel
]

{ #category : #accessing }
MorphicWifiBotBody >> basicBatteryLevel [
	^batteryLevel
]

{ #category : #running }
MorphicWifiBotBody >> batteryConsumptionDelta [
	^ 0.01
]

{ #category : #sensing }
MorphicWifiBotBody >> batteryLevel [
	^ batteryLevel integerPart 
]

{ #category : #accessing }
MorphicWifiBotBody >> batteryLevel: aNumber [ 
	batteryLevel := aNumber asFloat
]

{ #category : #morphic }
MorphicWifiBotBody >> bounds [
	^self morph bounds
]

{ #category : #morphic }
MorphicWifiBotBody >> centerInArena [
	self rotationOnly ifFalse: [
		self updateLastCenter 
	].
	^ self lastCenter 
]

{ #category : #morphic }
MorphicWifiBotBody >> centerInArena: aPoint [ 
	self morph centerInArena: aPoint.
	self updateLastCenter
	
]

{ #category : #running }
MorphicWifiBotBody >> commitActuatorValues [
	self basicBatteryLevel <= 0 ifTrue: [^ self].
	self basicAct
]

{ #category : #sensing }
MorphicWifiBotBody >> currentPositionRelativeToOrigin [
	^ self positionInArena - self originPositionInWorld
]

{ #category : #running }
MorphicWifiBotBody >> decreaseBatteryLevel [
	(self forwardSpeed = 0
			and: [self rotationSpeed = 0])
		ifTrue: [^ self].
	self batteryLevel: self basicBatteryLevel - self batteryConsumptionDelta.

]

{ #category : #morphic }
MorphicWifiBotBody >> delete [
	self morph delete
]

{ #category : #sensing }
MorphicWifiBotBody >> distanceToLeftObstacles [
	^ self morph leftObstacleSensor minDistanceToObstacle 
]

{ #category : #sensing }
MorphicWifiBotBody >> distanceToRightObstacles [
	^ self morph rightObstacleSensor minDistanceToObstacle
]

{ #category : #moving }
MorphicWifiBotBody >> forwardSpeed [
	^forwardSpeed
]

{ #category : #moving }
MorphicWifiBotBody >> forwardSpeed: newSpeed [ 
	forwardSpeed := newSpeed
]

{ #category : #moving }
MorphicWifiBotBody >> forwardSpeed: speed rotationSpeed: angleInDegrees [ 
	rotationOnly := (speed = 0).
	self forwardSpeed: speed.
	self rotationSpeed: angleInDegrees
]

{ #category : #sensing }
MorphicWifiBotBody >> frontLeftWheelSpeed [
	| speedRatio |
	speedRatio := (self forwardSpeed + self rotationSpeed) abs / self maxForwardSpeed.
	^ (self maxWheelSpeed * speedRatio) integerPart 
]

{ #category : #sensing }
MorphicWifiBotBody >> frontRightWheelSpeed [
	| speedRatio |
	speedRatio := (self forwardSpeed - self rotationSpeed) abs / self maxForwardSpeed.
	^ (self maxWheelSpeed * speedRatio) integerPart
]

{ #category : #morphic }
MorphicWifiBotBody >> heading [
	^self morph heading
]

{ #category : #morphic }
MorphicWifiBotBody >> heading: value [
	self morph heading: value
]

{ #category : #morphic }
MorphicWifiBotBody >> hideSensors [
	self morph hideSensors
]

{ #category : #'initialize-release' }
MorphicWifiBotBody >> initialBatteryLevel [
	^ 255
]

{ #category : #'initialize-release' }
MorphicWifiBotBody >> initialize [
	self morph: WifiBotMorph new.
	self morph botBody: self.
	self batteryLevel: self initialBatteryLevel.
	self originPositionInWorld: 0@0.
	super initialize
]

{ #category : #private }
MorphicWifiBotBody >> lastCenter [
	^ lastCenter ifNil: [ lastCenter := self morph centerInArena]
]

{ #category : #private }
MorphicWifiBotBody >> lastCenter: c [
	lastCenter := c
]

{ #category : #accessing }
MorphicWifiBotBody >> leftObstacleSensor [
	^self morph leftObstacleSensor 
]

{ #category : #accessing }
MorphicWifiBotBody >> morph [
	^ morph
]

{ #category : #accessing }
MorphicWifiBotBody >> morph: anObject [
	morph := anObject
]

{ #category : #morphic }
MorphicWifiBotBody >> openIn: aMorph [
	self morph openIn: aMorph
]

{ #category : #morphic }
MorphicWifiBotBody >> openInHand [
	self openInWorld.
	self morph openInHand
]

{ #category : #morphic }
MorphicWifiBotBody >> openInWorld [
	self morph openInWorld
]

{ #category : #accessing }
MorphicWifiBotBody >> originPositionInWorld [
	^originPositionInWorld
]

{ #category : #accessing }
MorphicWifiBotBody >> originPositionInWorld: anObject [
	originPositionInWorld := anObject
]

{ #category : #morphic }
MorphicWifiBotBody >> positionInArena [
	^ self morph positionInArena
]

{ #category : #morphic }
MorphicWifiBotBody >> positionInArena: aPoint [ 
	self originPositionInWorld: aPoint.
	self morph positionInArena: aPoint.
	self updateLastCenter
]

{ #category : #sensing }
MorphicWifiBotBody >> rearLeftWheelSpeed [
	^ self frontLeftWheelSpeed
]

{ #category : #sensing }
MorphicWifiBotBody >> rearRightWheelSpeed [
	^self frontRightWheelSpeed
]

{ #category : #accessing }
MorphicWifiBotBody >> rightObstacleSensor [
	^ self morph rightObstacleSensor
]

{ #category : #accessing }
MorphicWifiBotBody >> rotationOnly [
	^ rotationOnly ifNil: [ rotationOnly := false]
]

{ #category : #moving }
MorphicWifiBotBody >> rotationSpeed [
	^ rotationSpeed
]

{ #category : #moving }
MorphicWifiBotBody >> rotationSpeed: newSpeed [ 
	rotationSpeed := newSpeed
]

{ #category : #morphic }
MorphicWifiBotBody >> scaleWithFactor: aFloat [
	self morph owner scale: aFloat
]

{ #category : #morphic }
MorphicWifiBotBody >> showSensors [
	self morph showSensors
]

{ #category : #morphic }
MorphicWifiBotBody >> toggleSensors [
	self morph toggleSensors
]

{ #category : #morphic }
MorphicWifiBotBody >> toggleShowDelete [
	self morph toggleShowDelete 
]

{ #category : #private }
MorphicWifiBotBody >> updateLastCenter [
	self lastCenter: self morph owner center.
	rotationOnly := true
]

{ #category : #running }
MorphicWifiBotBody >> updateSensorValues [
	^ self
]
