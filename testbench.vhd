-- Code your testbench here
library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture behavior of testbench is
	signal wireClk, wireCause, wireRst: std_logic;
    constant clockTime: time := 10ns;
    begin
    	PROCESSOR: entity work.design port map (
        	clk => wireClk,
            rst => wireRst,
            causeOut => wireCause
        );
        CLOCKWAVE: process
        begin
        	for i in 0 to 500 loop
            	wireClk<= '0';
                wait for clockTime/2;
                wireClk<= '1';
                wait for clockTime/2;
                
                if(wireCause = '1') then
                	exit;
                end if;
            end loop;
            wait;
        end process;
        process
        	begin
            	wireRst <='1';
                wait for 10ns;
                wireRst <= '0';
                wait for 10ns;
                wait;
        end process;
end behavior;