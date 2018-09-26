Class {
	#name : #ClosedArenaForMorphicWifiBotTest,
	#superclass : #TestCase,
	#instVars : [
		'arena',
		'bot',
		'botMorph'
	],
	#category : #'WifiBotST-Legacy-Kernel-Test'
}

{ #category : #running }
ClosedArenaForMorphicWifiBotTest >> assertArenaBordersPositions [
	| topBorderPosition bottomBorderPosition leftBorderPosition rightBorderPosition arenaPosition |
	topBorderPosition := arena topBorder position.
	bottomBorderPosition := arena bottomBorder position.
	leftBorderPosition := arena leftBorder position.
	rightBorderPosition := arena rightBorder position.
	arenaPosition := arena position.
	self assert: topBorderPosition x = arenaPosition x.
	self assert: topBorderPosition y = (arenaPosition y - 1).
	self assert: bottomBorderPosition x = arenaPosition x.
	self assert: bottomBorderPosition y = (arenaPosition y + arena height + 1).
	self assert: leftBorderPosition x = (arenaPosition x - 1).
	self assert: leftBorderPosition y = arenaPosition y.
	self assert: rightBorderPosition x = (arenaPosition x + arena width + 1).
	self assert: rightBorderPosition y = arenaPosition y
]

{ #category : #running }
ClosedArenaForMorphicWifiBotTest >> assertArenaBordersPositionsAndSizes [
	self assertArenaBordersPositions.
	self assertArenaBordersSizes
]

{ #category : #running }
ClosedArenaForMorphicWifiBotTest >> assertArenaBordersSizes [
	arena close.
	self assert: arena topBorder width = arena width.
	self assert: arena topBorder height = 100.
	self assert: arena bottomBorder width = arena width.
	self assert: arena bottomBorder height = 100.
	self assert: arena leftBorder height = arena height.
	self assert: arena leftBorder width = 100.
	self assert: arena rightBorder height = arena height.
	self assert: arena rightBorder width = 100
]

{ #category : #'setUp-tearDown' }
ClosedArenaForMorphicWifiBotTest >> setUp [
	arena := ArenaForMorphicWifiBot new.
	arena mission: WifiBotMission new.
	arena close.
	bot := ObstacleAvoiderWifiBot morphic.
	botMorph := bot body morph.
	botMorph openInWorld
]

{ #category : #'setUp-tearDown' }
ClosedArenaForMorphicWifiBotTest >> tearDown [
	arena delete.
	botMorph delete
]

{ #category : #running }
ClosedArenaForMorphicWifiBotTest >> testAddedBotIsLinkedtoMission [
	| botFlexShell |
	botFlexShell := botMorph owner.
	arena addMorph: botFlexShell.
	self
		assert: (arena submorphs includes: botFlexShell);
		
		assert: (arena mission bots includes: bot)
]

{ #category : #running }
ClosedArenaForMorphicWifiBotTest >> testArenaClipping [
	self assert: arena clipSubmorphs
]

{ #category : #running }
ClosedArenaForMorphicWifiBotTest >> testBorderObstaclesLocked [
	arena borders
		do: [:border | self assert: border isLocked]
]

{ #category : #running }
ClosedArenaForMorphicWifiBotTest >> testBorderObstaclesUpdatedOnResize [
	arena width: 300.
	arena height: 400.
	arena extent: 250 @ 350.
	self assertArenaBordersSizes
]

{ #category : #running }
ClosedArenaForMorphicWifiBotTest >> testRemovedBotIsDeletedFromMission [
	| botFlexShell |
	botFlexShell := botMorph owner.
	arena addMorph: botFlexShell.
	arena removeMorph: botFlexShell.
	self
		deny: (arena submorphs includes: botFlexShell);
		
		deny: (arena mission bots includes: bot)
]
