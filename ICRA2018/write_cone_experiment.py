#!/usr/bin/python

# Sarah Tang
# Simple script that makes a .bash file that generates waypoints and a trajectory that navigates cones.
# Cones are assumed to go in the +x direction. 

import sys
import argparse
import yaml
import math 

LAUNCH_STRING = """echo "Stop motors for safety"
rosservice call /{robot_name}/mav_services/motors false
sleep 1

read -p "Press [Enter] to start motors"
echo "Enable motors..."
rosservice call /{robot_name}/mav_services/motors true
sleep 1

read -p "Press [Enter] to takeoff"
echo "Takeoff..."
rosservice call /{robot_name}/mav_services/takeoff
sleep 1

read -p "Press [Enter] to go to initial position"
echo "Going to position..."
rosservice call /{robot_name}/mav_services/goTo '{init_pos}'
sleep 1

read -p "Press [Enter] to switch to payload tracking"
echo "Switching to payload control..."
rosservice call /{robot_name}/trackers_manager/track_payload '{data_string}'
sleep 1

read -p "Press [Enter] to load trajectory waypoints"
echo "Loading waypoints..."
rosservice call /{robot_name}/mav_services/loadTimedWaypoints "{timed_waypoints_str}" 
sleep 1

read -p "Press [Enter] to follow trajectory waypoints"
echo "Following waypoints..."
rosservice call /{robot_name}/mav_services/followWaypoints "{relative_string}" 
sleep 1

read -p "Press [Enter] to eland" 
echo "EMERGENCY!!!!!"
rosservice call /{robot_name}/mav_services/eland
sleep 1
  """

parser = argparse.ArgumentParser(description="")
parser.add_argument('task_filename', type=str, help="filepath to yaml containing the task parameters")
parser.add_argument('robot_params', type=str, help="filepath to robot yaml containing cable length and tag length")
parser.add_argument('robot', type=str, help="name of the robot being used")

args = parser.parse_args()
print args

# Some default filenames.
script_filename="cone_experiment.bash"

# Read the yaml file to get robot names
print "Opening the yaml file..."
with open(args.task_filename, 'r') as taskfile:
  params = yaml.safe_load(taskfile)

print params

with open(args.robot_params, 'r') as robotfile:
  robot_params = yaml.safe_load(robotfile)

print robot_params

num_cones = params['num_cones']
base_length = params['base_length']
side_clearance = params['side_clearance']
dist_between_cones = params['dist_between_cones']
end_dist = params['end_dist']

# Construct the string of waypoints needed to visit. 
first_x = params['robot_init_pos']['x']
second_x = params['first_pos']['x']
waypoints_string ="{x: [" + str(first_x) + ", " + str(second_x)
x_dist = second_x
add_dist = (dist_between_cones + base_length) / 2.0
for ii in range(num_cones - 1):
  # Add midpoint
  x_dist += add_dist * params['direction_x']
  waypoints_string += ", " + str(x_dist)
  # Add sidepoint
  x_dist += add_dist * params['direction_x']
  waypoints_string += ", " + str(x_dist)
second_last_x = params['first_pos']['x'] + ((num_cones - 1) * (dist_between_cones + base_length)) * params['direction_x']
last_x = second_last_x + ((end_dist + base_length / 2.0) * params['direction_x'])

first_y =params['robot_init_pos']['y'] - (base_length / 2.0 + side_clearance)
y_coord = params['first_pos']['y']
add_dist = base_length / 2.0 + side_clearance
second_y = y_coord + add_dist
waypoints_string += ", " + str(last_x) + "], y:[" + str(first_y) + ", " + str(second_y)
sign = -1.0;
for ii in range(num_cones - 1):
  # Add midpoint
  waypoints_string += ", " + str(params['first_pos']['y'])
  # Add sidepoint
  waypoints_string += ", " + str(y_coord + sign * add_dist)
  sign *= -1.0
second_last_y = y_coord + (-sign) * add_dist
last_y = y_coord + sign * (add_dist)

z_coord = params['robot_init_pos']['z']
first_z = z_coord
second_z = z_coord
waypoints_string += ", " + str(last_y) + "], z:[" + str(z_coord)
for ii in range(2 * num_cones):
  waypoints_string += ", " + str(z_coord)
second_last_z = z_coord
last_z = z_coord

waypoints_string += "], yaw:[0.0"
for ii in range(2 * num_cones):
  waypoints_string += ", 0.0"
waypoints_string = waypoints_string + "]"

print waypoints_string

breaktimes_string = "times: ["
time_scale = params['time_factor']
first_time = (math.sqrt(math.pow(first_x - second_x, 2) + math.pow(first_y - second_y, 2) + math.pow(first_z - second_z, 2))) / params['vdes']
breaktimes_string += str(first_time * time_scale)
next_time = first_time
for ii in range(2 * (num_cones - 1)):
  next_time = (next_time + params['time_between_cones'])
  breaktimes_string += ", " + str(next_time * time_scale)
# Last coordinate next to a cone.
last_time = (next_time + (math.sqrt(math.pow(second_last_x - last_x, 2) + math.pow(second_last_y - last_y, 2) + math.pow(second_last_z - last_z, 2))) / params['vdes'])
breaktimes_string += ", " + str(last_time*time_scale) + ']'

print breaktimes_string

timed_waypoints_string = waypoints_string + ", " + breaktimes_string + ", cost: 6}"

cable_length = robot_params['cable_length']
tag_dist_cog = robot_params['distance_tag_CoG']

init_pos_string="{goal: [" + str(params['robot_init_pos']['x']) + ", "+ str(params['robot_init_pos']['y'] - (base_length / 2.0 + side_clearance)) + ", "+ str(params['robot_init_pos']['z'] + cable_length + tag_dist_cog) + ", "+ str(0.0) + "]}"
print init_pos_string

data_string = "{data: true}"
relative_string = "{relative: false}"

# Construct the bash file.
launch_string = LAUNCH_STRING.format(robot_name=args.robot,
    init_pos =init_pos_string,
    data_string=data_string,
    relative_string=relative_string,
    timed_waypoints_str=timed_waypoints_string)
#print launch_string


# Write to output file.
print "Opening the roslaunch output file..."
with open("./cone_experiment.bash", 'w') as launch_file:
  launch_file.write(launch_string)


