Extension { #name : #WifiBot }

{ #category : #'*WifiBotStMorphicSimulation' }
WifiBot class >> morphic [
	^ self on: self morphicBodyClass new
]

{ #category : #'*WifiBotStMorphicSimulation' }
WifiBot class >> morphicBodyClass [
	^MorphicWifiBotBody 
]
