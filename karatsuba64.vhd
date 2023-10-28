library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity Karatsuba64 IS 
port(
    clk:in std_logic;
    start:in std_logic;
    nrst:in std_logic;
    multiplicand:IN std_logic_vector(63 downto 0);
    multiplier:IN std_logic_vector(63 downto 0);
    result:out std_logic_vector(127 downto 0);
    done:out std_logic
);
end Karatsuba64;

architecture behavorial of Karatsuba64 is
    -- signal fHalf_multiplicand64:std_logic_vector(31 downto 0):=(others=>'0');
    -- signal fHalf_multiplier64:std_logic_vector(31 downto 0):=(others=>'0');
    -- signal sHalf_multiplicand64:std_logic_vector(31 downto 0):=(others=>'0');
    -- signal sHalf_multiplier64:std_logic_vector(31 downto 0):=(others=>'0');
    signal fsHalf_multiplicand64:std_logic_vector(31 downto 0):=(others=>'0');
     signal fsHalf_multiplier64:std_logic_vector(31 downto 0):=(others=>'0');
    signal ans1_64:std_logic_vector(63 downto 0):=(others=>'0');
    signal ans2_64:std_logic_vector(63 downto 0):=(others=>'0');
    signal ans3_64:std_logic_vector(63 downto 0):=(others=>'0');
    signal done_ans1_64:std_logic:='0';
    signal done_ans2_64:std_logic:='0';
    signal done_ans3_64:std_logic:='0';
    signal counter_finished64:std_logic:='0';
--declaration
component shift_mul32 IS 
port(
        clk:IN std_logic;
        start:in std_logic;
        rst:in std_logic;
        multiplicand : IN std_logic_vector(31 DOWNTO 0);
        multiplier : IN std_logic_vector(31 DOWNTO 0);
        result : OUT std_logic_vector(63 DOWNTO 0);
        done:OUT std_logic
);
end component;

begin
    -- fHalf_multiplicand64<=multiplicand(63 downto 32);
    -- fHalf_multiplier64<=multiplier(63 downto 32);
    -- sHalf_multiplicand64<=multiplicand(31 downto 0);
    -- sHalf_multiplier64<=multiplier(31 downto 0);
     fsHalf_multiplicand64<=multiplicand(63 downto 32) +multiplicand(31 downto 0);
    fsHalf_multiplier64<= multiplier(63 downto 32)+multiplier(31 downto 0);
    mul32_1:shift_mul32 port map(
    clk=>clk,
    start=>start,
    rst=>nrst,
    multiplicand=>multiplicand(63 downto 32),
    multiplier=>multiplier(63 downto 32),
    result=> ans1_64,
    done=>done_ans1_64
   
    );
    mul32_2:shift_mul32 port map(
    clk=>clk,
    start=>start,
    rst=>nrst,
    multiplicand=>multiplicand(31 downto 0),
    multiplier=>multiplier(31 downto 0),
    result=>ans2_64,
    done=>done_ans2_64
    
    
    );
    mul32_3:shift_mul32 port map(
    clk=>clk,
     start=>start,
    rst=>nrst,
    multiplicand=> fsHalf_multiplicand64,
    multiplier=>fsHalf_multiplier64,
     result=>ans3_64,
    done=>done_ans3_64
   
    );
    process(clk)
    variable z0_64: std_logic_vector(127 downto 0):=(others=>'0');
    variable z2_64: std_logic_vector(127 downto 0):=(others=>'0');
    variable z1_64: std_logic_vector(127 downto 0):=(others=>'0');
    begin
    if(rising_edge(clk)) then
     if(counter_finished64='1')then
           result<=(others=>'0');
           done<='0';
           counter_finished64<='0';
           z0_64:=(others=>'0');
           z1_64:=(others=>'0');
           z2_64:=(others=>'0');
           counter_finished64<='0';
     elsif(done_ans1_64='1' and done_ans2_64='1' and done_ans3_64='1')then
            z2_64:=ans1_64&"0000000000000000000000000000000000000000000000000000000000000000";
            z1_64:="00000000000000000000000000000000"&(ans3_64-ans1_64-ans2_64)&"00000000000000000000000000000000";
            z0_64:="0000000000000000000000000000000000000000000000000000000000000000"&ans2_64;
            done<='1';
            counter_finished64<='1';
            result<=z0_64+z1_64+z2_64;
      else
           result<=(others=>'0');
           done<='0';
     end if;
    end if;
    end process;
end behavorial;