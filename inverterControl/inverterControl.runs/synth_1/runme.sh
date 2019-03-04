#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
<<<<<<< HEAD
  PATH=/home/offersen/Programs/xilinx/SDK/2018.3/bin:/home/offersen/Programs/xilinx/Vivado/2018.3/ids_lite/ISE/bin/lin64:/home/offersen/Programs/xilinx/Vivado/2018.3/bin
else
  PATH=/home/offersen/Programs/xilinx/SDK/2018.3/bin:/home/offersen/Programs/xilinx/Vivado/2018.3/ids_lite/ISE/bin/lin64:/home/offersen/Programs/xilinx/Vivado/2018.3/bin:$PATH
=======
  PATH=/opt/Xilinx/SDK/2018.3/bin:/opt/Xilinx/Vivado/2018.3/ids_lite/ISE/bin/lin64:/opt/Xilinx/Vivado/2018.3/bin
else
  PATH=/opt/Xilinx/SDK/2018.3/bin:/opt/Xilinx/Vivado/2018.3/ids_lite/ISE/bin/lin64:/opt/Xilinx/Vivado/2018.3/bin:$PATH
>>>>>>> 4efbdfd94ef8bc666bd8d56843a097e3c3c2fd20
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
<<<<<<< HEAD
  LD_LIBRARY_PATH=/home/offersen/Programs/xilinx/Vivado/2018.3/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/home/offersen/Programs/xilinx/Vivado/2018.3/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/offersen/Programs/vivadoprojects/gokart_inverter/inverterControl/inverterControl.runs/synth_1'
=======
  LD_LIBRARY_PATH=/opt/Xilinx/Vivado/2018.3/ids_lite/ISE/lib/lin64
else
  LD_LIBRARY_PATH=/opt/Xilinx/Vivado/2018.3/ids_lite/ISE/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/jonas/Documents/SDU/Master/Semester 1/Project/software/git/gokart_inverter/inverterControl/inverterControl.runs/synth_1'
>>>>>>> 4efbdfd94ef8bc666bd8d56843a097e3c3c2fd20
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

<<<<<<< HEAD
EAStep vivado -log top.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source top.tcl
=======
EAStep vivado -log block_adc_wrapper.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source block_adc_wrapper.tcl
>>>>>>> 4efbdfd94ef8bc666bd8d56843a097e3c3c2fd20
