Class {
	#name : #WifiBotMorphOLD,
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
WifiBotMorphOLD class >> defaultImage [
	^defaultImage
]

{ #category : #initialization }
WifiBotMorphOLD class >> defaultImageFile [
	| iceRepository |
	iceRepository := IceRepository registry detect:  [ :each | each includesPackageNamed: self package name].
	^iceRepository location / 'Graphics' / 'wifiBot.png'

]

{ #category : #initialization }
WifiBotMorphOLD class >> initDefaultImage [
	defaultImage := self defaultImageFile
		binaryReadStreamDo: [ :str | ImageReadWriter formFromStream: str ]
]

{ #category : #initialization }
WifiBotMorphOLD class >> initialize [
	self initDefaultImage
]

{ #category : #'initialize-release' }
WifiBotMorphOLD >> addFlexShellIfNecessary [
	self isFlexed
		ifTrue: [^ self].
	self addFlexShell.
]

{ #category : #'initialize-release' }
WifiBotMorphOLD >> addObstacleSensors [
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
WifiBotMorphOLD >> addObstacleSensorsIfNecessary [
	self leftObstacleSensor ifNotNil: [^self].
	self addObstacleSensors 
]

{ #category : #'morphic menu' }
WifiBotMorphOLD >> addStandardHaloMenuItemsTo: aMenu hand: aHandMorph [ 
	super addStandardHaloMenuItemsTo: aMenu hand: aHandMorph.
	aMenu addLine.
	aMenu defaultTarget: self.
	[aMenu addUpdating: #toggleSensorsString translated action: #toggleSensors] 
		on: Error do: [: ex| self inform: 'ToFix: WifiBotMorph>>addStandardHaloMenuItemsTo:hand:'].
]

{ #category : #'insertion into arena' }
WifiBotMorphOLD >> addToArena: arena [
	arena addWifiBotMorph: self
]

{ #category : #accessing }
WifiBotMorphOLD >> arena [
	^self owner owner.

]

{ #category : #accessing }
WifiBotMorphOLD >> botBody [
	^botBody
]

{ #category : #accessing }
WifiBotMorphOLD >> botBody: aWifiBotBody [
	botBody := aWifiBotBody
]

{ #category : #geometry }
WifiBotMorphOLD >> centerInArena [	
	^ self positionInArena + (self extent//2)
]

{ #category : #geometry }
WifiBotMorphOLD >> centerInArena: aPoint [
	^ self owner center: aPoint
]

{ #category : #'initialize-release' }
WifiBotMorphOLD >> defaultImage [
	^self class defaultImage
]

{ #category : #displaying }
WifiBotMorphOLD >> delete [
	self isInWorld ifTrue: [self updatePositionInArena].
	self owner delete
]

{ #category : #'morphic menu' }
WifiBotMorphOLD >> ensureSensorsDisplay [
	self submorphsDo: 
			[:subMorph | 
			subMorph position: subMorph position + 1.
			subMorph position: subMorph position - 1]
]

{ #category : #accessing }
WifiBotMorphOLD >> forwardSpeed [
	^ self speedLock
		critical: [forwardSpeed
				ifNil: [0] ifNotNil: [forwardSpeed]]
]

{ #category : #accessing }
WifiBotMorphOLD >> forwardSpeed: anObject [ 
	self speedLock critical: [forwardSpeed := anObject  // self speedRatio]
]

{ #category : #accessing }
WifiBotMorphOLD >> forwardSpeed: speed rotationSpeed: angleInDegrees [ 
	self forwardSpeed: speed.
	self rotationSpeed: angleInDegrees.
	self heading: self heading + self getThenZeroRotationSpeed.
	self positionInArena: self positionInArena - self getThenZeroSpeedVector
]

{ #category : #accessing }
WifiBotMorphOLD >> getThenZeroForwardSpeed [
	| speed |
	speed := self forwardSpeed.
	self forwardSpeed: 0.
	^speed
]

{ #category : #accessing }
WifiBotMorphOLD >> getThenZeroRotationSpeed [
	| speed |
	speed := self rotationSpeed.
	self rotationSpeed: 0.
	^ speed
]

{ #category : #accessing }
WifiBotMorphOLD >> getThenZeroSpeedVector [
	| speed |
	speed := self speedVector.
	self forwardSpeed: 0.
	^ speed
]

{ #category : #accessing }
WifiBotMorphOLD >> heading [
	^self owner angle radiansToDegrees
]

{ #category : #geometry }
WifiBotMorphOLD >> heading: angleInDegrees [
	self addFlexShellIfNecessary.
	self owner angle: (angleInDegrees % 360) degreesToRadians
]

{ #category : #displaying }
WifiBotMorphOLD >> hideSensors [
	self clipSubmorphs: true
]

{ #category : #'initialize-release' }
WifiBotMorphOLD >> initSubmorphsAndShell [
	| displayForSetup |
	displayForSetup := self isInWorld.
	displayForSetup
		ifFalse: [super openInWorld].
	self addFlexShellIfNecessary.
	self addObstacleSensorsIfNecessary.
	self clipSubmorphs: true.
	displayForSetup
		ifFalse: [self delete].
	self owner layoutChanged
]

{ #category : #accessing }
WifiBotMorphOLD >> leftObstacleSensor [
	^leftObstacleSensor
]

{ #category : #accessing }
WifiBotMorphOLD >> leftObstacleSensor: anObject [
	leftObstacleSensor := anObject
]

{ #category : #'initialize-release' }
WifiBotMorphOLD >> newTransformationMorph [
	^ WifiBotTransformationMorph new
]

{ #category : #displaying }
WifiBotMorphOLD >> openIn: aMorph [ 
	| position |
	position := self positionInArena.
	self openIn: aMorph at: position
]

{ #category : #displaying }
WifiBotMorphOLD >> openIn: aMorph at: aPoint [ 
	self initSubmorphsAndShell.
	aMorph addMorph: self owner.
	self positionInArena: aPoint
]

{ #category : #displaying }
WifiBotMorphOLD >> openInHand [
	self openInWorld. 
	self showSensors.
	self owner openInHand
]

{ #category : #displaying }
WifiBotMorphOLD >> openInWorld [
	self openIn: World
]

{ #category : #geometry }
WifiBotMorphOLD >> positionInArena [
	positionInArena ifNil: [
					positionInArena := 0 @ 0].
	self isInWorld
		ifTrue: [self updatePositionInArena].
	^ positionInArena
]

{ #category : #geometry }
WifiBotMorphOLD >> positionInArena: newPosition [ 
	| deltaPosition |
	self isInWorld
		ifTrue: [deltaPosition := newPosition - self positionInArena.
			self owner position: self owner position + deltaPosition.
			self wrap].
	self updatePositionInArena.
	self botBody ifNotNil: [self botBody updateLastCenter]  
]

{ #category : #accessing }
WifiBotMorphOLD >> potentialObstacles [
	self arena
		ifNil: [^ #()].
	^ self arena submorphs copyWithout: self owner
]

{ #category : #'insertion into arena' }
WifiBotMorphOLD >> removeFromArena: arena [
	arena removeWifiBotMorph: self
]

{ #category : #accessing }
WifiBotMorphOLD >> rightObstacleSensor [
	^rightObstacleSensor
]

{ #category : #accessing }
WifiBotMorphOLD >> rightObstacleSensor: anObject [
	rightObstacleSensor := anObject
]

{ #category : #accessing }
WifiBotMorphOLD >> rotationSpeed [
	^ self speedLock
		critical: [rotationSpeed
				ifNil: [0] ifNotNil: [rotationSpeed]]
]

{ #category : #accessing }
WifiBotMorphOLD >> rotationSpeed: anObject [ 
	self speedLock critical: [rotationSpeed := anObject  // self speedRatio]
]

{ #category : #accessing }
WifiBotMorphOLD >> sensorHeight [
	^ 150
]

{ #category : #'morphic menu' }
WifiBotMorphOLD >> showSensors [
	self clipSubmorphs: false.
	self ensureSensorsDisplay
]

{ #category : #accessing }
WifiBotMorphOLD >> speedLock [
	speedLock ifNil: [speedLock := Semaphore forMutualExclusion].
	^ speedLock
]

{ #category : #accessing }
WifiBotMorphOLD >> speedRatio [
	"Makes simulation run nearly realistically. Otherwise it is too fast"

	^ 5
]

{ #category : #accessing }
WifiBotMorphOLD >> speedVector [
	| headingRadians |
	headingRadians := self heading degreesToRadians.
	^(headingRadians sin @ headingRadians cos) * self forwardSpeed
]

{ #category : #'morphic menu' }
WifiBotMorphOLD >> toggleSensors [
	self clipSubmorphs ifTrue: [^self showSensors].
	self hideSensors
]

{ #category : #'morphic menu' }
WifiBotMorphOLD >> toggleSensorsString [
	^ (self clipSubmorphs 
		ifTrue: ['<off>']
		ifFalse: ['<on>']), ' display sensors' translated
]

{ #category : #displaying }
WifiBotMorphOLD >> toggleShowDelete [
	self isInWorld
		ifTrue: [^ self delete].
	^ self openInWorld
]

{ #category : #geometry }
WifiBotMorphOLD >> updatePositionInArena [
	positionInArena := self owner position - self arena position
]

{ #category : #'initialize-release' }
WifiBotMorphOLD >> wrap [
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
