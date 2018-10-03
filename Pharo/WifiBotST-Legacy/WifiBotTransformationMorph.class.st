Class {
	#name : #WifiBotTransformationMorph,
	#superclass : #TransformationMorph,
	#instVars : [
		'isBoundingBoxVisible'
	],
	#category : #'WifiBotST-Legacy-Kernel GUI'
}

{ #category : #accessing }
WifiBotTransformationMorph >> boundingBoxVisible: aBool [
	isBoundingBoxVisible := aBool
]

{ #category : #accessing }
WifiBotTransformationMorph >> center [
	"Hack !
	The center of the transformMorph is the center of the icon of the bot and not the real center of the transformMorph 
	"
	(self hasSubmorphs and: [ self submorphs first isKindOf: WifiBotMorph ]) ifTrue: [
		^ (transform localBoundsToGlobal: self submorphs first bounds) center
	].
	^ super center
]

{ #category : #geometry }
WifiBotTransformationMorph >> computeBounds [
	(self hasSubmorphs and: [ self submorphs first isKindOf: WifiBotMorph ]) ifTrue: [
		bounds := (transform localBoundsToGlobal: self submorphs first privateFullBounds).
		^ fullBounds := bounds.
	].
	^ super computeBounds
]

{ #category : #drawing }
WifiBotTransformationMorph >> drawOn: aCanvas [

	| r |
	"display the bounds of the transfo morph"
	self isBoundingBoxVisible ifTrue: [
		r:= ObstacleMorph roundRectPrototype.
		r position: self position.
		r extent: (fullBounds width @ fullBounds height).
		r drawOn: aCanvas.
	].
	"display the center of transfo morph"
	"c := CircleMorph new.
	c extent: 5@5.
	c position: self center.
	c drawOn: aCanvas."
	
	super drawOn: aCanvas
]

{ #category : #actions }
WifiBotTransformationMorph >> hideBoundingBox [
	self boundingBoxVisible: false
]

{ #category : #accessing }
WifiBotTransformationMorph >> isBoundingBoxVisible [
	^ isBoundingBoxVisible ifNil: [ isBoundingBoxVisible := false ]
]

{ #category : #actions }
WifiBotTransformationMorph >> showBoundingBox [
	self boundingBoxVisible: true
]

{ #category : #actions }
WifiBotTransformationMorph >> toggleBoundingBox [
	self boundingBoxVisible: self isBoundingBoxVisible not
]
