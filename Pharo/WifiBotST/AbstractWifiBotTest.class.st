Class {
	#name : #AbstractWifiBotTest,
	#superclass : #TestCase,
	#instVars : [
		'bot',
		'botBody',
		'arena',
		'obstacle'
	],
	#category : #'WifiBotST-Kernel-Test'
}

{ #category : #'setUp-tearDown' }
AbstractWifiBotTest >> botClass [
	^ self subclassResponsibility 
]

{ #category : #'setUp-tearDown' }
AbstractWifiBotTest >> setUp [
	super setUp.
	bot := self botClass morphic.
	botBody := bot body.
	arena := ObstacleMorph new.
	arena
		color: Color yellow;
		width: World width;
		height: World height.
	arena openInWorld.
	obstacle := ObstacleMorph new.
	arena addMorph: obstacle.
	botBody openIn: arena
]

{ #category : #'setUp-tearDown' }
AbstractWifiBotTest >> tearDown [
	arena delete
]
