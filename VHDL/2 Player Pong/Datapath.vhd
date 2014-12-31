LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
use ieee.numeric_std.all;

ENTITY Datapath IS
	PORT(
		clock : IN STD_LOGIC; 
		reset : IN STD_LOGIC; --KEY 3
		task  : IN STD_LOGIC_VECTOR(2 downto 0);
		movement : IN STD_LOGIC_VECTOR(17 downto 0);
		colour_plot   : OUT STD_LOGIC_VECTOR(2 downto 0);
		x       : OUT STD_LOGIC_VECTOR(7 downto 0);
		y		  : OUT STD_LOGIC_VECTOR(6 downto 0); 
		plot    : OUT STD_LOGIC; 
		done_drawing  : OUT STD_LOGIC; --send to fsm after vga core is done drawing so that fsm is ready to send new values.
		winner : OUT std_logic_vector (1 downto 0)
);
END;

architecture behavioural of datapath is
	
begin

process(clock, reset)

   --==Clear screen variables========================
	variable x_counter : std_logic_vector(7 downto 0):="00000000";
	variable y_counter : std_logic_vector(6 downto 0):="0000000";
	constant x_159 : std_logic_vector := "10011111";
	constant y_119 : std_logic_vector :="1110111";
	--================================================
	
	--==Draw white line variables=====================
	variable line_x : std_logic_vector(7 downto 0) := "00000000"; --counter for x direction
	constant y_top : std_logic_vector := "0000000"; --represents the top y boundary of the game
	constant y_bottom : std_logic_vector := "1110111"; -- represents the bottom y boundary
	variable line_y : std_logic_vector(6 downto 0) := y_top; --counter for y direction
	--================================================
	
	--==T1 goalie variables===========================
	variable y0_t1g : integer := 50; 
	variable y1_t1g : integer := 65;      --initial and final points
	constant x_t1g : integer := 5;        --constant x coordinate  
	variable counter_y1 : integer := 1;   --starts at 1 so that we don't have black spots on the white line 
	variable clear_t1g : std_logic := '0'; --temp variable for erasing a pixel when the paddle move 
	variable flag1     : std_logic;			--1 if moving up, 0 if moving down
	variable move1     : std_logic;			--prevents the paddle from being moved more than 1 time per state 
	--==T1 forward variables===========================
	variable y0_t1f : integer := 50; 
	variable y1_t1f : integer := 65;      --initial and final points
	constant x_t1f : integer := 50;       --constant x coordinate  
	variable counter_y2 : integer := 1;   --starts at 1 so that we don't have black spots on the white line 
	variable clear_t1f : std_logic := '0';
	variable flag2     : std_logic;
	variable move2     : std_logic;
	--==T2 goalie variables===========================
	variable y0_t2g : integer := 50; 
	variable y1_t2g : integer := 65;      --initial and final points
	constant x_t2g : integer := 154;      --constant x coordinate  
	variable counter_y3 : integer := 1;   --starts at 1 so that we don't have black spots on the white line 
	variable clear_t2g : std_logic := '0';
	variable flag3     : std_logic;
	variable move3     : std_logic;
	--==T2 forward variables===========================
	variable y0_t2f : integer := 50; 
	variable y1_t2f : integer := 65;      --initial and final points
	constant x_t2f : integer := 110;      --constant x coordinate  
	variable counter_y4 : integer := 1;   --starts at 1 so that we don't have black spots on the white line 
	variable clear_t2f : std_logic := '0';
	variable flag4     : std_logic;			
	variable move4     : std_logic;
	--==Puck variables=================================
	variable dx : integer :=  -1;					--rates of change
	variable dy : integer := -1;
	variable puck_x : integer := 80;				--position
	variable puck_y : integer := 60;
	variable clear_puck : std_logic := '1';
	variable oldpuck_x: integer := puck_x;
	variable oldpuck_y : integer := puck_y;

	
begin
		if (reset = '0') then
			plot <= '0';
			done_drawing <= '0';
			x_counter:="00000000";
			y_counter:="0000000";
			x <= "00000000";
			y <= "0000000";
			line_x := "00000000";
			line_y := y_top;
			dx :=  1;
			dy := 1;
			puck_x := 80; 
			puck_y := 60;					
		elsif (rising_edge(clock)) then
		
--====clear screen code(taken from last lab)===================
			if(task = "111")then
				plot <= '1';
				done_drawing <= '0';
				
				x <= x_counter;
				y <= y_counter;
				colour_plot <= "000";	
				if(x_counter > x_159)then
					x_counter := "00000000";
					if (y_counter > y_119)then  --reset all the variables (this may have to be moved to a separate task that clears variables and then comes to this task)
						plot <= '0';
						y_counter := "0000000";
						x_counter := "00000000";
						x <= "00000000";
						y <= "0000000";
						line_x := "00000000";
						line_y := y_top;
						dx :=  1;
						dy := 1;
						puck_x := 80; 
						puck_y := 60;
						done_drawing <= '1';
					else
						y_counter := std_logic_vector(unsigned(y_counter) + 1);
					end if;
				else
					x_counter := std_logic_vector(unsigned(x_counter) + 1);
			   end if;	

--====draw horizontal lines=======
			elsif (task = "001") then
				plot <= '1';
				done_drawing <= '0';	
				colour_plot <= "111";
				x <= line_x;
				y <= line_y;
				if((line_x > x_159) AND (line_y = y_bottom))then
					done_drawing <= '1';
					plot <= '0';
				elsif (line_x > x_159) then
					line_x := "00000000";
					line_y := y_bottom;
				else 
					line_x := std_logic_vector(unsigned(line_x) + 1);
				end if;
			
			
--====update team 1's goalie========
			elsif (task = "010") then
				plot <= '1';
				done_drawing <= '0';
				x <= std_logic_vector(to_unsigned(x_t1g,8));
				
				 --T1 goalie movement computation
			if(move1 = '0')then
				if(movement(17) = '1')then
					if(y0_t1g > 1) then
						y0_t1g := y0_t1g - 1;
						y1_t1g := y1_t1g - 1;
						flag1 := '1';
						move1 := '1';
					end if;
				end if;
			
				if(movement(17) = '0') then
					if(y1_t1g < 118) then
						y0_t1g := y0_t1g + 1;
						y1_t1g := y1_t1g + 1;
						flag1 := '0';
						move1 := '1';
					end if;	
				end if;	
			end if;
				
				
			if(flag1 = '1')then
				if(clear_t1g = '0')then
					colour_plot <= "000";
					counter_y1 := y1_t1g + 2;
					y <= std_logic_vector(to_unsigned(counter_y1,7));
					clear_t1g := '1'; 
				else
					if(y0_t1g>1)then
					colour_plot <= "100";
					counter_y1 := y0_t1g-1;
					y <= std_logic_vector(to_unsigned(counter_y1,7));
					end if;
					done_drawing <= '1';
					clear_t1g := '0';
					move1 := '0';
	
				end if;
			end if;
			
			if(flag1 = '0')then
				if(clear_t1g = '0')then
					colour_plot <= "000";
					counter_y1 := y0_t1g - 2;
					y <= std_logic_vector(to_unsigned(counter_y1,7));
					clear_t1g := '1';
					
				else
					if(y1_t1g<118)then
					colour_plot <= "100";
					counter_y1 := y1_t1g+1; 
					y <= std_logic_vector(to_unsigned(counter_y1,7));
					end if;
					done_drawing <= '1';
					clear_t1g := '0';
					move1 := '0';
						
				end if;
			end if;
				
--====update team 1's forward=======
			elsif (task = "011") then
				plot <= '1';
				done_drawing <= '0';
				x <= std_logic_vector(to_unsigned(x_t1f,8));
				
				
				 --T1 forward movement computation
			if(move2 = '0')then
				if(movement(16) = '1')then
					if(y0_t1f > 1) then
						y0_t1f := y0_t1f - 1;
						y1_t1f := y1_t1f - 1;
						flag2 := '1';
						move2 := '1';
					end if;
				end if;
			
				if(movement(16) = '0') then
					if(y1_t1f < 118) then
						y0_t1f := y0_t1f + 1;
						y1_t1f := y1_t1f + 1;
						flag2 := '0';
						move2 := '1';
					end if;	
				end if;	
			end if;
				
				
			if(flag2 = '1')then
				if(clear_t1f = '0')then
					colour_plot <= "000";
					counter_y2 := y1_t1f + 2;
					y <= std_logic_vector(to_unsigned(counter_y2,7));
					clear_t1f := '1';
					
				else
					if(y0_t1f>1)then
					colour_plot <= "100";
					counter_y2 := y0_t1f-1;
					y <= std_logic_vector(to_unsigned(counter_y2,7));
					end if;
					done_drawing <= '1';
					clear_t1f := '0';
					move2 := '0';
	
				end if;
			end if;
			
			if(flag2 = '0')then
				if(clear_t1f = '0')then
					colour_plot <= "000";
					counter_y2 := y0_t1f - 2;
					y <= std_logic_vector(to_unsigned(counter_y2,7));
					clear_t1f := '1';
					
				else
					if(y1_t1f<118)then
					colour_plot <= "100";
					counter_y2 := y1_t1f+1; 
					y <= std_logic_vector(to_unsigned(counter_y2,7));
					end if;
					done_drawing <= '1';
					clear_t1f := '0';
					move2 := '0';
	
				end if;
			end if;

--====update team 2's goalie========
			elsif(task="100")then
				plot <= '1';
				done_drawing <= '0';
				x <= std_logic_vector(to_unsigned(x_t2g,8));
				
				
				 --T2 goalie movement computation
			if(move3 = '0')then
				if(movement(0) = '1')then
					if(y0_t2g > 1) then
						y0_t2g := y0_t2g - 1;
						y1_t2g := y1_t2g - 1;
						flag3 := '1';
						move3 := '1';
					end if;
				end if;
			
				if(movement(0) = '0') then
					if(y1_t2g < 118) then
						y0_t2g := y0_t2g + 1;
						y1_t2g := y1_t2g + 1;
						flag3 := '0';
						move3 := '1';
					end if;	
				end if;	
			end if;
				
				
			if(flag3 = '1')then
				if(clear_t2g = '0')then
					colour_plot <= "000";
					counter_y3 := y1_t2g + 2;
					y <= std_logic_vector(to_unsigned(counter_y3,7));
					clear_t2g := '1';
					
				else
					if(y0_t2g>1)then
					colour_plot <= "001";
					counter_y3 := y0_t2g-1;
					y <= std_logic_vector(to_unsigned(counter_y3,7));
					end if;
					done_drawing <= '1';
					clear_t2g := '0';
					move3 := '0';
	
				end if;
			end if;
			
			if(flag3 = '0')then
				if(clear_t2g = '0')then
					colour_plot <= "000";
					counter_y3 := y0_t2g - 2;
					y <= std_logic_vector(to_unsigned(counter_y3,7));
					clear_t2g := '1';
					
				else
					if(y1_t2g<118)then
					colour_plot <= "001";
					counter_y3 := y1_t2g+1; 
					y <= std_logic_vector(to_unsigned(counter_y3,7));
					end if;
					done_drawing <= '1';
					clear_t2g := '0';
					move3 := '0';
	
				end if;
			end if;
							
--====update team 2's forward=======
		elsif (task = "101") then
				plot <= '1';
				done_drawing <= '0';
				x <= std_logic_vector(to_unsigned(x_t2f,8));
				
				
				 --T2 forward movement computation
			if(move4 = '0')then
				if(movement(1) = '1')then
					if(y0_t2f > 1) then
						y0_t2f := y0_t2f - 1;
						y1_t2f := y1_t2f - 1;
						flag4 := '1';
						move4 := '1';
					end if;
				end if;
			
				if(movement(1) = '0') then
					if(y1_t2f < 118) then
						y0_t2f := y0_t2f + 1;
						y1_t2f := y1_t2f + 1;
						flag4 := '0';
						move4 := '1';
					end if;	
				end if;	
			end if;
				
				
			if(flag4 = '1')then
				if(clear_t2f = '0')then
					colour_plot <= "000";
					counter_y4 := y1_t2f + 2;
					y <= std_logic_vector(to_unsigned(counter_y4,7));
					clear_t2f := '1';
					
				else
					if(y0_t2f>1)then
					colour_plot <= "001";
					counter_y4 := y0_t2f-1;
					y <= std_logic_vector(to_unsigned(counter_y4,7));
					end if;
					done_drawing <= '1';
					clear_t2f := '0';
					move4 := '0';
	
				end if;
			end if;
			
			if(flag4 = '0')then
				if(clear_t2f = '0')then
					colour_plot <= "000";
					counter_y4 := y0_t2f - 2;
					y <= std_logic_vector(to_unsigned(counter_y4,7));
					clear_t2f := '1';
					
				else
					if(y1_t2f<118)then
					colour_plot <= "001";
					counter_y4 := y1_t2f+1; 
					y <= std_logic_vector(to_unsigned(counter_y4,7));
					end if;
					done_drawing <= '1';
					clear_t2f := '0';
					move4 := '0';
	
				end if;
			end if;
					
--====update puck===================
			elsif(task = "110")then
				plot <= '1';
				done_drawing <= '0';
				
				--check for winner
				if(puck_x = 1)then
					puck_x := 80;
					puck_y := 60;
					winner <= "10";
   			elsif(puck_x = 158)then
					puck_x := 80;
					puck_y := 60;
					winner <= "01";
				else
					winner <= "00";
				end if; --end win check if statement
				
				--COLLISION CODE
				if (puck_y = 1 AND dy = -1) then	--if puck hits the top		
					dy := 1; 
				
				elsif (puck_y = 118 AND dy = 1) then	--if puck hits the bottom
					dy := -1; 

				elsif(puck_x = (x_t2g - 1) AND (puck_y >= y0_t2g) AND (puck_y <= y1_t2g) AND dx = 1) then --hit t2g from left
					dx := -1;
				
				elsif(puck_x = (x_t1g + 1) AND (puck_y >= y0_t1g) AND (puck_y <= y1_t1g) AND dx = -1) then --hit t1g from right
					dx := 1;
					
				elsif(puck_x = (x_t1f + 1) AND (puck_y >= y0_t1f) AND (puck_y <= y1_t1f) AND dx = -1) then --hit t1f from right
					dx := 1;
					
				elsif(puck_x = (x_t1f - 1) AND (puck_y >= y0_t1f) AND (puck_y <= y1_t1f) AND dx = 1) then --hit t1f from left
					dx := -1;
					
				elsif(puck_x = (x_t2f + 1) AND (puck_y >= y0_t2f) AND (puck_y <= y1_t2f) AND dx = -1) then --hit t2f from right
					dx := 1;
					
				
			elsif(puck_x = (x_t2f - 1) AND (puck_y >= y0_t2f) AND (puck_y <= y1_t2f) AND dx = 1) then --hit t2f from left
					dx := -1;

			else --proceed to draw the puck in its new spot 

				if( clear_puck = '0') then
					oldpuck_x := puck_x;
					oldpuck_y := puck_y;
					colour_plot <= "111";
					x <= std_logic_vector(to_unsigned(puck_x,8));
					y <= std_logic_vector(to_unsigned(puck_y,7));
			
					clear_puck := '1';
					puck_x := puck_x + dx;
					puck_y := puck_y + dy;
					done_drawing <= '1';
				else
					colour_plot <= "000"; --erase previous location (based on current trajectory)
					clear_puck := '0';
				   x <= std_logic_vector(to_unsigned(oldpuck_x,8));
					y <= std_logic_vector(to_unsigned(oldpuck_y,7));
					done_drawing <= '1';
			end if;		

				end if;
			end if; --end task if statement	
	end if; --end clock/reset if statement
end process;
end behavioural;