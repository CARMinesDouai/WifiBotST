Class {
	#name : #MorphicWifiBotBodyDisplayingTest,
	#superclass : #MorphicWifiBotBodyTest,
	#category : #'WifiBotStMorphicSimulation-Kernel-Test'
}

{ #category : #'setUp-tearDown' }
MorphicWifiBotBodyDisplayingTest >> openBotBodyInArena [
	"Nothing to do because the test case is about openning"
]

{ #category : #running }
MorphicWifiBotBodyDisplayingTest >> testCenter [
	| expectedCenterInArena |
	botBody openIn: arena.
	expectedCenterInArena := arena extent // 2.
	botBody centerInArena: expectedCenterInArena.
	arena position: arena position + 100.
	self assert: botBody centerInArena equals: expectedCenterInArena.
	self assert: botBody morph centerInArena equals: expectedCenterInArena.

]

{ #category : #running }
MorphicWifiBotBodyDisplayingTest >> testExtraTransformMorphCreatedWhenOpenningInHand [
	| expectedArenaTransformMorphs originalAreanTransformMorphs actualArenaTransformMorphs expectedWorldTransformMorphs actualWorldTransformMorphs |
	expectedWorldTransformMorphs := (World submorphs
				select: [:morph | morph isKindOf: TransformMorph]) asSet.
	originalAreanTransformMorphs := (arena submorphs
				select: [:morph | morph isKindOf: TransformMorph]) asSet.
	botBody openInHand.
	botBody openIn: arena.
	actualWorldTransformMorphs := (World submorphs
				select: [:morph | morph isKindOf: TransformMorph]) asSet.
	self assertCollection: expectedWorldTransformMorphs hasSameElements: actualWorldTransformMorphs.
	actualArenaTransformMorphs := (arena submorphs
				select: [:morph | morph isKindOf: TransformMorph]) asSet.
	expectedArenaTransformMorphs := originalAreanTransformMorphs copyWith: botBody morph owner.
	self assert: actualArenaTransformMorphs = expectedArenaTransformMorphs.
	self assert: World activeHand submorphs size = 0
]

{ #category : #running }
MorphicWifiBotBodyDisplayingTest >> testObstacleDetectionWhenOpenningInHand [
	botBody openInHand.
	botBody openIn: arena.
	self testNearObstacleSensing 
]

{ #category : #running }
MorphicWifiBotBodyDisplayingTest >> testSensorPositions [
	botBody openIn: arena.
	botBody positionInArena: 300@200.
	arena position: arena position + 100.
	self assert: botBody leftObstacleSensor position equals: 0 @ -150.
	self assert: botBody rightObstacleSensor position equals: 49 @ -150.

]

{ #category : #running }
MorphicWifiBotBodyDisplayingTest >> testTransformMorphIsNotLostWhenOpenningInHand [
	botBody openInHand.
	botBody openIn: arena.
	self assert: botBody morph isFlexed
]
