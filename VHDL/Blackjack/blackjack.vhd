LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY BlackJack IS
	PORT(
		CLOCK_50 : in std_logic; -- A 50MHz clock
	   	SW   : in  std_logic_vector(17 downto 0); -- SW(0) = player stands
		   KEY  : in  std_logic_vector(3 downto 0);  -- KEY(3) reset, KEY(0) advance
	   	LEDR : out std_logic_vector(17 downto 0); -- red LEDs: dealer wins
	   	LEDG : out std_logic_vector(7 downto 0);  -- green LEDs: player wins

	   	HEX7 : out std_logic_vector(6 downto 0);  -- dealer, fourth card
	   	HEX6 : out std_logic_vector(6 downto 0);  -- dealer, third card
	   	HEX5 : out std_logic_vector(6 downto 0);  -- dealer, second card
	   	HEX4 : out std_logic_vector(6 downto 0);   -- dealer, first card

	   	HEX3 : out std_logic_vector(6 downto 0);  -- player, fourth card
	   	HEX2 : out std_logic_vector(6 downto 0);  -- player, third card
	   	HEX1 : out std_logic_vector(6 downto 0);  -- player, second card
	   	HEX0 : out std_logic_vector(6 downto 0)   -- player, first card
	);
END;


ARCHITECTURE Structural OF BlackJack IS

	COMPONENT Card7Seg IS
	PORT(
	   	card : IN  STD_LOGIC_VECTOR(3 DOWNTO 0); -- value of card
	   	seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- 7-seg LED pattern
	);
	END COMPONENT;

	COMPONENT DataPath IS
	PORT(
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		stand : IN STD_LOGIC;
		newPlayerCard : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		newDealerCard : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);

		playerCards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- player’s hand
		dealerCards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- dealer’s hand

		
		player_score : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		dealer_score : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		
		dealerStands : OUT STD_LOGIC; --true if dealerScore >= 17

		playerWins : OUT STD_LOGIC; --true if playerScore >  dealerScore AND playerScore <= 21
		dealerWins : OUT STD_LOGIC; --true if dealerScore >= playerScore AND dealerScore <= 21

		playerBust : OUT STD_LOGIC; -- true if playerScore > 21
		dealerBust : OUT STD_LOGIC  -- true if dealerScore > 21
	);
	END COMPONENT;

	COMPONENT FSM IS
	PORT(
		clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		nextStep     : IN STD_LOGIC; -- when true, it advances game to next step
		stand        : IN STD_LOGIC;
	   playerStands : IN STD_LOGIC; -- true if player wants to stand
	   dealerStands : IN STD_LOGIC; -- true if dealerScore >= 17
		playerWins   : IN STD_LOGIC; -- true if playerScore >  dealerScore AND playerScore <= 21
		dealerWins   : IN STD_LOGIC; -- true if dealerScore >= playerScore AND dealerScore <= 21
		playerBust   : IN STD_LOGIC; -- true if playerScore > 21
		dealerBust   : IN STD_LOGIC;  -- true if dealerScore > 21

		playerScore : IN STD_LOGIC_VECTOR(4 downto 0); 
		dealerScore : IN STD_LOGIC_VECTOR(4 downto 0);
		
		newPlayerCard : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		newDealerCard : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		red_LEDs		  : OUT STD_LOGIC_VECTOR(17 downto 0);
	   green_LEDs	  : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
	END COMPONENT;
	SIGNAL playerStands, dealerStands, playerWins, dealerWins, playerBust, dealerBust : STD_LOGIC := '0';
	SIGNAL newPlayerCard : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL newDealerCard : STD_LOGIC_VECTOR (3 DOWNTO 0);
	SIGNAL player_hand : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000"; 
	SIGNAL dealer_hand : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
	SIGNAL pLED, dLED : std_LOGIC_VECTOR(4 downto 0);
	
BEGIN
	state_machine : FSM
		port map  (clock_50, key(3), Key(0), SW(0), playerStands, dealerStands, playerWins, dealerWins, playerBust, dealerBust , pLED, dLED, newPlayerCard, newDealerCard, LEDR, LEDG);
	
	Data_path : DataPath
	port map (clock_50, key(3), SW(0), newPlayerCard, newDealerCard, player_hand, dealer_hand, pLED, dLED, dealerStands, playerWins, dealerWins, playerBust, dealerBust); 

	card7seg_1 : card7Seg
		port map (player_hand(3 downto 0), hex0);
	
	card7seg_2 : card7Seg
		port map (player_hand(7 downto 4), hex1);
	
	card7seg_3 : card7Seg
		port map (player_hand(11 downto 8), hex2);
	
	card7seg_4 : card7Seg
		port map (player_hand(15 downto 12), hex3);
		
	card7seg_5 : card7Seg
		port map (dealer_hand(3 downto 0), hex4);
	
	card7seg_6 : card7Seg
		port map (dealer_hand(7 downto 4), hex5);
		
	card7seg_7 : card7Seg
		port map (dealer_hand(11 downto 8), hex6);
	
	card7seg_8 : card7Seg
		port map (dealer_hand(15 downto 12), hex7);
	
END Structural;

