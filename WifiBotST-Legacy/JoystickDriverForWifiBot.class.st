Class {
	#name : #JoystickDriverForWifiBot,
	#superclass : #Object,
	#instVars : [
		'bot'
	],
	#category : #'WifiBotST-Legacy-JoystickDrivenBot'
}

{ #category : #'instance creation' }
JoystickDriverForWifiBot class >> defaultBotClass [
	^ ObstacleAvoiderWifiBot 
]

{ #category : #'instance creation' }
JoystickDriverForWifiBot class >> onBot: bot [ 
	^ self new bot: bot;
		 yourself
]

{ #category : #'instance creation' }
JoystickDriverForWifiBot class >> onMorphicBot [
	^ self onBot: self defaultBotClass morphic
]

{ #category : #accessing }
JoystickDriverForWifiBot >> body [
	^self bot body
]

{ #category : #accessing }
JoystickDriverForWifiBot >> bot [
	^bot
]

{ #category : #accessing }
JoystickDriverForWifiBot >> bot: anObject [
	bot := anObject
]

{ #category : #stepping }
JoystickDriverForWifiBot >> step [
	self bot step
]

{ #category : #updating }
JoystickDriverForWifiBot >> update: joystick [ 
	self bot forwardSpeed: joystick upDown asInteger;
		 rotationSpeed: joystick leftRight asInteger
]
