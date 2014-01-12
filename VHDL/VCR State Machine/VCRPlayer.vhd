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
		TapeLoaded		:IN STD_LOGIC; -- If loaded 1 otherwise ejected = 0
		TapeStart		:IN STD_LOGIC;
		TapeEnd			:IN STD_LOGIC;
		WriteProtect   :IN STD_LOGIC;
		Done				:IN STD_LOGIC;
		Ready				:IN STD_LOGIC;
		
	-- Outputs
		Increment		:OUT STD_LOGIC;
		Decrement		:OUT STD_LOGIC;
		ResetCount		:OUT STD_LOGIC;
		WriteMessage	:OUT STD_LOGIC;  -- active low
		Load				:OUT STD_LOGIC_VECTOR (1 DOWNTO 0);		-- 11 = 1s, 01 = 1/100th s, 10 = 1/5th s, 00 = off
		Message			:OUT STD_LOGIC_VECTOR (3 DOWNTO 0)  -- 1 of 8 messages
	);
END;

ARCHITECTURE behavorial OF VCRPlayer IS

	CONSTANT STOPPED				:STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
	CONSTANT PAUSED				:STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
	CONSTANT PLAYING				:STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
	CONSTANT FORWARDING			:STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
	CONSTANT REWINDING			:STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
	CONSTANT FASTFORWARDING		:STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
	CONSTANT FASTREWINDING		:STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
	CONSTANT RECORDING			:STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
	
	SIGNAL NextState			:STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL CurrentState		:STD_LOGIC_VECTOR(3 DOWNTO 0);
	
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
				TapeStart, TapeEnd, WriteProtect, Done, Ready)
		BEGIN
			-- Defaults
			NextState <= CurrentState;
			Message <= "1011"; -- Output default message
			WriteMessage <= '1'; --Reset Message (0ff)
			Increment <= '0';
			Decrement <= '0';
			ResetCount <= '1'; --Active low
			Load <= "00"; --Do nothing
			
			IF (CurrentState = STOPPED) THEN
				ResetCount <= '0'; --reset the counter
				IF (TapeLoaded = '1' AND Play = '1' AND TapeEnd = '0') THEN
				WriteMessage <= '0';
					NextState <= PLAYING;
				ELSIF (TapeLoaded = '1' AND Forward = '1' AND Rewind = '0' AND TapeEnd = '0') THEN
					NextState <= FASTFORWARDING;
				ELSIF (TapeLoaded = '1' AND Rewind = '1' AND Forward = '0' AND TapeStart = '0') THEN
					NextState <= FASTREWINDING;
				ELSIF (TapeLoaded = '1' AND RecordV = '1' AND WriteProtect = '0') THEN
					NextState <= RECORDING;
				ELSIF (TapeLoaded = '1' AND RecordV = '1' AND WriteProtect = '1') THEN
					Message <= "0110"; --Writeprotected
					WriteMessage <= '0';
				ELSIF (TapeLoaded = '0') THEN
					Message <= "0101"; -- Ejecting
					WriteMessage <= '0';
				ELSE
					Message <= "0001"; -- Stopped
				   WriteMessage <= '0';
				END IF;
			
			ELSIF (CurrentState = PLAYING) THEN
				Load <= "11";
				Increment <= Done;
				IF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (TapeLoaded = '0') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (Forward = '1' AND Rewind = '0') THEN
					NextState <= FORWARDING;
				ELSIF (Forward = '0' AND Rewind = '1') THEN
					NextState <= REWINDING;
				ELSIF (TapeEnd = '1') THEN
					NextState <= STOPPED;
				ELSE
					Message <= "0000"; --playing
				   WriteMessage <= '0';
				END IF;
				
			ELSIF (CurrentState = PAUSED) THEN
				Load <= "00";
				Message <= "0010"; -- paused
				WriteMessage <= '0';
				IF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Play = '1') THEN
					NextState <= PLAYING;
				ELSIF (Rewind = '1' AND Forward = '0') THEN
					NextState <= REWINDING;
				ELSIF (Rewind = '0' AND Forward = '1') THEN
					NextState <= FORWARDING;
				ELSIF (RecordV = '1' AND WriteProtect = '0') THEN
					NextState <= RECORDING;
				ELSIF (TapeLoaded = '0') THEN
					NextState <= STOPPED;	
				END IF;
				
			ELSIF (CurrentState = FORWARDING) THEN
				Load <= "10";
				Message <= "0011"; --forwarding
		      WriteMessage <= '0';
				Increment <= Done;
				IF (Play = '1') THEN
					NextState <= PLAYING;
				ELSIF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (Rewind = '1' AND Forward = '0') THEN
					NextState <= REWINDING;
				ELSIF (TapeLoaded = '0') THEN
					NextState <= STOPPED;
				ELSIF (TapeEnd = '1' AND TapeStart = '0') THEN
					NextState <= STOPPED; 
				END IF;
			
			ELSIF (CurrentState = REWINDING) THEN
				Load <= "10";
				Message <= "0100"; --rewinding
				WriteMessage <= '0';
				Decrement <=  Done;
				IF (Play = '1' AND Rewind  = '0') THEN
					NextState <= PLAYING;
				ELSIF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (Rewind = '0' AND Forward = '1') THEN
					NextState <= FORWARDING;
				ELSIF (TapeLoaded = '0') THEN
					NextState <= STOPPED;
				ELSIF (TapeEnd = '0' AND TapeStart = '1') THEN
					NextState <= STOPPED;
				END IF;
	---------------------------------------------------------------------- 			
				ELSIF (CurrentState = FASTFORWARDING) THEN
				Load <= "01";
				Message <= "0011"; --forwarding
				WriteMessage <= '0';
				Increment <= Done;
				IF (Play = '1') THEN
					NextState <= PLAYING;
				ELSIF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (Rewind = '1' AND Forward = '0') THEN
					NextState <= FASTREWINDING;
				ELSIF (TapeLoaded = '0') THEN
					NextState <= STOPPED;
				ELSIF (TapeEnd = '1' AND TapeStart = '0') THEN
					NextState <= STOPPED; 
				END IF;
			
			ELSIF (CurrentState = FASTREWINDING) THEN
				Load <= "01";
				Message <= "0100"; --rewinding
				WriteMessage <= '0';
				Decrement <=  Done;
				IF (Play = '1' AND Rewind  = '0') THEN
					NextState <= PLAYING;
				ELSIF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (Rewind = '0' AND Forward = '1') THEN
					NextState <= FASTFORWARDING;
				ELSIF (TapeLoaded = '0') THEN
					NextState <= STOPPED;
				ELSIF (TapeEnd = '0' AND TapeStart = '1') THEN
					NextState <= STOPPED;
				END IF;
			
			ELSIF (CurrentState = RECORDING) THEN
				Load <= "11";
				Message <= "0111"; --recording
				WriteMessage <= '0';
				Increment <= Done;
				IF (TapeEnd = '1' AND TapeStart = '0') THEN
					NextState <= STOPPED;
				ELSIF (Stop = '1') THEN
					NextState <= STOPPED;
				ELSIF (Pause = '1') THEN
					NextState <= PAUSED;
				ELSIF (TapeLoaded = '0') THEN
					NextState <= STOPPED;
			END IF;	
		END IF;
		END PROCESS;
END;
