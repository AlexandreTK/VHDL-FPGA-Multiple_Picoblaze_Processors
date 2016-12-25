library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity Decodificador is
    Port ( clk : in  STD_LOGIC;
           inp : in  STD_LOGIC_VECTOR (15 downto 0);
           an : out  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0));
end Decodificador;

architecture Behavioral of Decodificador is

constant preset : std_logic_vector(17 downto 0):= "101111101011110000"; 
--preset = "101111101011110000" = 195312 (Clock de 100MHz)
signal count : std_logic_vector(17 downto 0):= (others=>'0');
signal control : std_logic_vector(1 downto 0):= "00";
signal inp1  : std_logic_vector (3 downto 0) := "0000";
signal inp2  : std_logic_vector (3 downto 0) := "0000";
signal inp3  : std_logic_vector (3 downto 0) := "0000";
signal inp4  : std_logic_vector (3 downto 0) := "0000";
signal deco  : std_logic_vector (3 downto 0) := "0000";
signal anodos: std_logic_vector (3 downto 0) := "1111";

 signal inp_decimal : integer range 0 to 10000 :=0;
 signal inp1_decimal  : std_logic_vector (3 downto 0) := "0000";
 signal inp2_decimal  : std_logic_vector (3 downto 0) := "0000";
 signal inp3_decimal  : std_logic_vector (3 downto 0) := "0000";
 signal inp4_decimal  : std_logic_vector (3 downto 0) := "0000";
 

begin
    inp_decimal <= to_integer(unsigned(inp));

--std_logic_vector(to_unsigned(my_int, my_slv'length));

    inp1_decimal <= std_logic_vector(to_unsigned(inp_decimal mod 10,4));
    inp2_decimal <= std_logic_vector(to_unsigned( ((inp_decimal/10) mod 10), 4));
    inp3_decimal <= std_logic_vector(to_unsigned( ((inp_decimal/100) mod 10) ,4));
    inp4_decimal <= std_logic_vector(to_unsigned( (inp_decimal/1000),4 ));

    inp1 <= inp1_decimal;
    inp2 <= inp2_decimal;
    inp3 <= inp3_decimal;
    inp4 <= inp4_decimal;
--	inp1 <= inp(3 downto 0);
--	inp2 <= inp(7 downto 4);
--	inp3 <= inp(11 downto 8);
--	inp4 <= inp(15 downto 12);
	
	process(clk)
	begin
		if rising_edge(clk) then
			if count = preset then
				count <= (others=>'0');
				control <= control+"01";
			else
				count <= count+'1'; 
			end if;
		end if;
	end process;
	
	with control select
		anodos <= "1110" when "00",
			      "1101" when "01",
		          "1011" when "10",
	              "0111" when others;
		
	with control select
		deco <= inp1 when "00",
		        inp2 when "01",
		        inp3 when "10",
		        inp4 when "11", 
				"0000" when others;
	
	process(deco)
	begin
		case deco is
			when "0000" => seg <= "1000000"; --0
            when "0001" => seg <= "1111001"; --1
            when "0010" => seg <= "0100100"; --2
            when "0011" => seg <= "0110000"; --3
            when "0100" => seg <= "0011001"; --4
            when "0101" => seg <= "0010010"; --5
            when "0110" => seg <= "0000010"; --6
            when "0111" => seg <= "1111000"; --7
            when "1000" => seg <= "0000000"; --8
            when "1001" => seg <= "0011000"; --9
            when "1010" => seg <= "0001000"; --a
            when "1011" => seg <= "0000011"; --b
            when "1100" => seg <= "1000110"; --c
            when "1101" => seg <= "0100001"; --d
            when "1110" => seg <= "0000110"; --e
            when others => seg <= "0001110"; --f
		end case;
	end process;
	
	an <= anodos;	
	
end Behavioral;
