LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY HexDisplayDriver IS
	PORT(
	   	Inputs_DCBA 			: in std_logic_vector(3 downto 0) ; 	
	   	Segments_g_to_a 		: out std_logic_vector(0 to 6)  	
       );
END;

ARCHITECTURE Behavioural OF HexDisplayDriver IS
BEGIN
	PROCESS(Inputs_DCBA) 						
	BEGIN


		if(Inputs_DCBA = "0000") then			--0
			Segments_g_to_a <= "0000001"; 		
		
		elsif(Inputs_DCBA = "0001") then		--1
			Segments_g_to_a <= "1001111";
		
		elsif(Inputs_DCBA = "0010") then		--2
			Segments_g_to_a <= "0010010";	
		
		elsif(Inputs_DCBA = "0011") then		--3
			Segments_g_to_a <= "0000110";
		
		elsif(Inputs_DCBA = "0100") then		--4
			Segments_g_to_a <= "1001100";
		
		elsif(Inputs_DCBA = "0101") then		--5
			Segments_g_to_a <= "0100100";
		
		elsif(Inputs_DCBA = "0110") then		--6	
			Segments_g_to_a <= "0100000";
			
		elsif(Inputs_DCBA = "0111") then		--7
			Segments_g_to_a <= "0001111";
		
		elsif(Inputs_DCBA = "1000") then		--8
			Segments_g_to_a <= "0000000";
		
		elsif(Inputs_DCBA = "1001") then		--9
			Segments_g_to_a <= "0000100";
		
		elsif(Inputs_DCBA = "1010") then		--A
			Segments_g_to_a <= "0001000";
		
		elsif(Inputs_DCBA = "1011") then		--B
			Segments_g_to_a <= "1100000";
		
		elsif(Inputs_DCBA = "1100") then		--C
			Segments_g_to_a <= "0110001";
			
		elsif(Inputs_DCBA = "1101") then		--D
			Segments_g_to_a <= "1000010";
			
		elsif(Inputs_DCBA = "1110") then		--E
			Segments_g_to_a <= "0110000";
			
		elsif(Inputs_DCBA = "1111") then		--F
			Segments_g_to_a <= "0111000";
		
		else												-- if inputs = 1111
			Segments_g_to_a <= "1111111"; 		
		end if ;	

	END PROCESS ;									
END;
