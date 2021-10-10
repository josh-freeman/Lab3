library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
    signal s_vect : std_logic_vector(31 downto 0);
    signal b_in : std_logic_vector(32 downto 0);
    signal addition : unsigned(32 downto 0);
begin
    s_vect <= (others => sub_mode);
    b_in <= '0' & (b xor s_vect);
    addition <= (unsigned(a) + unsigned(b_in) + unsigned(s_vect(0 downto 0)));
    carry <= addition(32);
    zero <= '1' when (addition(31 downto 0) = 0) else '0';
    r <= std_logic_vector(addition(31 downto 0));
end synth;