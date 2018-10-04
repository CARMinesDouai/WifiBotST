Class {
	#name : #PathFollowerWifiBot,
	#superclass : #PathFinderWifiBot,
	#instVars : [
		'pathPoints'
	],
	#category : #'WifiBotStMorphicSimulation-BotExamples'
}

{ #category : #stepping }
PathFollowerWifiBot >> computeActuatorValues [
	self reachedTarget ifTrue: [
		self target: self nextTarget].
	super computeActuatorValues	
]

{ #category : #stepping }
PathFollowerWifiBot >> nextTarget [
	(self pathPoints last = self target) ifTrue: [
		^self pathPoints first].
	^self pathPoints after: self target	
]

{ #category : #accessing }
PathFollowerWifiBot >> pathPoints [
	^ pathPoints
]

{ #category : #accessing }
PathFollowerWifiBot >> pathPoints: pointsSequenceableCollection [
	pathPoints := pointsSequenceableCollection.
	self target: pathPoints first
]
