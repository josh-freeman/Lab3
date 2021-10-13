library ieee;
use ieee.std_logic_1164.all;

entity IR is
    port(
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector(31 downto 0);
        Q      : out std_logic_vector(31 downto 0)--The input en enables to write the input D in 
                                                  --the register at the next rising edge of the clock. In
                                                  --other words, at every rising edge of clk, the value of
                                                  -- D is passed over to Q if en is enabled
    );
end IR;

architecture synth of IR is
begin
    
    
    instructionRegister : process (clk, enable) is
    begin
        if rising_edge(clk) and enable ='1' then
          Q<=D;
        end if;
    end process instructionRegister;

end synth;
