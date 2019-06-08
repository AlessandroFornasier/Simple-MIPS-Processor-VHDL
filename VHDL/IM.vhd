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
--*         .          *
--          .          *
--*	               *
--**********************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library STD;
use STD.textio.all;

entity IM is
generic(N: integer);
port(I1: in std_ulogic_vector(31 downto 0);
     O1: out std_ulogic_vector(31 downto 0));
end IM;

architecture IM1 of IM is
type MEMORY is array (0 to (N-1)) of std_ulogic_vector(31 downto 0); --N*4 byte memory
signal M1: MEMORY := (others => (others => '0'));
signal D1: std_ulogic_vector(29 downto 0) := (others => '0');
signal R1: std_ulogic_vector(31 downto 0) := (others => '0');
begin
	D1 <= I1(31 downto 2); --PC/4	

	initmem:process
	file fp: text;
	variable ln: line;
	variable instruction: string(1 to 32);
	variable i, j: integer := 0;
	variable ch: character := '0';
	begin
		file_open(fp, "instruction.txt", READ_MODE);
		while not endfile(fp) loop
			readline(fp, ln);
			read(ln, instruction);
			for j in 1 to 32 loop
				ch := instruction(j);
				if(ch = '0') then
					M1(i)(32-j) <= '0';
				else
					M1(i)(32-j) <= '1';
				end if;
			end loop;
			i := i+1;
		end loop;
		file_close(fp);
		wait;
	end process;

	R1 <= M1(to_integer(unsigned(D1))) when to_integer(unsigned(D1)) < (N-1) else
	      std_ulogic_vector(to_signed(-1, 32)) when to_integer(unsigned(D1)) > (N-1);
	
	O1 <= R1;
end IM1;
