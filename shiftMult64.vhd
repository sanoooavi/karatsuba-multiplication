LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
 use ieee.numeric_std.all ;
ENTITY shift_mul64 IS
    PORT (
         clk:IN std_logic;
        start:in std_logic;
        rst:in std_logic;
        multiplicand : IN std_logic_vector(63 DOWNTO 0);
        multiplier : IN std_logic_vector(63 DOWNTO 0);
        result : OUT std_logic_vector(127 DOWNTO 0);
        done:OUT std_logic
       );
END shift_mul64;
ARCHITECTURE arch OF shift_mul64 IS 
signal clk_counter:integer:=0;
signal lock:std_logic:='0';
signal my_multiplier:std_logic_vector(63 downto 0):=(others=>'0');
signal mul_tmp : std_logic_vector(127 DOWNTO 0);
signal out_tmp : std_logic_vector(127 DOWNTO 0);

BEGIN
    PROCESS (clk,rst)
        
    BEGIN
     if (rst='1') then
            out_tmp<= (others => '0');
            mul_tmp <=  (others => '0');
            my_multiplier<= (others => '0');
            done <= '0';
            clk_counter <=0;
     elsif(rising_edge(clk) )then
           if (start='1') then
                      lock<='1';
                      mul_tmp(127 downto 64)<=(others=>'0');
                      mul_tmp(63 downto 0) <=multiplicand;
                      my_multiplier<=multiplier;
                      out_tmp <= (others => '0');
                      done<='0';
            elsif(lock='1')then
                  if (my_multiplier(0) = '1') THEN
                          out_tmp <= out_tmp+mul_tmp;
                   end if;
                 mul_tmp <= std_logic_vector(shift_left(unsigned(mul_tmp),1)); 
                 my_multiplier<=std_logic_vector(shift_right(unsigned(my_multiplier),1));
                 clk_counter<=clk_counter+1; 
                 if(clk_counter=64)then
                              clk_counter<=0;  
                               lock<='0';
                               done<='1';
                               result <= out_tmp;
                 end if;
            else
                out_tmp<= (others => '0');
                mul_tmp <=  (others => '0');
                my_multiplier<= (others => '0');
                clk_counter <= 0;
                done <= '0';
                result<=(others=>'0');
            end if;
                
         end if;
    END PROCESS;
END arch;
