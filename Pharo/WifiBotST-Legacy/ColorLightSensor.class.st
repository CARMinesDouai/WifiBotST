"
A ColorLightSensor is a light sensor that senses a single color.

"
Class {
	#name : #ColorLightSensor,
	#superclass : #LightSensor,
	#category : #'WifiBotST-Legacy-LightSensing'
}

{ #category : #sensing }
ColorLightSensor >> sensedBulbs [
	^super sensedBulbs select: [: bulb|
		self color = bulb color]
]
