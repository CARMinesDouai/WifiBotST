# Catkin package for WifiBot robots


## Installation
		
		cd <catkin_dir>/src
		git clone https://github.com/CARMinesDouai/wifibot.git
		cd wifibot
		./install/installInPhaROS5.sh

		rosrun wifibot edit

# Usage
		
		roscore

		rosrun wifibot headless wifibotpackage_start

		rostopic pub -1 /cmd_vel geometry_msgs/Twist "linear:
			x: 0.1
			y: 0.0
			z: 0.0
		angular:
			x: 0.0
			y: 0.0
			z: 0.0"


				


