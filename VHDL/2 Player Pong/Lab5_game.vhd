LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
use ieee.numeric_std.all;

ENTITY lab5_game IS
	PORT(
		CLOCK_50 : in std_logic; -- A 50MHz clock
	   SW   : in  std_logic_vector(17 downto 0); 
		KEY  : in  std_logic_vector(3 downto 0);  -- KEY(3) reset
		VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
      VGA_HS              : out std_logic;
      VGA_VS              : out std_logic;
      VGA_BLANK           : out std_logic;
      VGA_SYNC            : out std_logic;
      VGA_CLK             : out std_logic;
		LEDR : OUT STD_LOGIC_VECTOR(17 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
END;

ARCHITECTURE Structural of lab5_game IS

 COMPONENT vga_adapter
    GENERIC(RESOLUTION : string);
    PORT (resetn                                       : in  std_logic; --KEY 3
          clock                                        : in  std_logic;
          colour                                       : in  std_logic_vector(2 downto 0);
          x                                            : in  std_logic_vector(7 downto 0);
          y                                            : in  std_logic_vector(6 downto 0);
          plot                                         : in  std_logic;
          VGA_R, VGA_G, VGA_B                          : out std_logic_vector(9 downto 0);
          VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK : out std_logic);
  END COMPONENT;

 COMPONENT FSM IS
	PORT(
		clock : IN STD_LOGIC; 
		reset : IN STD_LOGIC; --KEY 3
		start : IN STD_LOGIC;
		done_drawing : IN STD_LOGIC;
		winner : IN STD_LOGIC_VECTOR(1 downto 0);	
		task		: OUT STD_LOGIC_VECTOR(2 downto 0);
		LEDR : OUT STD_LOGIC_VECTOR(17 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(7 downto 0)
	);
	END COMPONENT;
	
COMPONENT Datapath IS
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
		winner : OUT STD_LOGIC_VECTOR(1 downto 0)
  );
  END COMPONENT;
  
signal x      : std_logic_vector(7 downto 0);
signal y      : std_logic_vector(6 downto 0);
signal colour : std_logic_vector(2 downto 0);
signal colour_plot : std_logic_vector(2 downto 0);
signal task      : std_logic_vector(2 downto 0) :="001";
signal plot   : std_logic := '0';
signal done_drawing : std_logic := '0';
signal winner : std_logic_vector(1 downto 0);
--signal clear : std_logic;
  
  
BEGIN
  state_machine : FSM
	 port map  (clock_50, key(3), key(0), done_drawing, winner, task, LEDR, LEDG);	

  Data_path : DataPath
	  port map (clock_50, key(3), task, SW(17 downto 0), colour_plot, x, y, plot, done_drawing, winner);
 
  
  vga_u0 : vga_adapter
    generic map(RESOLUTION => "160x120") 
    port map(resetn    => KEY(3),
             clock     => CLOCK_50,
             colour    => colour_plot,
             x         => x,
             y         => y,
             plot      => plot,
             VGA_R     => VGA_R,
             VGA_G     => VGA_G,
             VGA_B     => VGA_B,
             VGA_HS    => VGA_HS,
             VGA_VS    => VGA_VS,
             VGA_BLANK => VGA_BLANK,
             VGA_SYNC  => VGA_SYNC,
             VGA_CLK   => VGA_CLK);
	
END Structural;