export DESIGN_NICKNAME = adder_comb
export DESIGN_NAME = adder_comb
export PLATFORM    = sky130hs

export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/design.sv

export SDC_FILE      = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

#export ADDER_MAP_FILE :=


export CORE_UTILIZATION = 45
export TNS_end_percent =100
#export EQUIVALANCE_CHECK  ?=   0
#export REMOVE_CELLS_FOR_EQY =sky130_fd_sc_hd__tapvpwrvgnd*
