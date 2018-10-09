Class {
	#name : #WifiBotTransformationMorph,
	#superclass : #TransformationMorph,
	#instVars : [
		'isBoundingBoxVisible'
	],
	#category : #'WifiBotStMorphicSimulation-Kernel'
}

{ #category : #accessing }
WifiBotTransformationMorph >> boundingBoxVisible: aBool [
	isBoundingBoxVisible := aBool
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
