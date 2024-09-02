library IEEE;
use IEEE.std_logic_1164.all;

entity design is
	port(
    	clk: in std_logic;
        rst: in std_logic;
        causeOut: out std_logic
    );
end design;

architecture behavior of design is
    signal wireClk, wireRst, wireBranch, wireZero, wireRegWrite, wireMemWR, wireAluSrc, wireIRWrite, wireAluSrcA, wireRegDst, wirePcWrite, wireMemToReg : std_logic;
    signal wireJumpAddr, wireBranchAddr, wirePcPlus4, wireInst, wireWriteData, wireReadData1, wireReadData2, wireImm, wireResult, wireRomOut, wireAluOut, wireMemData, wireBOut, wireAOUT, wireMemOut, wireNextPc, wireNewPc, wireAluIn, wireMemDataRegOut, wireAluIn1: std_logic_vector(31 downto 0);
    signal wireOpCode, wireFunct: std_logic_vector(5 downto 0);
    signal wireAluOp, wireAluSrcB, wirePcSrc  : std_logic_vector(1 downto 0);
    signal wireAddr : std_logic_vector(25 downto 0);
    signal wireRT, wireRD, wireRS, wireWriteRegister : std_logic_vector(4 downto 0);
    signal wireImmAux : std_logic_vector(15 downto 0);
    signal wireAluOper : std_logic_vector(2 downto 0);
begin
	process(clk,rst)
    	begin
        	wireClk <= clk;
            wireRst <= rst;
        end process;
    
    PC : entity work.reg32 port map(
    	clk 	=> wireClk,
        rst 	=> wireRst,
        load 	=> (wireZero and wireBranch) or wirePcWrite,
        d 		=> wireNextPc,
        q 		=> wireNewPc
    );
    
     MEMROM: entity work.rom port map (
    	address => wireNewPc,
        data 	=> wireRomOut
    );
    
    MUXNEWPC : entity work.mux332 port map(
    	d0 => wireResult,
        d1 => wireAluOut,
        d2 => wireNewPC(31 downto 28) & wireAddr & "00",
        s => wirePcSrc,
        y => wireNextPc
    );
    
     MEMORYRAM : entity work.ram port map (
    	clk     => 	wireClk,
        datain  => 	wireBOut,
        address => 	wireAluOut,
        write   => 	wireMemWR,
        dataout => 	wireMemOut
    );
    
    ICONTROL: entity work.control port map(
    	rst		 => wireRst,
        clk		 => wireClk,
        op		 => wireOpCode,
        regDst	 => wireRegDst,
        branch	 => wireBranch,
        memWR	 => wireMemWR,
        memToReg => wireMemToReg,
        aluOp	 => wireAluOp,
        regWrite => wireRegWrite,
        aluSrcA	 => wireAluSrcA,
        aluSrcB	 => wireAluSrcB,
        IRWrite  => wireIRWrite,
        PcWrite	 => wirePcWrite,
        PcSrc	 => wirePcSrc,
        cause	 => causeOut
    );
    
    IREGP: entity work.iReg port map(
    	clk   	 => wireClk,
    	load  	 => wireIRWrite,
        inst     => wireRomOut,
        op	  	 => wireOpCode,
        addr	 => wireAddr,
        rs	  	 => wireRS,
        rt	  	 => wireRT,
        rd	  	 => wireRD,
        imm	  	 => wireImmAux,
        funct	 => wirefunct
    );
    
    CPUREGISTERS: entity work.registers port map ( --design
        clock => wireClk,
        reset => wireRst,
        rr1   => wireRS, -- read register 1 (RS)
        rr2   => wireRt, -- read register 2 (RT)
        rw    => wireRegWrite,           -- read or write on register
        wr    => wireWriteRegister,  -- register for write
        wd 	  => wireWriteData,          -- write data
        rd1	  => wireReadData1,          -- read data 1
        rd2	  => wireReadData2           -- read data 2
  	);
    
    FFA : entity work.flipflop32 port map(
    	clk  => clk,
        rst  => rst,
        d    => wireReadData1,
        q    => wireAOUT
    );
    
    FFB : entity work.flipflop32 port map(
    	clk  => clk,
        rst  => rst,
        d    => wireReadData2,
        q    => wireBOUT
    );
    
    FFALU : entity work.flipflop32 port map (
    	clk  => clk,
        rst  => rst,
        d    => wireResult,
        q    => wireAluOut
    	
    ); 
    
    MUX1 : entity work.mux215 port map(
    	d0 => wireRT, 
        d1 => wireRD,
        s  => wireRegDst,
        y  => wireWriteRegister
    );
    
    MUX232MEM : entity work.mux232 port map(
    	d0 	   => wireAluOut,
        d1 	   => wireMemDataRegOut,
        s 	   => wireMemToReg,
        y      => wireWriteData
    );
    
    MUX232ALU : entity work.mux232 port map(
    	d0 	   => wireNewPc,
        d1 	   => wireAOut,
        s 	   => wireAluSrcA,
        y      => wireAluIn1
    );
   
    MUX432 : entity work.mux432 port map(
    	d0  => wireBOut,
        d1  => x"00000004",
        d2  => "0000000000000000" & wireImmAux,
        d3  => "00000000000000" & wireImmAux & "00",
        s   => wireAluSrcB,
    	y   => wireAluIn	
    );
    
    ALUCRTL: entity work.aluControl port map (
    	  clk => wireClk,
          aluOp => wireAluOp,
          funct => wireFunct,
          oper => wireAluOper
    );
    
    ALURISC: entity work.alu port map (
          regA => wireAluIn1,
          regB => wireAluIn,
          oper => wireAluOper,
          result => wireResult,
          zero => wireZero
    );
    
end behavior;