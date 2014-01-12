LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;

ENTITY Timer IS
		PORT( 	
			Clock			 	: IN STD_LOGIC;
			Load				: IN UNSIGNED(1 DOWNTO 0); -- there are three types of loads so use a 2 bit number
			Done				: OUT STD_LOGIC
		);
	END;
	
ARCHITECTURE Behavorial OF Timer IS
	SIGNAL 	Count : UNSIGNED (31 DOWNTO 0); 
	
	
BEGIN
	PROCESS(Clock)
	BEGIN	
		IF(rising_edge(Clock)) THEN
			IF (Count  = 0) THEN
				IF (Load = "11") THEN -- 1 second
					Count <= X"02FA_F080"; -- Approx 50 million
				
				ELSIF (Load = "10") THEN -- 1/5th of a second
					Count <= X"0098_967F"; -- Approx 10 million
				
				ELSIF (Load = "01" ) THEN	-- 1/100th of a second
					Count <= X"0007_A11F";  -- Approx 500k
				
				END IF;
			ELSIF (Count > 0 ) THEN	
				Count <= Count - X"0000_0001";
				
			ELSE	
				Count <= X"0000_0000";
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(Count)
	BEGIN
		IF (Count = 0) THEN
			Done <= '1';
		ELSE
			Done <= '0';
		END IF;
	END PROCESS;
END;