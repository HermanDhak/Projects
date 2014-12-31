LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY card7seg IS
	PORT(
		card : IN  std_logic_vector(3 DOWNTO 0);
		seg7 : OUT  std_logic_vector(6 DOWNTO 0)
	);
END;

ARCHITECTURE behavioural OF card7seg IS

	CONSTANT ace     : std_logic_vector(6 DOWNTO 0) := "0001000";
	CONSTANT king    : std_logic_vector(6 DOWNTO 0) := "0001001";
	CONSTANT queen   : std_logic_vector(6 DOWNTO 0) := "0011000";
	CONSTANT jack    : std_logic_vector(6 DOWNTO 0) := "1100001";
	CONSTANT ten     : std_logic_vector(6 DOWNTO 0) := "1000000";
	CONSTANT nine    : std_logic_vector(6 DOWNTO 0) := "0010000";
	CONSTANT eight   : std_logic_vector(6 DOWNTO 0) := "0000000";
	CONSTANT seven   : std_logic_vector(6 DOWNTO 0) := "1111000";
	CONSTANT six     : std_logic_vector(6 DOWNTO 0) := "0000010";
	CONSTANT five    : std_logic_vector(6 DOWNTO 0) := "0010010";
	CONSTANT four    : std_logic_vector(6 DOWNTO 0) := "0011001";
	CONSTANT three   : std_logic_vector(6 DOWNTO 0) := "0110000";
	CONSTANT two     : std_logic_vector(6 DOWNTO 0) := "0100100";
	CONSTANT no_card : std_logic_vector(6 DOWNTO 0) := "1111111";

BEGIN
	
	PROCESS(card) 
	BEGIN
		CASE card IS
			WHEN "0010" => seg7 <= two;
			WHEN "0011" => seg7 <= three;
			WHEN "0100" => seg7 <= four;
			WHEN "0101" => seg7 <= five;
			WHEN "0110" => seg7	<= six;
			WHEN "0111" => seg7 <= seven;
			WHEN "1000" => seg7 <= eight;
			WHEN "1001" => seg7	<= nine;
			WHEN "1010" => seg7 <= ten;
			WHEN "1011" => seg7 <= jack;
			WHEN "1100" => seg7 <= queen;
			WHEN "1101" => seg7 <= king;
			WHEN "0001" => seg7 <= ace;
			WHEN "0000" => seg7 <= no_card;
			WHEN OTHERS => seg7 <= "1011111"; --throw a garbage value, it should should never equal this value.
		END CASE;
	END PROCESS;
END behavioural;