#!/bin/bash

#Check microarchitecture
cpu_info=$(likwid-topology -g| grep -i "CPU type")

	if echo "$cpu_info" | grep -q "IvyBridge EN/EP/EX"
	then
		arch="IvyBridgeS"
	elif echo "$cpu_info" | grep -q "IvyBridge"
	then 
		arch="IvyBridge"
	elif echo "$cpu_info" | grep -q "SandyBridge EP/EN"
	then 
		arch="SandyBridgeS"
	elif echo "$cpu_info" | grep -q "SandyBridge"
	then 
		arch="SandyBridge"
	elif echo "$cpu_info" | grep -q "Haswell EP/EN/EX"
	then 
		arch="HaswellS"
	elif echo "$cpu_info" | grep -q "Haswell"
	then 
		arch="Haswell"
	elif echo "$cpu_info" | grep -q "Broadwell EP"
	then 
		arch="BroadwellS"
	elif echo "$cpu_info" | grep -q "Broadwell"
	then 
		arch="Broadwell"
	elif echo "$cpu_info" | grep -q "Skylake"
	then 
		arch="Skylake"
	else
		echo "[ERROR] Microarchitecture not supported. Cannot install Salaak"
		exit 1
	fi
