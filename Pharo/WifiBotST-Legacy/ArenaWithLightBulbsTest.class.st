Class {
	#name : #ArenaWithLightBulbsTest,
	#superclass : #TestCase,
	#instVars : [
		'arena'
	],
	#category : #'WifiBotST-Legacy-LightSensing-Test'
}

{ #category : #'setUp-tearDown' }
ArenaWithLightBulbsTest >> setUp [
	super setUp.
	arena := ArenaWithLightBulbs new
]

{ #category : #'setUp-tearDown' }
ArenaWithLightBulbsTest >> tearDown [ 
	super tearDown.
	arena delete
]

{ #category : #testing }
ArenaWithLightBulbsTest >> testAddLightBulbAnswersTheNewlyCreatedBulb [
	|createdBulbs bulbProvidedPositions|
	bulbProvidedPositions := {0@0. 100@200. 300@400. 300@200. 500@500}.
	createdBulbs := IdentitySet new.
	bulbProvidedPositions do: [:point|
			createdBulbs add: (arena addLightBulbAt: 100@100 color: Color green)].
	self assert: createdBulbs = arena lightBulbs
	
]

{ #category : #testing }
ArenaWithLightBulbsTest >> testAdditionOfLightBulbs [
	| greenBulb redBulb |
	arena position: 0 @ 0.
	self assert: arena lightBulbs isEmpty.
	greenBulb := arena addLightBulbAt: 100 @ 100 color: Color green.
	redBulb := arena addLightBulbAt: 200 @ 200 color: Color red.
	self
		assert:
			arena lightBulbs
				=
					{greenBulb.
					redBulb} asSet.
	self assert: greenBulb center = (100 @ 100).
	self assert: redBulb center = (200 @ 200).
	self assert: (arena submorphs includesAll: arena lightBulbs)
]

{ #category : #testing }
ArenaWithLightBulbsTest >> testPositionOfLightBulbsShouldBeRelativeToTheTopLeftCornerOfArena [
	| bulb |
	arena position: 100@100. 
	bulb := arena addLightBulbAt: 100@100 color: Color green.
	self assert: bulb center = (200@200)
]

{ #category : #testing }
ArenaWithLightBulbsTest >> testRemovalOfLightBulbs [
	| greenBulb redBulb orangeBulb |
	arena position: 0@0.
	self assert: arena lightBulbs isEmpty.
	arena addLightBulbAt: 100@100 color: Color green.
	arena addLightBulbAt: 200@200 color: Color red.
	arena addLightBulbAt: 300@300 color: Color orange.
	arena removeLightBulbAt: 100@100 color: Color green.
	self assert: arena lightBulbs size = 2.
	self assert: arena submorphs size = 2.
	greenBulb := arena lightBulbs detect: [:bulb| bulb color = Color green] ifNone: [nil].
	self assert: greenBulb isNil.
	arena removeLightBulbAt:  200@200 color: Color red.
	self assert: arena lightBulbs size = 1.
	self assert: arena submorphs size = 1.
	redBulb := arena lightBulbs detect: [:bulb| bulb color = Color red] ifNone: [nil].
	self assert: redBulb isNil.
	arena removeLightBulbAt:  300@300 color: Color orange.
	self assert: arena lightBulbs isEmpty.
	self assert: arena submorphs isEmpty.
	orangeBulb := arena lightBulbs detect: [:bulb| bulb color = Color orange] ifNone: [nil].
	self assert: orangeBulb isNil.
	
]

{ #category : #testing }
ArenaWithLightBulbsTest >> testRemovalOfLightBulbsAfterChangingArenaPosition [
	| bulb |
	arena addLightBulbAt: 100@100 color: Color green.
	arena position: 300@300. 
	arena removeLightBulbAt: 100@100 color: Color green.
	self assert: arena lightBulbs isEmpty
]
