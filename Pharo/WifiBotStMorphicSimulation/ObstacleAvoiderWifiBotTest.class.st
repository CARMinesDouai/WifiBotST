Class {
	#name : #ObstacleAvoiderWifiBotTest,
	#superclass : #AbstractWifiBotTest,
	#category : #'WifiBotStMorphicSimulation-BotExamples-Tests'
}

{ #category : #'setUp-tearDown' }
ObstacleAvoiderWifiBotTest >> botClass [
	^ ObstacleAvoiderWifiBot
]

{ #category : #running }
ObstacleAvoiderWifiBotTest >> testMoveForwardIfNoObstacle [
	bot forwardSpeed: 100.
	botBody positionInArena: 300 @ 300.
	bot step.
	self assert: botBody positionInArena = (300 @ 280)
]

{ #category : #running }
ObstacleAvoiderWifiBotTest >> testRotationToLeftOnRightObstacle [
	| obstacleX obstacleY initialHeading |
	initialHeading := -90.
	botBody heading: initialHeading.
	botBody positionInArena: 300 @ 300.
	obstacleX := 300 + bot minDistanceToIgnoreObstacles - 1.
	obstacleY := 300 + (0.75 * botBody morph width).
	obstacle position: obstacleX @ obstacleY.
	self assert: botBody distanceToLeftObstacles equals: 150.
	self assert: botBody distanceToRightObstacles < bot minDistanceToIgnoreObstacles.
	bot step.
	self assert: botBody heading < initialHeading
]

{ #category : #running }
ObstacleAvoiderWifiBotTest >> testRotationToRightOnLeftObstacle [
	| obstacleX obstacleY initialHeading |
	initialHeading := -90.
	botBody heading: initialHeading.
	botBody positionInArena: 300 @ 300.
	obstacleX := 300 + bot minDistanceToIgnoreObstacles - 1.
	obstacleY := 300 - (0.25 * botBody morph width).
	obstacle position: obstacleX @ obstacleY.
	self assert: botBody distanceToLeftObstacles < bot minDistanceToIgnoreObstacles.
	self assert: botBody distanceToRightObstacles equals: 150.
	bot step.
	self assert: botBody heading > initialHeading
]
