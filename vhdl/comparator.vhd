library ieee;
use ieee.std_logic_1164.all;

entity comparator is
    port(
        a_31    : in  std_logic;
        b_31    : in  std_logic;
        diff_31 : in  std_logic;
        carry   : in  std_logic;
        zero    : in  std_logic;
        op      : in  std_logic_vector(2 downto 0);
        r       : out std_logic
    );
end comparator;

architecture synth of comparator is
    signal result : std_logic;
    
begin
    choose : process(op, a_31, b_31, diff_31 , zero, carry) is
    begin
        case op is
            when "001" => result <= (a_31 and ('1'xor b_31)) or ((a_31 xnor b_31) and (diff_31 or zero));
            when "010" => result <= (('1'xor a_31) and b_31) or ((a_31 xnor b_31) and (('1'xor diff_31)and ('1' xor zero)));
            when "011" => result <= '1' xor zero;
            when "101" => result <= ('1'xor carry)or zero;
            when "110" => result <= ('1' xor zero) and carry;
            when others => result <= zero;
        end case;
        
    end process choose;
    r <= result;
end synth;
