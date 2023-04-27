
ghdl --version

:: delete
del /Q *.vcd &
del /Q *.o &
del /Q *.exe &
del /Q *.cf &

:: analyze
ghdl -a pattern_detector.vhd
ghdl -a tb_pattern_trig.vhd
:: elaborate
ghdl -e pattern_detector
ghdl -e tb_pattern_trig
:: run
ghdl -r tb_pattern_trig --vcd=pattern_wave.vcd --stop-time=1us
gtkwave pattern_wave.vcd pattern_waveform.gtkw

:: delete
del /Q *.o &
del /Q *.exe &
del /Q *.cf &
