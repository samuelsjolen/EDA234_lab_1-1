library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_tb is
end counter_tb;

architecture counter_tb_arch of counter_tb is

component counter is
    Port ( SEG      : out STD_LOGIC_VECTOR (7 downto 0);
           AN       : out STD_LOGIC_VECTOR (7 downto 0);
           clk      : in STD_LOGIC;
           reset    : in STD_LOGIC;
           Decad_db : out std_logic_vector(3 downto 0);
	   tio_pot_db : out std_logic_vector(3 downto 0));
           --CE       : in STD_LOGIC;
           --Cnt      : out STD_LOGIC_VECTOR (7 downto 0));
           --EC       : out STD_LOGIC);
end component counter;

signal clk : std_logic := '0';
constant PERIOD : time := 10 ns; 
signal reset : std_logic;
signal SEG : STD_LOGIC_vector(7 downto 0);
signal AN : STD_LOGIC_vector(7 downto 0);
signal Decad_db : std_logic_vector(3 downto 0);
signal tio_pot_db : std_logic_vector(3 downto 0);
--constant sec_def : real := 25.0e6; 
--constant disp_def : real := 10.0e4;

begin 

	counter_inst : 
	  component counter
	    port map(SEG => SEG,
		     AN => AN,
		     clk => clk,
	    	     reset => reset,
	             Decad_db => Decad_db,
                     tio_pot_db => tio_pot_db);

	clk <= not clk after PERIOD/2.0; 
	
reset_proc: process
begin
 reset <= '0';
 wait for PERIOD;
 reset <= '1';
 wait for PERIOD;
 reset <= '0';
 wait;
end process;

verification : process
variable cnt_up : unsigned(3 downto 0):=(others => '0');
variable cnt_tio : unsigned(3 downto 0):=(others => '0'); 
begin
  wait for 25000 ns; 
for jdx in 0 to 4 loop 
   for idx in 0 to 8 loop
     cnt_up := cnt_up + 1;
     wait for 50000 ns;
     assert(Decad_db = std_logic_vector(cnt_up)) report "missmatch decad" severity warning;
     assert(tio_pot_db = std_logic_vector(cnt_tio)) report "missmatch tio_pot" severity warning; 
    end loop;
      cnt_tio := cnt_tio + 1;
end loop; 

 wait for 10 ns;
 report "testbench finished!" severity failure;
end process;

end  architecture counter_tb_arch;