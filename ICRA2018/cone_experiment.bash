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
rosservice call /quadrotor/mav_services/goTo '{goal: [6.3, 0.0, 1.178, 0.0]}'
sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to payload control..."
rosservice call /quadrotor/trackers_manager/track_payload '{data: true}'
sleep 15

# read -p "Press [Enter] to load trajectory waypoints"
echo "Loading waypoints..."
rosservice call /quadrotor/mav_services/loadTimedWaypoints "{x: [6.3, 5.1, 4.66, 4.22, 3.78, 3.34, 2.9, 2.46, 1.67], y:[0.0, 0.49, 0.0, -0.49, 0.0, 0.49, 0.0, -0.49, 0.49], z:[0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7], yaw:[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], times: [2.3331360869, 2.7831360869, 3.2331360869, 3.6831360869, 4.1331360869, 4.5831360869, 5.0331360869, 7.29892071921], cost: 6}" 
sleep 2

# read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /quadrotor/mav_services/followWaypoints "{relative: false}" 
# sleep 1

read -p "Press [Enter] to eland" 
echo "EMERGENCY!!!!!"
rosservice call /quadrotor/mav_services/eland
sleep 1
  