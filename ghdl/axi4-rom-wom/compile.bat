
ghdl --version

:: delete
del /Q *.vcd &
del /Q *.o &
del /Q *.exe &
del /Q *.cf &

:: analyze
ghdl -a skidbuffer.vhd
ghdl -a axis_pipeline.vhd
ghdl -a axi4_rom_wom.vhd
ghdl -a tb_rom_wom.vhd
:: elaborate
ghdl -e skidbuffer
ghdl -e axis_pipeline
ghdl -e axi4_rom_wom
ghdl -e tb_rom_wom
:: run
ghdl -r tb_rom_wom --vcd=wave.vcd --stop-time=1us
gtkwave wave.vcd waveform.gtkw

:: delete
del /Q *.o &
del /Q *.exe &
del /Q *.cf &
