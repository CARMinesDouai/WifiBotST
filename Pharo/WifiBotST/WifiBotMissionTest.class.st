Class {
	#name : #WifiBotMissionTest,
	#superclass : #AbstractWifiBotTest,
	#instVars : [
		'mission'
	],
	#category : #'WifiBotST-Kernel-Test'
}

{ #category : #'setUp-tearDown' }
WifiBotMissionTest >> botClass [
	^ WifiBotStepCounter
]

{ #category : #running }
WifiBotMissionTest >> processCount [
	| nonTerminatedProcesses |
	nonTerminatedProcesses := Process allInstances
		reject: [:process | process isTerminated].
	^nonTerminatedProcesses size
]

{ #category : #'setUp-tearDown' }
WifiBotMissionTest >> setUp [
	super setUp.
	mission := WifiBotStepCounterMission bots: {  bot}
]

{ #category : #'setUp-tearDown' }
WifiBotMissionTest >> tearDown [
	super tearDown.
	mission stop
]

{ #category : #running }
WifiBotMissionTest >> testPauseResume [
	| delay stepCountOnPause |
	delay := Delay forMilliseconds: mission steppingDelayMilliseconds * 3.
	mission start.
	3 timesRepeat: [mission pause.
	self deny: mission isRunning.
	stepCountOnPause := bot stepCount.
	delay wait.
	self assert: bot stepCount = stepCountOnPause.
	mission resume.
	delay wait.
	self assert: mission isRunning.
	self assert: bot stepCount >= (stepCountOnPause + 2)]
]

{ #category : #running }
WifiBotMissionTest >> testStart [
	| delay expectedProcessCount |
	bot stepCount: 10.
	expectedProcessCount := self processCount + 1.
	mission start.
	self assert: mission isRunning.
	self assert: mission resetCount = 1.
	self assert: self processCount = expectedProcessCount.
	delay := Delay forMilliseconds: mission steppingDelayMilliseconds * 3.
	delay wait.
	self assert: bot stepCount >= 2.
	self assert: mission resetCount = 1.
	self assert: mission isRunning
]

{ #category : #running }
WifiBotMissionTest >> testStep [
	1 to: 10 do: [:expectedCount| mission step.
	self assert: bot stepCount = expectedCount]
]

{ #category : #running }
WifiBotMissionTest >> testStop [
	| delay expectedProcessCount stepCountAfterStop |
	expectedProcessCount := self processCount.
	mission start.
	mission stop.
	self deny: mission isRunning.
	stepCountAfterStop := bot stepCount.
	self assert: self processCount = expectedProcessCount.
	delay := Delay forMilliseconds: mission steppingDelayMilliseconds * 3.
	delay wait.
	self deny: mission isRunning.
	self assert: bot stepCount = stepCountAfterStop.
	self assert: self processCount = expectedProcessCount
]
