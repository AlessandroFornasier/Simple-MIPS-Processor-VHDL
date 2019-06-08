--***************************************************
--*   SOMMATORE A 64bit (Adder)                     *
--*                                                 *
--*   Convenzione utilizzata:                       *
--*   In = n-esima porta di input                   *
--*   Cn = n-esima porta di controllo in ingresso   *
--*   On = n-esima porta di output                  *
--*   Dn = n-esimo dato (operando)                  *
--*   Rn = n-esimo risultato                        *
--***************************************************

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADDER is
port(I1, I2: in std_ulogic_vector(31 downto 0);   
     O1: out std_ulogic_vector(31 downto 0));
end ADDER;

architecture ADD1 of ADDER is
signal	D1, D2, R1: signed(31 downto 0) := (others => '0');
begin
	D1 <= signed(I1);
	D2 <= signed(I2);
	R1 <= D1+D2;
	O1 <= std_ulogic_vector(R1);
end ADD1;
