library ieee ;
use ieee.std_logic_1164.all ;
 

entity kar256_tb is
end kar256_tb;
architecture testbench of kar256_tb is
    signal t_clk:std_logic:='0';
    signal t_start:std_logic:='0';
    signal t_nrst:std_logic:='0';
    signal t_multiplicand :std_logic_vector(255 downto 0);
    signal t_done:std_logic:='0';
    signal t_multiplier:std_logic_vector(255 downto 0);
    signal t_result:std_logic_vector(511 downto 0);
 component Karatsuba256 IS 
        port(
        clk:in std_logic;
        start:in std_logic;
        nrst:in std_logic;
        multiplicand:IN std_logic_vector(255 downto 0);
        multiplier:IN std_logic_vector(255 downto 0);
        result:out std_logic_vector(511 downto 0);
        done:out std_logic
    );

    end component;
    begin
        t_clk <= NOT t_clk AFTER 5 ns;
        u1: Karatsuba256 port map(
                           clk=>t_clk,
                           start=>t_start,
                           nrst=>t_nrst,
                           multiplicand=>t_multiplicand,
                           multiplier=>t_multiplier,
                           result=>t_result,
                           done=>t_done
        );
        process
        begin
            t_nrst<='1';
            t_multiplicand<="0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011100010000110011010110011";
            t_multiplier  <="0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001101100001000100100011";
            wait for 10 ns;
            t_nrst<='0';
            t_start<='1';
            WAIT FOR 10 ns;
            t_start<='0';
            wait;
        end process;
end testbench;