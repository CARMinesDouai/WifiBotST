Class {
	#name : #UpdateCounter,
	#superclass : #Object,
	#instVars : [
		'count'
	],
	#category : #'WifiBotST-Legacy-JoystickDrivenBot'
}

{ #category : #accessing }
UpdateCounter >> count [
	^count
]

{ #category : #accessing }
UpdateCounter >> count: anObject [
	count := anObject
]

{ #category : #'initialize-release' }
UpdateCounter >> initialize [
	super initialize.
	self count: 0
]

{ #category : #updating }
UpdateCounter >> update: aParameter [
	super update: aParameter.
	self count: self count + 1
]
