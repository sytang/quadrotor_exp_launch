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
rosservice call /QuadrotorHappy/mav_services/goTo '{goal: [0.0, -0.29, 1.046, 0.0]}'
sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to payload control..."
rosservice call /QuadrotorHappy/trackers_manager/track_payload '{data: true}'
sleep 1

read -p "Press [Enter] to load trajectory waypoints"
echo "Loading waypoints..."
rosservice call /QuadrotorHappy/mav_services/loadTimedWaypoints "{x: [0.0, 1.2, 2.08, 2.96, 3.84, 4.83], y:[-0.29, 0.29, -0.29, 0.29, -0.29, 0.29], z:[0.5, 0.5, 0.5, 0.5, 0.5, 0.5], yaw:[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], times: [2.66563313305, 3.66563313305, 4.66563313305, 5.66563313305, 7.96040981063], cost: 6}" 
sleep 1

read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /QuadrotorHappy/mav_services/followWaypoints "{relative: false}" 
sleep 1

read -p "Press [Enter] to eland" 
echo "EMERGENCY!!!!!"
rosservice call /QuadrotorHappy/mav_services/eland
sleep 1
  