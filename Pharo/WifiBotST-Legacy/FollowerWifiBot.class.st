Class {
	#name : #FollowerWifiBot,
	#superclass : #PathFinderWifiBot,
	#instVars : [
		'bot'
	],
	#category : #'WifiBotST-Legacy-BotExamples'
}

{ #category : #'as yet unclassified' }
FollowerWifiBot >> addbot: abot [ 
	bot := abot
]

{ #category : #'as yet unclassified' }
FollowerWifiBot >> computeActuatorValues [
	self target: bot body positionInArena. 
	self distancetoTarget = self minDistanceToTarget
	ifTrue: [^self body forwardSpeed: 0 rotationSpeed: 0].
	^super computeActuatorValues.
	



]

{ #category : #'as yet unclassified' }
FollowerWifiBot >> distancetoTarget [
	^ self body positionInArena dist: target
]

{ #category : #'as yet unclassified' }
FollowerWifiBot >> minDistanceToTarget [
	^self body morph width



]
