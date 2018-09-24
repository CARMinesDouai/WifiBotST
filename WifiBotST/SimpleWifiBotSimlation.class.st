"
A SimpleSimlation is a simulation with a single robot and a light bulb.
Robot only avoid obstacles. 
"
Class {
	#name : #SimpleWifiBotSimlation,
	#superclass : #WifiBotSimulation,
	#category : #'WifiBotST-BotExamples'
}

{ #category : #'initialize-release' }
SimpleWifiBotSimlation >> initialize [
	|bot| 
	super initialize.
	bot := self addRobotInstanceOf: TwoWheeledWifiBot atPosition: 300@500.
	bot leftSpeed: 100 rightSpeed: 100.
	self addLightBulbAt: 500@300 color: Color green.
	self addObstacleAt: 200@0 width: 50  height: 200.
	self addObstacleAt: 800@400 width: 50  height: 200
]
