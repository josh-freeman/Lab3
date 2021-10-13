library ieee;
use ieee.std_logic_1164.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is
    component ROM_Block
        port(
            address : IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
            clock   : IN  STD_LOGIC;
            q       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    end component ROM_Block;
    signal q_sig : std_logic_vector(31 downto 0);
    signal s_cs : std_logic;
    signal s_read : std_logic;
    
begin
    ROM_INSTANCE: ROM_Block port map(
        address => address,
        clock   => clk,
        q => q_sig
    );

    rom : process (clk) is
    begin
        if rising_edge(clk) then
            if read = '1' and cs = '1' then
                rddata <= q_sig;
            else
                rddata <= (others => 'Z');
            end if;
        end if;
    end process rom;

end synth;
