library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity Karatsuba128 IS 
port(
    clk:in std_logic;
    start:in std_logic;
    nrst:in std_logic;
    multiplicand:IN std_logic_vector(127 downto 0);
    multiplier:IN std_logic_vector(127 downto 0);
    result:out std_logic_vector(255 downto 0);
    done:out std_logic
);
end Karatsuba128;
architecture behavorial of Karatsuba128 is
    -- signal fHalf_multiplicand128:std_logic_vector(63 downto 0):=(others=>'0');
    -- signal fHalf_multiplier128:std_logic_vector(63 downto 0):=(others=>'0');
    -- signal sHalf_multiplicand128:std_logic_vector(63 downto 0):=(others=>'0');
    -- signal sHalf_multiplier128:std_logic_vector(63 downto 0):=(others=>'0');
     signal fsHalf_multiplicand128:std_logic_vector(63 downto 0):=(others=>'0');
     signal fsHalf_multiplier128:std_logic_vector(63 downto 0):=(others=>'0');
    signal ans1_128:std_logic_vector(127 downto 0):=(others=>'0');
    signal ans2_128:std_logic_vector(127 downto 0):=(others=>'0');
    signal ans3_128:std_logic_vector(127 downto 0):=(others=>'0');
    signal done_ans1_128:std_logic:='0';
    signal done_ans2_128:std_logic:='0';
    signal done_ans3_128:std_logic:='0';
    signal counter_finished128:std_logic:='0';
--declaration
component Karatsuba64 IS 
port(
    clk:in std_logic;
    start:in std_logic;
    nrst:in std_logic;
    multiplicand:IN std_logic_vector(63 downto 0);
    multiplier:IN std_logic_vector(63 downto 0);
    result:out std_logic_vector(127 downto 0);
    done:out std_logic
);
end component;

 begin
--     fHalf_multiplicand128<=multiplicand(127 downto 64);
--     fHalf_multiplier128<=multiplier(127 downto 64);
--     sHalf_multiplicand128<=multiplicand(63 downto 0);
--     sHalf_multiplier128<=multiplier(63 downto 0);
     fsHalf_multiplicand128<= multiplicand(127 downto 64)+multiplicand(63 downto 0);
     fsHalf_multiplier128<= multiplier(127 downto 64)+multiplier(63 downto 0);
    kar64_1:Karatsuba64 port map(
    clk,
    start,
    nrst,
    multiplicand=>multiplicand(127 downto 64),
    multiplier=>multiplier(127 downto 64),
    result=> ans1_128,
    done=>done_ans1_128);
    kar64_2:Karatsuba64 port map(
    clk,
    start,
    nrst,
    multiplicand=>multiplicand(63 downto 0),
    multiplier=>multiplier(63 downto 0),
    result=>ans2_128,
    done=>done_ans2_128
    );
    kar64_3:Karatsuba64 port map(
    clk,
    start,
    nrst,
    multiplicand=> fsHalf_multiplicand128,
    multiplier=>fsHalf_multiplier128,
    result=>ans3_128,
    done=>done_ans3_128
    );
    process(clk)
    variable z0_128: std_logic_vector(255 downto 0):=(others=>'0');
    variable z2_128: std_logic_vector(255 downto 0):=(others=>'0');
    variable z1_128: std_logic_vector(255 downto 0):=(others=>'0');
    begin
    if(rising_edge(clk))then
          if(counter_finished128='1')then
           result<=(others=>'0');
           done<='0';
           counter_finished128<='0';
           z0_128:=(others=>'0');
           z1_128:=(others=>'0');
           z2_128:=(others=>'0');
           counter_finished128<='0';
     elsif(done_ans1_128='1' and done_ans2_128='1' and done_ans3_128='1')then
        z2_128:=ans1_128&"00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000";
     
        z1_128:="0000000000000000000000000000000000000000000000000000000000000000"&
        (ans3_128-ans1_128-ans2_128)&
        "0000000000000000000000000000000000000000000000000000000000000000";

        z0_128:="00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"&
        ans2_128;
        done<='1';
         counter_finished128<='1';
        result<=z0_128+z1_128+z2_128;
     else
           result<=(others=>'0');
           done<='0';
     end if;
    end if;
    end process;
end behavorial;