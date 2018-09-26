"
A WifiBotHardware is the reification of the physical WifiBot.

Instance Variables
	botIp:		<ByteArray with 4 bytes>
	motorValues:		<ByteArray with 2 bytes>
	sensorValues:		<ByteArray with 7 bytes>
	socket:		<Socket>

botIp
	- IP to access the robot

motorValues
	- Bytes that are to send to the motor to set the speed and the orientation of the motors. First element = left motor. Second element = right motor

sensorValues
	- Bytes that are read from the sensors

socket
	- Connects to the actual bot

"
Class {
	#name : #RealWifiBotBody,
	#superclass : #WifiBotBody,
	#instVars : [
		'ip',
		'socket',
		'sensorValues',
		'motorValues'
	],
	#category : #'WifiBotST-Kernel'
}

{ #category : #'instance creation' }
RealWifiBotBody class >> ip: ipAddressArray [
	^self new
		ip: ipAddressArray;
		yourself
]

{ #category : #sensing }
RealWifiBotBody >> batteryLevel [
	^self sensorValues at: 1
]

{ #category : #running }
RealWifiBotBody >> commitActuatorValues [
	self writeMotorsAndReadSensorsOnDisconnectionRetry: self defaultRetryTimes
]

{ #category : #running }
RealWifiBotBody >> defaultRetryTimes [
	^3
]

{ #category : #sensing }
RealWifiBotBody >> distanceToLeftObstacles [
	self leftWheelSpeedsAreDifferent ifTrue: [^0].
	^ 150
		- (self sensorValues at: 6)
]

{ #category : #sensing }
RealWifiBotBody >> distanceToRightObstacles [
	self rightWheelSpeedsAreDifferent
		ifTrue: [^ 0].
	^ 150
		- (self sensorValues at: 7)
]

{ #category : #'initialize-release' }
RealWifiBotBody >> finalize [
	super finalize.
	socket ifNotNil: [socket closeAndDestroy]
]

{ #category : #moving }
RealWifiBotBody >> forwardSpeed: forwardSpeed rotationSpeed: rotationSpeed [ 
	| leftSpeed rightSpeed leftSpeedNormalized rightSpeedNormalized |
	leftSpeed := forwardSpeed + rotationSpeed.
	rightSpeed := forwardSpeed - rotationSpeed.
	leftSpeedNormalized := self normalizedSpeedFrom: leftSpeed.
	rightSpeedNormalized := self normalizedSpeedFrom: rightSpeed.
	self leftMotorSpeed: leftSpeedNormalized rightMotorSpeed: rightSpeedNormalized
]

{ #category : #sensing }
RealWifiBotBody >> frontLeftWheelSpeed [
	"Unit = ticks"
	"max 40 ticks / 41 ms == max about 1 tick per ms"
	^self sensorValues at: 2
]

{ #category : #sensing }
RealWifiBotBody >> frontRightWheelSpeed [
	"Unit = ticks"
	"max 40 ticks / 41 ms == max about 1 tick per ms"
	^ self sensorValues at: 4
]

{ #category : #'initialize-release' }
RealWifiBotBody >> initSocket [
	Socket initializeNetwork.
	socket := Socket newTCP.
	socket connectTo: self ip asByteArray port: 15000.
	socket waitForConnectionFor: 10
]

{ #category : #'initialize-release' }
RealWifiBotBody >> initialize [
	self motorValues: (ByteArray new: 2).
	super initialize.
	self sensorValues: (ByteArray new: 7)
]

{ #category : #accessing }
RealWifiBotBody >> ip [
	^ ip
]

{ #category : #accessing }
RealWifiBotBody >> ip: ipAddressArray [ 
	ip := ipAddressArray asByteArray
]

{ #category : #moving }
RealWifiBotBody >> leftMotorSpeed [
	| leftMotorValue |
	leftMotorValue := self motorValues at: 1.
	^self speedFromMotorValue: leftMotorValue
]

{ #category : #moving }
RealWifiBotBody >> leftMotorSpeed: leftSpeed rightMotorSpeed: rightSpeed [ 
	| leftMotorValue rightMotorSpeed |
	leftMotorValue := self motorValueFromSpeed: leftSpeed.
	rightMotorSpeed := self motorValueFromSpeed: rightSpeed.
	self motorValues at: 1 put: leftMotorValue;
		 at: 2 put: rightMotorSpeed
]

{ #category : #sensing }
RealWifiBotBody >> leftWheelSpeedsAreDifferent [
	^ (self frontLeftWheelSpeed - self rearLeftWheelSpeed) abs > 5
]

{ #category : #moving }
RealWifiBotBody >> maxAbsoluteSpeed [
	^ 40
]

{ #category : #moving }
RealWifiBotBody >> maxMotorBackwardValue [
	"Bit 8 (highest) set to 1 for control
	Bit 7 set 1 for forward speed
	Rest for the actual speed 0-40 with control and 0-60 without control (bit 8 set to 0)
	
	here we use control
	"
	^ 168
]

{ #category : #moving }
RealWifiBotBody >> maxMotorForwardValue [
	"Bit 8 (highest) set to 1 for control
	Bit 7 set 1 for forward speed
	Rest for the actual speed 0-40 with control and 0-60 without control (bit 8 set to 0)
	
	Here we use control"
	^ 232
]

{ #category : #running }
RealWifiBotBody >> millisecondsBetweenReadWriteAttempts [
	^1000
]

{ #category : #moving }
RealWifiBotBody >> minAbsoluteSpeed [
	^ 0
]

{ #category : #moving }
RealWifiBotBody >> minMotorBackwardValue [
	^ 128
]

{ #category : #moving }
RealWifiBotBody >> minMotorForwardValue [
	^ 192
]

{ #category : #moving }
RealWifiBotBody >> motorValueFromNegativeSpeed: motorSpeed [ 
	| rawValue |
	rawValue := motorSpeed abs + self minMotorBackwardValue.
	^ rawValue min: self maxMotorBackwardValue
]

{ #category : #moving }
RealWifiBotBody >> motorValueFromPositiveSpeed: motorSpeed [ 
	| rawValue |
	rawValue := motorSpeed + self minMotorForwardValue.
	^ rawValue min: self maxMotorForwardValue
]

{ #category : #moving }
RealWifiBotBody >> motorValueFromSpeed: speed [ 
	speed >= 0
		ifTrue: [^ self motorValueFromPositiveSpeed: speed].
	^ self motorValueFromNegativeSpeed: speed
]

{ #category : #moving }
RealWifiBotBody >> motorValues [
	^ motorValues
]

{ #category : #moving }
RealWifiBotBody >> motorValues: twoByteArray [
	motorValues := twoByteArray
]

{ #category : #moving }
RealWifiBotBody >> normalizedSpeedFrom: speed [ 
	"Answers a speed that actually allows moving the bot. If the speed is too low the bot don'''t move because of high friction"
	| normilzedSpeedAbs |
	speed = 0
		ifTrue: [^ 0].
	normilzedSpeedAbs := speed abs min: self maxAbsoluteSpeed.
	^ speed sign * normilzedSpeedAbs
]

{ #category : #sensing }
RealWifiBotBody >> rearLeftWheelSpeed [
	"Unit = ticks"
	"max 40 ticks / 41 ms == max about 1 tick per ms"
	^ self sensorValues at: 3
]

{ #category : #sensing }
RealWifiBotBody >> rearRightWheelSpeed [
	"Unit = ticks"
	"max 40 ticks / 41 ms == max about 1 tick per ms"
	^ self sensorValues at: 5
]

{ #category : #moving }
RealWifiBotBody >> rightMotorSpeed [
	| rightMotorValue |
	rightMotorValue := self motorValues at: 2.
	^ self speedFromMotorValue: rightMotorValue
]

{ #category : #sensing }
RealWifiBotBody >> rightWheelSpeedsAreDifferent [
	^ (self frontRightWheelSpeed - self rearRightWheelSpeed) abs > 5
]

{ #category : #sensing }
RealWifiBotBody >> sensorValues [
	^sensorValues
]

{ #category : #sensing }
RealWifiBotBody >> sensorValues: valuesByteArray [
	^ sensorValues := valuesByteArray 
]

{ #category : #accessing }
RealWifiBotBody >> socket [
	(socket isNil or: [socket isConnected not])
		ifTrue: [self initSocket].
	^ socket
]

{ #category : #moving }
RealWifiBotBody >> speedFromMotorValue: motorValue [ 
	motorValue <= self maxMotorBackwardValue ifTrue: [^ motorValue negated + self minMotorBackwardValue].
	^ motorValue - self minMotorForwardValue
]

{ #category : #running }
RealWifiBotBody >> updateSensorValues [
	"Need to send data to the bot before getting sensor values"
	self writeMotorsAndReadSensorsOnDisconnectionRetry: self defaultRetryTimes
]

{ #category : #sensing }
RealWifiBotBody >> wheelSpeeds [
	^self sensorValues copyFrom: 2 to: 5
]

{ #category : #running }
RealWifiBotBody >> writeMotorsAndReadSensorsOnDisconnectionRetry: attempts [ 
	
	[self socket sendData: self motorValues.
	^self socket receiveDataInto: self sensorValues ] 
		on: ConnectionTimedOut
		do: [ :ex | attempts = 1 ifTrue: [ ex signal ] ].
	(Delay forMilliseconds: self millisecondsBetweenReadWriteAttempts) wait.
	self writeMotorsAndReadSensorsOnDisconnectionRetry: attempts - 1
]
