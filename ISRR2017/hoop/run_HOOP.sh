#!/bin/bash

read -p "Press [Enter] to plan!"
echo "Planning!"
rosservice call /multi_mav_services/labeled_plan
sleep 1

read -p "Press [Enter] to assign."
echo "Done!"
rosservice call /multi_mav_services/assign_traj
sleep 1

read -p "Press [Enter] to turn motors on."
echo "Done..."
rosservice call /multi_mav_services/motors 1
sleep 1

read -p "Press [Enter] to take off."
echo "Done..."
rosservice call /multi_mav_services/takeoff
sleep 1

read -p "GoTo!"
echo "Done..."
rosservice call /multi_mav_services/prep_traj
sleep 1

read -p "Send!"
echo "Done!"
rosservice call /multi_mav_services/send_traj
sleep 1

read -p "GO!"
echo "Good luck!"
rosservice call /multi_mav_services/start_traj 
sleep 1

read -p "DONE!"
echo "Hovering!"
rosservice call /multi_mav_services/hover 
sleep 1

read -p "Land?"
echo "Landing!"
rosservice call /multi_mav_services/land
sleep 1

