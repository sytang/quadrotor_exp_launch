#!/usr/bin/python

# Sarah Tang
# Simple script that takes a .yaml file containing a multirobot problem and outputs
# a vicon node that remaps all the vicon readings of the robot to the global namespace.

import sys
import argparse
import yaml

SCRIPT_TEMPLATE = """<launch>

  <node pkg="mocap_vicon"
    type="mocap_vicon_node"
    name="vicon"
    output="screen">
    <param name="server_address" value="mocap"/> <!-- mocap, lev: 192.168.129.74 --> 
    <param name="frame_rate" value="100"/>
    <param name="max_accel" value="10.0"/>
    <param name="publish_tf" value="false"/>
    <param name="fixed_frame_id" value="mocap"/>
    <rosparam param="model_list">[]</rosparam>
{}
  </node>
</launch>"""


ROBOT_REMAP = """    <remap from="vicon/Quadrotor{robot_name}/odom" to="Quadrotor{robot_name}/odom"/>
"""

parser = argparse.ArgumentParser(description="")
parser.add_argument('robots_filename', type=str, help="filepath to yaml file")
parser.add_argument('launch_filename', type=str, help="filepath to roslaunch output file")

args = parser.parse_args()
#print args

# Read the yaml file to get start positions of robots.
print "Opening the yaml file..."
with open(args.robots_filename, 'r') as problemfile:
  problem = yaml.safe_load(problemfile)

print problem

# Construct remap string.
num_robots = len(problem['quadrotor_names'])
remap_string = ""
for ii in range(num_robots):
  remap_string += ROBOT_REMAP.format(robot_name=problem['quadrotor_names'][ii])
#print remap_string

# Construct launch string.
launch_string = SCRIPT_TEMPLATE.format(remap_string)

# Write to output file.
print "Opening the roslaunch output file..."
with open(args.launch_filename, 'w') as launch_file:
  launch_file.write(launch_string)
