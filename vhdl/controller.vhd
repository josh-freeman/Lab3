library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
    type state is (FETCH1, FETCH2, DECODE, R_OP, STORE, BREAK, LOAD1, I_OP, LOAD2, BRANCH, CALL, CALLR,JMP,JMPI,
        RI_OP,--R-type instructions, but they use a 5-bit immediate value for the second operand
        UI_OP--These immediate operations require their immediate value to be considered as an unsigned number
        );
    
    signal s_current_state: state;
    signal s_next_state : state;
    signal s_next_state_dcode : state;
    signal s_op_alu_IOP:std_logic_vector(5 downto 0);
    signal s_op_alu_branch:std_logic_vector(5 downto 0);
    signal s_op_alu_uiop:std_logic_vector(5 downto 0);
    signal s_op_alu_riop:std_logic_vector(5 downto 0);
    signal s_op_alu_ROP:std_logic_vector(5 downto 0);
    
    signal s_op_alu:std_logic_vector(5 downto 0);
    
    signal s_branch_op:std_logic;
begin
    
    stateMachine : process (clk, reset_n) is
    begin
        if reset_n = '0' then
            s_current_state <= FETCH1;
        elsif rising_edge(clk) then
            s_current_state <= s_next_state;
        end if;
    end process stateMachine;
    
    pc_sel_a <='1' when s_current_state = CALLR or s_current_state = JMP else '0';
    sel_pc <= '1' when s_current_state = CALL or s_current_state = CALLR else '0';
    read <= '1' when s_current_state =FETCH1 or s_current_state =LOAD1 else '0';
    pc_en <= '1' when s_current_state = FETCH2 or s_current_state = JMPI or s_current_state = CALL or s_current_state = CALLR or  s_current_state = JMP else '0';
    ir_en <= '1' when s_current_state = FETCH2 else '0';
    pc_add_imm <= '1' when s_current_state = BRANCH else '0';
    pc_sel_imm <= '1' when s_current_state = CALL or s_current_state = JMPI else '0';
    sel_ra<='1' when s_current_state = CALL or s_current_state = CALLR else '0';
    rf_wren <= '1' when s_current_state = CALL or s_current_state = I_OP or s_current_state = RI_OP or s_current_state = R_OP or s_current_state =LOAD2 or s_current_state =CALLR or s_current_state =UI_OP else '0';
    imm_signed <= '1' when
        s_current_state = I_OP--and not(s_op_alu = "011101" or s_op_alu = "011110") 
        or s_current_state=LOAD1 
        or s_current_state = STORE
         else '0';
    --TODO check should imm signed be 1 when I_OP or just when 
    --we need to perform an immediate type operation with signed ?
    
    sel_b <= '1' when s_current_state = R_OP  or s_current_state=BRANCH else '0';
      --TODO check  sel_b should be on when state is STORE  
    sel_rC <= '1' when s_current_state = R_OP  or s_current_state = RI_OP  else '0';
    sel_addr <= '1' when s_current_state = LOAD1 or s_current_state=STORE else '0';
    sel_mem <= '1' when s_current_state =LOAD2 else '0';
    write <= '1' when s_current_state=STORE else '0';
    
    with s_current_state select s_next_state <=
        FETCH2 when FETCH1,
        DECODE when FETCH2,
        s_next_state_dcode when DECODE,
        BREAK when BREAK,
        LOAD2 when LOAD1,
        FETCH1 when others;
    
    
    s_next_state_dcode <= 
        BREAK when ("00"& opx=X"34" and "00"&op=X"3A") else
        CALLR when "00"&op=X"3A" and "00"&opx=X"1D" else
        JMP when "00"&op=X"3A" and ("00"&opx=X"0D" or "00"&opx=X"05") else     
        STORE when "00"&op=X"15" else
        LOAD1 when "00"&op=X"17" else
        UI_OP when s_op_alu_uiop /= "111111" else
        I_OP when s_op_alu_IOP /= "111111" else
        RI_OP when s_op_alu_riop /= "111111"  else
        R_OP when s_op_alu_ROP /= "111111" else
        BRANCH when s_op_alu_branch /= "111111" else
        CALL when "00"&op=X"00" else
        JMPI when "00"&op=X"01" else
                FETCH1;--when ```s_op_alu_IOP= (others => 'Z')```,
                       --no valid I_OPcode hase been found.
        
        
    s_op_alu_ROP <= 
        "011011" when "00" & op= X"3A"and"00" & opx = X"18"else
        "011100" when "00" & op= X"3A"and"00"&opx =X"20" else     
        "011101" when "00" & op= X"3A"and"00"&opx = X"28"else
        "011110" when "00" & op= X"3A"and"00"&opx = X"30"else
        "110000" when "00" & op= X"3A"and"00"&opx = X"03"else
        "110001" when "00" & op= X"3A"and"00"&opx = X"0B"else
        "100000" when "00" & op= X"3A"and "00" & opx= X"06"else
        "011001" when "00" & op= X"3A"and "00" & opx= X"08"else
        "011010" when "00" & op= X"3A"and "00" & opx= X"10"else
        "100001" when "00" & op= X"3A"and "00" & opx= X"0E"else
        "100010" when "00" & op= X"3A"and "00" & opx= X"16"else
        "110010" when "00" & op= X"3A"and "00" & opx= X"13"else
        "110011" when "00" & op= X"3A"and "00" & opx= X"1B"else
        "110111" when "00" & op= X"3A"and "00" & opx= X"3B"else
        "000000" when  "00" & op= X"3A"and "00" & opx= X"31"else
        "001000" when "00" & op= X"3A"and "00" & opx= X"39"else
        "100011" when "00" & op= X"3A"and "00" & opx= X"1E"else
                "111111";
        
    s_op_alu_uiop <= 
        "100001" when "00" & op = X"0C"else
        "100010" when "00"&op =X"14" else     
        "100011" when "00"&op = X"1C"else
        "011101" when "00"&op = X"28"else
        "011110" when "00"&op = X"30"else
                "111111";
        
    s_op_alu_riop <= 
        "110010" when "00" & op= X"3A"and "00" & opx= X"12"else
        "110011" when "00" & op= X"3A"and "00" & opx= X"1A"else
        "110111" when "00" & op= X"3A"and "00" & opx= X"3A"else
        "110000" when "00" & op= X"3A"and "00" & opx= X"02"else


                "111111";
                
                
    s_branch_op <= '1' when s_current_state=BRANCH else '0';
    branch_op <= s_branch_op;
    s_op_alu_IOP <= 
        "000000" when ("00" & op = X"04"  or "00" &op = X"15" or "00" &op = X"17") else
        "011001" when ("00"&op = X"08") else
        "011010" when ("00"&op = X"10") else
        "011011" when ("00"&op = X"18") else
        "011100" when ("00"&op = X"20") else
                "111111";
                --debug : not sure if this should explicitly be turned off in state LOAD2
    s_op_alu_branch <= 
        "011100" when "00" & op = X"06"  or "00" &op = X"26" else
        "011001" when "00"&op =X"0E" else
        "011010" when "00"&op = X"16" else
        "011011" when "00"&op = X"1E" else
        "011101" when "00"&op = X"2E" else--TODO in these two states, imm_signed must 
        "011110" when "00"&op = X"36" else--be down (unsigned comparisons)
                "111111";

    op_alu <= s_op_alu;
    s_op_alu <= s_op_alu_IOP and s_op_alu_branch and s_op_alu_riop and s_op_alu_ROP and s_op_alu_uiop;--normally shouldn't conflict as both of them aren't on at the same time
    
end synth;
