LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY dealcard IS
	PORT(
		clock_50: IN std_logic;
		card    : OUT std_logic_vector(3 DOWNTO 0)
	);
	END;
	
ARCHITECTURE behavioural OF dealcard IS	
BEGIN
	PROCESS(clock_50)
		
		variable current_card : std_logic_vector( 3 downto 0 ) := "0001";
    	variable next_card : std_logic_vector( 3 downto 0 );
		
		BEGIN
			
			IF(rising_edge(clock_50))THEN
				
				card <= current_card;
				
				CASE current_card IS
					when "0001" => next_card := "0010"; 
					when "0010" => next_card := "0011";
					when "0011" => next_card := "0100";
					when "0100" => next_card := "0101" ;
					when "0101" => next_card := "0110";
					when "0110" => next_card := "0111";
					when "0111" => next_card := "1000";
					when "1000" => next_card := "1001";
					when "1001" => next_card := "1010";
					when "1010" => next_card := "1011";
					when "1011" => next_card := "1100";
					when "1100" => next_card := "1101";
					when others => next_card := "0001";
				END CASE;
				current_card := next_card;
			END IF;
		END PROCESS;
END behavioural;	