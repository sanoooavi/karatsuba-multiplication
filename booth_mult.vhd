library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;   
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity mult is
    port(
        clk:IN std_logic;
        multiplicand:IN std_logic_vector(7 downto 0);
        multiplier:IN std_logic_vector(7 downto 0);
        result:OUT std_logic_vector(15 downto 0)
    );
    end mult;
architecture booth_mult of mult is
     signal addition: std_logic_vector(16 downto 0):=(others=>'0');
     signal subtract: std_logic_vector(16 downto 0):=(others=>'0');
     signal clk_counter:std_logic_vector(3 downto 0):="0000";
    begin
        process(clk)
          variable product : std_logic_vector(16 downto 0):=(others=>'0');
        begin
            if(rising_edge(clk)) then
               if(clk_counter="0000")then
                         addition(16 downto 9)<=multiplicand;
                         subtract(16 downto 9)<=not(multiplicand)+1;
                         product(8 downto 1):=multiplier;
              
               end if;
               case product(1 downto 0) is
                  when "01"=>
                      product:=product+addition;
                  when "10"=>
                      product:=product+subtract;        
                  when others=>
                      product:=product;
               end case;
                clk_counter<=clk_counter+1; 
                product:=product(16)&product(16 downto 1) ;
                         if(clk_counter="0111")then
                              clk_counter<="0000";  
                              result<=product(16 downto 1);
                         end if;
               
             end if;
        end process;
    end booth_mult;