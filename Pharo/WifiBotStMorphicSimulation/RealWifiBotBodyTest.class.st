Class {
	#name : #RealWifiBotBodyTest,
	#superclass : #AbstractWifiBotBodyTest,
	#category : #'WifiBotStMorphicSimulation-Kernel-Test'
}

{ #category : #running }
RealWifiBotBodyTest >> assertLeftSpeed: leftSpeed rightSpeed: rightSpeed [ 
	self assert: botBody leftMotorSpeed = leftSpeed.
	self assert: botBody rightMotorSpeed = rightSpeed
]

{ #category : #'setUp-tearDown' }
RealWifiBotBodyTest >> botBodyClass [
	^ RealWifiBotBody
]

{ #category : #running }
RealWifiBotBodyTest >> tearDown [
			
]

{ #category : #running }
RealWifiBotBodyTest >> testForwardSpeed: providedSpeed leadsToMotorsSpeed: expectedSpeed andValue: expectedValue [ 
	botBody forwardSpeed: providedSpeed rotationSpeed: 0.
	self assertLeftSpeed: expectedSpeed rightSpeed: expectedSpeed.
	self assert: (botBody motorValues at: 1) = expectedValue.
	self assert: (botBody motorValues at: 2) = expectedValue
]

{ #category : #running }
RealWifiBotBodyTest >> testMaxBackward [
	self
		testForwardSpeed: -100
		leadsToMotorsSpeed: -40
		andValue: 168
]

{ #category : #running }
RealWifiBotBodyTest >> testMaxForward [
	self
		testForwardSpeed: 100
		leadsToMotorsSpeed: 40
		andValue: 232
]

{ #category : #running }
RealWifiBotBodyTest >> testMinBackward [
	self
		testForwardSpeed: -1
		leadsToMotorsSpeed: -1
		andValue: 129
]

{ #category : #running }
RealWifiBotBodyTest >> testMinForward [
	self
		testForwardSpeed: botBody minAbsoluteSpeed 
		leadsToMotorsSpeed: botBody minAbsoluteSpeed
		andValue: botBody minMotorForwardValue
]

{ #category : #running }
RealWifiBotBodyTest >> testMoveBackward [
	self
		testForwardSpeed: -30
		leadsToMotorsSpeed: -30
		andValue: 158
]

{ #category : #running }
RealWifiBotBodyTest >> testMoveForward [
	self
		testForwardSpeed: 30
		leadsToMotorsSpeed: 30
		andValue: 222
]

{ #category : #running }
RealWifiBotBodyTest >> testMoveWhileTurningAt: rotationSpeed [ 
	botBody forwardSpeed: 10 rotationSpeed: rotationSpeed.
	self assert: botBody leftMotorSpeed = (10 - rotationSpeed).
	self assert: botBody rightMotorSpeed = (10 + rotationSpeed)
]

{ #category : #running }
RealWifiBotBodyTest >> testTurnOnItself [
	| rotationSpeed |
	rotationSpeed := botBody minAbsoluteSpeed.
	botBody forwardSpeed: 0 rotationSpeed: rotationSpeed.
	self assert: botBody leftMotorSpeed = rotationSpeed.
	self assert: botBody rightMotorSpeed = rotationSpeed negated
]

{ #category : #tests }
RealWifiBotBodyTest >> testTurnToLeft [
	botBody forwardSpeed: 10 rotationSpeed: -90.
	self assertLeftSpeed: -40 rightSpeed: 40
]

{ #category : #tests }
RealWifiBotBodyTest >> testTurnToRight [
	botBody forwardSpeed: 10 rotationSpeed: 90.
	self assertLeftSpeed: 40 rightSpeed: -40
]
