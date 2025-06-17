library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.FIR_Pkg.all;

entity FIR_Notch is
    Port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        ena     : in  std_logic;
        x_in    : in  unsigned(11 downto 0);
        y_out   : out unsigned(11 downto 0)
    );
end FIR_Notch;

architecture arch_FIR_Noch of FIR_Notch is
    constant N : integer := 67;

    -- Array de coeficientes normalizados por 2 a la 11
    constant rom : integer_array := (18,
    -12,
    67,
    -46,
    90,
    -23,
    50,
    40,
    -5,
    58,
    5,
    -2,
    34,
    -38,
    -12,
    -8,
    -78,
    -17,
    -50,
    -86,
    1,
    -69,
    -38,
    49,
    -52,
    72,
    107,
    -8,
    234,
    114,
    38,
    507,
    -291,
    741,
    -291,
    507,
    38,
    114,
    234,
    -8,
    107,
    72,
    -52,
    49,
    -38,
    -69,
    1,
    -86,
    -50,
    -17,
    -78,
    -8,
    -12,
    -38,
    34,
    -2,
    5,
    58,
    -5,
    40,
    50,
    -23,
    90,
    -46,
    67,
    -12,
    18
    );

    signal x_signed   : signed(11 downto 0);
    signal x_samples  : signed_array;
    signal products   : integer_array;
    signal y_signed   : signed(11 downto 0);
begin

    --x_signed <= signed(x_in);
    -- unsigned to signed
    x_signed <= signed(x_in) - to_signed(2048, 12);

    SHIFT_REG: entity work.shift_register
        generic map (N => N)
        port map (
            clk      => clk,
            rst      => rst,
            ena      => ena,
            sample   => x_signed,
            regs_out => x_samples
        );

    gen_mult: for i in 0 to N-1 generate
        MULTi: entity work.multiplier
            port map (
                clk    => clk,
                ena    => ena,
                sample => x_samples(i),
                coeff  => rom(i),
                result => products(i)
            );
    end generate;

    SUM: entity work.adder
        generic map (N => N)
        port map (
            clk     => clk,
            ena     => ena,
            data_in => products,
            result  => y_out
        );
end arch_FIR_Noch;
