Extension { #name : #Morph }

{ #category : #'*WifiBotStMorphicSimulation-insertion into arena' }
Morph >> addToArena: arena [ 
	arena addAnyMorph: self
]

{ #category : #'*WifiBotStMorphicSimulation-geometry' }
Morph >> centerInWorld [
	^self pointInWorld: self center
]

{ #category : #'*WifiBotStMorphicSimulation-geometry' }
Morph >> centerInWorld: aPoint [
	self center: (self point: aPoint from: self world)
]

{ #category : #'*WifiBotStMorphicSimulation-insertion into arena' }
Morph >> removeFromArena: arena [
	arena removeAnyMorph: self
]
