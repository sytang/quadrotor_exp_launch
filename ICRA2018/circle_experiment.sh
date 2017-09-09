#!/bin/bash

ROBOT="quadrotor"

echo "Disable motors..."
rosservice call /$ROBOT/mav_services/motors '{data: false}'
sleep 1

read -p "Press [Enter] to start motors"
echo "Enable motors..."
rosservice call /$ROBOT/mav_services/motors true
sleep 1

read -p "Press [Enter] to takeoff"
echo "Takeoff..."
rosservice call /$ROBOT/mav_services/takeoff
sleep 1

read -p "Press [Enter] to go to initial position"
echo "Going to position..."
rosservice call /$ROBOT/mav_services/goTo '{goal: [5.0, 0.0, 1.2, 0.0]}'
# sleep 3

read -p "Press [Enter] to switch to payload tracking"
# sleep 4
echo "Switching to payload control..."
rosservice call /$ROBOT/trackers_manager/track_payload '{data: true}'
sleep 10

# read -p "Press [Enter] to trajectory"
echo "Circling..."
rosservice call /$ROBOT/mav_services/circle "{Ax: 1.5, Ay: 1.5, T: 3.0, duration: 12.0}" 
# sleep 2
# rosservice call /$ROBOT/mav_services/goToRelative '{goal: [-3.0, 0.0, 0.0, 0.0]}'
sleep 1

# read -p "Press [Enter] to hover quadrotor" 
# echo "Hovering..."
# rosservice call /$ROBOT/mav_services/hover
# sleep 1

# read -p "Press [Enter] to switch to quad tracking"
# echo "Switching to quadrotor control..."
# rosservice call /$ROBOT/trackers_manager/track_payload '{data: false}'
# sleep 1

# read -p "Press [Enter] to go to origin"
# echo "Going to origin..."
# rosservice call /$ROBOT/mav_services/goTo "{goal: [0.0, 0.0, 2.0, 0.0]}" 
# sleep 1

# read -p "Press [Enter]"
# echo "Landing quadrotor..."
# rosservice call /$ROBOT/mav_services/eland
# sleep 1

read -p "Press [Enter]"
echo "Landing quadrotor..."
rosservice call /$ROBOT/mav_services/motors '{data: false}'
# sleep 1

# read -p "Press [Enter] to start payload landing maneuver"
# echo "Landing..."
# rosservice call /$ROBOT/mav_services/goTo "{goal: [0.0, 0.0, 0.25, 0.0]}" 
# sleep 1

# read -p "Press [Enter]"
# echo "Shifting quadrotor..."
# rosservice call /$ROBOT/mav_services/goToRelative "{goal: [0.2, 0.0, 0.0, 0.0]}" 
# sleep 1

# read -p "Press [Enter]"
# echo "Landing quadrotor..."
# rosservice call /$ROBOT/mav_services/land
# sleep 1