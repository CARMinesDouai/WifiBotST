Extension { #name : #Morph }

{ #category : #'*WifiBotST-insertion into arena' }
Morph >> addToArena: arena [ 
	arena addAnyMorph: self
]

{ #category : #'*WifiBotST-geometry' }
Morph >> centerInWorld [
	^self pointInWorld: self center
]

{ #category : #'*WifiBotST-geometry' }
Morph >> centerInWorld: aPoint [
	self center: (self point: aPoint from: self world)
]

{ #category : #'*WifiBotST-insertion into arena' }
Morph >> removeFromArena: arena [
	arena removeAnyMorph: self
]
