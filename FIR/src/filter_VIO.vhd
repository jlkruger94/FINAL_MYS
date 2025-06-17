library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- VIO
entity filter_VIO is
	port(
		clk: 	in std_logic
	);
end;

architecture arch_filter_VIO of filter_VIO is
	
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

component vio_0 is
    Port ( 
        clk : in STD_LOGIC;
        probe_in0 : in STD_LOGIC_VECTOR ( 1 downto 0 );
        probe_out0 : out STD_LOGIC_VECTOR ( 5 downto 0 );
        probe_out1 : out STD_LOGIC_VECTOR ( 0 to 0 )
    );
  
  end component;

component ila_0 is
    Port ( 
      clk : in STD_LOGIC;
      probe0 : in STD_LOGIC_VECTOR ( 11 downto 0 );
      probe1 : in STD_LOGIC_VECTOR ( 11 downto 0 )
    );
  
end component;
	
    constant DATA_W: natural:= 13;
    constant ADDR_W: natural:= 12;
    constant PUNTOS: natural:= 32767;
    constant PASO_W: natural:= 6;

    signal rst_vio: std_logic_vector(0 downto 0);
    signal ena_vio : std_logic;
    signal sin_o_out: unsigned(DATA_W-2 downto 0);
    signal salida_filtro_vio: unsigned(DATA_W-2 downto 0);
    signal paso_vio : std_logic_vector(5 downto 0);
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
        clk,
        rst_vio(0),
        unsigned(paso_vio),
        sin_o_out,
        open
    );

    filter_DUT: FIR_Notch
        port map(
            clk    =>   clk,
            rst    =>   rst_vio(0),
            ena    =>   ena_vio,
            x_in   => sin_o_out,
            y_out  => salida_filtro_vio
        );


    gen_ena: gen_enable
        generic map (
            65
        )
        port map(
            clk   => clk,
            rst   => rst_vio(0),
            ena_o => ena_vio
        );

    VIO: vio_0
    port map(
        clk => clk,
        probe_in0 => select_paso,
        probe_out0 => paso_vio,
        probe_out1 => rst_vio
    );

    ILA: ila_0
    port map(
        clk => clk,
        probe0 => std_logic_vector(sin_o_out),
        probe1 => std_logic_vector(salida_filtro_vio)
    );
end architecture;