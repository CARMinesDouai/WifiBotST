"
A LightSensingMorphicWifiBotBody is a body of a robot that has two light sensors, one on each side

Instance Variables
	leftLightSensor:		<LightSensor>
	rightLightSensor:		<LightSensor>


"
Class {
	#name : #LightSensingMorphicWifiBotBody,
	#superclass : #MorphicWifiBotBody,
	#instVars : [
		'leftLightSensor',
		'rightLightSensor'
	],
	#category : #'WifiBotST-LightSensing'
}

{ #category : #'initialize-release' }
LightSensingMorphicWifiBotBody >> initialize [ 
	|sensorPositionOffset|
	super initialize.
	self leftLightSensor: self lightSensorClass new.
	self rightLightSensor: self lightSensorClass new.
	self morph 
		addMorph: self leftLightSensor;
		addMorph: self rightLightSensor.
	sensorPositionOffset := self leftLightSensor width@0. 
	self leftLightSensor center: (self morph leftCenter + sensorPositionOffset).
	self rightLightSensor center: (self morph rightCenter - sensorPositionOffset).
	
	
]

{ #category : #accessing }
LightSensingMorphicWifiBotBody >> leftLightSensor [
	^ leftLightSensor
]

{ #category : #accessing }
LightSensingMorphicWifiBotBody >> leftLightSensor: anObject [
	leftLightSensor := anObject
]

{ #category : #'initialize-release' }
LightSensingMorphicWifiBotBody >> lightSensorClass [
	^LightSensor 
]

{ #category : #morphic }
LightSensingMorphicWifiBotBody >> openIn: arena [
	super openIn: arena.
	self leftLightSensor arena: arena.
	self rightLightSensor arena: arena 
	
]

{ #category : #accessing }
LightSensingMorphicWifiBotBody >> rightLightSensor [
	^ rightLightSensor
]

{ #category : #accessing }
LightSensingMorphicWifiBotBody >> rightLightSensor: anObject [
	rightLightSensor := anObject
]
