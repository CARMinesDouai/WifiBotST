Extension { #name : #Morph }

{ #category : #'*WifiBotST-Legacy-insertion into arena' }
Morph >> addToArena: arena [ 
	arena addAnyMorph: self
]

{ #category : #'*WifiBotST-Legacy-geometry' }
Morph >> centerInWorld [
	^self pointInWorld: self center
]

{ #category : #'*WifiBotST-Legacy-geometry' }
Morph >> centerInWorld: aPoint [
	self center: (self point: aPoint from: self world)
]

{ #category : #'*WifiBotST-Legacy-insertion into arena' }
Morph >> removeFromArena: arena [
	arena removeAnyMorph: self
]
