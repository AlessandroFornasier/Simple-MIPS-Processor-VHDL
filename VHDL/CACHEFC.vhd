library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CFC is
port(I1, I2, I3: in std_ulogic_vector(31 downto 0);
     C1, C2, C3, C4: in std_ulogic;
     O1, O2: out std_ulogic_vector(31 downto 0);
     O3, O4: out std_ulogic);
end CFC;

architecture CFC1 of CFC is
signal D1, D2, D3, D8, D9: std_ulogic_vector(31 downto 0) := (others => '0');
signal D4, D5, D6, D7, D10, D11: std_ulogic := '0';
begin
	D1 <= I1; --address
	D2 <= I2; --write data
	D3 <= I3; --data (dato dalla memoria da scrivere nella cache nel caso di lettura con miss)
	D4 <= C1; --mem write
	D5 <= C2; --mem read
	D6 <= C3; --ready l2
	D7 <= C4; --hit

	feedbackcontrol:process(D1, D2, D3, D4, D5, D6, D7)
	begin
		D8 <= D1;
		if(D4 = '0' and D5 = '1' and D6 = '1' and D7 = '0') then
			D9 <= D3;
			D10 <= '1';
			D11 <= '0';
		else
			D9 <= D2;
			D10 <= D4;
			D11 <= D5;
		end if;
	end process;
	
	O1 <= D8;
	O2 <= D9;
	O3 <= D10;
	O4 <= D11;
end CFC1;
