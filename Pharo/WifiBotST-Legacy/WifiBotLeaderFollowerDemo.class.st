"
A leader robot (with infra-red sensors range displayed) has to go to four location (blue dots) while avoiding obstacles and collisions with other robots. Two followers have to keep close to the leader. Because, there is no cooperation, the leader gets sometimes blocked by the two followers and has to find another path to its target.

To run the demo, evaluate the following in a workspace

""demo := WifiBotLeaderFollowerDemo new.
demo show.
demo reset.
demo start.""

The following allows stopping the demo
""demo stop.""

"
Class {
	#name : #WifiBotLeaderFollowerDemo,
	#superclass : #Object,
	#instVars : [
		'arena',
		'leader',
		'mission',
		'window',
		'bot1',
		'bot2'
	],
	#category : #'WifiBotST-Legacy-BotExamples'
}

{ #category : #'life-cycle' }
WifiBotLeaderFollowerDemo >> hide [
	window delete
]

{ #category : #'initialize-release' }
WifiBotLeaderFollowerDemo >> initialize [
	mission := WifiBotMission new.
	arena := ArenaForMorphicWifiBot new.
	arena mission: mission.
	arena
		close;
		width: 1000;
		height: 600.
	leader := PathFollowerWifiBot morphic.
	leader pathPoints: {
		200@175. 
		200@500.
		800@500.
		800@175}.
	bot1 := FollowerWifiBot morphic.
	bot2 := FollowerWifiBot morphic.
	bot2 body openIn: arena.
	bot2 body positionInArena: 600 @ 200.
	leader forwardSpeed: 40.
	bot1 forwardSpeed: 40.
	bot2 forwardSpeed: 40.
	bot1 target: leader body positionInArena.
	bot2 target: leader body positionInArena.
	bot1 addbot: leader.
	bot2 addbot: leader.

]

{ #category : #'life-cycle' }
WifiBotLeaderFollowerDemo >> reset [
	leader target: leader pathPoints first.
	{leader. bot1. bot2} with: self robotsInitialPositions do: [:bot :center|
		bot stepsToWaitBeforeHeadingTowardsTarget: 0.
		bot body heading: 0.
		bot body centerInArena: center].

]

{ #category : #'life-cycle' }
WifiBotLeaderFollowerDemo >> robotsInitialPositions [
	^ {  (500 @ 300). (550 @ 400). (450 @ 400)  }
]

{ #category : #'life-cycle' }
WifiBotLeaderFollowerDemo >> show [
	| targetMorph obstacle |
	window := arena openInWindowLabeled: 'Leader and Two Followers'.
	window position: 0 @ 0.
	leader pathPoints do: 
		[ :each | 
		targetMorph := CircleMorph new.
		targetMorph color: Color blue.
		window addMorph: targetMorph.
		targetMorph center: each ].
	{  (0 @ 320). (500 @ 500). (750 @ 320). (500 @ 0)  } 
		with: { 
				(300 @ 50).
				(50 @ 200).
				(300 @ 50).
				(50 @ 200)
			 }
		do: 
			[ :center :widthHeight | 
			obstacle := RectangleMorph new.
			obstacle color: Color black.
			arena addMorph: obstacle.
			obstacle center: center.
			obstacle width: widthHeight x.
			obstacle height: widthHeight y ].
	{  leader. bot1. bot2  } 
		with: self robotsInitialPositions
		do: 
			[ :bot :center | 
			bot body openIn: arena.
			bot body scaleWithFactor: 0.5.
			bot body centerInArena: center ].
	leader body showSensors
]

{ #category : #'life-cycle' }
WifiBotLeaderFollowerDemo >> showAndStart [
	self show.
	self start.
	
]

{ #category : #'life-cycle' }
WifiBotLeaderFollowerDemo >> start [
	mission start.
	
]

{ #category : #'life-cycle' }
WifiBotLeaderFollowerDemo >> stop [
	mission stop.

]

{ #category : #'life-cycle' }
WifiBotLeaderFollowerDemo >> stopAndHide [
	self stop.
	self hide
]
