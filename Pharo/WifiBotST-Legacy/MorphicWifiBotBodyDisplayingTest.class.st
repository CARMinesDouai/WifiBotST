Class {
	#name : #MorphicWifiBotBodyDisplayingTest,
	#superclass : #MorphicWifiBotBodyTest,
	#category : #'WifiBotST-Legacy-Kernel-Test'
}

{ #category : #'setUp-tearDown' }
MorphicWifiBotBodyDisplayingTest >> openBotBodyInArena [
	"Nothing to do because the test case is about openning"
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
	self assert: expectedWorldTransformMorphs = actualWorldTransformMorphs.
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
MorphicWifiBotBodyDisplayingTest >> testTransformMorphIsNotLostWhenOpenningInHand [
	botBody openInHand.
	botBody openIn: arena.
	self assert: botBody morph isFlexed
]
