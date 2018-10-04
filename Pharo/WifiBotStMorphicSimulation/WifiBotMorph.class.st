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

{ #category : #'initialize-release' }
WifiBotMorph >> addFlexShellIfNecessary [
	self isFlexed
		ifTrue: [^ self].
	self addFlexShell.
]

{ #category : #'initialize-release' }
WifiBotMorph >> addObstacleSensors [
	| halfWidth halfWidthIntegerPart leftSensorWidth rightSensorWidth sensorsYOrigin |
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
	sensorsYOrigin := self sensorHeight negated.
	self leftObstacleSensor width: leftSensorWidth;
		 height: self sensorHeight;
		 position: 0 @ sensorsYOrigin;
		 color: Color red.
	self rightObstacleSensor width: rightSensorWidth;
		 height: self sensorHeight;
		 position: leftSensorWidth + 1 @ sensorsYOrigin;
		 color: Color red.
]

{ #category : #'initialize-release' }
WifiBotMorph >> addObstacleSensorsIfNecessary [
	self leftObstacleSensor ifNotNil: [^self].
	self addObstacleSensors 
]

{ #category : #'morphic menu' }
WifiBotMorph >> addStandardHaloMenuItemsTo: aMenu hand: aHandMorph [ 
	super addStandardHaloMenuItemsTo: aMenu hand: aHandMorph.
	aMenu addLine.
	aMenu defaultTarget: self.
	[aMenu addUpdating: #toggleSensorsString translated action: #toggleSensors] 
		on: Error do: [: ex| self inform: 'ToFix: WifiBotMorph>>addStandardHaloMenuItemsTo:hand:'].
]

{ #category : #'insertion into arena' }
WifiBotMorph >> addToArena: arena [
	arena addWifiBotMorph: self
]

{ #category : #accessing }
WifiBotMorph >> arena [
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
	^ self owner center
]

{ #category : #geometry }
WifiBotMorph >> centerInArena: aPoint [
	^ self owner center: aPoint
]

{ #category : #'initialize-release' }
WifiBotMorph >> defaultImage [
	^self class defaultImage
]

{ #category : #displaying }
WifiBotMorph >> delete [
	self isInWorld ifTrue: [self updatePositionInArena].
	self owner delete
]

{ #category : #'morphic menu' }
WifiBotMorph >> ensureSensorsDisplay [
	self submorphsDo: 
			[:subMorph | 
			subMorph position: subMorph position + 1.
			subMorph position: subMorph position - 1]
]

{ #category : #accessing }
WifiBotMorph >> forwardSpeed [
	^ self speedLock
		critical: [forwardSpeed
				ifNil: [0] ifNotNil: [forwardSpeed]]
]

{ #category : #accessing }
WifiBotMorph >> forwardSpeed: anObject [ 
	self speedLock critical: [forwardSpeed := anObject  // self speedRatio]
]

{ #category : #accessing }
WifiBotMorph >> forwardSpeed: speed rotationSpeed: angleInDegrees [ 
	self forwardSpeed: speed.
	self rotationSpeed: angleInDegrees.
	self heading: self heading + self getThenZeroRotationSpeed.
	self positionInArena: self positionInArena - self getThenZeroSpeedVector
]

{ #category : #accessing }
WifiBotMorph >> getThenZeroForwardSpeed [
	| speed |
	speed := self forwardSpeed.
	self forwardSpeed: 0.
	^speed
]

{ #category : #accessing }
WifiBotMorph >> getThenZeroRotationSpeed [
	| speed |
	speed := self rotationSpeed.
	self rotationSpeed: 0.
	^ speed
]

{ #category : #accessing }
WifiBotMorph >> getThenZeroSpeedVector [
	| speed |
	speed := self speedVector.
	self forwardSpeed: 0.
	^ speed
]

{ #category : #accessing }
WifiBotMorph >> heading [
	^self owner angle radiansToDegrees
]

{ #category : #geometry }
WifiBotMorph >> heading: angleInDegrees [
	self addFlexShellIfNecessary.
	self owner angle: (angleInDegrees % 360) degreesToRadians
]

{ #category : #'morphic menu' }
WifiBotMorph >> hideSensors [
	self clipSubmorphs: true
]

{ #category : #'initialize-release' }
WifiBotMorph >> initSubmorphsAndShell [
	| displayForSetup |
	self addObstacleSensorsIfNecessary.
	displayForSetup := self isInWorld.
	displayForSetup
		ifFalse: [super openInWorld].
	self addFlexShellIfNecessary.
	self clipSubmorphs: true.
	displayForSetup
		ifFalse: [self delete].
	self owner layoutChanged
]

{ #category : #accessing }
WifiBotMorph >> leftObstacleSensor [
	^leftObstacleSensor
]

{ #category : #accessing }
WifiBotMorph >> leftObstacleSensor: anObject [
	leftObstacleSensor := anObject
]

{ #category : #'initialize-release' }
WifiBotMorph >> newTransformationMorph [
	^ WifiBotTransformationMorph new
]

{ #category : #displaying }
WifiBotMorph >> openIn: aMorph [ 
	| position |
	position := self positionInArena.
	self openIn: aMorph at: position
]

{ #category : #displaying }
WifiBotMorph >> openIn: aMorph at: aPoint [ 
	self initSubmorphsAndShell.
	aMorph addMorph: self owner.
	self positionInArena: aPoint
]

{ #category : #displaying }
WifiBotMorph >> openInHand [
	self openInWorld. 
	self showSensors.
	self owner openInHand
]

{ #category : #displaying }
WifiBotMorph >> openInWorld [
	self openIn: World
]

{ #category : #geometry }
WifiBotMorph >> positionInArena [
	positionInArena ifNil: [
					positionInArena := 0 @ 0].
	self isInWorld
		ifTrue: [self updatePositionInArena].
	^ positionInArena
]

{ #category : #geometry }
WifiBotMorph >> positionInArena: newPosition [ 
	| deltaPosition |
	self isInWorld
		ifTrue: [deltaPosition := self positionInArena - newPosition.
			self owner position: self owner position - deltaPosition.
			self wrap].
	positionInArena := self positionInArena.
	self botBody ifNotNil: [self botBody updateLastCenter]  
]

{ #category : #accessing }
WifiBotMorph >> potentialObstacles [
	self arena
		ifNil: [^ #()].
	^ self arena submorphs copyWithout: self owner
]

{ #category : #'insertion into arena' }
WifiBotMorph >> removeFromArena: arena [
	arena removeWifiBotMorph: self
]

{ #category : #accessing }
WifiBotMorph >> rightObstacleSensor [
	^rightObstacleSensor
]

{ #category : #accessing }
WifiBotMorph >> rightObstacleSensor: anObject [
	rightObstacleSensor := anObject
]

{ #category : #accessing }
WifiBotMorph >> rotationSpeed [
	^ self speedLock
		critical: [rotationSpeed
				ifNil: [0] ifNotNil: [rotationSpeed]]
]

{ #category : #accessing }
WifiBotMorph >> rotationSpeed: anObject [ 
	self speedLock critical: [rotationSpeed := anObject  // self speedRatio]
]

{ #category : #accessing }
WifiBotMorph >> sensorHeight [
	^ 150
]

{ #category : #'morphic menu' }
WifiBotMorph >> showSensors [
	self clipSubmorphs: false.
	self ensureSensorsDisplay
]

{ #category : #accessing }
WifiBotMorph >> speedLock [
	speedLock ifNil: [speedLock := Semaphore forMutualExclusion].
	^ speedLock
]

{ #category : #accessing }
WifiBotMorph >> speedRatio [
	"Makes simulation run nearly realistically. Otherwise it is too fast"

	^ 5
]

{ #category : #accessing }
WifiBotMorph >> speedVector [
	| headingRadians |
	headingRadians := self heading degreesToRadians.
	^(headingRadians sin @ headingRadians cos) * self forwardSpeed
]

{ #category : #'morphic menu' }
WifiBotMorph >> toggleSensors [
	self clipSubmorphs ifTrue: [^self showSensors].
	self hideSensors
]

{ #category : #'morphic menu' }
WifiBotMorph >> toggleSensorsString [
	^ (self clipSubmorphs 
		ifTrue: ['<off>']
		ifFalse: ['<on>']), ' display sensors' translated
]

{ #category : #displaying }
WifiBotMorph >> toggleShowDelete [
	self isInWorld
		ifTrue: [^ self delete].
	^ self openInWorld
]

{ #category : #geometry }
WifiBotMorph >> updatePositionInArena [
	positionInArena := self point: self position in: self arena
]

{ #category : #'initialize-release' }
WifiBotMorph >> wrap [
"backport of the method Morph>>wrap that has been removed in Pharo"
	
| myBox box newX newY wrapped myTransfoMorph arena |
	
	myTransfoMorph := self owner.
	arena := myTransfoMorph owner.
	arena ifNil: [^ self].
	myBox := myTransfoMorph fullBounds.
	myBox corner < (50000@50000) ifFalse: [
		myTransfoMorph inform: 'Who is trying to wrap a hidden object?'. ^ self].
	box := arena bounds.
	newX := myTransfoMorph position x.
	newY := myTransfoMorph position y.
	wrapped := false.
	((myBox right < box left) or: [myBox left > box right]) ifTrue: [
		newX := box left + ((myTransfoMorph position x - box left) \\ box width).
		wrapped := true].
	((myBox bottom < box top) or: [myBox top > box bottom]) ifTrue: [
		newY := box top + ((myTransfoMorph position y - box top) \\ box height).
		wrapped := true].
	myTransfoMorph position: newX@newY.
	wrapped ifTrue: [arena changed.].  "redraw all turtle trails if wrapped"

]
