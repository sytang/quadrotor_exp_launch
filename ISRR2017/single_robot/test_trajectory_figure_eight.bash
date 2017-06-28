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

read -p "Press [Enter] to go to initial position"
echo "Going to position..."
rosservice call /QuadrotorVictor/mav_services/goTo '{goal: [-2.0, 1.0, 2.0, 0.0]}'
sleep 1

read -p "Press [Enter] to send trajectory FigureEight"
echo "Sending FigureEight..."
rosservice call /QuadrotorVictor/test_figure_eight/SendTrajAction 1
sleep 1

read -p "Press [Enter] to follow trajectory FigureEight"
echo "Tracking FigureEight..."
rosservice call /QuadrotorVictor/trackers_manager/transition "tracker: 'payload_trackers/PointloadFFTrackerAction'" 
sleep 1

read -p "Press [Enter] to hover"
echo "Takeoff..."
rosservice call /QuadrotorVictor/mav_services/hover
sleep 1

read -p "Press [Enter] to send trajectory Line"
echo "Sending Line..."
rosservice call /QuadrotorVictor/test_line/SendTrajAction 1
sleep 1

read -p "Press [Enter] to follow trajectory Line"
echo "Tracking Line..."
rosservice call /QuadrotorVictor/trackers_manager/transition "tracker: 'payload_trackers/PointloadFFTrackerAction'" 
sleep 1

read -p "Press [Enter] to come back"
echo "Going to position..."
rosservice call /QuadrotorVictor/mav_services/goTo '{goal: [0.0, 0.0, 2.0, 0.0]}'
sleep 1

read -p "Press [Enter] to land a little"
echo "Going to position..."
rosservice call /QuadrotorVictor/mav_services/goTo '{goal: [-0.5, 0.0, 0.5, 0.0]}'
sleep 1

read -p "Press [Enter] to move forwards"
echo "Going to position..."
rosservice call /QuadrotorVictor/mav_services/goTo '{goal: [0.0, 0.0, 0.5, 0.0]}'
sleep 1

read -p "Press [Enter] to land"
echo "Landing.."
rosservice call /QuadrotorVictor/mav_services/land
sleep 1

read -p "Press [Enter] to stop"
echo "Sopping..."
rosservice call /QuadrotorVictor/mav_services/motors 0
sleep 1