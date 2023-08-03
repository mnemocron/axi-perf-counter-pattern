
ghdl --version

:: delete
del /Q *.vcd &
del /Q *.o &
del /Q *.exe &
del /Q *.cf &

:: analyze
ghdl -a axis_wom_counter.vhd
ghdl -a tb_myip.vhd

:: elaborate
ghdl -e axis_wom_counter
ghdl -e tb_myip
:: run
ghdl -r tb_myip --vcd=wave.vcd --stop-time=1us
gtkwave wave.vcd waveform.gtkw

:: delete
del /Q *.o &
del /Q *.exe &
del /Q *.cf &
