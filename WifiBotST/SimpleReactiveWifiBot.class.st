"
A SimpleReactiveWifiBot is a wifibot which step is a sequence :
-updateSensorValues
-computeActuatorValues
-commitActuatorValues

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
