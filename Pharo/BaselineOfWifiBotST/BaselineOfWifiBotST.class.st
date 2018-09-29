Class {
	#name : #BaselineOfWifiBotST,
	#superclass : #BaselineOf,
	#category : #BaselineOfWifiBotST
}

{ #category : #baselines }
BaselineOfWifiBotST >> baseline: spec [ 
	<baseline>
	spec for: #common do: [ spec
		
		package: 'WifiBotST-Legacy';
		package: 'WifiBotST' with: [ spec requires: #('WifiBotST-Legacy') ];
		package: 'WifibotPackage' with: [ spec requires: #('WifiBotST') ];
		
		group: 'default' with: #(WifiBotST);
		group: 'ros' with: #( 'WifibotPackage' ) ]
]
