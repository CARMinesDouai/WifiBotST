Class {
	#name : #AbstractWifiBotBodyTest,
	#superclass : #TestCase,
	#instVars : [
		'botBody'
	],
	#category : #'WifiBotST-Legacy-Kernel-Test'
}

{ #category : #testing }
AbstractWifiBotBodyTest class >> isAbstract [
	^ self == AbstractWifiBotBodyTest 
]

{ #category : #'setUp-tearDown' }
AbstractWifiBotBodyTest >> botBodyClass [
	self subclassResponsibility
]

{ #category : #'setUp-tearDown' }
AbstractWifiBotBodyTest >> setUp [
	self setUpBotBody
]

{ #category : #'setUp-tearDown' }
AbstractWifiBotBodyTest >> setUpBotBody [
	botBody := self botBodyClass new
]
