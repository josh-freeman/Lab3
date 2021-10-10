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
    signal s_current_state: std_logic_vector(31 downto 0);
    signal s_next_state: std_logic_vector(31 downto 0);
    
begin
    instructionRegister : process (clk) is
    begin
        if rising_edge(clk) then
            
          s_current_state <= s_next_state;
        end if;
    end process instructionRegister;
    s_next_state <= D when enable='1'else s_next_state;
    Q<= s_current_state;
end synth;
