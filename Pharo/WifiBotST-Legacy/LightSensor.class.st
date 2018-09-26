"
A LightSensor is a light sensor that detects any light color.
It is situated inside an arena (IV).
It computes the cumulative received light intensity (see method receivedLightIntensity) from all light bulbs in the arena.
The received light intensity is linear to the distance from the center of the light source to the center of the bulb.
If the received intensity computed can not more than maxLightIntensity, neither it can be below minLightIntensity.
The higher is the value of sensitivity (IV) the higher can be the distance from the sensor to light sources that are detected.

Instance Variables
	arena:		<ArenaWithLightBulbs>
	minLightIntensity:		<Intteger>
	maxLightIntensity:		<Intteger>
	sensitivity:		<Number>

"
Class {
	#name : #LightSensor,
	#superclass : #CircleMorph,
	#instVars : [
		'arena',
		'maxLightIntensity',
		'minLightIntensity',
		'sensitivity'
	],
	#category : #'WifiBotST-Legacy-LightSensing'
}

{ #category : #accessing }
LightSensor >> arena [
	^ arena
]

{ #category : #accessing }
LightSensor >> arena: anObject [
	arena := anObject
]

{ #category : #'initialize-release' }
LightSensor >> defaultMaxLightIntensity [
	^ 256
]

{ #category : #'initialize-release' }
LightSensor >> defaultMinLightIntensity [
	^ 0
]

{ #category : #'initialize-release' }
LightSensor >> defaultSensitivity [
	^ 1
]

{ #category : #'initialize-release' }
LightSensor >> defaultWidth [
	^10
]

{ #category : #'initialize-release' }
LightSensor >> initialize [
	super initialize.
	self maxLightIntensity: self defaultMaxLightIntensity.
	self minLightIntensity: self defaultMinLightIntensity.
	self sensitivity: self defaultSensitivity.
	self width: self defaultWidth
]

{ #category : #accessing }
LightSensor >> maxLightIntensity [
	^ maxLightIntensity
]

{ #category : #accessing }
LightSensor >> maxLightIntensity: anObject [
	maxLightIntensity := anObject
]

{ #category : #accessing }
LightSensor >> minLightIntensity [
	^ minLightIntensity
]

{ #category : #accessing }
LightSensor >> minLightIntensity: anObject [
	minLightIntensity := anObject
]

{ #category : #sensing }
LightSensor >> receivedLightIntensity [
	|rawTotal|
	rawTotal := self sensedBulbs inject: 0 into: [:total :bulb| total + (self receivedLightIntensityFrom: bulb)].
	^rawTotal min: self maxLightIntensity
]

{ #category : #sensing }
LightSensor >> receivedLightIntensityFrom: bulb [
	| rawIntensity intensityLoss distance |
	distance := (bulb centerInWorld  dist: self centerInWorld).
	rawIntensity := self maxLightIntensity - (self sensitivity * distance).
	rawIntensity > self maxLightIntensity ifTrue: [^self maxLightIntensity].
	rawIntensity < self minLightIntensity ifTrue: [^0].
	^rawIntensity
]

{ #category : #sensing }
LightSensor >> sense [
	|rawTotal|
	rawTotal := self sensedBulbs inject: 0 into: [:total :bulb| total + self receivedLightIntensityFrom: bulb].
	self receivedLightIntensity: (rawTotal max: self maxLightIntensity)
]

{ #category : #sensing }
LightSensor >> sensedBulbs [
	^self arena lightBulbs
]

{ #category : #accessing }
LightSensor >> sensitivity [
	^ sensitivity
]

{ #category : #accessing }
LightSensor >> sensitivity: anObject [
	sensitivity := anObject
]
