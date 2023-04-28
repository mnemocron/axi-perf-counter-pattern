
ghdl --version

:: delete
del /Q *.vcd &
del /Q *.o &
del /Q *.exe &
del /Q *.cf &

:: analyze
ghdl -a pattern_detector.vhd
ghdl -a axis_latency_counter.vhd
ghdl -a tb_myip.vhd

:: elaborate
ghdl -e pattern_detector
ghdl -e axis_latency_counter
ghdl -e tb_myip
:: run
ghdl -r tb_myip --vcd=wave.vcd --stop-time=1us
gtkwave wave.vcd waveform.gtkw

:: delete
del /Q *.o &
del /Q *.exe &
del /Q *.cf &
