library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( SEG        : out STD_LOGIC_VECTOR (7 downto 0);
           AN         : out STD_LOGIC_VECTOR (7 downto 0);
           clk        : in STD_LOGIC;
           resetn     : in STD_LOGIC;
           Decad_db   : out std_logic_vector(3 downto 0);
           tio_pot_db : out std_logic_vector(3 downto 0));
           --CE       : in STD_LOGIC;
           --Cnt      : out STD_LOGIC_VECTOR (7 downto 0));
           --EC       : out STD_LOGIC);
end counter;

architecture behavioral of counter is

signal sec_clk      : STD_LOGIC; 
signal LED_activate : STD_logic; 
signal refresh      : Unsigned(18 downto 0); 
signal counter_sec  : integer;
signal counter_disp : integer;
signal reset        : std_logic;
signal num          : unsigned(3 downto 0);   
signal Decad        : unsigned(3 downto 0);
signal tio_pot      : unsigned(3 downto 0);

begin

Decad_db <= std_logic_vector(Decad);
tio_pot_db <= std_logic_vector(tio_pot);

reset <= not resetn;

sec_counter : process (clk)
begin
	if rising_edge(clk) then 
		if reset = '1' then
			sec_clk <= '0'; 
			counter_sec <= 0;
		else
   		  if counter_sec = 2500 then
		      counter_sec <= 0;
		      sec_clk <= not sec_clk;
		    else
		      counter_sec <= counter_sec + 1; 
		  end if;
		end if;  
	end if;
end process;
 
refresh_proc : process (clk)
begin
  if rising_edge(clk) then
    if reset = '1' then
		refresh <= (OTHERS => '0');
	else
		refresh <= refresh + 1;
    end if;
  end if;
end process;

LED_activate <= refresh(9); 


 an_proc : process (clk, reset, LED_activate)
 begin
  if rising_edge(clk) then
    if reset = '1' then 
	AN <= (others => '0'); 
    else 
	    if LED_activate = '1' then 
        	AN <= "11111110"; --Aktiverar AN0
   	    elsif LED_activate = '0' then
        	AN <= "11111101"; --Activates AN1
    	    end if;
    end if; 
  end if;
end process an_proc;
            

DcadCnt : process (sec_clk, reset)
 begin
    if reset = '1' then
	    Decad <= (OTHERS => '0');
 	    tio_pot <= (OTHERS => '0');
    elsif sec_clk = '1' then
      Decad <= Decad + 1;
	    if Decad = "1001" then -- Decad = 9
		    Decad <= (OTHERS => '0');
      end if; -- Decad   
    end if; -- reset
    
    -- Combinatorial part --
  if rising_edge(sec_clk) then
      if Decad = "1001" then -- 0, Could be wrong
        	tio_pot <= tio_pot + 1;
		    if tio_pot = "0101" then
          tio_pot <=(OTHERS => '0');
		    end if;
 	    end if;
  end if; -- Decad    
end process DcadCnt;
 
MUX : process (Decad, tio_pot, LED_activate, clk)
begin
	if LED_activate = '1' then
		num <= Decad; 
	else
	  if LED_activate = '0' then
            num <= tio_pot;
          end if;
	end if; 
end process; 

 
 display_output_proc : process (num, clk)
 begin

    case num is
        when "0000" =>
            SEG <= "11000000"; -- C0
        when "0001" =>
            SEG <= "11111001"; -- F9
        when "0010" =>
            SEG <= "10100100"; -- A4
        when "0011" =>
            SEG <= "10110000"; -- B0
        when "0100" =>
            SEG <= "10011001"; -- 99                          
        when "0101" =>
            SEG <= "10010010"; -- 92
        when "0110" =>
            SEG <= "10000010"; -- 82
        when "0111" =>
            SEG <= "11111000"; -- F8
        when "1000" =>
            SEG <= "10000000"; -- 80
        when "1001" =>
            SEG <= "10010000"; -- 90
	when others => 
	    SEG <= "11111101";
     end case;
end process display_output_proc;


          
          
 
end behavioral;

