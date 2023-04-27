
ghdl --version

:: delete
del /Q *.vcd &
del /Q *.o &
del /Q *.exe &
del /Q *.cf &

:: analyze
ghdl -a axi_perf_counter.vhd
ghdl -a tb_axi_perf_counter.vhd
:: elaborate
ghdl -e axi_perf_counter
ghdl -e tb_axi_perf_counter
:: run
ghdl -r tb_axi_perf_counter --vcd=axi_wave.vcd --stop-time=1us
gtkwave axi_wave.vcd axi_waveform.gtkw

:: delete
del /Q *.o &
del /Q *.exe &
del /Q *.cf &
