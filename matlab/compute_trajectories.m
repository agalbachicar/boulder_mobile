%% Computes open loop trajectories

%% Initialization

% Cleans the workspace
clear all;
close all;
clc;

fc = 1;
% Sampling rate + time vector.
fs = 20; 
dt = 1/fs;
t = 0:0.01:10;

%% Line trajectory

vr = 1;
vl = 1;
l = 1;
pose_i = [0, 0, 0];

% Computes the trajectory
poses = zeros(3,length(t));
poses(:,1) = pose_i;
for ii=2:length(t)
   poses(:,ii) = odometry_step(vr, vl, l, poses(:,ii-1), dt);
end

fc = plot_trajectory(poses, t, fc);

%% Circle trajectory

vr = 2;
vl = 1;
l = 1;
pose_i = [0, 0, 0];

% Computes the trajectory
poses = zeros(3,length(t));
poses(:,1) = pose_i;
for ii=2:length(t)
   poses(:,ii) = odometry_step(vr, vl, l, poses(:,ii-1), dt);
end

fc = plot_trajectory(poses, t, fc);
