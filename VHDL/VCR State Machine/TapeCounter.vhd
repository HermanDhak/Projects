LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;

USE IEEE.NUMERIC_STD.ALL;

ENTITY TapeCounter IS
	PORT( 	
		Clock 			: IN STD_LOGIC ;
		Reset_L 			: IN STD_LOGIC ;
		Increment_H		: IN STD_LOGIC;
		Decrement_H		: IN STD_LOGIC;
		
		S1			: OUT UNSIGNED(3 DOWNTO 0);
		S2			: OUT UNSIGNED(3 DOWNTO 0);
		M1			: OUT UNSIGNED(3 DOWNTO 0);
		M2			: OUT UNSIGNED(3 DOWNTO 0);
		H1			: OUT UNSIGNED(3 DOWNTO 0);
		H2			: OUT UNSIGNED(3 DOWNTO 0)
		);
END;

ARCHITECTURE Behavioural OF TapeCounter IS
	SIGNAL S1_Temp : UNSIGNED(3 DOWNTO 0);
	SIGNAL S2T : UNSIGNED(3 DOWNTO 0); -- temporary signals which are used to an intermediate value
	SIGNAL M1T : UNSIGNED(3 DOWNTO 0);
	SIGNAL M2T : UNSIGNED(3 DOWNTO 0);
	SIGNAL H1T : UNSIGNED(3 DOWNTO 0);
	SIGNAL H2T : UNSIGNED(3 DOWNTO 0);
	
BEGIN
	PROCESS(Clock)
	BEGIN
			IF(rising_edge(Clock)) THEN   ---Reset, increment and decrement are synchronous
				IF(Reset_L = '0') THEN
					S1_Temp <= "0000";
					S2T <= "0000";
					M1T <= "0000";
					M2T <= "0000";
					H1T <= "0000";
					H2T <= "0000";
				
				ELSIF(Increment_H = '1' AND Decrement_H = '0') THEN    --INCREMENT
					IF (S1_Temp = "1001") THEN
						S1_Temp <= "0000";
						S2T <= S2T + 1;
					ELSE
						S1_Temp <= S1_Temp + 1;
					END IF;
					
					IF (S2T = "0101" AND S1_Temp = "1001") THEN
						S2T <= "0000";
						M1T <= M1T + 1;
					END IF;
					
					IF (M1T = "1001" AND S2T = "0101" AND S1_Temp = "1001") THEN
						M1T <= "0000";
						M2T <= M2T + 1;
					END IF;
					
					IF (M2T = "0101" AND M1T = "1001" AND S2T = "0101" AND S1_Temp = "1001") THEN
						M2T <= "0000";
						H1T <= H1T + 1;
					END IF;
					
					IF (H1T = "1001" AND M2T = "0101" AND M1T = "1001" AND S2T = "0101" AND S1_Temp = "1001") THEN
						H1T <= "0000";
						H2T <= H2T + 1;
					END IF;
					
					IF (H2T = "1001" AND H1T = "1001" AND M2T = "0101" AND M1T = "1001" AND S2T = "0101" AND S1_Temp = "1001") THEN
						H1T <= "0000";
						H2T <= "0000";
					END IF;
						
				
				ELSIF(Increment_H = '0' AND Decrement_H = '1') THEN	--DECREMENT
					IF (S1_Temp = "0000") THEN
						S1_Temp <= "1001";
						S2T <= S2T - 1;
					ELSE
						S1_Temp <= S1_Temp - 1;
					END IF;
					
					IF (S2T = "0000" AND S1_Temp = "0000") THEN
						S2T <= "0101";
						S1_Temp <= "1001";
						M1T <= M1T - 1;
					END IF;
					
					IF (M1T = "0000" AND S2T = "0000" AND S1_Temp = "0000") THEN
						M1T <= "1001";
						S2T <= "0101";
						S1_Temp <= "1001";
						M2T <= M2T - 1;
					END IF;
					
					IF (M2T = "0000" AND M1T = "0000" AND S2T = "0000" AND S1_Temp = "0000") THEN
						M2T <= "0101";
						M1T <= "1001";
						S2T <= "0101";
						S1_Temp <= "1001";
						H1T <= H1T - 1;
					END IF;
					
					IF (H1T = "0000" AND M2T = "0000" AND M1T = "0000" AND S2T = "0000" AND S1_Temp = "0000") THEN
						H1T <= "1001";
						M2T <= "0101";
						M1T <= "1001";
						S2T <= "0101";
						S1_Temp <= "1001";
						H2T <= H2T - 1;
					END IF;
					
					IF (H2T = "0000" AND H1T = "0000" AND M2T = "0000" AND M1T = "0000" AND S2T = "0000" AND S1_Temp = "0000") THEN
						H1T <= "1001";
						H2T <= "1001";
					END IF;
				
				ELSE
					S1_Temp <= S1_Temp; --no change to the output
					S2T <= S2T;
					M1T <= M1T;
					M2T <= M2T;
					H1T <= H1T;
					H2T <= H2T;
				END IF;
			END IF;
	END PROCESS;
	
	S1 <= S1_Temp;
	S2 <= S2T;
	M1 <= M1T;
	M2 <= M2T;
	H1 <= H1T;
	H2 <= H2T;
END;
	
	
	