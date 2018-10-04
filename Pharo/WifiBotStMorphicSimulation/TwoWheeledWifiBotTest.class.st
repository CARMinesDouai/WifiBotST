Class {
	#name : #TwoWheeledWifiBotTest,
	#superclass : #TestCase,
	#instVars : [
		'arena',
		'mission',
		'robot',
		'botBody'
	],
	#category : #'WifiBotStMorphicSimulation-BotExamples-Tests'
}

{ #category : #'setUp-tearDown' }
TwoWheeledWifiBotTest >> setUp [ 
	super setUp.
	mission := WifiBotMission new.
	arena := ArenaWithLightBulbs new.
	arena mission: mission.
	arena openInWorld.
	robot := TwoWheeledWifiBot morphic.
	botBody := 	robot body.
	botBody openIn: arena

]

{ #category : #'setUp-tearDown' }
TwoWheeledWifiBotTest >> tearDown [
	super tearDown.
	mission stop.
	arena delete.
	botBody delete
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testCenter [
	{10@10. 450@100. 60@200. 280@500} do: [:center|
		robot body morph centerInArena:  center.
		self assert: robot center = center] 
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testHeading [
	{10. 45. 60. 90. 180. 280} do: [:angle|
		robot body morph heading: angle.
		self assert: robot heading rounded equals: angle ] 
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testIndividualSpeedSetupForBackwardMovement [
	robot leftSpeed: -100 rightSpeed: -100.
	self assert: robot forwardSpeed equals: -100.
	self assert: robot rotationSpeed equals: 0.
	 
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testIndividualSpeedSetupForForwardMovement [
	robot leftSpeed: 100 rightSpeed: 100.
	self assert: robot forwardSpeed = 100.
	self assert: robot rotationSpeed = 0.
	 
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testIndividualSpeedSetupForRotationToTheLeft [
	robot leftSpeed: -50 rightSpeed: 50.
	self assert: robot forwardSpeed = 0.
	self assert: robot rotationSpeed = -100.
	 
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testIndividualSpeedSetupForRotationToTheRight [
	robot leftSpeed: 50 rightSpeed: -50.
	self assert: robot forwardSpeed = 0.
	self assert: robot rotationSpeed = 100.
	 
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testMaxLeftLightIntensity [
	{50. 100. 200} do: [:max|
		robot body  leftLightSensor maxLightIntensity: max.
		self assert: robot maxLeftLightIntensity =  max].
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testMaxRigtLightIntensity [
	{50. 100. 200} do: [:max|
		robot body  rightLightSensor maxLightIntensity: max.
		self assert: robot maxRightLightIntensity =  max].
]

{ #category : #testing }
TwoWheeledWifiBotTest >> testSensing [
	| bulb leftLightSensorCenter rightLightSensorCenter distanceBetweenLightSensors maxLightIntensityOfSensors |
	botBody centerInArena: 100@100.
	leftLightSensorCenter := botBody leftLightSensor centerInWorld.
	rightLightSensorCenter := botBody rightLightSensor centerInWorld.
	distanceBetweenLightSensors	:= leftLightSensorCenter dist: rightLightSensorCenter.
	bulb := arena addLightBulbAt: 0@0 color: Color green.
	maxLightIntensityOfSensors := 256. 
	bulb centerInWorld: leftLightSensorCenter.
	self assert: robot lightReceivedByLeftSensor = maxLightIntensityOfSensors.
	self assert: robot lightReceivedByRightSensor = (maxLightIntensityOfSensors - distanceBetweenLightSensors).
	bulb centerInWorld: rightLightSensorCenter.
	self assert: robot lightReceivedByLeftSensor = (maxLightIntensityOfSensors - distanceBetweenLightSensors)..
	self assert: robot lightReceivedByRightSensor = maxLightIntensityOfSensors

]

{ #category : #testing }
TwoWheeledWifiBotTest >> testSpeedSetup [
	robot leftSpeed: -100 rightSpeed: 200.
	self assert: robot leftSpeed = -100.
	self assert: robot rightSpeed = 200.
	robot leftSpeed: 50 rightSpeed: 60.
	self assert: robot leftSpeed = 50.
	self assert: robot rightSpeed = 60.
	robot leftSpeed: 80 rightSpeed: 120.
	self assert: robot leftSpeed = 80.
	self assert: robot rightSpeed = 120.

]
