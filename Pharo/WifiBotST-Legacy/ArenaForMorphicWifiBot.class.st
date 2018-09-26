"
A ClosedArenaForMorphicWifiBot is an arena with ""obstacles"" on its borders.
Robots are supposed to detect those obstacles and remain inside the visible area of the arena.

Example. Evaluate:
ClosedArenaForMorphicWifiBot demoWithSingleBot

"
Class {
	#name : #ArenaForMorphicWifiBot,
	#superclass : #PasteUpMorph,
	#instVars : [
		'isClosed',
		'topBorder',
		'bottomBorder',
		'leftBorder',
		'rightBorder',
		'mission'
	],
	#category : #'WifiBotST-Legacy-Kernel GUI'
}

{ #category : #examples }
ArenaForMorphicWifiBot class >> demoWithOnePathFinderBot [
"
A demo of PathFinderBot which should stop on the target point at the center of the arena

arena := ArenaForMorphicWifiBot demoWithOnePathFinderBot.
arena mission start.
"

	| mission arena bot botBody targetPoint targetPointMorph |

mission := WifiBotMission new.
arena := ArenaForMorphicWifiBot new.
arena mission: mission.
arena extent: 600@400.
arena openInWorld.
arena addRandomSmallObstacles: 4.
arena beSticky.

targetPoint := (arena extent // 2).

"show target"
targetPointMorph := CircleMorph new.
targetPointMorph extent: 5@5.
targetPointMorph position: targetPoint.
targetPointMorph openInWorld.

"bot := ObstacleAvoiderWifiBot morphic.
bot forwardSpeed: 20."

bot := PathFinderWifiBot morphic.
bot forwardSpeed: 20.
bot target: targetPoint.

botBody := bot body.
botBody openIn: arena.
botBody scaleWithFactor: 0.5.
botBody positionInArena: 0@0.
botBody heading:90.

botBody toggleSensors.
botBody morph owner toggleBoundingBox.

mission start.

^ arena

]

{ #category : #examples }
ArenaForMorphicWifiBot class >> demoWithSingleBot [
	"ClosedArenaForMorphicWifiBot demoWithSingleBot."

	| mission arena bot |
	mission := WifiBotMission new.
	arena := ArenaForMorphicWifiBot new.
	arena mission: mission.
	arena
		width: 600;
		height: 600.
	arena openInWorld.
	bot := ObstacleAvoiderWifiBot morphic.
	bot body openIn: arena.
	bot forwardSpeed: 40.
	mission start.
	^ mission
]

{ #category : #'submorph management' }
ArenaForMorphicWifiBot >> addAnyMorph: aMorph [ 
	super addMorph: aMorph
]

{ #category : #'submorph management' }
ArenaForMorphicWifiBot >> addMorph: aMorph [ 
	aMorph addToArena: self
]

{ #category : #initialization }
ArenaForMorphicWifiBot >> addObstacleAt: aPoint width: width height:  height [
	|obstacle offset|
	offset := self positionInWorld.
	obstacle := RectangleMorph new.
	self addMorph: obstacle.
	^obstacle 
		color: Color black;
		width: width;
		height: height;
		position: (aPoint + offset);
		yourself 
]

{ #category : #initialization }
ArenaForMorphicWifiBot >> addRandomSmallObstacles: obstaclesCount [
	| xInterval yInterval x y obstacle |
	xInterval := 50 to: self width - 50.
	yInterval := 50 to: self height - 50.
	obstaclesCount timesRepeat:
			[ x := xInterval atRandom.
			y := yInterval atRandom.
			self addObstacleAt: x @ y
				width: 50
				height: 50 ]
]

{ #category : #'submorph management' }
ArenaForMorphicWifiBot >> addWifiBotMorph: aTransformMorphWrapperForWifiBotMorph [
	| wifiBotMorph |
	super addMorph: aTransformMorphWrapperForWifiBotMorph.
	wifiBotMorph := aTransformMorphWrapperForWifiBotMorph submorphs first.
	mission addBot: wifiBotMorph bot
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> borders [
	^{self topBorder. self bottomBorder. self leftBorder. self rightBorder}
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> bottomBorder [
	^bottomBorder
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> bottomBorder: anObject [
	bottomBorder := anObject
]

{ #category : #borders }
ArenaForMorphicWifiBot >> close [
	^ self isClosed: true
	
]

{ #category : #initialization }
ArenaForMorphicWifiBot >> createBorders [
	self topBorder: RectangleMorph new.
	self topBorder lock: true;
		 height: 100.
	self bottomBorder: self topBorder copy.
	self leftBorder: RectangleMorph new.
	self leftBorder lock: true;
		 width: 100.
	self rightBorder: self leftBorder copy.

]

{ #category : #initialization }
ArenaForMorphicWifiBot >> defaultColor [
	^Color yellow
]

{ #category : #geometry }
ArenaForMorphicWifiBot >> extent: aPoint [ 
	super extent: aPoint.
	self updateBorderPositions
]

{ #category : #displaying }
ArenaForMorphicWifiBot >> hideBorders [
	self borders
		do: [:aBorder | aBorder owner == self ifTrue: [self removeMorph: aBorder]]
]

{ #category : #initialization }
ArenaForMorphicWifiBot >> initialize [
	super initialize.
	self createBorders.
	self isClosed: false.
	self clipSubmorphs: true;
		 width: 400;
		 height: 300
]

{ #category : #borders }
ArenaForMorphicWifiBot >> isClosed [
	^isClosed
]

{ #category : #borders }
ArenaForMorphicWifiBot >> isClosed: aBoolean [ 
	isClosed := aBoolean.
	isClosed
		ifTrue: [^self showBorders].
	self hideBorders
]

{ #category : #borders }
ArenaForMorphicWifiBot >> isOpen [
	^self isClosed not
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> leftBorder [
	^leftBorder
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> leftBorder: anObject [
	leftBorder := anObject
]

{ #category : #initialization }
ArenaForMorphicWifiBot >> minHeight [
	^ 300
]

{ #category : #initialization }
ArenaForMorphicWifiBot >> minWidth [
	^ 400
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> mission [
	^mission
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> mission: aWifiBotMission [
	mission := aWifiBotMission
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> obstacles [ 
	^self submorphs
]

{ #category : #borders }
ArenaForMorphicWifiBot >> open [
	^ self isClosed: false
]

{ #category : #displaying }
ArenaForMorphicWifiBot >> openInHand [
	super openInHand.
	self updateBorderPositions
]

{ #category : #displaying }
ArenaForMorphicWifiBot >> openInWorld [
	super openInWorld.
	self updateBorderPositions
]

{ #category : #'submorph management' }
ArenaForMorphicWifiBot >> removeAnyMorph: aMorph [
	super removeMorph: aMorph
]

{ #category : #'submorph management' }
ArenaForMorphicWifiBot >> removeMorph: aMorph [ 
	aMorph removeFromArena: self
]

{ #category : #'submorph management' }
ArenaForMorphicWifiBot >> removeWifiBotMorph: aTransformMorphWrapperForWifiBotMorph [ 
	| wifiBotMorph |
	super removeMorph: aTransformMorphWrapperForWifiBotMorph.
	wifiBotMorph := aTransformMorphWrapperForWifiBotMorph submorphs first.
	self mission removeBot: wifiBotMorph bot
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> rightBorder [
	^rightBorder
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> rightBorder: anObject [
	rightBorder := anObject
]

{ #category : #displaying }
ArenaForMorphicWifiBot >> showBorders [
	self hideBorders.
	self borders
		do: [:aBorder | self addMorph: aBorder].
	self updateBorderPositions
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> topBorder [
	^topBorder
]

{ #category : #accessing }
ArenaForMorphicWifiBot >> topBorder: anObject [
	topBorder := anObject
]

{ #category : #displaying }
ArenaForMorphicWifiBot >> updateBorderPositions [
	| pixelsDisplayed |
	self isOpen
		ifTrue: [^ self].
	pixelsDisplayed := 2.
	self topBorder width: self width;
		 position: self position - (0 @ self topBorder height) + (0 @ pixelsDisplayed).
	self bottomBorder width: self width;
		 position: self position + (0 @ self height) - (0 @ pixelsDisplayed).
	self leftBorder height: self height;
		 position: self position - (self leftBorder width @ 0) + (pixelsDisplayed @ 0).
	self rightBorder height: self height;
		 position: self position + (self width @ 0) - (pixelsDisplayed @ 0)
]
