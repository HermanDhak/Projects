LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;


ENTITY VCRPlayer	IS
	PORT(
		Reset				:IN STD_LOGIC;
		Clock				:IN STD_LOGIC;
		
	--Inputs
		Play				:IN STD_LOGIC;
		Pause				:IN STD_LOGIC;
		Stop				:IN STD_LOGIC;
		Record			:IN STD_LOGIC;
		Forward			:IN STD_LOGIC;
		Rewind			:IN STD_LOGIC;
		TapeLoaded		:IN STD_LOGIC;
		TapeStart		:IN STD_LOGIC;
		TapeEnd			:IN STD_LOGIC;
		WriteProtect:  :IN STD_LOGIC;
		Done				:IN STD_LOGIC;
		Ready				:IN STD_LOGIC;
			
	-- Outputs
		Increment		:OUT STD_LOGIC;
		Decrement		:OUT STD_LOGIC;
		Reset				:OUT STD_LOGIC;
		WriteMessage	:OUT STD_LOGIC;
		Load				:OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		Message			:OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
	);
END;