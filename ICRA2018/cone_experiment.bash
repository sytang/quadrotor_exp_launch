echo "Stop motors for safety"
rosservice call /QuadrotorHappy/mav_services/motors false
sleep 1

read -p "Press [Enter] to start motors"
echo "Enable motors..."
rosservice call /QuadrotorHappy/mav_services/motors true
sleep 1

read -p "Press [Enter] to takeoff"
echo "Takeoff..."
rosservice call /QuadrotorHappy/mav_services/takeoff
sleep 1

read -p "Press [Enter] to go to initial position"
echo "Going to position..."
rosservice call /QuadrotorHappy/mav_services/goTo '{goal: [6.3, 0.0, 1.646, 0.0]}'
sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to payload control..."
rosservice call /QuadrotorHappy/trackers_manager/track_payload '{data: true}'
sleep 15

# read -p "Press [Enter] to load trajectory waypoints"
echo "Loading waypoints..."
rosservice call /QuadrotorHappy/mav_services/loadTimedWaypoints "{x: [6.3, 5.1, 4.66, 4.22, 3.78, 3.34, 2.9, 2.46, 1.67], y:[0.0, 0.49, 0.0, -0.49, 0.0, 0.49, 0.0, -0.49, 0.49], z:[1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1, 1.1], yaw:[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], times: [2.59237342989, 3.09237342989, 3.59237342989, 4.09237342989, 4.59237342989, 5.09237342989, 5.59237342989, 8.10991191023], cost: 6}" 
sleep 2

# read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /QuadrotorHappy/mav_services/followWaypoints "{relative: false}" 
# sleep 1

read -p "Press [Enter] to eland" 
echo "EMERGENCY!!!!!"
rosservice call /QuadrotorHappy/mav_services/eland
sleep 1
  