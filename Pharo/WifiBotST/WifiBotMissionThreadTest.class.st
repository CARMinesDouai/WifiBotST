Class {
	#name : #WifiBotMissionThreadTest,
	#superclass : #WifiBotMissionTest,
	#instVars : [
		'missionThread'
	],
	#category : #'WifiBotST-Kernel-Test'
}

{ #category : #'setUp-tearDown' }
WifiBotMissionThreadTest >> tearDown [
	super tearDown.
	missionThread terminate
]

{ #category : #running }
WifiBotMissionThreadTest >> testMultipleResumesDoNotCreateManyThreads [
	mission resume.
	missionThread := mission steppingProcess.
	mission resume.
	self assert: mission steppingProcess == missionThread
]

{ #category : #running }
WifiBotMissionThreadTest >> testMultipleStartsDoNotCreateManyThreads [
	mission start.
	missionThread := mission steppingProcess.
	mission start.
	self assert: mission steppingProcess == missionThread
]
