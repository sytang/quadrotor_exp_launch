#!/bin/bash

ROBOT="QuadrotorDopey"

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
rosservice call /$ROBOT/mav_services/goTo '{goal: [0.0, 0.0, 3.0, 0.0]}'
sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to payload control..."
rosservice call /$ROBOT/trackers_manager/track_payload '{data: true}'
sleep 1

read -p "Press [Enter] to start circle"
echo "Circling..."
rosservice call /$ROBOT/mav_services/circle "{Ax: 1, Ay: 0.5, T: 10.0, duration: 20.0}" 
sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to quadrotor control..."
rosservice call /$ROBOT/trackers_manager/track_payload '{data: false}'
sleep 1

read -p "Press [Enter] to hover quadrotor" 
echo "Hovering..."
rosservice call /$ROBOT/mav_services/hover
sleep 1

read -p "Press [Enter] to go to origin"
echo "Going to origin..."
rosservice call /$ROBOT/mav_services/goTo "{goal: [0.0, 0.0, 2.0, 0.0]}" 
sleep 1

read -p "Press [Enter] to start payload landing maneuver"
echo "Landing..."
rosservice call /$ROBOT/mav_services/goTo "{goal: [0.0, 0.0, 0.25, 0.0]}" 
sleep 1

read -p "Press [Enter]"
echo "Shifting quadrotor..."
rosservice call /$ROBOT/mav_services/goToRelative "{goal: [0.2, 0.0, 0.0, 0.0]}" 
sleep 1

read -p "Press [Enter]"
echo "Landing quadrotor..."
rosservice call /$ROBOT/mav_services/land
sleep 1