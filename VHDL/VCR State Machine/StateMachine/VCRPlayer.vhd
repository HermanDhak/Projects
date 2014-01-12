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
		RecordV			:IN STD_LOGIC;
		Forward			:IN STD_LOGIC;
		Rewind			:IN STD_LOGIC;
		TapeLoaded		:IN STD_LOGIC;
		TapeStart		:IN STD_LOGIC;
		TapeEnd			:IN STD_LOGIC;
		WriteProtect   :IN STD_LOGIC;
		Done				:IN STD_LOGIC;
		Ready				:IN STD_LOGIC;
		Eject				:IN STD_LOGIC;
		
	-- Outputs
		Increment		:OUT STD_LOGIC;
		Decrement		:OUT STD_LOGIC;
		ResetCount		:OUT STD_LOGIC;
		WriteMessage	:OUT STD_LOGIC;
		Load				:OUT STD_LOGIC_VECTOR (1 DOWNTO 0);		-- 11 = 1s, 01 = 1/100th s, 10 = 1/5th s, 00 = off
		Message			:OUT STD_LOGIC_VECTOR (3 DOWNTO 0)  -- 1 of 8 messages
	);
END;

ARCHITECTURE behavorial OF VCRPlayer IS

	CONSTANT STOPPED			:STD_LOGIC_VECTOR(2 DOWNTO 0) := "000";
	CONSTANT PAUSED			:STD_LOGIC_VECTOR(2 DOWNTO 0) := "001";
	CONSTANT PLAYING			:STD_LOGIC_VECTOR(2 DOWNTO 0) := "011";
	CONSTANT FORWARDING		:STD_LOGIC_VECTOR(2 DOWNTO 0) := "100";
	CONSTANT REWINDING		:STD_LOGIC_VECTOR(2 DOWNTO 0) := "110";
	CONSTANT RECORDING		:STD_LOGIC_VECTOR(2 DOWNTO 0) := "111";
	
	SIGNAL NextState			:STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL CurrentState		:STD_LOGIC_VECTOR(2 DOWNTO 0);
	
BEGIN
	-- The State Memory
	PROCESS(Clock)
		BEGIN
			IF(rising_edge(Clock)) THEN   ---Reset, increment and decrement are synchronous
				IF(Reset = '0') THEN
					CurrentState <= STOPPED;
				ELSE
					CurrentState <= NextState;
				END IF;
			END IF;
	END PROCESS;
	
	-- INPUT/OUTPUT COMBINATORIAL LOGIC
	PROCESS(CurrentState, Play, Pause, Stop, RecordV, Forward, Rewind, TapeLoaded,
				TapeStart, TapeEnd, WriteProtect, Done, Ready, Eject)
		BEGIN
			-- Defaults
			NextState <= CurrentState;
		
			Increment <= '0';
			Decrement <= '0';
			ResetCount <= '1'; --Active low
			Message <= "0001"; -- Output Message "Stopped"
			WriteMessage <= '1'; --Always have some sort of message displayed
			Load <= "00"; --Do nothing
			
			IF (CurrentState = STOPPED) THEN
				Message <= "0001";
				--ResetCount <= "0"; --reset the counter
				IF (TapeLoaded = '1' AND Play = '1' AND TapeEnd = '0') THEN
					NextState <= PLAYING;
				ELSIF (TapeLoaded = '1' AND Forward = '1' AND TapeEnd = '0') THEN
					Load <= "01"; -- set speed
					NextState <= FORWARDING;
				ELSIF (TapeLoaded = '1' AND Rewind = '1' AND TapeStart = '0') THEN
					Load <= "01";
					NextState <= REWINDING;
				ELSIF (TapeLoaded = '1' AND RecordV = '1' AND WriteProtect = '0') THEN
					NextState <= RECORDING;
				ELSIF (TapeLoaded = '1' AND RecordV = '1' AND WriteProtect = '1') THEN
					Message <= "0110"; --Writeprotected
				END IF;
			
			ELSIF (CurrentState = PLAYING) THEN
				Load <= "11";
				Increment <= Done;
				Message <= "0000"; -- playing
				IF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Eject = '1') THEN
					Message <= "0101"; --Ejecting
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (Forward = '1' AND Rewind = '0') THEN
					Load <= "10"; --set speed here
					NextState <= FORWARDING;
				ELSIF (Forward = '0' AND Rewind = '1') THEN
					Load <= "10";
					NextState <= REWINDING;
				ELSIF (TapeEnd = '1') THEN
					NextState <= STOPPED;
				END IF;
				
			ELSIF (CurrentState = PAUSED) THEN
				Message <= "0010"; -- Paused
				Load <= "00";
				IF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Play = '1') THEN
					NextState <= PLAYING;
				ELSIF (Rewind = '1' AND Forward = '0') THEN
					Load <= "10";
					NextState <= REWINDING;
				ELSIF (Rewind = '0' AND Forward = '1') THEN
					Load <= "10";
					NextState <= FORWARDING;
				ELSIF (RecordV = '1' AND WriteProtect = '0') THEN
					NextState <= RECORDING;
				END IF;


			ELSIF (CurrentState = FORWARDING) THEN
				Message <= "0011"; --Forwarding 
				Increment <= Done;
				IF (Play = '1') THEN
					NextState <= PLAYING;
				ELSIF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (Rewind = '1' AND Forward = '0') THEN
					NextState <= REWINDING;
				ELSIF (Eject = '1') THEN
					Message <= "0101";
					NextState <= STOPPED;
				ELSIF (TapeEnd = '1' AND TapeStart = '0') THEN
					NextState <= STOPPED; 
				END IF;
			
			ELSIF (CurrentState = REWINDING) THEN
				Message <= "0100"; --Forwarding 
				Decrement <= Done;
				IF (Play = '1') THEN
					NextState <= PLAYING;
				ELSIF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (Rewind = '0' AND Forward = '1') THEN
					NextState <= FORWARDING;
				ELSIF (Eject = '1') THEN
					Message <= "0101";
					NextState <= STOPPED;
				ELSIF (TapeEnd = '0' AND TapeStart = '1') THEN
					NextState <= STOPPED;
				END IF;
			
			ELSIF (CurrentState = RECORDING) THEN
				Message <= "0111";
				Increment <= Done;
				IF (TapeEnd = '1' AND TapeStart = '0') THEN
					NextState <= STOPPED;
				ELSIF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
			END IF;
		END IF;
		END PROCESS;
END;
