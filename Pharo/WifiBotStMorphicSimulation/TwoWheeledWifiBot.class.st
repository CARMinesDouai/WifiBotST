"
A TwoWheeledRobot is a robot with:
-two wheels, 
-two infra-red sensors on the front,  for obstacle detection
-two light sensors

"
Class {
	#name : #TwoWheeledWifiBot,
	#superclass : #ObstacleAvoiderWifiBot,
	#category : #'WifiBotStMorphicSimulation-BotExamples'
}

{ #category : #'instance creation' }
TwoWheeledWifiBot class >> morphicBodyClass [
	^LightSensingMorphicWifiBotBody
]

{ #category : #sensing }
TwoWheeledWifiBot >> center [ 
	^self body morph centerInArena
]

{ #category : #sensing }
TwoWheeledWifiBot >> distanceToObstaclesByLeftSensor [
	^self body distanceToLeftObstacles
]

{ #category : #sensing }
TwoWheeledWifiBot >> distanceToObstaclesByRightSensor [
	^ self body distanceToRightObstacles
]

{ #category : #sensing }
TwoWheeledWifiBot >> heading [ 
	^self body heading
]

{ #category : #accessing }
TwoWheeledWifiBot >> leftSpeed [
	^self forwardSpeed - (self rotationSpeed / 2)
]

{ #category : #stepping }
TwoWheeledWifiBot >> leftSpeed: leftSpeed rightSpeed: rightSpeed [ 
	self
		forwardSpeed: (leftSpeed + rightSpeed) / 2;
		rotationSpeed: (rightSpeed - leftSpeed).

]

{ #category : #sensing }
TwoWheeledWifiBot >> lightReceivedByLeftSensor [
	^self body leftLightSensor receivedLightIntensity
]

{ #category : #sensing }
TwoWheeledWifiBot >> lightReceivedByRightSensor [
	^self body rightLightSensor receivedLightIntensity 
]

{ #category : #stepping }
TwoWheeledWifiBot >> maxDistanceToSenseObstacles [
	^150
]

{ #category : #sensing }
TwoWheeledWifiBot >> maxLeftLightIntensity [
	^self body leftLightSensor maxLightIntensity 
]

{ #category : #sensing }
TwoWheeledWifiBot >> maxRightLightIntensity [
		^self body rightLightSensor maxLightIntensity 
]

{ #category : #accessing }
TwoWheeledWifiBot >> rightSpeed [
	^self forwardSpeed + (self rotationSpeed / 2)
]
