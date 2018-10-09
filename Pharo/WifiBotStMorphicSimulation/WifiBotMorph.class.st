"
I am the morphic representation of a wifibot. I provide the graphics but also simulate the physical interaction with the world (e.g. sensors, position).

This design is interesting because it reuses Morphic features to quickly implement the simulation. But, it forbids using different graphical representations. A more modulare design would fix this.
"
Class {
	#name : #WifiBotMorph,
	#superclass : #ImageMorph,
	#instVars : [
		'forwardSpeed',
		'rotationSpeed',
		'speedLock',
		'leftObstacleSensor',
		'rightObstacleSensor',
		'botBody',
		'positionInArena'
	],
	#classInstVars : [
		'defaultImage'
	],
	#category : #'WifiBotStMorphicSimulation-Kernel'
}

{ #category : #initialization }
WifiBotMorph class >> defaultImage [
	^defaultImage
]

{ #category : #initialization }
WifiBotMorph class >> defaultImageFile [
	| iceRepository |
	iceRepository := IceRepository registry detect:  [ :each | each includesPackageNamed: self package name].
	^iceRepository location / 'Graphics' / 'wifiBot.png'

]

{ #category : #initialization }
WifiBotMorph class >> initDefaultImage [
	defaultImage := self defaultImageFile
		binaryReadStreamDo: [ :str | ImageReadWriter formFromStream: str ]
]

{ #category : #initialization }
WifiBotMorph class >> initialize [
	self initDefaultImage
]

{ #category : #initialization }
WifiBotMorph >> addObstacleSensors [
	| halfWidth halfWidthIntegerPart leftSensorWidth rightSensorWidth sensorsYOrigin leftSensorX |
	halfWidth := self width // 2.
	halfWidthIntegerPart := halfWidth asFloat integerPart.
	halfWidthIntegerPart = halfWidth
		ifTrue: [leftSensorWidth := halfWidth.
			rightSensorWidth := halfWidth]
		ifFalse: [leftSensorWidth := halfWidthIntegerPart + 1.
			rightSensorWidth := halfWidthIntegerPart].
	self leftObstacleSensor: WifiBotObstacleSensorMorph new.
	self rightObstacleSensor: WifiBotObstacleSensorMorph new.
	self addAllMorphs: {leftObstacleSensor. rightObstacleSensor}.
	leftSensorX := self position x.
	sensorsYOrigin := self position y - self obstacleSensorHeight.
	self leftObstacleSensor width: leftSensorWidth;
		 height: self obstacleSensorHeight;
		 position: leftSensorX @ sensorsYOrigin;
		 color: Color red.
	self rightObstacleSensor width: rightSensorWidth;
		 height: self obstacleSensorHeight;
		 position: leftSensorX + leftSensorWidth + 1 @ sensorsYOrigin;
		 color: Color red.
]

{ #category : #accessing }
WifiBotMorph >> arena [
	self owner ifNil: [ ^nil ].
	^self owner owner.

]

{ #category : #accessing }
WifiBotMorph >> bot [
	^self botBody bot
]

{ #category : #accessing }
WifiBotMorph >> botBody [
	^botBody
]

{ #category : #accessing }
WifiBotMorph >> botBody: aWifiBotBody [
	botBody := aWifiBotBody
]

{ #category : #geometry }
WifiBotMorph >> centerInArena [	
	^ self positionInArena + (self extent//2)
]

{ #category : #geometry }
WifiBotMorph >> centerInArena: newCenter [	
	| delta |
	delta := newCenter - self centerInArena.
	self positionInArena: self positionInArena + delta
]

{ #category : #initialization }
WifiBotMorph >> defaultImage [
	^self class defaultImage
]

{ #category : #displaying }
WifiBotMorph >> delete [
	self owner ifNil: [ ^super delete ].
	self owner delete
]

{ #category : #displaying }
WifiBotMorph >> ensureSensorsDisplay [
	"Hack simply swithcing off clipping is not enough!"
	self submorphsDo: 
			[:subMorph | 
			subMorph position: subMorph position + 1.
			subMorph position: subMorph position - 1]
]

{ #category : #moving }
WifiBotMorph >> forwardSpeed [
	^ self speedLock
		critical: [forwardSpeed
				ifNil: [0] ifNotNil: [forwardSpeed]]
]

{ #category : #moving }
WifiBotMorph >> forwardSpeed: anObject [ 
	self speedLock critical: [forwardSpeed := anObject  // self speedRatio]
]

{ #category : #moving }
WifiBotMorph >> forwardSpeed: speed rotationSpeed: angleInDegrees [ 
	self forwardSpeed: speed.
	self rotationSpeed: angleInDegrees.
	self heading: self heading + self getThenZeroRotationSpeed.
	self positionInArena: self positionInArena - self getThenZeroSpeedVector
]

{ #category : #moving }
WifiBotMorph >> getThenZeroForwardSpeed [
	| speed |
	speed := self forwardSpeed.
	self forwardSpeed: 0.
	^speed
]

{ #category : #moving }
WifiBotMorph >> getThenZeroRotationSpeed [
	| speed |
	speed := self rotationSpeed.
	self rotationSpeed: 0.
	^ speed
]

{ #category : #moving }
WifiBotMorph >> getThenZeroSpeedVector [
	| speed |
	speed := self speedVector.
	self forwardSpeed: 0.
	^ speed
]

{ #category : #geometry }
WifiBotMorph >> heading [
	^self owner angle radiansToDegrees
]

{ #category : #geometry }
WifiBotMorph >> heading: angleInDegrees [
	self owner angle: (angleInDegrees % 360) degreesToRadians
]

{ #category : #displaying }
WifiBotMorph >> hideSensors [
	self clipSubmorphs: true.

]

{ #category : #initialization }
WifiBotMorph >> initSubmorphsAndShell [
	| displayForSetup |
	displayForSetup := self isInWorld.
	displayForSetup ifFalse: [super openInWorld].
	self addFlexShell.
	self addObstacleSensors.
	displayForSetup
		ifFalse: [self delete].

]

{ #category : #accessing }
WifiBotMorph >> leftObstacleSensor [
	^leftObstacleSensor
]

{ #category : #accessing }
WifiBotMorph >> leftObstacleSensor: anObject [
	leftObstacleSensor := anObject
]

{ #category : #initialization }
WifiBotMorph >> obstacleSensorHeight [
	^ 150
]

{ #category : #displaying }
WifiBotMorph >> openIn: aMorph [ 
	self openIn: aMorph at: self positionInArena
]

{ #category : #displaying }
WifiBotMorph >> openIn: aMorph at: aPoint [ 
	self initSubmorphsAndShell.
	self arena == aMorph ifFalse: [aMorph addMorph: self owner].
	self positionInArena: aPoint
]

{ #category : #displaying }
WifiBotMorph >> openInHand [
	self openInWorld. 
	self owner openInHand
]

{ #category : #displaying }
WifiBotMorph >> openInWorld [
	self openIn: World
]

{ #category : #geometry }
WifiBotMorph >> positionInArena [
	self arena ifNil: [ ^0@0 ].
	^self owner position - self arena position
]

{ #category : #geometry }
WifiBotMorph >> positionInArena: newPosition [
	self arena ifNil: [ ^self ].
	self owner position: newPosition + self arena position
]

{ #category : #sensing }
WifiBotMorph >> potentialObstacles [
	self arena
		ifNil: [^ #()].
	^ self arena submorphs copyWithout: self owner
]

{ #category : #accessing }
WifiBotMorph >> rightObstacleSensor [
	^rightObstacleSensor
]

{ #category : #accessing }
WifiBotMorph >> rightObstacleSensor: anObject [
	rightObstacleSensor := anObject
]

{ #category : #moving }
WifiBotMorph >> rotationSpeed [
	^ self speedLock
		critical: [rotationSpeed
				ifNil: [0] ifNotNil: [rotationSpeed]]
]

{ #category : #moving }
WifiBotMorph >> rotationSpeed: anObject [ 
	self speedLock critical: [rotationSpeed := anObject  // self speedRatio]
]

{ #category : #displaying }
WifiBotMorph >> showSensors [
	self clipSubmorphs: false.
	self ensureSensorsDisplay
]

{ #category : #moving }
WifiBotMorph >> speedLock [
	speedLock ifNil: [speedLock := Semaphore forMutualExclusion].
	^ speedLock
]

{ #category : #moving }
WifiBotMorph >> speedRatio [
	"Makes simulation run nearly realistically. Otherwise it is too fast"

	^ 5
]

{ #category : #moving }
WifiBotMorph >> speedVector [
	| headingRadians |
	headingRadians := self heading degreesToRadians.
	^(headingRadians sin @ headingRadians cos) * self forwardSpeed
]
