"
WifiBotBody is the abstract class for WifiBot body.

"
Class {
	#name : #WifiBotBody,
	#superclass : #Object,
	#instVars : [
		'bot'
	],
	#category : #'WifiBotST-Kernel'
}

{ #category : #sensing }
WifiBotBody >> batteryLevel [
	self subclassResponsibility
]

{ #category : #accessing }
WifiBotBody >> bot [
	^bot
]

{ #category : #accessing }
WifiBotBody >> bot: anObject [
	bot := anObject
]

{ #category : #running }
WifiBotBody >> commitActuatorValues [
	self subclassResponsibility
]

{ #category : #sensing }
WifiBotBody >> currentPositionRelativeToOrigin [
	self subclassResponsibility
]

{ #category : #'initialize-release' }
WifiBotBody >> defaultForwardSpeed [
	^ 0
]

{ #category : #'initialize-release' }
WifiBotBody >> defaultRotationSpeed [
	^ 0
]

{ #category : #sensing }
WifiBotBody >> distanceToLeftObstacles [
	self subclassResponsibility
]

{ #category : #sensing }
WifiBotBody >> distanceToRightObstacles [
	self subclassResponsibility
]

{ #category : #moving }
WifiBotBody >> forwardSpeed: forwardSpeed rotationSpeed: rotationSpeed [
	self subclassResponsibility 
]

{ #category : #sensing }
WifiBotBody >> frontLeftWheelSpeed [
	self subclassResponsibility 
]

{ #category : #sensing }
WifiBotBody >> frontRightWheelSpeed [
	self subclassResponsibility
]

{ #category : #'initialize-release' }
WifiBotBody >> initialize [
	super initialize.
	self forwardSpeed: self defaultForwardSpeed rotationSpeed: self defaultRotationSpeed
]

{ #category : #sensing }
WifiBotBody >> maxForwardSpeed [
	^ 60
]

{ #category : #sensing }
WifiBotBody >> maxWheelSpeed [
	^40
]

{ #category : #sensing }
WifiBotBody >> rearLeftWheelSpeed [
	self subclassResponsibility
]

{ #category : #sensing }
WifiBotBody >> rearRightWheelSpeed [
	self subclassResponsibility
]

{ #category : #running }
WifiBotBody >> updateSensorValues [
	self subclassResponsibility
]

{ #category : #sensing }
WifiBotBody >> wheelSpeeds [
	^{self frontLeftWheelSpeed. self rearLeftWheelSpeed. self frontRightWheelSpeed. self rearRightWheelSpeed}
]
