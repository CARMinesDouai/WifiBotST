"
A SimpleTrackerWifiBot is a bot keeps close to the object in front. If the object moves, the tracker follows it.

"
Class {
	#name : #SimpleTrackerWifiBot,
	#superclass : #SimpleReactiveWifiBot,
	#category : #'WifiBotStMorphicSimulation-BotExamples'
}

{ #category : #stepping }
SimpleTrackerWifiBot >> computeActuatorValues [
	| rotationSpeedToAlignOnTarget forwardSpeedToTouchTarget forwardSpeedToTrackTarget |
	rotationSpeedToAlignOnTarget := self body distanceToRightObstacles - self body distanceToLeftObstacles.
	forwardSpeedToTouchTarget := self body distanceToRightObstacles min: self body distanceToLeftObstacles.
	forwardSpeedToTrackTarget := forwardSpeedToTouchTarget <= self minAcceptableDistanceToTarget
				ifTrue: [0]
				ifFalse: [forwardSpeedToTouchTarget - self minAcceptableDistanceToTarget].
	self body forwardSpeed: forwardSpeedToTrackTarget rotationSpeed: rotationSpeedToAlignOnTarget
]

{ #category : #accessing }
SimpleTrackerWifiBot >> maxAcceptableDistanceToTarget [
	^ 100
]

{ #category : #accessing }
SimpleTrackerWifiBot >> minAcceptableDistanceToTarget [
	^ 10
]
