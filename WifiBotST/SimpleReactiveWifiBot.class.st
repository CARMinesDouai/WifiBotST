"
A SimpleReactiveWifiBot is a wifibot which step is a sequence :
-updateSensorValues
-computeActuatorValues
-commitActuatorValues

Example
bot := SimpleReactiveWifiBot bodyIp: #[192 168 0 130].
bot forwardSpeed: 100; rotationSpeed: 20.
1 to: 10 do: [bot step]
"
Class {
	#name : #SimpleReactiveWifiBot,
	#superclass : #WifiBot,
	#instVars : [
		'forwardSpeed',
		'rotationSpeed'
	],
	#category : #'WifiBotST-Kernel'
}

{ #category : #example }
SimpleReactiveWifiBot class >> startGoForward130Ethernet [
	<example>
	| bot |
	bot := SimpleReactiveWifiBot bodyIp: #[192 168 0 130].
	bot forwardSpeed: 10;
		rotationSpeed: 0.	
	bot step
]

{ #category : #example }
SimpleReactiveWifiBot class >> startGoForward132Wifi [
	<example>
	| bot |
	bot := SimpleReactiveWifiBot bodyIp: #[192 168 1 132].
	bot forwardSpeed: 10;
		rotationSpeed: 0.	
	bot step
]

{ #category : #example }
SimpleReactiveWifiBot class >> startRotateInPlace130Ethernet [
	<example>
	| bot |
	bot := SimpleReactiveWifiBot bodyIp: #[192 168 0 130].
	bot forwardSpeed: 0;
		rotationSpeed: 10.	
	bot step
]

{ #category : #example }
SimpleReactiveWifiBot class >> startRotateInPlace132Wifi [
	<example>
	| bot |
	bot := SimpleReactiveWifiBot bodyIp: #[192 168 1 132].
	bot forwardSpeed: 0;
		rotationSpeed: 10.	
	bot step
]

{ #category : #example }
SimpleReactiveWifiBot class >> stop130Ethernet [
	<example>
	| bot |
	bot := SimpleReactiveWifiBot bodyIp: #[192 168 0 130].
	bot forwardSpeed: 0;
		rotationSpeed: 0.	
	bot step
]

{ #category : #example }
SimpleReactiveWifiBot class >> stop132Wifi [
	<example>
	| bot |
	bot := SimpleReactiveWifiBot bodyIp: #[192 168 1 132].
	bot forwardSpeed: 0;
		rotationSpeed: 0.	
	bot step
]

{ #category : #stepping }
SimpleReactiveWifiBot >> computeActuatorValues [
	"Subclasses may redefine this method"
	self body forwardSpeed: self forwardSpeed rotationSpeed: self rotationSpeed
]

{ #category : #accessing }
SimpleReactiveWifiBot >> forwardSpeed [
	^forwardSpeed
]

{ #category : #accessing }
SimpleReactiveWifiBot >> forwardSpeed: positiveInteger [ 
	forwardSpeed := positiveInteger
]

{ #category : #'initialize-release' }
SimpleReactiveWifiBot >> initialize [
	super initialize.
	self forwardSpeed: 0.
	self rotationSpeed: 0
]

{ #category : #accessing }
SimpleReactiveWifiBot >> rotationSpeed [
	^rotationSpeed
]

{ #category : #accessing }
SimpleReactiveWifiBot >> rotationSpeed: anObject [
	rotationSpeed := anObject
]

{ #category : #stepping }
SimpleReactiveWifiBot >> step [
	self body updateSensorValues.
	self computeActuatorValues.
	self body commitActuatorValues
]
