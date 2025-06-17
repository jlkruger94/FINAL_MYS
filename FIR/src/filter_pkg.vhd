library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity filter_pkg is
	port(
		clk_top     : in  std_logic;
        fir_in_top  : out  unsigned(11 downto 0);
        PASO_W_top  : in unsigned (5 downto 0);
        y_out_top   : out unsigned(11 downto 0)
	);
end;

architecture arch_filter_pkg of filter_pkg is
	
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
    constant ADDR_W: natural:= 12;
    constant PUNTOS: natural:= 32767;
    constant PASO_W: natural:= 6;

    signal rst_signal: std_logic_vector(0 downto 0);
    signal ena_signal : std_logic;
    signal sin_o_out: unsigned(DATA_W-2 downto 0);
    signal salida_filtro_vio: unsigned(DATA_W-2 downto 0);
    signal select_paso : std_logic_vector(1 downto 0);

begin

	nco_inst: nco
    --generic map(
        --DATA_W,
        --ADDR_W,
        --PUNTOS,
        --PASO_W
    --)
    generic map(
        DATA_W => 13,
        ADDR_W => 12,
        modulo => 32767,
        PASO_W => 6
    )
    port map(
        clk_top,
        rst_signal(0),
        PASO_W_top,
        sin_o_out,
        open
    );

    filter_DUT: FIR_Notch
        port map(
            clk    =>   clk_top,
            rst    =>   rst_signal(0),
            ena    =>   ena_signal,
            x_in   => sin_o_out,
            y_out  => y_out_top
        );


    gen_ena: gen_enable
        generic map (
            65
        )
        port map(
            clk   => clk_top,
            rst   => rst_signal(0),
            ena_o => ena_signal
        );

    fir_in_top <= sin_o_out;

end architecture;