echo "Stop motors for safety"
rosservice call /quadrotor/mav_services/motors false
sleep 1

read -p "Press [Enter] to start motors"
echo "Enable motors..."
rosservice call /quadrotor/mav_services/motors true
sleep 1

read -p "Press [Enter] to takeoff"
echo "Takeoff..."
rosservice call /quadrotor/mav_services/takeoff
sleep 1

read -p "Press [Enter] to go to initial position"
echo "Going to position..."
rosservice call /quadrotor/mav_services/goTo '{goal: [6.3, -0.39, 1.578, 0.0]}'
sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to payload control..."
rosservice call /quadrotor/trackers_manager/track_payload '{data: true}'
sleep 15

# read -p "Press [Enter] to load trajectory waypoints"
echo "Loading waypoints..."
rosservice call /quadrotor/mav_services/loadTimedWaypoints "{x: [6.3, 4.66, 4.22, 3.78, 3.34, 2.9, 2.46, 3.78, 2.99], y:[-0.39, 0.39, 0.0, -0.39, 0.0, 0.39, 0.0, -0.39, 0.39], z:[1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1], yaw:[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], times: [8.58733951815, 10.0873395182, 11.5873395182, 13.0873395182, 14.5873395182, 16.0873395182, 17.5873395182, 19.0873395182, 20.5873395182, 27.2484205115], cost: 6}" 
sleep 2

# read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /quadrotor/mav_services/followWaypoints "{relative: false}" 
# sleep 1

read -p "Press [Enter] to eland" 
echo "EMERGENCY!!!!!"
rosservice call /quadrotor/mav_services/eland
sleep 1
  