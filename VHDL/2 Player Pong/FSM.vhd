LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
use ieee.numeric_std.all;

ENTITY FSM IS
	PORT(
		
		clock : IN STD_LOGIC; 
		reset : IN STD_LOGIC; --KEY 3
		start : IN STD_LOGIC;
		done_drawing : IN STD_LOGIC; 
		winner : IN STD_LOGIC_VECTOR(1 downto 0);
		task		: OUT STD_LOGIC_VECTOR(2 downto 0); --tells the datapath what to draw, there are 6 different things(see below)7
		LEDR : OUT STD_LOGIC_VECTOR(17 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(7 downto 0)
);
END;

architecture behavioral of FSM is
	
	type states is (gamesetup, waiting, clearscreen, counting, t1_goalie, t1_forward, t2_goalie, t2_forward, puck, endgame_waiting);
	signal current_state : states := gamesetup;
	signal next_state : states := gamesetup;
	signal speed : integer range 0 to 2000000 := 2000000;
	signal current_count : integer range 0 to 500;
	
begin 

--fsm will be organized as several repeating steps
--1)draw the two horizontal lines and EVERYTHING else in the default location (task = 001) 
--2)refresh team 1's goalie (task = 010)
--3)"       " 1's forward (task = 011)
--4)"       " 2's goalie (task = 100)
--5)" 		" 2's forward (task = 101)
--6)refresh the puck (task = 110)
--7)if reset, clear the screen (task = 111)
	--then loop back to 2
--8)if winner != zero, jump to endgame state

process(clock, reset)

variable current_task : std_logic_vector(2 downto 0) := "001";
variable counter : integer range 0 to 4000000 := 0; --game speed
variable temp : std_logic;
variable t1_score : integer := 0; 
variable t2_score : integer := 0; 

begin
	
	if (reset = '0') then
		t1_score := 0; 
		t2_score := 0; 
		LEDR <= std_logic_vector(to_unsigned(t1_score,18));
		LEDG <= std_logic_vector(to_unsigned(t2_score,8));
		next_state <= clearscreen;
		counter := 0;
		current_task := "111";
	elsif (rising_edge(clock)) then
		
		counter := counter + 1;
		current_state <= next_state;
		task<=current_task;
		
		case current_state is
		
			when clearscreen =>
				current_task := "111";
				if (done_drawing = '1') then
					next_state <= gamesetup;
				else	
					next_state <= clearscreen;
				end if;
		
		
			when gamesetup =>					
													
				current_task := "001";					
				if (done_drawing = '1') then 
					next_state <= waiting;
				else
					next_state <= gamesetup;
				end if;
				
			when waiting =>
				if (start = '0') then
					next_state <= t1_goalie;
				else
					next_state <= waiting;
				end if;
				
			when counting =>
			
				if(counter = speed)then
					next_state <= t1_goalie;
					current_count <= current_count + 1;
					counter := 0;
				else
					next_state <= counting;
				end if;

			when t1_goalie =>

				task <= "010";
				if (done_drawing = '1') then
					if(temp = '0')then
						next_state <= t1_goalie;
						temp := '1';
					else
						next_state <= t1_forward;
						temp := '0';
					end if;
				else
					next_state <= t1_goalie;
				end if;
				
			when t1_forward =>
				
				task <= "011";
				if (done_drawing = '1') then
					next_state <= t2_goalie;
				else
					next_state <= t1_forward;
				end if;
				
			when t2_goalie =>
				task <= "100";
				if (done_drawing = '1') then
					next_state <= t2_forward;
				else
					next_state <= t2_goalie;
				end if;
				
			when t2_forward =>
				task <= "101";
				if (done_drawing = '1') then
					next_state <= puck;
				else
					next_state <= t2_forward;
				end if;
				
			when puck => 
				task <= "110";
				if (winner = "10") then -- t2 won (right)
					t2_score := t2_score + 1;
					LEDG <= std_logic_vector(to_unsigned(t2_score,8));
					next_state <= endgame_waiting;
				elsif (winner = "01") then --t1 won (left)
					t1_score := t1_score + 1;
					LEDR <= std_logic_vector(to_unsigned(t1_score,18));
					next_state <= endgame_waiting;
				elsif (done_drawing = '1') then
					next_state <= counting;
				else
					next_state <= puck;
				end if;
			
			when  endgame_waiting => --once in this state, loop until key 0 is pressed to start a new game
				if (start = '0') then
					current_count <= 0;
					task <= "111";
					next_state <= clearscreen;
				else
					next_state <= endgame_waiting;
				end if;
				
		end case;
		
		end if;
end process;

process(clock, current_count, winner)
begin
if(rising_edge(clock))then
--increases speed every 10 seconds (500 * 1 000 000 cycles = 500 million cycles @ 50 MHz = 10 seconds).
--if winner event occurs, resets to initial speed.
		if(current_count >= 480)then 
			speed <= speed - 50; 
		end if;
		if (winner > "00")then
			speed <= 2000000;
		end if;
end if;
end process;

end behavioral;