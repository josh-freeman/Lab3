library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port(
        address : in  std_logic_vector(15 downto 0);
        cs_LEDS : out std_logic;
        cs_RAM  : out std_logic;
        cs_ROM  : out std_logic;
        cs_buttons : out std_logic
    );
end decoder;

architecture synth of decoder is
    signal CSLEDS : std_logic;
    signal CSRAM : std_logic;
    signal CSROM : std_logic;  
    signal CSBUTTONS : std_logic;  
begin
    CSROM <= '1' when 0 <= unsigned(address) and unsigned(address) <= X"0FFC" else '0';
    CSRAM <= '1' when X"1000" <= unsigned(address) and unsigned(address) <= X"1FFC" else '0';
    CSLEDS <= '1' when X"2000" <= unsigned(address) and unsigned(address) <= X"200C" else '0';
    CSBUTTONS <= '1' when X"2030" <= unsigned(address) and unsigned(address) <= X"2034" else '0';        
    
    cs_buttons <= CSBUTTONS;
    cs_LEDS <= CSLEDS;
    cs_RAM <= CSRAM;
    cs_ROM <= CSROM;
end synth;
