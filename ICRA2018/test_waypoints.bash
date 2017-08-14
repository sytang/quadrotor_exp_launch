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
rosservice call /$ROBOT/mav_services/goTo '{goal: [-3.0, 1.0, 1.0, 0.0]}'
sleep 1

read -p "Press [Enter] to load trajectory waypoints"
echo "Loading waypoints..."
rosservice call /$ROBOT/mav_services/loadWaypoints "{x: [-5.0, -3.0, 2.0], y: [1.0, 0.0, 0.2], z: [1.0, 1.5, 1.2], yaw: [0.0, 0.0, 0.0], vdes: 0.5}" 
sleep 1

read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /$ROBOT/mav_services/followWaypoints "{relative: true}" 
sleep 1

