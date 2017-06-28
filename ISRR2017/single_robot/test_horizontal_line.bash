#!/bin/bash

ROBOT="QuadrotorHappy"

read -p "Press [Enter] to start motors"
echo "Enable motors..."
rosservice call /${ROBOT}/mav_services/motors true
sleep 1

read -p "Press [Enter] to takeoff"
echo "Takeoff..."
rosservice call /${ROBOT}/mav_services/takeoff
sleep 1

read -p "Press [Enter] to go to initial position"
echo "Going to position..."
rosservice call /${ROBOT}/mav_services/goTo '{goal: [-0.6, -0.8, 1.3, 0.0]}'
sleep 1

read -p "Press [Enter] to send trajectory Line"
echo "Sending Line..."
rosservice call /${ROBOT}/test_line/SendTrajAction 1
sleep 1

read -p "Press [Enter] to follow trajectory Line"
echo "Tracking Line..."
rosservice call /${ROBOT}/trackers_manager/transition "tracker: 'payload_trackers/PointloadFFTrackerAction'" 
sleep 1
