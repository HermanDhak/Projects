LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY Datapath IS
	PORT(
		clock         : IN STD_LOGIC;
		reset         : IN STD_LOGIC;
		stand			  : IN STD_LOGIC;
		newPlayerCard : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		newDealerCard : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		playercards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		dealercards : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		player_score : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		dealer_score : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		dealerStands : OUT STD_LOGIC; --true if dealerScore >= 17
		playerWins : OUT STD_LOGIC; --true if playerScore >  dealerScore AND playerScore <= 21
		dealerWins : OUT STD_LOGIC; --true if dealerScore >= playerScore AND dealerScore <= 21
		playerBust : OUT STD_LOGIC; -- true if playerScore > 21
		dealerBust : OUT STD_LOGIC  -- true if dealerScore > 21
	);
	END;
	
ARCHITECTURE behaviour OF Datapath IS

	COMPONENT dealcard IS
		PORT(
		clock_50: IN std_logic;
		card    : OUT std_logic_vector(3 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT scorehand IS
	PORT(
		card1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		card2 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		card3 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		card4 : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		sum   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		bust : OUT STD_LOGIC;
		stand : OUT STD_LOGIC
		);
	END COMPONENT;
	
	
	SIGNAL pbust : STD_LOGIC;
	SIGNAL dbust : STD_LOGIC;
	SIGNAL dstand : STD_LOGIC;
	SIGNAL sump : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL sumd : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal card : std_logic_vector (3 downto 0);
	SIGNAL c1p : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c2p : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c3p : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c4p : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c1d : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c2d : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c3d : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c4d : STD_LOGIC_VECTOR(3 DOWNTO 0);	
BEGIN
	deal_inst : dealcard
		port map (clock, card);
	
	score_inst_player : scorehand
	   port map (c1p, c2p, c3p, c4p, sump, pbust); --we dont need to recieve a stand signal here since it is player controlled
		
	score_inst_dealer : scorehand
		port map (c1d, c2d, c3d, c4d, sumd, dbust, dstand);
	
----------------- BEGIN PROCESS -------------------------------------
	PROCESS(clock, reset)
		
		VARIABLE new_card : STD_LOGIC_VECTOR(3 downto 0);
		VARIABLE player, dealer : STD_LOGIC_VECTOR(3 downto 0);
		
	BEGIN
	
	If(reset = '0')then
		playercards <= "0000000000000000";
		dealercards <= "0000000000000000";
		c1p <= "0000";
		c2p <= "0000";
		c3p <= "0000";
		c4p <= "0000";
		c1d <= "0000";
		c2d <= "0000";
		c3d <= "0000";
		c4d <= "0000";
	elsIf(rising_edge(clock))then
	
		player := newPlayerCard;
		dealer := newdealerCard;
	
		if (Player(0) = '1') then
			new_card := card;	
			c1p <= new_card;
		end if;
		
		if (Player(1) = '1')THEN
			new_card := card;	
			c2p <= new_card;
		END IF;
	
		if (Player(2) = '1')THEN
			new_card := card;	
			c3p <= new_card;
		END IF;
		
		if (Player(3) = '1')THEN
			new_card := card;	
			c4p <= new_card;
		END IF;
	
	
		--------------------
		player_score <= sump;
		--------------------
		
		if (Dealer(0) ='1') then
			new_card := card;	
			c1d <= new_card;
		end if;
	
		if(Dealer(1) = '1') then
			new_card := card;	
			c2d <= new_card;
		END IF;
		
		if(Dealer(2) = '1') then
			new_card := card;	
			c3d <= new_card;
		END IF;
		
		if(Dealer(3) = '1') then
			new_card := card;	
			c4d <= new_card;
		END IF;
		
		--------------------
		dealer_score <= sumd;
		--------------------
		
		playercards(3 downto 0) <= c1p;
		playercards(7 downto 4) <= c2p;
		playercards(11 downto 8) <= c3p;
		playercards(15 downto 12) <= c4p;
		
		dealercards(3 downto 0) <= c1d;
		dealercards(7 downto 4) <= c2d;
		dealercards(11 downto 8) <= c3d;
		dealercards(15 downto 12) <= c4d;
		
		playerBust <= pbust;
		dealerBust <= dbust;
		dealerStands <= dstand;
		
		player := "0000";
      dealer := "0000";		
		
	END IF;
	
	END PROCESS;
	
PROCESS(pbust, dBust, dStand, sump, sumd)
begin
	if (pBust = '1' and dBust = '1') then
		playerWins <= '0';
		dealerWins <= '0';
	elsif (pBust = '1' and dstand = '1' and dBust = '0') then
		playerWins <= '0';
		dealerWins <= '1';
	elsif (pBust = '0' and dBust = '1') then
		playerWins <= '1';
		dealerWins <= '0';
	elsif (stand = '1' and dstand = '1' and sump > sumd)then
		playerWins <= '1';
		dealerWins <= '0';
	elsif (sump <= sumd) then
		playerWins <= '0';
		dealerWins <= '1';
	elsif (sump > sumd) then
		playerWins <= '0';
		dealerWins  <= '1';
	else
		playerWins <= '0';
		dealerWins <= '0';
	end if;
end process;
END behaviour;