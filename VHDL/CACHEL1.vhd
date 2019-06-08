library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CACHEL1 is
port(I1,I2: in std_ulogic_vector(31 downto 0);
     O1,O2: out std_ulogic_vector(31 downto 0);
     O3, O4: out std_ulogic;
     C1, C2: in std_ulogic);
end CACHEL1;

architecture CACHEL11 of CACHEL1 is
type MEMORY is array (0 to 31) of std_ulogic_vector(59 downto 0);
signal M1: MEMORY := (others => (others => '0'));
signal D1, D2, R2, R3: std_ulogic_vector(31 downto 0) := (others => '0');
signal D3, D4, HIT, READY: std_ulogic := '0';
begin
	D1 <= transport I1 after 13 ns; --address (TAG&POINTER)
	D2 <= transport I2 after 13 ns; --Write Data
	D3 <= transport C1 after 13 ns; --MemWrite
	D4 <= transport C2 after 13 ns; --MemRead

	-- D1(4 downto 0) 5 bit di pointer (32 indirizzi possibili nella cache) !! offset non presente
	-- D1(31 downto 5) 27 bit di tag (istruzione)
	-- R1(58 downto 32) 27 bit di tag
	-- R1(59) valid

	Control:process(D1, D2, D3, D4)
	variable MEMDATA: std_ulogic_vector(59 downto 0) := (others => '0');
	variable VALIDFLAG, TAGFLAG, HITFLAG, READYFLAG: std_ulogic := '0';
	begin
		if(to_integer(unsigned(D1(4 downto 0))) < 32) then
			MEMDATA := M1(to_integer(unsigned(D1(4 downto 0))));
			VALIDFLAG := MEMDATA(59);
		end if;

		if(D1(31 downto 5) = MEMDATA(58 downto 32)) then
			TAGFLAG := '1';
		else
			TAGFLAG := '0';
		end if;

		if(D3 = '0' and D4 = '0' and MEMDATA = "000000000000000000000000000000000000000000000000000000000000") then
			HITFLAG := '1';
		else
			HITFLAG := VALIDFLAG and TAGFLAG;
		end if;

		READYFLAG := '0';

		if(D3 = '0' and D4 = '1') then --lettura
			if(HITFLAG = '1') then --prendi il dato dalla cache
				R2 <= MEMDATA(31 downto 0);
				READYFLAG := '1';
			else --metti in uscita l'indirizzo del dato da prendere in memoria
				R2 <= D1;
				READYFLAG := '1';
			end if;
		else if(D3 = '1' and D4 = '0') then --scrittura
			if(VALIDFLAG = '0') then --scrivo il dato nella cache (ho hit = '0' in quanto il dato precedente è NON valido)
				M1(to_integer(unsigned(D1(4 downto 0)))) <= '1'&D1(31 downto 5)&D2;
				HITFLAG := '1';
				READYFLAG := '1';
			else if(VALIDFLAG = '1') then
				if(HITFLAG = '1') then --aggiorno il dato
					M1(to_integer(unsigned(D1(4 downto 0)))) <= '1'&D1(31 downto 5)&D2; --dato valido, stesso tag, nuovo dato
					READYFLAG := '1';
				else --tag non corrispondenti -> write back
					R3 <= MEMDATA(31 downto 0); --dato da scrivere in memoria write-back
					R2 <= MEMDATA(58 downto 32)&D1(4 downto 0);
					M1(to_integer(unsigned(D1(4 downto 0)))) <= '1'&D1(31 downto 5)&D2; --dato valido, diverso tag, nuovo dato
					READYFLAG := '1';
				end if;
			end if;
			end if;			
		end if;
		end if;
		HIT <= HITFLAG;
		READY <= READYFLAG;
	end process;

	O1 <= R2; --dato letto o indirizzo da leggere in memoria o indirizzo dove scrivere il write back
	O2 <= R3; --dato da scrivere in memoria (write back)
	O3 <= HIT; --hit
	O4 <= READY; --ready

end CACHEL11;
