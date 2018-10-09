Class {
	#name : #WifiBotMorphTest,
	#superclass : #TestCase,
	#instVars : [
		'botMorph'
	],
	#category : #'WifiBotStMorphicSimulation-Kernel-Test'
}

{ #category : #setUp }
WifiBotMorphTest >> setUp [
	botMorph := WifiBotMorph new.
	botMorph openInWorld
]

{ #category : #setUp }
WifiBotMorphTest >> tearDown [
	botMorph delete
]

{ #category : #tests }
WifiBotMorphTest >> testHideSensors [
	botMorph hideSensors.
	self assert: botMorph clipSubmorphs
]

{ #category : #tests }
WifiBotMorphTest >> testSensorPositions [
	| leftSensorPosition rightSensorPosition sensorExpectedY botMorphPosition |
	botMorphPosition := botMorph positionInArena.
	sensorExpectedY := botMorphPosition y - botMorph leftObstacleSensor height.
	leftSensorPosition := botMorph leftObstacleSensor positionInWorld.
	self assert: leftSensorPosition x = botMorphPosition x.
	self assert: leftSensorPosition y = sensorExpectedY.
	rightSensorPosition := botMorph rightObstacleSensor positionInWorld.
	self assert: rightSensorPosition x = (botMorphPosition x + (botMorph width // 2) + 1).
	self assert: rightSensorPosition y = sensorExpectedY
]

{ #category : #tests }
WifiBotMorphTest >> testShowSensors [
	botMorph showSensors.
	self deny: botMorph clipSubmorphs.

]
