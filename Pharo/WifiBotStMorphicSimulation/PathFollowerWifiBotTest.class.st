Class {
	#name : #PathFollowerWifiBotTest,
	#superclass : #AbstractWifiBotTest,
	#category : #'WifiBotStMorphicSimulation-BotExamples-Tests'
}

{ #category : #'setUp-tearDown' }
PathFollowerWifiBotTest >> botClass [
	^PathFollowerWifiBot 
]

{ #category : #'setUp-tearDown' }
PathFollowerWifiBotTest >> setUp [
	super setUp.
	bot pathPoints: {
		100@100. 
		500@100. 
		300@500}
]

{ #category : #testing }
PathFollowerWifiBotTest >> testTargetSelection [
	| expectedTargets |
	expectedTargets := bot pathPoints copyWith: bot pathPoints first.
	expectedTargets do: [:currentTarget|
		self assert: bot target equals: currentTarget.
		botBody centerInArena: bot target.
		bot step]
	
]
