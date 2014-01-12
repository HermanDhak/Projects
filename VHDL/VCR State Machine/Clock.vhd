library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SlowClock is
	port(
		fast : in std_logic;
	
		slow : out std_logic
		);
	end;

architecture behaviour of SlowClock is

	constant FREQ : integer := 10_999_9;
	signal count : unsigned(31 downto 0);
	signal slowc : std_logic;

begin
	process(fast) begin
		if (falling_edge(fast)) then
			count <= count + 1;
		if (count >= FREQ) then
			slowc <= not slowc;
			count <= X"0000_0000";
		end if;
		end if;
		end process;

	slow <= slowc;
end;