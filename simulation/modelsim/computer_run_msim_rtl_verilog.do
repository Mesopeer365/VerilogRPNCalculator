transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/display_modules {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/display_modules/disp_decimal.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/display_modules {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/display_modules/snum_to_sseg.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/display_modules {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/display_modules/disp_hex.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/display_modules {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/display_modules/sseg_encoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/synchroniser.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/debounce.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/falling_edge_detector.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/timer.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/enable_gen.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/auxillary/counter.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu/instruction_splitter.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/top.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/soc.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/instruction_memory.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu/cpu.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu/controller.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu/register_file.v}
vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/src/cpu/instruction_pointer.v}

vlog -vlog01compat -work work +incdir+C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/simulation {C:/Users/Admin/Desktop/Long/_School/ELEN20006_2022_SM1/Project/Files/simulation/test_cpu_early_stage.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  test_cpu_early_stage

add wave *
view structure
view signals
run -all
