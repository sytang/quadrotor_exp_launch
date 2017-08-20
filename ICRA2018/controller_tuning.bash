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

read -p "Press [Enter] to hover in place"
echo "Hovering..."
rosservice call /$ROBOT/mav_services/hover
sleep 1

#read -p "Press [Enter] to go to initial position"
#echo "Going to position..."
#rosservice call /$ROBOT/mav_services/goTo '{goal: [0.0, 0.0, 1.5, 0.0]}'
#sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to payload control..."
rosservice call /$ROBOT/trackers_manager/track_payload '{data: true}'
sleep 1

read -p "Press [Enter] shift setpoint"
echo "Moving right..."
rosservice call /$ROBOT/mav_services/goToRelative '{goal: [1.0, 0.0, 0.0, 0.0]}'
sleep 1

read -p "Press [Enter] to switch to quadrotor tracking"
echo "Switching to quadrotor control..."
rosservice call /$ROBOT/trackers_manager/track_payload '{data: false}'
sleep 1