library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity Karatsuba16 IS 
port(
    clk:in std_logic;
    start:in std_logic;
    nrst:in std_logic;
    multiplicand:IN std_logic_vector(15 downto 0);
    multiplier:IN std_logic_vector(15 downto 0);
    result:out std_logic_vector(31 downto 0);
    done:out std_logic
);
end Karatsuba16;
architecture behavorial of Karatsuba16 is
    signal fHalf_multiplicand:std_logic_vector(7 downto 0):=(others=>'0');
    signal fHalf_multiplier:std_logic_vector(7 downto 0):=(others=>'0');
    signal sHalf_multiplicand:std_logic_vector(7 downto 0):=(others=>'0');
    signal sHalf_multiplier:std_logic_vector(7 downto 0):=(others=>'0');
    signal fsHalf_multiplicand:std_logic_vector(7 downto 0):=(others=>'0');
    signal fsHalf_multiplier:std_logic_vector(7 downto 0):=(others=>'0');
    signal ans1:std_logic_vector(15 downto 0):=(others=>'0');
    signal ans2:std_logic_vector(15 downto 0):=(others=>'0');
    signal ans3:std_logic_vector(15 downto 0):=(others=>'0');
    signal done_ans1:std_logic:='0';
    signal done_ans2:std_logic:='0';
    signal done_ans3:std_logic:='0';
    signal counter_finished:std_logic:='0';

    component shift_mul IS
    PORT (
        start:in std_logic;
        rst:in std_logic;
        clk:IN std_logic;
        multiplicand : IN std_logic_vector(7 DOWNTO 0);
        multiplier : IN std_logic_vector(7 DOWNTO 0);
        done:out std_logic:='0';
        result : OUT std_logic_vector(15 DOWNTO 0)
       );
END component;
begin
    fHalf_multiplicand<=multiplicand(15 downto 8);
    fHalf_multiplier<=multiplier(15 downto 8);
    sHalf_multiplicand<=multiplicand(7 downto 0);
    sHalf_multiplier<=multiplier(7 downto 0);
    fsHalf_multiplicand<=fHalf_multiplicand+sHalf_multiplicand;
    fsHalf_multiplier<=fHalf_multiplier+sHalf_multiplier;
    k1:shift_mul port map(
    start,
    rst=>nrst,
    clk=>clk,
    multiplicand=>fHalf_multiplicand,
    multiplier=>fHalf_multiplier,
    done=>done_ans1,
    result=> ans1
    );
    k2:shift_mul port map(
    start,
    rst=>nrst,
    clk=>clk,
    multiplicand=>sHalf_multiplicand,
    multiplier=>sHalf_multiplier,
    done=>done_ans2,
    result=>ans2
    );
    k3:shift_mul port map(
    start,
    rst=>nrst,
    clk=>clk,
    multiplicand=>fsHalf_multiplicand,
    multiplier=>fsHalf_multiplier,
    done=>done_ans3,
    result=>ans3
    );
    process(clk)
    variable z0: std_logic_vector(31 downto 0):=(others=>'0');
    variable z2: std_logic_vector(31 downto 0):=(others=>'0');
    variable z1: std_logic_vector(31 downto 0):=(others=>'0');
    begin
    if(rising_edge(clk)) then
       if(counter_finished='1')then
           result<=(others=>'0');
           done<='0';
           counter_finished<='0';
           z0:=(others=>'0');
           z1:=(others=>'0');
           z2:=(others=>'0');
       elsif(done_ans1='1' and done_ans2='1' and done_ans3='1') then
             z2:=ans1&"0000000000000000";
             z1:="00000000"&(ans3-ans1-ans2)&"00000000";
             z0:="0000000000000000"&ans2;
             done<='1';
             result<=z0+z1+z2;
             counter_finished<='1';
        else
           result<=(others=>'0');
           done<='0';
     end if;
    end if;
    end process;
    
 end behavorial;