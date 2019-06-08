library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HDU is
port(I1: in std_ulogic_vector(31 downto 0);
     I2: in std_ulogic_vector(4 downto 0);
     I3: in std_ulogic;
     O1, O2, O3: out std_ulogic);
end HDU;

architecture HDU1 of HDU is
signal	D1, D2, D3: std_ulogic_vector(4 downto 0) := (others => '0');
signal  D4, R1, R2: std_ulogic;
begin
	D1 <= I1(25 downto 21); --rs (registro dove prendere l'indirizzo della memoria (+ valore costante))
	D2 <= I1(20 downto 16); --rt (indirizzo del registro dove viene caricato il dato dalla memoria)
	D3 <= I2; --rt (indirizzo del registro dove viene caricato il dato dell'istruzione precedente)
	D4 <= I3; --MemRead
	
	R1 <= '0' when (D1 /= D3 and D2 /= D3) or D4 = '0' else
	      '1' when (D1 = D3 or D2 = D3) and D4 = '1';
	R2 <= '0' when (D1 = D3 or D2 = D3) and D4 = '1' else
	      '1' when (D1 /= D3 and D2 /= D3) or D4 = '0';
	
	O1 <= R1; --MUXctrl
	O2 <= R2; --PCEnable
	O3 <= R2; --IFIDEnable
end HDU1;
