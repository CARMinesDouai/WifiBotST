Class {
	#name : #WifiBotJoystickMorphTest,
	#superclass : #TestCase,
	#instVars : [
		'joystick'
	],
	#category : #'WifiBotST-JoystickDrivenBot'
}

{ #category : #'setUp-tearDown' }
WifiBotJoystickMorphTest >> setUp [
	super setUp.
	joystick := WifiBotJoystickMorph new
]

{ #category : #running }
WifiBotJoystickMorphTest >> testAddRemoveDependents [
	|updateCounter|
	updateCounter := UpdateCounter new.
	joystick addDependent: updateCounter.
	self assert: joystick dependents size = 1.
	self assert: joystick dependents anyOne == updateCounter.
	self assert: updateCounter count = 0.
	3 timesRepeat: [joystick notifyDependents].
	self assert: updateCounter count = 3.
	joystick removeDependent: updateCounter.
	self assert: joystick dependents isEmpty.
	3 timesRepeat: [joystick notifyDependents].
	self assert: updateCounter count = 3.

]

{ #category : #running }
WifiBotJoystickMorphTest >> testDependents [
	| dependentsArray |
	self
		assert: (joystick class instVarNames includes: #dependents).
	dependentsArray := #().
	joystick instVarNamed: #dependents put: dependentsArray.
	self assert: joystick dependents == dependentsArray
]

{ #category : #running }
WifiBotJoystickMorphTest >> testLeftRightValues [
	| maxLeft maxRight handleMorph handleY |
	self assert: joystick upDown = 0.
	handleMorph := joystick handleMorph.
	handleY := handleMorph position y.
	maxLeft := joystick position x.
	handleMorph position: maxLeft @ handleY.
	self assert: joystick leftRight = -60.
	maxRight := maxLeft + joystick width - handleMorph width.
	handleMorph position: maxRight @ handleY.
	self assert: joystick leftRight = 60.
	handleMorph center: joystick center.
	self assert: joystick upDown = 0
]

{ #category : #running }
WifiBotJoystickMorphTest >> testUpDownValues [
	| maxUp maxDown handleMorph handleX |
	self assert: joystick upDown = 0.
	handleMorph := joystick handleMorph.
	handleX := handleMorph position x.
	maxUp := joystick position y.
	handleMorph position: handleX @ maxUp.
	self assert: joystick upDown = 120.
	maxDown := maxUp + joystick height- handleMorph height.
	handleMorph position: handleX @ maxDown.
	self assert: joystick upDown = -120.
	handleMorph center: joystick center.
	self assert: joystick upDown = 0
]
