Class {
	#name : #LightSensorTest,
	#superclass : #TestCase,
	#instVars : [
		'arena',
		'sensor'
	],
	#category : #'WifiBotStMorphicSimulation-LightSensing-Test'
}

{ #category : #'setUp-tearDown' }
LightSensorTest >> lightSensorClass [
	^LightSensor
]

{ #category : #'setUp-tearDown' }
LightSensorTest >> setUp [
	super setUp.
	arena := ArenaWithLightBulbs new.
	sensor := self lightSensorClass new.
	sensor arena: arena.
	arena addMorph: sensor.
	sensor center: 0@0.
	sensor maxLightIntensity: 100.
	sensor minLightIntensity: 0.
	sensor sensitivity: 1
]

{ #category : #'setUp-tearDown' }
LightSensorTest >> tearDown [ 
	super tearDown.
	sensor delete
]

{ #category : #testing }
LightSensorTest >> testLightReceivedFromASingleBulbe [
	| positionToExpectedReceivedIntensityDict |
	arena addLightBulbAt: 0@0 color: Color green.
	positionToExpectedReceivedIntensityDict := Dictionary newFrom:  {
	(0@0)->100. 
	(0@50) -> 50. 
	(50@0) -> 50. 
	(0@100) -> 0.
	(100@0) -> 0.
	(0@101) -> 0.
	(101@0) -> 0.
	(293@539) -> 0.}.
	positionToExpectedReceivedIntensityDict keysAndValuesDo: [:position :expectedReceivedIntensity|
			sensor center: position.
		self assert: (sensor receivedLightIntensity) = expectedReceivedIntensity.
	].	
]

{ #category : #testing }
LightSensorTest >> testLightReceivedFromMultipleBulbesWithCloseLocations [
	|positionToExpectedReceivedIntensityDict|
	arena addLightBulbAt: 0@0 color: Color green.
	arena addLightBulbAt: 0@100 color: Color green.
	positionToExpectedReceivedIntensityDict := Dictionary newFrom:  {
	(0@0)->100. 
	(0@25) -> 100. 
	(0@50) -> 100.
	(0@75) -> 100. 
	(0@100) -> 100.
	(0@150) -> 50.
	(0@200) -> 0.}.
	positionToExpectedReceivedIntensityDict keysAndValuesDo: [:position :expectedReceivedIntensity|
			sensor center: position.
		self assert: (sensor receivedLightIntensity) = expectedReceivedIntensity.
]
]

{ #category : #testing }
LightSensorTest >> testLightReceivedFromMultipleBulbesWithDistantLocations [
	|positionToExpectedReceivedIntensityDict|
	arena addLightBulbAt: 0@0 color: Color green.
	arena addLightBulbAt: 0@175 color: Color green.
	positionToExpectedReceivedIntensityDict := Dictionary newFrom:  {
	(0@0)->100. 
	(0@25) -> 75. 
	(0@50) -> 50.
	(0@75) -> 25. 
	(0@100) -> 25.
	(0@125) -> 50.
	(0@150) -> 75.
	(0@175) -> 100.
	(0@200) -> 75}.
	positionToExpectedReceivedIntensityDict keysAndValuesDo: [:position :expectedReceivedIntensity|
			sensor center: position.
		self assert: (sensor receivedLightIntensity) = expectedReceivedIntensity.
]
]

{ #category : #testing }
LightSensorTest >> testLightReceivedFromMultipleBulbesWithTheSameLocation [
	|positionToExpectedReceivedIntensityDict|
	2 timesRepeat: [arena addLightBulbAt: 0@0 color: Color green].
	positionToExpectedReceivedIntensityDict := Dictionary newFrom:  {
	(0@0)->100. 
	(0@50) -> 100. 
	(50@0) -> 100. 
	(0@75) -> 50. 
	(75@0) -> 50. 
	(0@100) -> 0.
	(100@0) -> 0.
	(0@101) -> 0.
	(101@0) -> 0.
	(293@539) -> 0.}.
	positionToExpectedReceivedIntensityDict keysAndValuesDo: [:position :expectedReceivedIntensity|
			sensor center: position.
		self assert: (sensor receivedLightIntensity) = expectedReceivedIntensity.
	].	
]

{ #category : #testing }
LightSensorTest >> testSensorGeometry [
	self assert: sensor width = 10.
	self assert: sensor height = 10.
	
]
