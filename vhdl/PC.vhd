library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;-- The input reset n initializes the address register to 0.
        
        en      : in  std_logic;--The input en (see FETCH2 figure) enables the PC to switch to the next address
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)--The output addr is the current 16-bit register value 
                                                   --extended to 32 bits. The 16 most significants
                                                   --bits are set to 0.
    );
end PC;

architecture synth of PC is
    signal s_next_address : std_logic_vector(31 downto 0);
    signal s_current_address :std_logic_vector(31 downto 0);
    signal s_immOrNot : integer;
begin
    
    instructionAddress : process (clk, reset_n) is
    begin
        if reset_n = '0' then
                s_current_address <= (others => '0');
        elsif rising_edge(clk) then
            if en='1' then
                s_current_address<=s_next_address;
            end if;
            
        end if;
    end process instructionAddress;
    
    s_immOrNot <= to_integer(signed(imm)) when add_imm='1' else 4;
    s_next_address <= 
        X"0000" &std_logic_vector(shift_left(arg => signed(imm), count => 2)) when sel_imm='1' else
        X"0000" & a when sel_a='1' else
        (std_logic_vector(to_unsigned(to_integer(unsigned(s_current_address))+s_immOrNot,32))) ; 
        --TODO : check signed or unsigned?
    addr <= s_current_address;
end synth;
