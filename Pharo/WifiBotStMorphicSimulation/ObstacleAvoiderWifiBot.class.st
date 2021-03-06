Class {
	#name : #ObstacleAvoiderWifiBot,
	#superclass : #SimpleReactiveWifiBot,
	#category : #'WifiBotStMorphicSimulation-BotExamples'
}

{ #category : #stepping }
ObstacleAvoiderWifiBot >> computeActuatorValues [
	"Move forward or turn to avoid obstacles"
	"We do use wheel speed sensors since the range of the default obstacle
	sensors of real robots is too narrow"
	self body forwardSpeed = 0
		ifFalse: [(self body wheelSpeeds
					anySatisfy: [:speed | speed = 0])
		ifTrue: [^ self body forwardSpeed: 0 rotationSpeed: #(-1 1 ) atRandom * 180]].
	self obstacleOnTheRight
		ifTrue: [^ self body forwardSpeed: 0 rotationSpeed: self rotationSpeedOnRightObstacle].
	self obstacleOnTheLeft
		ifTrue: [^ self body forwardSpeed: 0 rotationSpeed: self rotationSpeedOnLeftObstacle].
	super computeActuatorValues
]

{ #category : #accessing }
ObstacleAvoiderWifiBot >> minDistanceToIgnoreObstacles [
	"Ignore the dist if the bot could pass near the obstacle"
	^ (self body centerInArena dist: self body positionInArena) truncated + 1
]

{ #category : #stepping }
ObstacleAvoiderWifiBot >> obstacleOnTheLeft [
	^self body distanceToLeftObstacles < self minDistanceToIgnoreObstacles
]

{ #category : #stepping }
ObstacleAvoiderWifiBot >> obstacleOnTheRight [
	^ self body distanceToRightObstacles < self minDistanceToIgnoreObstacles
]

{ #category : #accessing }
ObstacleAvoiderWifiBot >> rotationSpeedOnLeftObstacle [
	^self rotationSpeedOnRightObstacle negated

]

{ #category : #accessing }
ObstacleAvoiderWifiBot >> rotationSpeedOnRightObstacle [
	^ (1 to: 359) atRandom
]
