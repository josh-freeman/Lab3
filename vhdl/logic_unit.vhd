library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity logic_unit is
    port(
        a  : in  std_logic_vector(31 downto 0);
        b  : in  std_logic_vector(31 downto 0);
        op : in  std_logic_vector(1 downto 0);
        r  : out std_logic_vector(31 downto 0)
    );
end logic_unit;

architecture synth of logic_unit is
begin
    
    chooseOperation : process(op,a,b) is
    begin
        case op is
            when "00" => r <= a nor b;
            when "01" => r <= a and b;
            when "10" => r <= a or b;
            when "11" => r <= a xnor b;
            when others => null;
        end case;
    end process chooseOperation;
    
end synth;
