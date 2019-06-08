--**********************
--*                    *
--*                    *
--*	   ---         *
--*	--|(0)|---     *
--*	  |---|        *
--*	--|(1)|---     *
--*       |---|        *
--*	--|(2)|-->     *
--*	  |---|        *
--*	    .          *
--*	    .          *
--*	               *
--**********************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CACHEL2 is
generic(N: integer);
port(I1,I2: in std_ulogic_vector(31 downto 0);
     O1: out std_ulogic_vector(31 downto 0);
     O2: out std_ulogic;
     C1, C2: in std_ulogic);
end CACHEL2;

architecture CACHEL21 of CACHEL2 is
type MEMORY is array (0 to (N-1)) of std_ulogic_vector(31 downto 0); --N*4 byte memory
signal M1: MEMORY := ("00000000000000000000000000000000",
		     "00000000000000000000000000000100",
		     others => (others => '0'));
signal D1, D2, R1: std_ulogic_vector(31 downto 0) := (others => '0');
signal D3, D4, R2: std_ulogic := '0';
begin
	D1 <= transport I1 after 201 ns; --Address
	D2 <= transport I2 after 201 ns; --Write Data
	D3 <= transport C1 after 201 ns; --MemWrite
	D4 <= transport C2 after 201 ns; --MemRead

	R1 <= M1(to_integer(unsigned(D1))) when (D3 = '0' and D4 = '1' and to_integer(unsigned(D1)) < (N-1));

	M1(to_integer(unsigned(D1))) <= D2 when (D3 = '1' and D4 = '0' and to_integer(unsigned(D1)) < (N-1));

	readypulse:process(D1, D2, D3, D4)
	variable FLAG: std_ulogic := '0';
	begin
		FLAG := '0';
		
		if((D3 = '0' and D4 = '1' and to_integer(unsigned(D1)) < (N-1)) or (D3 = '1' and D4 = '0' and to_integer(unsigned(D1)) < (N-1))) then
			FLAG := '1';
		end if;
		
		R2 <= FLAG;
	end process;
	
	O1 <= R1;
	O2 <= R2;
end CACHEL21;
