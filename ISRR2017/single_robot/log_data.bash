#!/bin/bash

NAME="Happy"

rosbag record /Quadrotor${NAME}/current_traj /Quadrotor${NAME}/odom /vicon/Payload${NAME}/odom /Quadrotor${NAME}/position_cmd /Quadrotor${NAME}/position_cmd_echo /Quadrotor${NAME}/so3_cmd /Quadrotor${NAME}/so3_control/corrections /Quadrotor${NAME}/trackers_manager/pointload_ff_tracker/traj_started 