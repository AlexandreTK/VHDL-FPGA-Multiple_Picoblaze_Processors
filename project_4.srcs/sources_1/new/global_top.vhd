----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/21/2016 01:46:50 PM
-- Design Name: 
-- Module Name: global_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity global_top is
    Port ( clk: in std_logic;
   sw: in std_logic_vector(15 downto 0);
   led: out std_logic_vector(15 downto 0);
   an : out  STD_LOGIC_VECTOR (3 downto 0);
   seg : out  STD_LOGIC_VECTOR (6 downto 0);
   btnC: in std_logic
);
end global_top;

architecture Behavioral of global_top is

component Decodificador is
    Port ( clk : in  STD_LOGIC;
           inp : in  STD_LOGIC_VECTOR (15 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

component top is
    Port ( clk: in std_logic;
       sw: in std_logic_vector(15 downto 0);
       display : out std_logic_vector(15 downto 0)
       --an : out  STD_LOGIC_VECTOR (3 downto 0);
       --seg : out  STD_LOGIC_VECTOR (6 downto 0)
);
end component;

component top_2 is
    Port ( clk: in std_logic;
       sw: in std_logic_vector(15 downto 0);
       out_led: out std_logic_vector(15 downto 0)
);
end component;

component top_3 is
    Port ( clk: in std_logic;
       sw: in std_logic_vector(15 downto 0);
       display : out std_logic_vector(15 downto 0)
       --an : out  STD_LOGIC_VECTOR (3 downto 0);
       --seg : out  STD_LOGIC_VECTOR (6 downto 0)
);
end component;


    signal    clk_2 : std_logic;
    signal    sw_2 : std_logic_vector(15 downto 0);
    signal    led_2 : std_logic_vector(15 downto 0);
    signal    an_2 : std_logic_vector(3 downto 0);
    signal    seg_2 : std_logic_vector(6 downto 0);
    
    signal    display1 : std_logic_vector(15 downto 0):= (others=>'0');
    signal    display2 : std_logic_vector(15 downto 0):= (others=>'0');
    signal    display_mix : std_logic_vector(15 downto 0):= (others=>'0');
begin



TOP1: top port map (	 	clk => clk,
                            sw => sw,
                            display => display1
                             );


TOP2: top_2 port map (	 	clk => clk,
                            sw => sw,
                            out_led => led
                             );


TOP3: top_3 port map (	 	clk => clk,
                            sw => sw,
                            display => display2
                             );

--execute_global_top: process(clk)
--    begin
--        if clk'event and clk = '1' then
--	    if(btnC='1') then
--            display_mix <= display1;
--        else
--            display_mix <= display2;
--        end if;

--    end if;
--end process execute_global_top;


process(clk)
begin
	if(clk'event and clk='1') then
	    if(btnC='1') then
            display_mix <= display1;
        else
            display_mix <= display2;
        end if;

    end if;

end process;




U1: Decodificador port map (	 	clk => clk,
                                    inp => display_mix,
                                    an => an,
                                    seg => seg
                            );

end Behavioral;
