	parameter ori = 'b001101, addi= 'b001000,
				 addiu='b001001,
				 lw  = 'b100011, 
				 lh  = 'b100001, lhu = 'b100101,
				 lb  = 'b100000, lbu = 'b100100,
				 
				 sw  = 'b101011, sh  = 'b101001, sb  = 'b101000,

				 beq = 'b000100, bne = 'b000101,
				 bgtz= 'b000111, blez= 'b000110,
				 lui = 'b001111,
				 j   = 'b000010, jal = 'b000011,
				 lwl = 'b100010, lwr = 'b100110,
				 xori= 'b001110, slti= 'b001010,
				 sltiu='b001011, andi= 'b001100;
	//opcode
	parameter addu= 'b100001, subu= 'b100011,
				 jr  = 'b001000, sll = 'b000000,
				 jalr= 'b001001, movn= 'b001011,
				 movz= 'b001010, add = 'b100000,
				 sub = 'b100010, srl = 'b000010,
				 and_= 'b100100, or_ = 'b100101,
				 xor_= 'b100110, sra = 'b000011,
				 sllv= 'b000100, srlv= 'b000110,
				 srav= 'b000111, nor_= 'b100111,
				 sltu= 'b101011, slt = 'b101010,
				 
				 mult= 'b011000, multu='b011001,
				 mthi= 'b010001, mtlo= 'b010011,
				 mfhi= 'b010000, mflo= 'b010010,
				 div = 'b011010, divu= 'b011011,
				 
				 break_='b001101,
				 eret= 'b011000;
				 
	//func
	parameter R   = 'b000000, SP2 = 'b011100,
				 SP3 = 'b011111, REGIMM = 'b000001,
				 COP0= 'b010000;
	parameter clo = 'b100001, clz = 'b100000,
				 mul = 'b000010, madd= 'b000000,
				 msub= 'b000100, maddu='b000001,
				 msubu='b000101;
	//sp2
	parameter ins = 'b000100, ext = 'b000000,
				 bshfl='b100000;
	//sp3
	parameter bgez= 'b00001, bltz= 'b00000,
				 bgezal = 'b10001, bltzal = 'b10000,
				 bal = 'b10001;
	//regimm
	parameter mfc0= 'b00000, mtc0= 'b00100;