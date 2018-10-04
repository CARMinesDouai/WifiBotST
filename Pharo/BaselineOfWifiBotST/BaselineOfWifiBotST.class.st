Class {
	#name : #BaselineOfWifiBotST,
	#superclass : #BaselineOf,
	#category : #BaselineOfWifiBotST
}

{ #category : #baselines }
BaselineOfWifiBotST >> baseline: spec [ 
	<baseline>
	spec for: #common do: [ spec
		
		package: 'WifiBotST';
		package: 'WifiBotStMorphicSimulation' with: [ spec requires: #('WifiBotST') ];
		package: 'WifibotPackage' with: [ spec requires: #('WifiBotST') ];
		
		group: 'default' with: #(WifiBotST WifiBotStMorphicSimulation);
		group: 'ros' with: #( 'WifibotPackage' ) ]
]
