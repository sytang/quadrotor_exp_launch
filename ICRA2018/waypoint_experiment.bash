#!/bin/bash

ROBOT="QuadrotorHappy"

read -p "Press [Enter] to start motors"
echo "Enable motors..."
rosservice call /$ROBOT/mav_services/motors true
sleep 1

read -p "Press [Enter] to takeoff"
echo "Takeoff..."
rosservice call /$ROBOT/mav_services/takeoff
sleep 1

#read -p "Press [Enter] to go to initial position"
#echo "Going to position..."
#rosservice call /$ROBOT/mav_services/goTo '{goal: [0.0, 0.0, 3.0, 0.0]}'
#sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to payload control..."
rosservice call /$ROBOT/trackers_manager/track_payload '{data: true}'
sleep 1

read -p "Press [Enter] to load trajectory waypoints"
echo "Loading waypoints..."
rosservice call /$ROBOT/mav_services/loadWaypoints "{x: [0.0, 0.5], y: [0.0, 0.0], z: [0.0, 0.0], yaw: [0.0, 0.0], vdes: 0.2, cost: 6}" 
sleep 1

read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /$ROBOT/mav_services/followWaypoints "{relative: true}" 
sleep 1

read -p "Press [Enter] to load trajectory waypoints"
echo "Loading waypoints..."
rosservice call /$ROBOT/mav_services/loadWaypoints "{x: [0.0, -7.0], y: [0.0, 0.0], z: [0.0, -0.3], yaw: [0.0, 0.0], vdes: 0.2, cost: 6}" 
sleep 1

read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /$ROBOT/mav_services/followWaypoints "{relative: true}" 
sleep 1

read -p "Press [Enter] to hover quadrotor" 
echo "Switching to quadrotor control..."
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