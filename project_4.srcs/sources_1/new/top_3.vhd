----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2016 01:24:44 PM
-- Design Name: 
-- Module Name: top_3 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_3 is
    Port ( clk: in std_logic;
       sw: in std_logic_vector(15 downto 0);
       display : out std_logic_vector(15 downto 0)
       -- an : out  STD_LOGIC_VECTOR (3 downto 0);
       -- seg : out  STD_LOGIC_VECTOR (6 downto 0)
);
end top_3;

architecture Behavioral of top_3 is

--component Decodificador is
--    Port ( clk : in  STD_LOGIC;
--           inp : in  STD_LOGIC_VECTOR (15 downto 0);
--           an : out  STD_LOGIC_VECTOR (3 downto 0);
--           seg : out  STD_LOGIC_VECTOR (6 downto 0));
--end component;

  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;

  

 component Somador is
            generic(             C_FAMILY : string := "6S"; 
                        C_RAM_SIZE_KWORDS : integer := 1;
                     C_JTAG_LOADER_ENABLE : integer := 0);
            Port (      address : in std_logic_vector(11 downto 0);
                    instruction : out std_logic_vector(17 downto 0);
                         enable : in std_logic;
                            rdl : out std_logic;                    
                            clk : in std_logic);
      end component;
            
     

    signal         address : std_logic_vector(11 downto 0);
    signal     instruction : std_logic_vector(17 downto 0);
    signal     bram_enable : std_logic;
    signal         in_port : std_logic_vector(7 downto 0);
    signal        out_port : std_logic_vector(7 downto 0);
    signal         port_id : std_logic_vector(7 downto 0);
    signal    write_strobe : std_logic;
    signal  k_write_strobe : std_logic;
    signal     read_strobe : std_logic;
    signal       interrupt : std_logic;
    signal   interrupt_ack : std_logic;
    signal    kcpsm6_sleep : std_logic;
    signal    kcpsm6_reset : std_logic;


    -- signal    display : std_logic_vector(15 downto 0):= (others=>'0');
begin


  processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);
               
  kcpsm6_sleep <= '0';
  interrupt <= interrupt_ack;

                  

  program_rom: Somador                     --Name to match your PSM file
    generic map(             C_FAMILY => "V6",   --Family 'S6', 'V6' or '7S'
                    C_RAM_SIZE_KWORDS => 2,      --Program size '1', '2' or '4'
                 C_JTAG_LOADER_ENABLE => 1)      --Include JTAG Loader when set to '1' 
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => kcpsm6_reset,
                       clk => clk);



input_ports: process(clk)
    begin
        if clk'event and clk = '1' then
            case port_id(2 downto 0) is
                -- Read input_port_c at port address 01 hex
                when "01" => in_port <= sw(7 downto 0);
                when "10" => in_port <= sw(15 downto 8);
                when others => in_port <= "XXXXXXXX";
            end case;
    end if;
end process input_ports;

output_ports: process(clk)
	begin
	    if clk'event and clk = '1' then 
		    -- 'write_strobe' is used to qualify all writes to general output ports.
		    if write_strobe = '1' then
		        -- Write to output_port_w at port address 02 hex
			    if port_id(1) = '1' then
			        display(7 downto 0) <= out_port;

				    -- display <= std_logic_vector(resize(unsigned(out_port), display'length));
			    end if;
			    		    
			    if port_id(2) = '1' then
                        display(15 downto 8) <= out_port;
                        -- display <= std_logic_vector(resize(unsigned(out_port), display'length));
			    end if;
            end if;
        end if;
    end process output_ports;


--U1: Decodificador port map (	 	clk => clk,
--                                    inp => display,
--                                    an => an,
--                                    seg => seg
--                            );



end Behavioral;
