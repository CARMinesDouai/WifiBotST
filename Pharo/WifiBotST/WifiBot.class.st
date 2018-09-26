Class {
	#name : #WifiBot,
	#superclass : #Object,
	#instVars : [
		'body'
	],
	#category : #'WifiBotST-Kernel'
}

{ #category : #'instance creation' }
WifiBot class >> bodyIp: ipAddressArray [ 
	| body |
	body := self realBodyClass ip: ipAddressArray.
	^ self on: body
]

{ #category : #'instance creation' }
WifiBot class >> morphic [
	^ self on: self morphicBodyClass new
]

{ #category : #'instance creation' }
WifiBot class >> morphicBodyClass [
	^MorphicWifiBotBody 
]

{ #category : #'instance creation' }
WifiBot class >> on: aWifiBotBody [
	^self new
		body: aWifiBotBody;
		yourself
]

{ #category : #'instance creation' }
WifiBot class >> realBodyClass [
	^ RealWifiBotBody 
]

{ #category : #accessing }
WifiBot >> body [
	^body
]

{ #category : #accessing }
WifiBot >> body: anObject [ 
	body := anObject.
	body bot: self
]

{ #category : #stepping }
WifiBot >> step [
	self subclassResponsibility 
]
