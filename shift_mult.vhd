LIBRARY ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY shift_mul IS
    PORT (
        start:in std_logic;
        rst:in std_logic;
        clk:IN std_logic;
        multiplicand : IN std_logic_vector(7 DOWNTO 0);
        multiplier : IN std_logic_vector(7 DOWNTO 0);
        done:OUT std_logic;
        result : OUT std_logic_vector(15 DOWNTO 0)
       );
END shift_mul;
ARCHITECTURE arch OF shift_mul IS 
signal clk_counter:std_logic_vector(3 downto 0):="0000";
signal lock:std_logic:='0';

BEGIN
    PROCESS (clk,rst)
        variable mul_tmp : std_logic_vector(15 DOWNTO 0);
        variable out_tmp : std_logic_vector(15 DOWNTO 0);
        variable my_multiplier:std_logic_vector(7 downto 0):="00000000";
    BEGIN
     if (rst='1') then
            out_tmp:= (others => '0');
            mul_tmp :=  (others => '0');
            my_multiplier:= (others => '0');
            done <= '0';
            clk_counter <= (others => '0');
     elsif(rising_edge(clk) )then
           if (start='1') then
                      lock<='1';
                      mul_tmp := "00000000"&multiplicand;
                      my_multiplier:=multiplier;
                      out_tmp := (others => '0');
                      done<='0';
            elsif(lock='1')then
                  if (my_multiplier(0) = '1') THEN
                          out_tmp := out_tmp+mul_tmp;
                   end if;
                 mul_tmp := mul_tmp(14 DOWNTO 0) & '0'; 
                 my_multiplier:='0'& my_multiplier(7 downto 1);
                 clk_counter<=clk_counter+1; 
                 if(clk_counter="1000")then
                              clk_counter<="0000";  
                               lock<='0';
                               done<='1';
                               result <= out_tmp;
                 end if;
            else
                out_tmp:= (others => '0');
                mul_tmp :=  (others => '0');
                my_multiplier:= (others => '0');
                clk_counter <= (others => '0');
                done <= '0';
                result<=(others=>'0');
            end if;
                
         end if;
    END PROCESS;
END arch;
