library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    Port ( BITS : in STD_LOGIC_VECTOR (3 downto 0);
           HEX : out STD_LOGIC_VECTOR (6 downto 0));
end decoder;

architecture Behavioral of decoder is

begin
process(BITS)
begin
    case BITS is
            when "0000" => 
                HEX <= "1000000";
            when "0001" => 
                HEX <= "1111001";
            when "0010" => 
                HEX <= "0100100";
            when "0011" => 
                HEX <= "0110000";
            when "0100" => 
                HEX <= "0011001";
            when "0101" => 
                HEX <= "0010010";
            when "0110" => 
                HEX <= "0000010";
            when "0111" => 
                HEX <= "1111000";
            when "1000" => 
                HEX <= "0000000";
            when "1001" => 
                HEX <= "0010000";
            when "1010" => 
                HEX <= "0001000";
            when "1011" => 
                HEX <= "0000011";
            when "1100" => 
                HEX <= "1000110";
            when "1101" => 
                HEX <= "0100001";
            when "1110" => 
                HEX <= "0000110";
            when "1111" => 
                HEX <= "0001110";
            when others => 
                HEX <= "0111111";
    end case;
end process;

end Behavioral;