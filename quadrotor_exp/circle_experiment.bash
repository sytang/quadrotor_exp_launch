#!/bin/bash

ROBOT="QuadrotorVictor"

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

read -p "Press [Enter] to start circle"
echo "Circling..."
rosservice call /$ROBOT/mav_services/circle "{Ax: 1.5, Ay: 1.0, T: 8.0, duration: 8.0}" 
sleep 1

read -p "Press [Enter] to hover quadrotor" 
echo "Hovering..."
rosservice call /$ROBOT/mav_services/hover
sleep 1
