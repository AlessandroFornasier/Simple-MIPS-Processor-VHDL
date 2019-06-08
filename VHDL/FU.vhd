--***********************
--*   Forwarding Unit   *
--***********************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FU is
port(I1, I2, I3, I4: in std_ulogic_vector(4 downto 0);
     C1, C2: in std_ulogic;
     O1, O2: out std_ulogic_vector(1 downto 0));
end FU;

architecture FU1 of FU is
signal	D1, D2, D3, D4: std_ulogic_vector(4 downto 0) := (others => '0');
signal	D5, D6: std_ulogic := '0';
signal  R1, R2: std_ulogic_vector(1 downto 0) := (others => '0');
begin
	
	D1 <= I1;  --Write Address 1
	D2 <= I2;  --Write Address
	D3 <= I3;  --Rs s2
	D4 <= I4;  --Rt s3 (R)
	D5 <= C1;  --RegWrite2 ex/mem
	D6 <= C2;  --RegWrite mem/wb

	R1 <= "10" when D3 = D1 and D5 = '1' else
	      "01" when D3 = D2 and D6 = '1' else
	      "00";
	      
	R2 <= "10" when D4 = D1 and D5 = '1' else
	      "11" when D4 = D2 and D6 = '1' else
	      "00";
	      

	O1 <= R1;  --mux SOPRA
	O2 <= R2;  --mux SOTTO 
	 
end FU1;
