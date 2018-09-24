Class {
	#name : #DrivingWifibotWithJoystickMission,
	#superclass : #WifiBotMission,
	#instVars : [
		'joystick'
	],
	#category : #'WifiBotST-JoystickDrivenBot'
}

{ #category : #'instance creation' }
DrivingWifibotWithJoystickMission class >> drivingOneMorphicWifibot [
	^ self bot: JoystickDriverForWifiBot onMorphicBot
]

{ #category : #accessing }
DrivingWifibotWithJoystickMission >> addBot: aWifiBot [
	super addBot: aWifiBot.
	self joystick addDependent: aWifiBot 
]

{ #category : #'initialize-release' }
DrivingWifibotWithJoystickMission >> initialize [
	super initialize.
	self joystick: WifiBotJoystickMorph new
]

{ #category : #accessing }
DrivingWifibotWithJoystickMission >> joystick [
	^joystick
]

{ #category : #accessing }
DrivingWifibotWithJoystickMission >> joystick: anObject [
	joystick := anObject
]

{ #category : #accessing }
DrivingWifibotWithJoystickMission >> removeBot: aWifiBot [ 
	super removeBot: aWifiBot.
	self joystick removeDependent: aWifiBot
]
