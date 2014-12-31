LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

ENTITY FSM IS
	PORT(
	clock         : IN STD_LOGIC;
	reset         : IN STD_LOGIC; --KEY3
	nextstep      : IN STD_LOGIC; --KEY0
	stand         : IN STD_LOGIC; --SW 0
	playerStands : IN STD_LOGIC; -- true if player wants to stand
	dealerStands : IN STD_LOGIC; -- true if dealerScore >= 17
	playerWins   : IN STD_LOGIC; -- true if playerScore >  dealerScore AND playerScore <= 21
	dealerWins   : IN STD_LOGIC; -- true if dealerScore >= playerScore AND dealerScore <= 21
	playerBust   : IN STD_LOGIC; -- true if playerScore > 21
	dealerBust   : IN STD_LOGIC;  -- true if dealerScore > 21
	playerScore : IN STD_LOGIC_VECTOR(4 downto 0); 
	dealerScore : IN STD_LOGIC_VECTOR(4 downto 0);
	newplayercard : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	newdealercard : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	red_LEDs		  : OUT STD_LOGIC_VECTOR(17 downto 0);
	green_LEDs	  : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
	END;
	
ARCHITECTURE behaviour OF FSM IS
	
	TYPE STATES IS (IDLE_STATE, GAME_START, DEAL_START, PLAYER_TURN2, PLAYER_TURN3, PLAYER_TURN4, DEALER_TURN2, DEALER_TURN3, DEALER_TURN4, WINNER, ENDGAME, DEALERWON, PLAYERWON);
	SIGNAL CURRENT_STATE : STATES := IDLE_STATE;
	SIGNAL NEXT_STATE : STATES;
	
	BEGIN
	PROCESS(clock, reset)
	
	VARIABLE player : STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
	VARIABLE dealer : STD_LOGIC_VECTOR(3 DOWNTO 0) :="0000";
	
	BEGIN
		
		IF(reset = '0')THEN
			player:="0000";
			dealer:="0000";
			newdealercard <= "0000";
			newplayercard <= "0000";
			red_LEDs <= "000000000000000000";
			green_LEDs <= "00000000";
			CURRENT_STATE <= IDLE_STATE;
		ELSIF(rising_edge(clock))THEN	
			newdealercard <= "0000";
			newplayercard <= "0000";
			red_LEDs(4 downto 0) <= dealerscore;
			green_LEDs(4 downto 0) <= playerScore;
			
			if(nextstep = '0')then
				CURRENT_STATE<=NEXT_STATE;
				newplayercard <= player;
				newdealercard <= dealer;
				player := "0000";
				dealer := "0000";
				--red_LEDs <= "000000000000000000";
				--green_LEDs <= "00000000";
			else	
				CASE CURRENT_STATE IS
					WHEN IDLE_STATE =>
						NEXT_STATE <= GAME_START;
					WHEN GAME_START =>              --P = 1
						player := "0001";
						NEXT_STATE <= DEAL_START;
					WHEN DEAL_START =>              --D = 1
						dealer := "0001";
						NEXT_STATE <=PLAYER_TURN2;  
					
					WHEN PLAYER_TURN2 =>            --P = 2
						player := "0010";
						NEXT_STATE <= PLAYER_TURN3;
	
					WHEN PLAYER_TURN3 =>            --P = 3
						if (stand = '1') then
							player := "0000";
							dealer := "0010";
							NEXT_STATE <= DEALER_TURN3;
						else
							player := "0100";
							NEXT_STATE <= PLAYER_TURN4;
						end if;
						
					WHEN PLAYER_TURN4 =>            --P = 4
						if (stand = '1' or playerBust = '1') then
							player := "0000";
							dealer := "0010";
							NEXT_STATE <= DEALER_TURN3;
						else
							player := "1000";
							NEXT_STATE <= DEALER_TURN2;
						end if;
				
	
-- DEALER -----------------------------------	
					WHEN DEALER_TURN2 =>
							dealer := "0010";
							NEXT_STATE <= DEALER_TURN3;  
						
					WHEN DEALER_TURN3 =>
						if (dealerStands = '1' or dealerBust = '1') then
							dealer := "0000";
							NEXT_STATE <= WINNER;
						else
							dealer := "0100";	
							NEXT_STATE <= DEALER_TURN4;  --D=4
						end if;
						
					WHEN DEALER_TURN4 =>
						if (dealerStands = '1' or dealerBust = '1') then 
							dealer := "0000";
							NEXT_STATE <= WINNER;
						else
							dealer := "1000";	
							NEXT_STATE <= WINNER;
						end if;
						
					WHEN WINNER =>
						if (dealerWins = '0' and playerWins = '0') then
							NEXT_STATE <= ENDGAME;
						elsif (dealerWins = '1') then
						   red_LEDs <= "111111111111111111";
							NEXT_STATE <= DEALERWON;
						elsif (playerWins = '1') then
							green_LEDs <= "11111111";
							NEXT_STATE <= PLAYERWON;
						else
							NexT_STATE <= ENDGAME;
						end if;	
					WHEN ENDGAME =>
						NEXT_STATE <= ENDGAME;
					WHEN PLAYERWON =>
						green_LEDs <= "11111111";
						NEXT_STATE <= ENDGAME;
					WHEN DEALERWON =>
						red_LEDs <= "111111111111111111";
						NEXT_STATE <= ENDGAME;
					WHEN OTHERS => NEXT_STATE <= IDLE_STATE;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
END behaviour;