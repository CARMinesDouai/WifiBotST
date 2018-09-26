"
A WifiBotMission manages the robots stepping process that makes the robots move and act.

Instance Variables
	bots:		<Set of WifiBot>
	isRunning:		<Boolean>
	isRunningLock:		<Semaphore>
	steppingDelay:		<Delay>
	steppingDelayMilliseconds:		<Interger>
	steppingProcess:		<Process>

bots
	- Set of bots that are

isRunning
	- Flag set to true while missing is running and to false otherwise

isRunningLock
	- Semaphore that synchronizes the isRunning flag reads and writes

steppingDelay
	- Delay between to step message sends to all robots

steppingDelayMilliseconds
	- Duration of the delay between two steps

steppingProcess
	- Process that repeatedly sends step to every bot

"
Class {
	#name : #WifiBotMission,
	#superclass : #Object,
	#instVars : [
		'bots',
		'isRunning',
		'isRunningLock',
		'steppingDelayMilliseconds',
		'steppingProcess',
		'steppingDelay'
	],
	#category : #'WifiBotST-Kernel'
}

{ #category : #'instance creation' }
WifiBotMission class >> bot: aWifiBot [
	^ self new addBot: aWifiBot;
		yourself

]

{ #category : #'instance creation' }
WifiBotMission class >> bots: collectionOfBots [ 
	^ self new bots: collectionOfBots;
		 yourself
]

{ #category : #examples }
WifiBotMission class >> singleBot130Ethernet5SecondsMission [
	<example>
	| bot mission |
	bot := SimpleReactiveWifiBot bodyIp: #[192 168 0 130].
	bot forwardSpeed: 10;
		rotationSpeed: 0.	
	mission := self bot: bot.
	[mission start.
	5 seconds wait] ensure: [mission stop.]
]

{ #category : #accessing }
WifiBotMission >> addBot: aWifiBot [ 
	self bots add: aWifiBot
]

{ #category : #accessing }
WifiBotMission >> bots [
	^ bots
]

{ #category : #accessing }
WifiBotMission >> bots: aCollection [
	bots addAll: aCollection
]

{ #category : #'initialize-release' }
WifiBotMission >> defaultSteppingDelayMilliseconds [
	^ 100
]

{ #category : #'initialize-release' }
WifiBotMission >> initialize [
	super initialize.
	bots := IdentitySet new.
	isRunningLock := Semaphore forMutualExclusion.
	self steppingDelayMilliseconds: self defaultSteppingDelayMilliseconds.
	self isRunning: false
]

{ #category : #accessing }
WifiBotMission >> isRunning [
	^isRunningLock
				critical: [isRunning]
]

{ #category : #accessing }
WifiBotMission >> isRunning: boolean [ 
	isRunningLock critical: [isRunning := boolean]
]

{ #category : #'running-private' }
WifiBotMission >> pause [
	self isRunning: false
]

{ #category : #accessing }
WifiBotMission >> removeBot: aWifiBot [ 
	self bots remove: aWifiBot ifAbsent: []
]

{ #category : #'running-private' }
WifiBotMission >> reset [
	^self
]

{ #category : #'running-private' }
WifiBotMission >> resetSteppingDelay [
	self steppingDelay: (Delay forMilliseconds: self steppingDelayMilliseconds)
]

{ #category : #'running-private' }
WifiBotMission >> resume [
	| newProcess |
	self isRunning ifTrue: [ ^ self ].
	self resetSteppingDelay.
	self isRunning: true.
	newProcess := 
	[ self run.
	self stopAllBots ] newProcess.
	self steppingProcess: newProcess.
	newProcess resume
]

{ #category : #'running-private' }
WifiBotMission >> run [
	[ self isRunning ] whileTrue: 
		[ self step.
		self steppingDelay wait ]
]

{ #category : #'running-public' }
WifiBotMission >> start [
	self reset.
	self resume
]

{ #category : #'running-public' }
WifiBotMission >> step [
	self bots do: [:bot| bot step]
]

{ #category : #accessing }
WifiBotMission >> steppingDelay [
	^ steppingDelay
]

{ #category : #accessing }
WifiBotMission >> steppingDelay: anObject [
	steppingDelay := anObject
]

{ #category : #accessing }
WifiBotMission >> steppingDelayMilliseconds [
	^steppingDelayMilliseconds
]

{ #category : #accessing }
WifiBotMission >> steppingDelayMilliseconds: anObject [
	steppingDelayMilliseconds := anObject
]

{ #category : #accessing }
WifiBotMission >> steppingProcess [
	^steppingProcess
]

{ #category : #accessing }
WifiBotMission >> steppingProcess: anObject [
	steppingProcess := anObject
]

{ #category : #accessing }
WifiBotMission >> steppingProcessIsTerminated [
	self steppingProcess ifNil: [^true].
	^self steppingProcess isTerminated
]

{ #category : #'running-public' }
WifiBotMission >> stop [
	self isRunning: false.
	[self steppingProcessIsTerminated]
		whileFalse: [Processor yield]
]

{ #category : #'running-private' }
WifiBotMission >> stopAllBots [
	^ self bots do: 
		[ :bot | 
		bot body 
			forwardSpeed: 0
			rotationSpeed: 0.
		bot body commitActuatorValues ]
]
