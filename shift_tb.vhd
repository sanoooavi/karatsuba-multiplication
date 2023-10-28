library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all ;


entity mult_tb is
end mult_tb;
architecture testbench of mult_tb is
    signal t_clk:std_logic:='0';
    signal t_start:std_logic:='0';
    signal t_multiplicand :unsigned(7 downto 0);
    signal t_multiplier:unsigned(7 downto 0);
    signal t_result:unsigned(15 downto 0);
    signal t_done:std_logic:='0';
    signal t_rst:std_logic:='1';
    component shift_mul is port
    (
     start:in std_logic;
        rst:in std_logic;
        clk:IN std_logic;
        multiplicand : IN unsigned(7 DOWNTO 0);
        multiplier : IN unsigned(7 DOWNTO 0);
        done:out std_logic;
        result : OUT unsigned(15 DOWNTO 0)
    );
    end component;
    begin
        t_clk <= NOT t_clk AFTER 5 ns;
        u1: shift_mul port map(
                            start=>t_start,
                            rst=>t_rst,
                           clk=>t_clk,
                           multiplicand=>t_multiplicand,
                           multiplier=>t_multiplier,
                           done=>t_done,
                           result=>t_result
        );
        process
        begin
            t_rst<='1';
            t_multiplicand<="10011100";
            t_multiplier<="00110110";
            wait for 10 ns;
            t_rst<='0';
            t_start<='1';
            WAIT FOR 10 ns;
            t_start<='0';
            wait;
        end process;
end testbench;