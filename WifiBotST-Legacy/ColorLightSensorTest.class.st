Class {
	#name : #ColorLightSensorTest,
	#superclass : #LightSensorTest,
	#category : #'WifiBotST-Legacy-LightSensing-Test'
}

{ #category : #'setUp-tearDown' }
ColorLightSensorTest >> lightSensorClass [
	^ColorLightSensor
]

{ #category : #'setUp-tearDown' }
ColorLightSensorTest >> setUp [ 
	super setUp.
	sensor color: Color red
]

{ #category : #testing }
ColorLightSensorTest >> testBulbWithDifferentColorIsNotSensed [
	arena addLightBulbAt: sensor center color: Color green.
	self deny: arena lightBulbs anyOne color = sensor color.
	self assert: sensor receivedLightIntensity = 0
]

{ #category : #testing }
ColorLightSensorTest >> testSensingSingleBulbWithSameColor [
	arena addLightBulbAt: sensor center color: sensor color.
	self assert: sensor receivedLightIntensity = 100
]
