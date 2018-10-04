Class {
	#name : #PathFinderWifiBot,
	#superclass : #ObstacleAvoiderWifiBot,
	#instVars : [
		'target',
		'stepsToWaitBeforeHeadingTowardsTarget'
	],
	#category : #'WifiBotStMorphicSimulation-BotExamples'
}

{ #category : #stepping }
PathFinderWifiBot >> computeActuatorValues [
	| deltaAngle angleSpeed |
	self reachedTarget
		ifTrue: [^ self body forwardSpeed: 0 rotationSpeed: 0].
	(self obstacleOnTheLeft
			or: [self obstacleOnTheRight])
		ifTrue: [self stepsToWaitBeforeHeadingTowardsTarget: self stepsToWaitBeforeHeadingTowardsTarget + 5.
			^ super computeActuatorValues].
	self stepsToWaitBeforeHeadingTowardsTarget > 0
		ifTrue: [self stepsToWaitBeforeHeadingTowardsTarget: self stepsToWaitBeforeHeadingTowardsTarget - 1.
			^ super computeActuatorValues].
	deltaAngle := self deltaAngleForHeadingTowardsTarget.
	deltaAngle abs < 1
	ifTrue: [^ self body forwardSpeed: self forwardSpeed rotationSpeed: self rotationSpeed].
	angleSpeed := deltaAngle * self body morph speedRatio.
	^ self body forwardSpeed: self forwardSpeed rotationSpeed: angleSpeed
]

{ #category : #stepping }
PathFinderWifiBot >> deltaAngleForHeadingTowardsTarget [
	| position dx dy angleAbs |
	position := self body centerInArena.
	dx := position x - self target x.
	dy := position y - self target y.
	angleAbs := (dx negated arcTan: dy) radiansToDegrees.
	^ angleAbs - self body heading
]

{ #category : #'initialize-release' }
PathFinderWifiBot >> initialize [
	super initialize.
	self stepsToWaitBeforeHeadingTowardsTarget: 0
]

{ #category : #stepping }
PathFinderWifiBot >> positiondeltaAngleForHeadingTowardsTarget [
	| position dx dy angleAbs |
	position := self body centerInArena.
	dx := position x - self target x.
	dy := position y - self target y.
	angleAbs := (dy negated arcTan: dx) radiansToDegrees.
	^ angleAbs - self body heading
]

{ #category : #stepping }
PathFinderWifiBot >> reachedTarget [
	^(self body centerInArena dist: self target) < (self minDistanceToIgnoreObstacles / 4) truncated
]

{ #category : #stepping }
PathFinderWifiBot >> stepsToWaitBeforeHeadingTowardsTarget [
	^ stepsToWaitBeforeHeadingTowardsTarget
]

{ #category : #stepping }
PathFinderWifiBot >> stepsToWaitBeforeHeadingTowardsTarget: count [ 
	stepsToWaitBeforeHeadingTowardsTarget := count min: 15
]

{ #category : #accessing }
PathFinderWifiBot >> target [
	^target
]

{ #category : #accessing }
PathFinderWifiBot >> target: aPoint [ 
	target := aPoint.
]
