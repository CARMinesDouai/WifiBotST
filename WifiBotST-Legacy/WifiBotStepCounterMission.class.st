Class {
	#name : #WifiBotStepCounterMission,
	#superclass : #WifiBotMission,
	#instVars : [
		'resetCount'
	],
	#category : #'WifiBotST-Legacy-Kernel-Test'
}

{ #category : #'initialize-release' }
WifiBotStepCounterMission >> initialize [
	super initialize.
	self resetCount: 0
]

{ #category : #running }
WifiBotStepCounterMission >> reset [
	self resetCount: self resetCount + 1.
	self bots
		do: [:bot | bot stepCount: 0]
]

{ #category : #accessing }
WifiBotStepCounterMission >> resetCount [
	^resetCount
]

{ #category : #accessing }
WifiBotStepCounterMission >> resetCount: anObject [
	resetCount := anObject
]
