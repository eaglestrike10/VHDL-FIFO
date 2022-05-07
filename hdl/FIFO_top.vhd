library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIFO_top is
	port(SW : in STD_LOGIC_VECTOR (9 downto 0);
			KEY : in STD_LOGIC_VECTOR (1 downto 0);
			LEDR0, LEDR1, LEDR8, LEDR9 : out STD_LOGIC;
			HEX0, HEX1, HEX2, HEX3, HEX4, HEX5 : out STD_LOGIC_VECTOR (6 downto 0));
			
end FIFO_top;






architecture behavior of FIFO_top is
signal data : STD_LOGIC_VECTOR (7 downto 0);
signal w_en, wren_in ,rden_in, r_en, wren_display, rden_display, full, empty, clock, clear: STD_LOGIC;
signal q, data_display : STD_LOGIC_VECTOR (7 downto 0);
signal wr_ptr, rd_ptr : INTEGER range 0 to 7 := 0;
signal count : INTEGER range 0 to 8 := 0;
signal wr_addr, rd_addr : STD_LOGIC_VECTOR (3 downto 0);

component decoder is
    port ( BITS : in STD_LOGIC_VECTOR (3 downto 0);
           HEX : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component RAM is
	port
	(
		clock		: IN STD_LOGIC;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		rden		: IN STD_LOGIC;
		wraddress		: IN STD_LOGIC_VECTOR (4 DOWNTO 0);
		wren		: IN STD_LOGIC;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;


begin

data_disp0 : decoder port map (BITS => SW(3 downto 0), HEX => HEX0);
data_disp1 : decoder port map (BITS => SW(7 downto 4), HEX => HEx1);

q_disp0 : decoder port map (BITS => q(3 downto 0), HEX => HEX2);
q_disp1 : decoder port map (BITS => q(7 downto 4), HEX => HEX3);

wraddr_disp : decoder port map (BITS => wr_addr, HEX => HEX4);
rdaddr_disp : decoder port map (BITS => rd_addr, HEX => HEX5);

memory : RAM port map (clock=>clock, data=>data, rdaddress => std_logic_vector(to_unsigned(rd_ptr,5)), rden => rden_in, wraddress => std_logic_vector(to_unsigned(wr_ptr,5)), wren => wren_in, q => q);

--connect hardware level I/O to signals

LEDR0 <= empty;
LEDR1 <= full;
LEDR8 <= wren_display;
LEDR9 <= rden_display;

clock <= KEY(0);
clear <= KEY(1);

data <= SW (7 downto 0);
w_en <= sw(8);
r_en <= SW(9);
--route enable signals and setup logic to prevent illegal r/w operations
wren_in <= w_en and not full;
rden_in <= r_en and not empty;
--route internal signals
rden_display <= r_en;
wren_display <= w_en;

wr_addr <= std_logic_vector(to_unsigned(wr_ptr,4));
rd_addr <= std_logic_vector(to_unsigned(rd_ptr,4));

process(clock, clear)
begin 
	if(clear = '0') then
		full <= '0'; 
		empty <= '1';
		count <= 0;
		rd_ptr <= 0;
		wr_ptr <= 0;
	elsif(rising_edge(clock)) then
		
		if(r_en = '1' and w_en = '1' and count > 0 and count < 9) then
		--if simultaneous r/w operation
			rd_ptr <= rd_ptr + 1;
			wr_ptr <= wr_ptr + 1;
		--count stays the same (+1-1)
		--check read and perform related operations
		--if read enabled and register is not empty, read and increment memory
		elsif(r_en = '1' and count /= 0) then
			--flag empty if reading last value
			if(count = 1) then
				empty <= '1';
			end if;
			rd_ptr <= rd_ptr + 1;
			count <= count - 1;
			full <= '0';
			
		--check write and perfrom related operations
		--if write and register is not full, write and increment pointer
		elsif(w_en = '1' and count < 8) then
			if(count = 7) then
				full <= '1';
			end if;
			wr_ptr <= wr_ptr + 1;
			count <= count + 1;
			empty <= '0';
		end if;
		
		

	end if;
end process;
end behavior;
			
			
			
			
		
		