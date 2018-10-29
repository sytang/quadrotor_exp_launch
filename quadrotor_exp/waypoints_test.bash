#!/bin/bash

ROBOT="QuadrotorVictor"

read -p "Press [Enter] to start motors"
echo "Enable motors..."
rosservice call /QuadrotorVictor/mav_services/motors true
sleep 1

read -p "Press [Enter] to takeoff"
echo "Takeoff..."
rosservice call /QuadrotorVictor/mav_services/takeoff
sleep 1

read -p "Press [Enter] to go higher"
echo "Going up..."
rosservice call /QuadrotorVictor/mav_services/goTo '{goal: [0.0, 0.0, 1.0, 0.0]}'
sleep 1

read -p "Press [Enter] to go to x = 3"
echo "Going..."
rosservice call /QuadrotorVictor/mav_services/goTo '{goal: [3.0, 0.0, 1.0, 0.0]}'
sleep 1

read -p "Press [Enter] to go to x = 1"
echo "Going..."
rosservice call /QuadrotorVictor/mav_services/goTo '{goal: [1.0, 0.0, 1.0, 0.0]}'
sleep 1

read -p "Press [Enter] to go to relative y = 0.5"
echo "Going..."
rosservice call /QuadrotorVictor/mav_services/goToRelative '{goal: [0.0, 0.5, 0.0, 0.0]}'
sleep 1

read -p "Press [Enter] to go to origin"
echo "Going..."
rosservice call /QuadrotorVictor/mav_services/goTo '{goal: [0.0, 0.0, 1.0, 0.0]}'
sleep 1

read -p "Press [Enter] to test velocity tracking"
echo "Going..."
rosservice call /QuadrotorVictor/mav_services/setDesVelInWorldFrame '{goal: [0.2, 0.1, 0.0, 0.0]}'
sleep 1

read -p "Press [Enter] to hover"
rosservice call /QuadrotorVictor/mav_services/hover
sleep 1

read -p "Press [Enter] to test yaw relative"
echo "Going..."
rosservice call /QuadrotorVictor/mav_services/goToRelative '{goal: [0.0, 0.0, 0.0, 1.5]}'
sleep 1

read -p "Press [Enter] to test body-frame velocity tracking"
echo "Going..."
rosservice call /QuadrotorVictor/mav_services/setDesVelInBodyFrame '{goal: [0.2, 0.0, 0.0, 0.0]}'
sleep 1

read -p "Press [Enter] to hover"
rosservice call /QuadrotorVictor/mav_services/hover
sleep 1

read -p "Press [Enter] to land"
rosservice call /QuadrotorVictor/mav_services/land

read -p "Press [Enter] to stop motors"
echo "Enable motors..."
rosservice call /QuadrotorVictor/mav_services/motors false