Class {
	#name : #WifiBotObstacleSensorMorph,
	#superclass : #Morph,
	#category : #'WifiBotStMorphicSimulation-Kernel GUI'
}

{ #category : #obstacleDetection }
WifiBotObstacleSensorMorph >> addBottomOf: morph to: collection ifBoundsIntersectWith: aRectangle [ 
	| otherBounds |
	otherBounds := morph boundsInWorld.
	(otherBounds intersects: aRectangle)
		ifTrue: [collection add: otherBounds bottom]
]

{ #category : #obstacleDetection }
WifiBotObstacleSensorMorph >> addIntersectionOf: rectangle1 with: rectangle2 to: aSet [
	| intersection |
	(rectangle1 intersects: rectangle2) ifFalse: [^self].
	intersection := rectangle1 intersect: rectangle2.
	aSet add: intersection
]

{ #category : #obstacleDetection }
WifiBotObstacleSensorMorph >> bottomLeftInWorld [
	^self pointInWorld: self bounds bottomLeft

]

{ #category : #obstacleDetection }
WifiBotObstacleSensorMorph >> bottomRightInWorld [
	^ self pointInWorld: self bounds bottomRight
]

{ #category : #obstacleDetection }
WifiBotObstacleSensorMorph >> intersections [
	| myBounds intersections |
	myBounds := self boundsInWorld.
	intersections := Set new.
	self potentialObstacles
		do: [:morph | 
			self addIntersectionOf: morph boundsInWorld with: myBounds to: intersections].
	^intersections

]

{ #category : #obstacleDetection }
WifiBotObstacleSensorMorph >> minDistanceToObstacle [
	| intersectionRectangles intersectionsPoints distancesToBottom bottomLeft bottomRight |
	intersectionRectangles := self intersections.
	intersectionRectangles
		ifEmpty: [^ self height].
	intersectionsPoints := Set new.
	intersectionRectangles
		do: [:rec | intersectionsPoints addAll: rec corners].
	distancesToBottom := Set new.
	bottomLeft := self bottomLeftInWorld.
	bottomRight := self bottomRightInWorld.
	intersectionsPoints
		do: [:point | distancesToBottom
				add: (bottomLeft dist: point);
				
				add: (bottomRight dist: point)].
	^ distancesToBottom min
]

{ #category : #accessing }
WifiBotObstacleSensorMorph >> potentialObstacles [
	^self owner potentialObstacles
]
