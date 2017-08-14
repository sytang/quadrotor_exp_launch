#!/usr/bin/python

# Sarah Tang
# Simple script that takes a .yaml file containing a multirobot problem and outputs
# all files for experiments, namely: 
# 1. a roslaunch file that will launch the proper set of nodes for each robot
# 2. an rviz_config file that will add the proper markers for each robot.
# 3. a vicon file that will add the proper remaps for each robot.
# 4. a log_data.sh script that will log all relevant topics

import sys
import argparse
import yaml

LAUNCH_TEMPLATE = """<launch>
  <arg name="home_path" default="/home/sytang/catkin_multirobot/src/quadrotor_exp_launch/ISRR2017/hoop"/>
  <arg name="sim" default="1"/>
  <arg name="mass" default="0.70"/>
  <arg name="zigbee" default="1"/>

  <param name="simulator_frame" value="simulator"/>
  <rosparam file="$(find quadrotor_exp_launch)/ISRR2017/config/quadrotor_names.yaml"/>
  <rosparam file="$(find quadrotor_exp_launch)/ISRR2017/config/pointload_params.yaml" />
  <param name="debug" value="false"/>

  <!-- For the planning problem.-->
  <node pkg="hoop"
    type="hoop_main"
    name="hoop"
    output="screen">
    <rosparam file="$(find quadrotor_exp_launch)/ISRR2017/config/goals_6.yaml" />
    <param name="precision" value="Float"/>
    <param name="basis" value="Power"/>
    <param name="centralized" value="true"/>
    <param name="goal_threshold" value="0.01"/>
  </node>

  <!-- IS THISOKAY?-->
  <node pkg="tf" 
    type="static_transform_publisher" 
    name="simulator_broadcaster" 
    args="0 0 0 0 0 0 1 map simulator 100">
  </node>

  <node pkg="multirobot_quadrotor"
    type="multi_mav_services"
    name="multi_mav_services"
    output="screen">
  </node>

  <!-- vicon node --> 
  <include file="$(find quadrotor_exp_launch)/ISRR2017/hoop/vicon.launch" unless="$(arg sim)">
  <!--  <arg name="model" value="$(arg model)" /> -->
  <!--arg name="vicon_fps" value="100"/-->
  </include>

  {}

</launch>  """


LAUNCH_ROBOT = """<include file="$(find quadrotor_exp_launch)/ISRR2017/hoop/singlerobot.launch">
    <arg name="name" value="{robot_name}"/>
    <arg name="initial_position_payload/x" value="{init_x}"/>
    <arg name="initial_position_payload/y" value="{init_y}"/>
    <arg name="initial_position_payload/z" value="{init_z}"/>
    <arg name="home_path" value="$(arg home_path)"/>
    <arg name="sim" value="$(arg sim)"/>
    <arg name="mass"  value="$(arg mass)"/>
    <arg name="zigbee"  value="$(arg zigbee)"/>
    <arg name="usb_num" value="{usb_num}"/>
  </include> 

  """

RVIZ_TEMPLATE = """Panels:
  - Class: rviz/Displays
    Help Height: 78
    Name: Displays
    Property Tree Widget:
      Expanded:
        - /Global Options1
        - /Robot1
        - /Marker1
      Splitter Ratio: 0.5
    Tree Height: 427
  - Class: rviz/Selection
    Name: Selection
  - Class: rviz/Tool Properties
    Expanded:
      - /2D Pose Estimate1
      - /2D Nav Goal1
      - /Publish Point1
    Name: Tool Properties
    Splitter Ratio: 0.588679016
  - Class: rviz/Views
    Expanded:
      - /Current View1
    Name: Views
    Splitter Ratio: 0.5
  - Class: rviz/Time
    Experimental: false
    Name: Time
    SyncMode: 0
    SyncSource: ""
Visualization Manager:
  Class: ""
  Displays:
    - Alpha: 0.5
      Cell Size: 1
      Class: rviz/Grid
      Color: 160; 160; 164
      Enabled: true
      Line Style:
        Line Width: 0.0299999993
        Value: Lines
      Name: Grid
      Normal Cell Count: 0
      Offset:
        X: 0
        Y: 0
        Z: 0
      Plane: XY
      Plane Cell Count: 10
      Reference Frame: <Fixed Frame>
      Value: true
      {}
  Enabled: true
  Global Options:
    Background Color: 48; 48; 48
    Fixed Frame: simulator
    Frame Rate: 30
  Name: root
  Tools:
    - Class: rviz/Interact
      Hide Inactive Objects: true
    - Class: rviz/MoveCamera
    - Class: rviz/Select
    - Class: rviz/FocusCamera
    - Class: rviz/Measure
    - Class: rviz/SetInitialPose
      Topic: /initialpose
    - Class: rviz/SetGoal
      Topic: /move_base_simple/goal
    - Class: rviz/PublishPoint
      Single click: true
      Topic: /clicked_point
  Value: true
  Views:
    Current:
      Class: rviz/Orbit
      Distance: 15.4051533
      Enable Stereo Rendering:
        Stereo Eye Separation: 0.0599999987
        Stereo Focal Distance: 1
        Swap Stereo Eyes: false
        Value: false
      Focal Point:
        X: 0.17701
        Y: -0.00770410988
        Z: 0.82889998
      Focal Shape Fixed Size: true
      Focal Shape Size: 0.0500000007
      Name: Current View
      Near Clip Distance: 0.00999999978
      Pitch: 1.56479633
      Target Frame: <Fixed Frame>
      Value: Orbit (rviz)
      Yaw: 1.56722212
    Saved: ~
Window Geometry:
  Displays:
    collapsed: false
  Height: 714
  Hide Left Dock: false
  Hide Right Dock: true
  QMainWindow State: 000000ff00000000fd00000004000000000000016a0000023afc0200000008fb0000001200530065006c0065006300740069006f006e00000001e10000009b0000006400fffffffb0000001e0054006f006f006c002000500072006f007000650072007400690065007302000001ed000001df00000185000000a3fb000000120056006900650077007300200054006f006f02000001df000002110000018500000122fb000000200054006f006f006c002000500072006f0070006500720074006900650073003203000002880000011d000002210000017afb000000100044006900730070006c00610079007301000000280000023a000000dd00fffffffb0000002000730065006c0065006300740069006f006e00200062007500660066006500720200000138000000aa0000023a00000294fb00000014005700690064006500530074006500720065006f02000000e6000000d2000003ee0000030bfb0000000c004b0069006e0065006300740200000186000001060000030c00000261000000010000010f00000319fc0200000003fb0000001e0054006f006f006c002000500072006f00700065007200740069006500730100000041000000780000000000000000fb0000000a00560069006500770073000000004300000319000000b000fffffffb0000001200530065006c0065006300740069006f006e010000025a000000b200000000000000000000000200000490000000a9fc0100000001fb0000000a00560069006500770073030000004e00000080000002e10000019700000003000003f000000044fc0100000002fb0000000800540069006d00650100000000000003f00000030000fffffffb0000000800540069006d00650100000000000004500000000000000000000002800000023a00000004000000040000000800000008fc0000000100000002000000010000000a0054006f006f006c00730100000000ffffffff0000000000000000
  Selection:
    collapsed: false
  Time:
    collapsed: false
  Tool Properties:
    collapsed: false
  Views:
    collapsed: true
  Width: 1008
  X: 65
  Y: 25"""


RVIZ_ROBOT = """
    - Class: rviz/Axes
      Enabled: true
      Length: 1
      Name: Axes
      Radius: 0.0299999993
      Reference Frame: <Fixed Frame>
      Value: true
    - Class: rviz/Marker
      Enabled: true
      Marker Topic: /Quadrotor{robot_name}/payload_visualization/robot
      Name: Robot
      Namespaces:
        /Quadrotor{robot_name}/payload_visualization: true
      Queue Size: 6
      Value: true
    - Class: rviz/Marker
      Enabled: true
      Marker Topic: /Quadrotor{robot_name}/trajectory_visualization/robot_current_traj
      Name: Marker
      Namespaces:
        {{}}
      Queue Size: 100
      Value: true"""


VICON_TEMPLATE = """<launch>

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


VICON_ROBOT = """    <remap from="vicon/Quadrotor{robot_name}/odom" to="Quadrotor{robot_name}/odom"/>
"""

ROS_TOPICS_TEMPLATE = """rosbag record /Quadrotor{robot_name}/current_traj /Quadrotor{robot_name}/odom /vicon/Payload{robot_name}/odom /Quadrotor{robot_name}/position_cmd /Quadrotor{robot_name}/position_cmd_echo /Quadrotor{robot_name}/so3_cmd /Quadrotor{robot_name}/payload_cmd /Quadrotor{robot_name}/so3_control/corrections /Quadrotor{robot_name}/trackers_manager/pointload_ff_tracker/traj_started """


parser = argparse.ArgumentParser(description="")
parser.add_argument('robots_filename', type=str, help="filepath to yaml file")
#parser.add_argument('launch_filename', type=str, help="filepath to roslaunch output file")
#parser.add_argument('rviz_filename', type=str, help="filepath to rviz_config output file")

args = parser.parse_args()
#print args

# Some default filenames.
launch_filename="test.launch" #args.launch_filename
rviz_filename="rviz_config.rviz" #args.rviz_filename
vicon_filename="vicon.launch" #args.vicon_filename
log_filename="log_data.sh"

# Read the yaml file to get robot names
print "Opening the yaml file..."
with open(args.robots_filename, 'r') as paramsfile:
  params = yaml.safe_load(paramsfile)

# print params

# Check that the sizes of parameters is correct.
num_robots = len(params['quadrotor_names'])
if (len(params['sim_init_x']) != num_robots):
  print "sim_init_x not the same size as names"
  sys.exit()
if (len(params['sim_init_y']) != num_robots):
  print "sim_init_y not the same size as names"
  sys.exit()
if (len(params['sim_init_z']) != num_robots):
  print "sim_init_z not the same size as names"
  sys.exit()
if (len(params['usb']) != num_robots):
  print "usb numbers not the same size as names"
  sys.exit()



# Construct launchfile string.
launch_string = ""
for ii in range(num_robots):
  launch_string += LAUNCH_ROBOT.format(robot_name=params['quadrotor_names'][ii],
    init_x=params['sim_init_x'][ii],
    init_y=params['sim_init_y'][ii],
    init_z=params['sim_init_z'][ii],
    usb_num=params['usb'][ii])
#print launch_string
launch_string=LAUNCH_TEMPLATE.format(launch_string)

# Write to output file.
print "Opening the roslaunch output file..."
with open(launch_filename, 'w') as launch_file:
  launch_file.write(launch_string)




# Construct rviz string.
rviz_string = ""
for ii in range(num_robots):
  rviz_string += RVIZ_ROBOT.format(robot_name=params['quadrotor_names'][ii])
print rviz_string
rviz_string=RVIZ_TEMPLATE.format(rviz_string)

# Write to output file.
print "Opening the rviz config output file..."
with open(rviz_filename, 'w') as rviz_file:
  rviz_file.write(rviz_string)




# Construct remap string.
remap_string = ""
for ii in range(num_robots):
  remap_string += VICON_ROBOT.format(robot_name=params['quadrotor_names'][ii])
#print remap_string

# Construct launch string.
vicon_string = VICON_TEMPLATE.format(remap_string)

# Write to output file.
print "Opening the roslaunch output file..."
with open(vicon_filename, 'w') as vicon_file:
  vicon_file.write(vicon_string)


rosbag_string = "rosbag record "
for ii in range(num_robots):
  rosbag_string += ROS_TOPICS_TEMPLATE.format(robot_name=params['quadrotor_names'][ii])

# Write to output file.
print "Opening the logging file..."
with open(log_filename, 'w') as log_file:
  log_file.write(rosbag_string)