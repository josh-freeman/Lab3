library ieee;
use ieee.std_logic_1164.all;

entity extend is
    port(
        imm16  : in  std_logic_vector(15 downto 0);
        signed : in  std_logic;
        imm32  : out std_logic_vector(31 downto 0)
    );
end extend;

architecture synth of extend is
    signal mask:std_logic_vector(15 downto 0);
begin
    mask <= (others => (imm16(15) and signed));
    imm32 <= mask & imm16 ;
end synth;
