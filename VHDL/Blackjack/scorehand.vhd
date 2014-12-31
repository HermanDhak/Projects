LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY scorehand IS
	PORT(
		card1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		card2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		card3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		card4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		sum   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bust : OUT STD_LOGIC;
		stand : OUT STD_LOGIC 
	);
	END;
	
ARCHITECTURE behaviour OF scorehand IS
	TYPE hand is ARRAY (3 downto 0) of STD_LOGIC_VECTOR(3 DOWNTO 0);
	TYPE flag_s is ARRAY (3 downto 0) of STD_LOGIC;
	CONSTANT ace : STD_LOGIC_VECTOR(3 DOWNTO 0):= "0001";
	CONSTANT jack : STD_LOGIC_VECTOR(3 DOWNTO 0):= "1011";
	CONSTANT queen : STD_LOGIC_VECTOR(3 DOWNTO 0):= "1100";
	CONSTANT king : STD_LOGIC_VECTOR(3 DOWNTO 0):= "1101";
	
	SIGNAL current_sum : std_logic_vector(4 DOWNTO 0);
	SIGNAL complete : std_logic;
	
	BEGIN
		PROCESS(card1, card2, card3, card4)
			VARIABLE flags : flag_s;
			VARIABLE cards : hand; --an array in which to store the 4 card values
			VARIABLE process_sum : std_logic_vector(4 DOWNTO 0) := "00000";
			VARIABLE flag_counter: integer range 0 to 4 := 0;			
		BEGIN
			cards(0)	:= card1;
			cards(1) := card2;
			cards(2) := card3;
			cards(3) := card4;
			
			--ace and face card tests
				case cards(0) is						
					when ace =>
						flags(0) := '1';
						flag_counter := flag_counter + 1;
						process_sum := std_logic_vector(unsigned(process_sum)+"00000");
					when jack =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(0) := '0';
						flag_counter := flag_counter + 0;
					when queen =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(0) := '0';
						flag_counter := flag_counter + 0;
					when king =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(0) := '0';
						flag_counter := flag_counter + 0;
					when others =>
						process_sum := std_logic_vector(unsigned(process_sum)+unsigned(cards(0)));
						flags(0) := '0';
						flag_counter := flag_counter + 0;
				end case;
			
				case cards(1) is						
					when ace =>
						flags(1) := '1';
						flag_counter := flag_counter + 1;
						process_sum := std_logic_vector(unsigned(process_sum)+"00000");
					when jack =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(1) := '0';
						flag_counter := flag_counter + 0;
					when queen =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(1) := '0';
						flag_counter := flag_counter + 0;
					when king =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(1) := '0';
						flag_counter := flag_counter + 0;
					when others =>
						process_sum := std_logic_vector(unsigned(process_sum)+unsigned(cards(1)));
						flags(1) := '0';
						flag_counter := flag_counter + 0;
				end case;
				
				case cards(2) is						
					when ace =>
						flags(2) := '1';
						flag_counter := flag_counter + 1;
						process_sum := std_logic_vector(unsigned(process_sum)+"00000");
					when jack =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(2) := '0';
						flag_counter := flag_counter + 0;
					when queen =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(2) := '0';
						flag_counter := flag_counter + 0;
					when king =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(2) := '0';
						flag_counter := flag_counter + 0;
					when others =>
						process_sum := std_logic_vector(unsigned(process_sum)+unsigned(cards(2)));
						flags(2) := '0';
						flag_counter := flag_counter + 0;
				end case;
				
				case cards(3) is						
					when ace =>
						flags(3)  := '1';
						flag_counter := flag_counter + 1;
						process_sum := std_logic_vector(unsigned(process_sum)+"00000");
					when jack =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(3) := '0';
						flag_counter := flag_counter + 0;
					when queen =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(3) := '0';
						flag_counter := flag_counter + 0;
					when king =>
						process_sum := std_logic_vector(unsigned(process_sum)+ "01010");
						flags(3) := '0';
						flag_counter := flag_counter + 0;
					when others =>
						process_sum := std_logic_vector(unsigned(process_sum)+unsigned(cards(3)));
						flags(3) := '0';
						flag_counter := flag_counter + 0;
				end case;
			
			--flag tests.
					
				case flags(0) is -- if the card's flag is set then...	
					When '1'=>
						if(flag_counter <= 1) AND (process_sum <= "01010")then				   --if this is the last ace and the sum is less than or
							process_sum := std_logic_vector(unsigned(process_sum)+"01011");	--equal to 10 then add this ace as an '11'
							flag_counter := flag_counter-1;
						else	
							process_sum := std_logic_vector(unsigned(process_sum)+"00001");	--otherwise add it as a '1'
							flag_counter := flag_counter-1;
						end if;
					when '0' =>
					 null;
				end case;

				case flags(1) is -- if the card's flag is set then...	
					When '1'=>
						if(flag_counter <= 1) AND (process_sum <= "01010")then				   --if this is the last ace and the sum is less than or
							process_sum := std_logic_vector(unsigned(process_sum)+"01011");	--equal to 10 then add this ace as an '11'
							flag_counter := flag_counter-1;
						else	
							process_sum := std_logic_vector(unsigned(process_sum)+"00001");	--otherwise add it as a '1'
							flag_counter := flag_counter-1;
						end if;
					when '0' =>
					 null;
				end case;
				
				case flags(2) is -- if the card's flag is set then...	
					When '1'=>
						if(flag_counter <= 1) AND (process_sum <= "01010")then				   --if this is the last ace and the sum is less than or
							process_sum := std_logic_vector(unsigned(process_sum)+"01011");	--equal to 10 then add this ace as an '11'
							flag_counter := flag_counter-1;
						else	
							process_sum := std_logic_vector(unsigned(process_sum)+"00001");	--otherwise add it as a '1'
							flag_counter := flag_counter-1;
						end if;
					when '0' =>
					 null;
				end case;
				
				case flags(3) is -- if the card's flag is set then...	
					When '1'=>
						if(flag_counter <= 1) AND (process_sum <= "01010")then				   --if this is the last ace and the sum is less than or
							process_sum := std_logic_vector(unsigned(process_sum)+"01011");	--equal to 10 then add this ace as an '11'
							flag_counter := flag_counter-1;
						else	
							process_sum := std_logic_vector(unsigned(process_sum)+"00001");	--otherwise add it as a '1'
							flag_counter := flag_counter-1;
						end if;
					when '0' =>
					 null;
				end case;
				
		current_sum <= process_sum;
		complete <= '1';
		flag_counter:=0;
		process_sum := "00000";
		
	END PROCESS;
	
	PROCESS(current_sum, complete)
	
	BEGIN
		if(current_sum > "10101")then		--if the current sum is greater than 21, player's hand is a bust
			stand <= '0';
			bust <= '1';
			sum <= "11111"; --turn on all LED's to indicate a bust
		elsif(current_sum >= "10001") AND (complete = '1')then --if the current sum is greater than/equal to 17, dealer stands
			stand <= '1';
			bust <= '0';
			sum <= current_sum;
		else					--otherwise do nothing
			bust <= '0';
			stand <= '0';
			sum <= current_sum;
		end if;
	END PROCESS;
	
END behaviour;