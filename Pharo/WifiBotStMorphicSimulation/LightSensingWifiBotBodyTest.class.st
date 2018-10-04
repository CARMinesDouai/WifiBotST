Class {
	#name : #LightSensingWifiBotBodyTest,
	#superclass : #TestCase,
	#instVars : [
		'arena',
		'botBody',
		'mission'
	],
	#category : #'WifiBotStMorphicSimulation-LightSensing-Test'
}

{ #category : #'setUp-tearDown' }
LightSensingWifiBotBodyTest >> setUp [
	super setUp.
	mission := WifiBotMission new.
	arena := ArenaWithLightBulbs new.
	arena mission: mission.
	botBody := LightSensingMorphicWifiBotBody new.
	arena openInWorld.
	botBody bot: WifiBot new.
	botBody openIn: arena

]

{ #category : #'setUp-tearDown' }
LightSensingWifiBotBodyTest >> tearDown [ 
	super tearDown.
	mission stop.
	arena delete.
	botBody delete
]

{ #category : #testing }
LightSensingWifiBotBodyTest >> testSensingAfterBodyMovement [
	|leftLightSensor rightLightSensor firstLightIntensityReceivedByLeftSensor firstLightIntensityReceivedByRightSensor |
	arena addLightBulbAt: 200@200 color: Color red. 
	botBody centerInArena: 200@200.
	leftLightSensor := botBody leftLightSensor.
	rightLightSensor := botBody rightLightSensor.
	firstLightIntensityReceivedByLeftSensor := leftLightSensor  receivedLightIntensity.
	firstLightIntensityReceivedByRightSensor := rightLightSensor  receivedLightIntensity.
	botBody forwardSpeed:  400.
	botBody commitActuatorValues. 
	self assert: leftLightSensor  receivedLightIntensity > 0.
	self assert: leftLightSensor  receivedLightIntensity < firstLightIntensityReceivedByLeftSensor.
	self assert: rightLightSensor  receivedLightIntensity > 0.
	self assert: rightLightSensor  receivedLightIntensity < firstLightIntensityReceivedByRightSensor
	
]

{ #category : #testing }
LightSensingWifiBotBodyTest >> testSensingCloseLightSource [
	arena addLightBulbAt: 100@100 color: Color red. 
	botBody morph center: 100@100.
	self assert:   botBody leftLightSensor receivedLightIntensity > 0.
	self assert: botBody rightLightSensor  receivedLightIntensity > 0.

]

{ #category : #testing }
LightSensingWifiBotBodyTest >> testSensorsKnowsArena [
	self assert: botBody leftLightSensor arena == arena.
	self assert: botBody rightLightSensor arena == arena.

]

{ #category : #testing }
LightSensingWifiBotBodyTest >> testSensorsMoveWhenBodyMovesRightward [
	| initialBodyPosition InitialLeftSensorPosition InitialRightSensorPosition |
	initialBodyPosition :=  200 @ 200.
	botBody heading: -90.
	botBody positionInArena: initialBodyPosition.
	InitialLeftSensorPosition := botBody leftLightSensor positionInWorld.
	InitialRightSensorPosition := botBody rightLightSensor positionInWorld.
	botBody forwardSpeed: 100 rotationSpeed: 0.
	botBody commitActuatorValues.
	self assert: botBody positionInArena =( initialBodyPosition + (20@0)).
	self assert: botBody leftLightSensor positionInWorld = (InitialLeftSensorPosition + (20 @ 0)) .
	self assert: botBody rightLightSensor positionInWorld = (InitialRightSensorPosition + (20 @ 0)) .
	self assert: (botBody leftLightSensor positionInWorld - botBody rightLightSensor positionInWorld) = (InitialLeftSensorPosition - InitialRightSensorPosition).
	botBody commitActuatorValues.
	self assert: botBody leftLightSensor positionInWorld = (InitialLeftSensorPosition + (40 @ 0)) .
	self assert: botBody rightLightSensor positionInWorld = (InitialRightSensorPosition + (40 @ 0)) .
	self assert: (botBody leftLightSensor positionInWorld - botBody rightLightSensor positionInWorld) = (InitialLeftSensorPosition - InitialRightSensorPosition)
]

{ #category : #testing }
LightSensingWifiBotBodyTest >> testSensorsMoveWhenBodyMovesUpward [
	| InitialLeftSensorPosition InitialRightSensorPosition |
	botBody positionInArena: 200.0 @ 200.0.
	InitialLeftSensorPosition := botBody leftLightSensor positionInWorld.
	InitialRightSensorPosition := botBody rightLightSensor positionInWorld.
	botBody forwardSpeed: 100 rotationSpeed: 0.
	botBody commitActuatorValues.
	self assert: botBody leftLightSensor positionInWorld = (InitialLeftSensorPosition - (0 @ 20)) .
	self assert: botBody rightLightSensor positionInWorld = (InitialRightSensorPosition - (0 @ 20)) .
	self assert: (botBody leftLightSensor positionInWorld - botBody rightLightSensor positionInWorld) = (InitialLeftSensorPosition - InitialRightSensorPosition).
	botBody commitActuatorValues.
	self assert: botBody leftLightSensor positionInWorld = (InitialLeftSensorPosition - (0 @ 40)) .
	self assert: botBody rightLightSensor positionInWorld = (InitialRightSensorPosition - (0 @ 40)) .
	self assert: (botBody leftLightSensor positionInWorld - botBody rightLightSensor positionInWorld) = (InitialLeftSensorPosition - InitialRightSensorPosition)
]
