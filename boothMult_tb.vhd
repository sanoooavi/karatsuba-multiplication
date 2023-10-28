library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mult_tb is
end mult_tb;
architecture testbench of mult_tb is
    signal t_clk:std_logic:='0';
    signal t_multiplicand :std_logic_vector(7 downto 0);
    signal t_multiplier:std_logic_vector(7 downto 0);
    signal t_result:std_logic_vector(15 downto 0);
    component mult is port
    (
        clk:IN std_logic;
        multiplicand:IN std_logic_vector(7 downto 0);
        multiplier:IN std_logic_vector(7 downto 0);
        result:OUT std_logic_vector(15 downto 0)
    );
    end component;
    begin
        t_clk <= NOT t_clk AFTER 5 ns;
        u1: mult port map(
                           clk=>t_clk,
                           multiplicand=>t_multiplicand,
                           multiplier=>t_multiplier,
                           result=>t_result
        );
        process
        begin
            t_multiplicand<="10011100";
            t_multiplier<="00110110";
            wait;
        end process;
end testbench;