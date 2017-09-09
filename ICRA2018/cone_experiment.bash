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
<<<<<<< HEAD
rosservice call /quadrotor/mav_services/loadTimedWaypoints "{x: [6.3, 5.1, 4.22, 3.34, 2.46, 1.67], y:[-0.39, 0.39, -0.39, 0.39, -0.39, 0.39], z:[1.1, 1.1, 1.1, 1.1, 1.1, 1.1], yaw:[0.0, 0.0, 0.0, 0.0, 0.0, 0.0], times: [8.58733951815, 10.0873395182, 11.5873395182, 13.0873395182, 19.7484205115], cost: 6}" 
sleep 2
=======
rosservice call /QuadrotorHappy/mav_services/loadTimedWaypoints "{x: [6.3, 4.66, 4.22, 3.78, 3.34, 2.9, 2.46, 3.78, 2.99], y:[-0.29, 0.29, 0.0, -0.29, 0.0, 0.29, 0.0, -0.29, 0.29], z:[0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5], yaw:[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], times: [5.33126626609, 6.33126626609, 7.33126626609, 8.33126626609, 9.33126626609, 10.3312662661, 11.3312662661, 12.3312662661, 13.3312662661, 17.2514703424], cost: 6}" 
sleep 1
>>>>>>> ed7c91d1d4c844846b8612e9852801acc6270937

# read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /quadrotor/mav_services/followWaypoints "{relative: false}" 
# sleep 1

read -p "Press [Enter] to eland" 
echo "EMERGENCY!!!!!"
rosservice call /quadrotor/mav_services/eland
sleep 1
  