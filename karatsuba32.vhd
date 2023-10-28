library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity Karatsuba32 IS 
port(
    clk:in std_logic;
    start:in std_logic;
    nrst:in std_logic;
    multiplicand:IN std_logic_vector(31 downto 0);
    multiplier:IN std_logic_vector(31 downto 0);
    result:out std_logic_vector(63 downto 0);
    done:out std_logic
);
end Karatsuba32;
architecture behavorial of Karatsuba32 is
    --declaration
    signal fHalf_multiplicand32:std_logic_vector(15 downto 0):=(others=>'0');
    signal fHalf_multiplier32:std_logic_vector(15 downto 0):=(others=>'0');
    signal sHalf_multiplicand32:std_logic_vector(15 downto 0):=(others=>'0');
    signal sHalf_multiplier32:std_logic_vector(15 downto 0):=(others=>'0');
    signal fsHalf_multiplicand32:std_logic_vector(15 downto 0):=(others=>'0');
    signal fsHalf_multiplier32:std_logic_vector(15 downto 0):=(others=>'0');
    signal ans1_32:std_logic_vector(31 downto 0):=(others=>'0');
    signal ans2_32:std_logic_vector(31 downto 0):=(others=>'0');
    signal ans3_32:std_logic_vector(31 downto 0):=(others=>'0');
    signal done_ans1_32:std_logic:='0';
    signal done_ans2_32:std_logic:='0';
    signal done_ans3_32:std_logic:='0';
    signal counter_finished32:std_logic:='0';
component Karatsuba16 IS 
port(
    clk:in std_logic;
    start:in std_logic;
    nrst:in std_logic;
    multiplicand:IN std_logic_vector(15 downto 0);
    multiplier:IN std_logic_vector(15 downto 0);
    result:out std_logic_vector(31 downto 0);
    done:out std_logic
);
end component;

begin
    fHalf_multiplicand32<=multiplicand(31 downto 16);
    fHalf_multiplier32<=multiplier(31 downto 16);
    sHalf_multiplicand32<=multiplicand(15 downto 0);
    sHalf_multiplier32<=multiplier(15 downto 0);
    fsHalf_multiplicand32<=fHalf_multiplicand32+sHalf_multiplicand32;
    fsHalf_multiplier32<=fHalf_multiplier32+sHalf_multiplier32;
    kar16_1:Karatsuba16 port map(
    clk,
    start,
    nrst,
    multiplicand=>fHalf_multiplicand32,
    multiplier=>fHalf_multiplier32,
    result=> ans1_32,
    done=>done_ans1_32);
    kar16_2:Karatsuba16 port map(
    clk,
    start,
    nrst,
    multiplicand=>sHalf_multiplicand32,
    multiplier=>sHalf_multiplier32,
    result=>ans2_32,
    done=>done_ans2_32
    );
    kar16_3:Karatsuba16 port map(
    clk,
    start,
    nrst,
    multiplicand=>fsHalf_multiplicand32,
    multiplier=>fsHalf_multiplier32,
    result=>ans3_32,
    done=>done_ans3_32
    );
    process(clk)
    variable z0_32: std_logic_vector(63 downto 0):=(others=>'0');
    variable z2_32: std_logic_vector(63 downto 0):=(others=>'0');
    variable z1_32: std_logic_vector(63 downto 0):=(others=>'0');
     begin
    if(rising_edge(clk)) then
      if(counter_finished32='1')then
           result<=(others=>'0');
           done<='0';
           counter_finished32<='0';
           z0_32:=(others=>'0');
           z1_32:=(others=>'0');
           z2_32:=(others=>'0');
      elsif(done_ans1_32='1' and done_ans2_32='1' and done_ans3_32='1')then
        z2_32:=ans1_32&"00000000000000000000000000000000";
        z1_32:="0000000000000000"&(ans3_32-ans1_32-ans2_32)&"0000000000000000";
        z0_32:="00000000000000000000000000000000"&ans2_32;
        done<='1';
        result<=z0_32+z1_32+z2_32;
        counter_finished32<='1';
      else
           result<=(others=>'0');
           done<='0';
     end if;
    end if;
    end process;
end behavorial;