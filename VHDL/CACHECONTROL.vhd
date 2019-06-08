library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CC is
port(I1, I2: in std_ulogic_vector(31 downto 0);
     O1, O2: out std_ulogic_vector(31 downto 0);
     O3, O4, O5, O6, O7: out std_ulogic;
     I3, I4, C1, C2: in std_ulogic);
end CC;

architecture CC1 of CC is
signal D1, D2, D7, D8: std_ulogic_vector(31 downto 0) := (others => '0');
signal D3, D4, D5, D6, D9, D10, D11, D12, D13: std_ulogic := '0';
begin

	D1 <= I1; --dato letto o indirizzo da leggere in memoria
	D2 <= I2; --dato da scrivere in memoria (write back)
	D3 <= I3; --l1ready
	D4 <= I4; --hit
	D5 <= C1; --memwrite
	D6 <= C2; --memread

	control:process(D1, D2, D3, D4, D5, D6)
	variable WRITEFLAG: std_ulogic := '0';
	begin
		D7 <= D1;
		D8 <= D2;
		WRITEFLAG := '0';

		if(D3 = '1' and D4 = '1' and D5 = '0' and D6 = '1') then --lettura cache andata a buon fine
			D10 <= '0';
			D11 <= '0';
			D12 <= '1';
		else if(D3 = '1' and D4 = '0' and D5 = '0' and D6 = '1') then --lettura cache non andata a buon fine -> leggo dalla memoria
			D10 <= '0';
			D11 <= '1';
			D12 <= '0';
		else if(D3 = '1' and D4 = '1' and D5 = '1' and D6 = '0') then --scrittura andata a buon fine
			WRITEFLAG := '1';
		else if(D3 = '1' and D4 = '0' and D5 = '1' and D6 = '0') then --scrittura non andata a buon fine (writeback)
			D10 <= '1';
			D11 <= '0';
			WRITEFLAG := '1';
		end if;
		end if;
		end if;
		end if;
		D13 <= WRITEFLAG;
	end process;

	O1 <= D7; --address mem
	O2 <= D8; --write data mem
	O3 <= D9; --hit delayed
	O4 <= D10; --mem write delayed (ATTIVO SOLO SE LI USO!!)
	O5 <= D11; --mem read delayed
	O6 <= D12; --mux ctrl
	O7 <= D13; --write ready

end CC1;
