"
An ArenaWithLightBulbs is an arena that can have different light sources.
It is used by LightSensingMorphicWifiBotBody which has two light sensors.

Instance Variables
	lightBulbs:		<IdentitySet of CicleMorph>

lightBulbs
	- are circle morphs that are considered as  light bulbs

"
Class {
	#name : #ArenaWithLightBulbs,
	#superclass : #ArenaForMorphicWifiBot,
	#instVars : [
		'lightBulbs'
	],
	#category : #'WifiBotST-LightSensing'
}

{ #category : #'light bulbs' }
ArenaWithLightBulbs >> addLightBulbAt: relativeCenterPoint color: aColor [
	|bulb|
	bulb := CircleMorph new.
	bulb color: aColor.
	self addMorph: bulb.
	bulb center: relativeCenterPoint + self position.
	self lightBulbs add: bulb .
	^bulb 
]

{ #category : #initialization }
ArenaWithLightBulbs >> initialize [ 
	super initialize.
	self lightBulbs: IdentitySet new
]

{ #category : #accessing }
ArenaWithLightBulbs >> lightBulbs [
	^ lightBulbs
]

{ #category : #accessing }
ArenaWithLightBulbs >> lightBulbs: anObject [
	lightBulbs := anObject
]

{ #category : #'light bulbs' }
ArenaWithLightBulbs >> removeLightBulbAt: relativeCenterPoint  color: aColor [
	| bulbToRemove centerPoint |
	centerPoint := relativeCenterPoint + self position.
	bulbToRemove := self lightBulbs 
		detect: [:bulb| 
			(bulb center = centerPoint) and: [bulb color = aColor]] 
		ifNone: [^self].
	self removeMorph: bulbToRemove.
	self lightBulbs remove: bulbToRemove
]
