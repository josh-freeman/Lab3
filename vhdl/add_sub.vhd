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
    signal result: std_logic_vector(31 downto 0);
    signal cout : std_logic;
    signal tmp: std_logic_vector(32 downto 0);
begin
    addOrSub : process(sub_mode,a,b,tmp) is
    begin
        if sub_mode='0' then
            tmp <= std_logic_vector(unsigned('0' & a) + unsigned(b));
        else tmp <=  std_logic_vector(unsigned('0' & a) + unsigned(not b) + 1);
        end if;
        result <= tmp(31 downto 0);
        cout <= tmp(32);
    end process addOrSub;
    
    r <= result;
    carry <= cout;
    zero <= '1' when signed(result)=0 else '0';
end synth;