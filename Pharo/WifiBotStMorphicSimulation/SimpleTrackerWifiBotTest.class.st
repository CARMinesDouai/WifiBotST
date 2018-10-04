Class {
	#name : #SimpleTrackerWifiBotTest,
	#superclass : #AbstractWifiBotTest,
	#category : #'WifiBotStMorphicSimulation-BotExamples-Tests'
}

{ #category : #'setUp-tearDown' }
SimpleTrackerWifiBotTest >> botClass [
	^ SimpleTrackerWifiBot
]

{ #category : #running }
SimpleTrackerWifiBotTest >> testAlignOnLeftObstacle [
	| obstacleX obstacleY |
	botBody positionInArena: 300 @ 300.
	obstacleX := 300 - (obstacle width//2) + 2.
	obstacleY := 300 - obstacle height - bot maxAcceptableDistanceToTarget + 1.
	obstacle position: obstacleX @ obstacleY.
	self assert: botBody distanceToLeftObstacles <= bot maxAcceptableDistanceToTarget.
	self assert: botBody distanceToRightObstacles > bot maxAcceptableDistanceToTarget.
	bot step.
	self assert: botBody morph heading - 45 <= 5.
	self assert: botBody distanceToLeftObstacles <= bot maxAcceptableDistanceToTarget.
	self assert: botBody distanceToRightObstacles <= bot maxAcceptableDistanceToTarget
]

{ #category : #running }
SimpleTrackerWifiBotTest >> testAlignOnRightObstacle [
	| obstacleX obstacleY |
	botBody positionInArena: 300 @ 300.
	obstacleX := 300 + (botBody morph width // 2) + 2.
	obstacleY := 300 - obstacle height - bot maxAcceptableDistanceToTarget + 10.
	obstacle position: obstacleX @ obstacleY.
	self assert: botBody distanceToLeftObstacles > bot maxAcceptableDistanceToTarget.
	self assert: botBody distanceToRightObstacles <= bot maxAcceptableDistanceToTarget.
	bot step.
	self assert: botBody morph heading - 45 <= 5.
	self assert: botBody distanceToLeftObstacles <= bot maxAcceptableDistanceToTarget.
	self assert: botBody distanceToRightObstacles <= bot maxAcceptableDistanceToTarget
]

{ #category : #running }
SimpleTrackerWifiBotTest >> testGetCloseToTarget [
	| obstacleY |
	botBody positionInArena: 300 @ 300.
	obstacle width: botBody morph width.
	obstacleY := 300 - obstacle height - bot maxAcceptableDistanceToTarget - 20.
	obstacle position: 300 @ obstacleY.
	bot step.
	self assert: botBody positionInArena x = 300.
	self assert: botBody positionInArena y - obstacle bottom <= bot maxAcceptableDistanceToTarget
]
