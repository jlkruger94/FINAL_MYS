library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--banco de pruebas
entity filter_tb is 
end ;

architecture arch_filter_tb of filter_tb is
	
-- declaraciones/inclusion de componentes antes del begin
component FIR_Notch is
    Port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        ena     : in  std_logic;
        x_in    : in  unsigned(11 downto 0);
        y_out   : out unsigned(11 downto 0)
    );
end component;

component nco is
    generic(
        DATA_W: natural := 11; -- cantidad de bits del dato + 1
        ADDR_W: natural := 12; -- cantidad de bits de las direcciones de la LUT
        modulo: natural;		-- cantidad de puntos
        PASO_W: natural			-- cantidad de bits del paso
    );
    port(
        clk, rst: in std_logic;
        paso: in unsigned(PASO_W-1 downto 0); -- valor de entrada (paso)
        salida_cos, salida_sen: out unsigned(DATA_W-2 downto 0)
    );
end component;

component gen_enable is
    Generic (
        N : integer := 5
    );
    Port (
        clk    : in std_logic;
        ena_o  : out std_logic;
        rst    : in std_logic
    );
end component;
	
    constant DATA_W: natural:= 13;
    constant ADDR_W: natural:= 15;
    constant PUNTOS: natural:= (2**ADDR_W)-1;
    constant PASO_W: natural:= 6;

    signal clk: std_logic:= '0';
    signal rst: std_logic:= '1';
    signal ena_tb : std_logic;
    signal sin_o_out: unsigned(DATA_W-2 downto 0);
    signal paso_prueba: unsigned(5 downto 0);
    signal salida_tb: unsigned(DATA_W-2 downto 0);

begin      
    clk <= not clk after 4 ns; -- 125 MHz
    rst <= '0' after 60 ns;

    paso_prueba <= "000001", "001101" after 500 us, "011101" after 1000 us;

	nco_inst: nco
    generic map(
        DATA_W => 13,
        ADDR_W => 12,
        modulo => 32767,
        PASO_W => 6
    )
    port map(
        clk,
        '0',
        paso_prueba,
        sin_o_out,
        open
    );
-- 65 => fs = 125 Mhz / 65 = 1.92 MHz
    gen_ena: gen_enable
        generic map (
            64
        )
        port map(
            clk   => clk,
            rst   => rst,
            ena_o => ena_tb
        );

    filter_DUT: FIR_Notch
        port map(
            clk    =>   clk,
            rst    =>   rst,
            ena    =>   ena_tb,
            x_in   => sin_o_out,
            y_out  => salida_tb
        );

end architecture;