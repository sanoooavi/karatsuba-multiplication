library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity kar16_tb is
end kar16_tb;
architecture testbench of kar16_tb is
    signal t_clk:std_logic:='0';
    signal t_start:std_logic:='0';
    signal t_nrst:std_logic:='0';
    signal t_done:std_logic:='0';
    signal t_multiplicand :unsigned(15 downto 0);
    signal t_multiplier:unsigned(15 downto 0);
    signal t_result:unsigned(31 downto 0);
 component Karatsuba16 IS 
        port(
        clk:in std_logic;
        start:in std_logic;
        nrst:in std_logic;
        multiplicand:IN unsigned(15 downto 0);
        multiplier:IN unsigned(15 downto 0);
        result:out unsigned(31 downto 0);
        done:out std_logic
    );

    end component;
    begin
        t_clk <= NOT t_clk AFTER 5 ns;
        u1: Karatsuba16 port map(
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
            t_multiplicand<="0001110010011100";
            t_multiplier  <="0011011000110110";
            wait for 10 ns;
            t_nrst<='0';
            t_start<='1';
            WAIT FOR 10 ns;
            t_start<='0';
            wait;
        end process;
end testbench;