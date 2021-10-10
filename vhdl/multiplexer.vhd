library ieee;
use ieee.std_logic_1164.all;

entity multiplexer is
    port(
        i0  : in  std_logic_vector(31 downto 0);
        i1  : in  std_logic_vector(31 downto 0);
        i2  : in  std_logic_vector(31 downto 0);
        i3  : in  std_logic_vector(31 downto 0);
        sel : in  std_logic_vector(1 downto 0);
        o   : out std_logic_vector(31 downto 0)
    );
end multiplexer;

architecture synth of multiplexer is
    signal outSignal : std_logic_vector(31 downto 0);
begin
    choose : process (i0, i1, i2, i3, sel) is
    begin
        case sel is
            when "00" => outSignal <= i0;
            when "01" => outSignal <= i1;
            when "10" => outSignal <= i2;
            when "11" => outSignal <= i3;
            when others => null;
        end case;
    end process choose;
    
    o <= outSignal;
end synth;
