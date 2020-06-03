
all: clean lib build sim

lib:
	vlib work
	vmap work work
	
build:
	vlog AHBSEL_STORE.sv mem.sv transaction.sv AHB_Package.sv interface.sv AHB_TOP.sv env.sv AHB_MUX.sv AHB_DECODER.sv memController.sv top.sv driver.sv generator.sv monitor.sv scoreboard.sv coverage_ahb.sv tb_top.sv top_main.sv
	
sim:
	vsim -c -do "run -all; coverage report -output report.txt -srcfile=* -detail -annotate -directive -cvg -codeAll; quit" top

clean:
	rm -rf modelsim.ini work report.txt transcript
