	.file	1 "main1.c"
	.section .mdebug.abi32
	.previous
	.nan	legacy
	.module	fp=xx
	.module	nooddspreg
	.abicalls
	.text
	.globl	reg_names
	.rdata
	.align	2
$LC0:
	.ascii	"$zero\000"
	.align	2
$LC1:
	.ascii	"$at\000"
	.align	2
$LC2:
	.ascii	"$v0\000"
	.align	2
$LC3:
	.ascii	"$v1\000"
	.align	2
$LC4:
	.ascii	"$a0\000"
	.align	2
$LC5:
	.ascii	"$a1\000"
	.align	2
$LC6:
	.ascii	"$a2\000"
	.align	2
$LC7:
	.ascii	"$a3\000"
	.align	2
$LC8:
	.ascii	"$t0\000"
	.align	2
$LC9:
	.ascii	"$t1\000"
	.align	2
$LC10:
	.ascii	"$t2\000"
	.align	2
$LC11:
	.ascii	"$t3\000"
	.align	2
$LC12:
	.ascii	"$t4\000"
	.align	2
$LC13:
	.ascii	"$t5\000"
	.align	2
$LC14:
	.ascii	"$t6\000"
	.align	2
$LC15:
	.ascii	"$t7\000"
	.align	2
$LC16:
	.ascii	"$s0\000"
	.align	2
$LC17:
	.ascii	"$s1\000"
	.align	2
$LC18:
	.ascii	"$s2\000"
	.align	2
$LC19:
	.ascii	"$s3\000"
	.align	2
$LC20:
	.ascii	"$s4\000"
	.align	2
$LC21:
	.ascii	"$s5\000"
	.align	2
$LC22:
	.ascii	"$s6\000"
	.align	2
$LC23:
	.ascii	"$s7\000"
	.align	2
$LC24:
	.ascii	"$t8\000"
	.align	2
$LC25:
	.ascii	"$t9\000"
	.align	2
$LC26:
	.ascii	"$k0\000"
	.align	2
$LC27:
	.ascii	"$k1\000"
	.align	2
$LC28:
	.ascii	"$gp\000"
	.align	2
$LC29:
	.ascii	"$sp\000"
	.align	2
$LC30:
	.ascii	"$fp\000"
	.align	2
$LC31:
	.ascii	"$ra\000"
	.section	.data.rel.local,"aw"
	.align	2
	.type	reg_names, @object
	.size	reg_names, 128
reg_names:
	.word	$LC0
	.word	$LC1
	.word	$LC2
	.word	$LC3
	.word	$LC4
	.word	$LC5
	.word	$LC6
	.word	$LC7
	.word	$LC8
	.word	$LC9
	.word	$LC10
	.word	$LC11
	.word	$LC12
	.word	$LC13
	.word	$LC14
	.word	$LC15
	.word	$LC16
	.word	$LC17
	.word	$LC18
	.word	$LC19
	.word	$LC20
	.word	$LC21
	.word	$LC22
	.word	$LC23
	.word	$LC24
	.word	$LC25
	.word	$LC26
	.word	$LC27
	.word	$LC28
	.word	$LC29
	.word	$LC30
	.word	$LC31
	.globl	instructions
	.section	.bss,"aw",@nobits
	.align	2
	.type	instructions, @object
	.size	instructions, 400
instructions:
	.space	400
	.globl	instruction_count
	.align	2
	.type	instruction_count, @object
	.size	instruction_count, 4
instruction_count:
	.space	4
	.globl	labels
	.align	2
	.type	labels, @object
	.size	labels, 2400
labels:
	.space	2400
	.globl	label_count
	.align	2
	.type	label_count, @object
	.size	label_count, 4
label_count:
	.space	4
	.rdata
	.align	2
$LC32:
	.ascii	"Input MIPS machine code: \000"
	.align	2
$LC33:
	.ascii	"%d instructions loaded\012\000"
	.align	2
$LC34:
	.ascii	"please input any key to stop...\000"
	.text
	.align	2
	.globl	main
	.set	nomips16
	.set	nomicromips
	.ent	main
	.type	main, @function
main:
	.frame	$fp,32,$31		# vars= 0, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	lui	$2,%hi($LC32)
	addiu	$4,$2,%lo($LC32)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	.option	pic0
	jal	read_instructions
	nop

	.option	pic2
	lw	$28,16($fp)
	bne	$2,$0,$L2
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L3
	nop

	.option	pic2
$L2:
	lui	$2,%hi(instruction_count)
	lw	$2,%lo(instruction_count)($2)
	move	$5,$2
	lui	$2,%hi($LC33)
	addiu	$4,$2,%lo($LC33)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	.option	pic0
	jal	disassemble_all
	nop

	.option	pic2
	lw	$28,16($fp)
	lui	$2,%hi($LC34)
	addiu	$4,$2,%lo($LC34)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$2,%call16(getchar)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,getchar
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$2,$0
$L3:
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.rdata
	.align	2
$LC35:
	.ascii	"\015\012\000"
	.align	2
$LC36:
	.ascii	" \000"
	.align	2
$LC37:
	.ascii	"Invalid length: %s\012\000"
	.align	2
$LC38:
	.ascii	"Invalid hex '%c' in %s\012\000"
	.text
	.align	2
	.globl	read_instructions
	.set	nomips16
	.set	nomicromips
	.ent	read_instructions
	.type	read_instructions, @function
read_instructions:
	.frame	$fp,1080,$31		# vars= 1040, regs= 3/0, args= 16, gp= 8
	.mask	0xc0010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-1080
	sw	$31,1076($sp)
	sw	$fp,1072($sp)
	sw	$16,1068($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	lw	$2,%got(__stack_chk_guard)($28)
	lw	$2,0($2)
	sw	$2,1060($fp)
	lw	$2,%got(stdin)($28)
	lw	$2,0($2)
	addiu	$3,$fp,36
	move	$6,$2
	li	$5,1024			# 0x400
	move	$4,$3
	lw	$2,%call16(fgets)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,fgets
1:	jalr	$25
	nop

	lw	$28,16($fp)
	bne	$2,$0,$L5
	nop

	move	$2,$0
	.option	pic0
	b	$L14
	nop

	.option	pic2
$L5:
	addiu	$3,$fp,36
	lui	$2,%hi($LC35)
	addiu	$5,$2,%lo($LC35)
	move	$4,$3
	lw	$2,%call16(strcspn)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,strcspn
1:	jalr	$25
	nop

	lw	$28,16($fp)
	addiu	$3,$fp,1064
	addu	$2,$3,$2
	sb	$0,-1028($2)
	addiu	$3,$fp,36
	lui	$2,%hi($LC36)
	addiu	$5,$2,%lo($LC36)
	move	$4,$3
	lw	$2,%call16(strtok)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,strtok
1:	jalr	$25
	nop

	lw	$28,16($fp)
	sw	$2,24($fp)
	.option	pic0
	b	$L7
	nop

	.option	pic2
$L13:
	lw	$4,24($fp)
	lw	$2,%call16(strlen)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,strlen
1:	jalr	$25
	nop

	lw	$28,16($fp)
	sw	$2,32($fp)
	lw	$3,32($fp)
	li	$2,8			# 0x8
	beq	$3,$2,$L8
	nop

	lw	$5,24($fp)
	lui	$2,%hi($LC37)
	addiu	$4,$2,%lo($LC37)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$2,$0
	.option	pic0
	b	$L14
	nop

	.option	pic2
$L8:
	sw	$0,28($fp)
	.option	pic0
	b	$L9
	nop

	.option	pic2
$L11:
	lw	$2,%call16(__ctype_b_loc)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,__ctype_b_loc
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$3,0($2)
	lw	$2,28($fp)
	lw	$4,24($fp)
	addu	$2,$4,$2
	lb	$2,0($2)
	andi	$2,$2,0x00ff
	sll	$2,$2,1
	addu	$2,$3,$2
	lhu	$2,0($2)
	andi	$2,$2,0x10
	bne	$2,$0,$L10
	nop

	lw	$2,28($fp)
	lw	$3,24($fp)
	addu	$2,$3,$2
	lb	$2,0($2)
	lw	$6,24($fp)
	move	$5,$2
	lui	$2,%hi($LC38)
	addiu	$4,$2,%lo($LC38)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$2,$0
	.option	pic0
	b	$L14
	nop

	.option	pic2
$L10:
	lw	$2,28($fp)
	lw	$3,24($fp)
	addu	$2,$3,$2
	lb	$2,0($2)
	andi	$2,$2,0x00ff
	move	$4,$2
	lw	$2,%call16(toupper)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,toupper
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$4,$2
	lw	$2,28($fp)
	lw	$3,24($fp)
	addu	$2,$3,$2
	seb	$3,$4
	sb	$3,0($2)
	lw	$2,28($fp)
	addiu	$2,$2,1
	sw	$2,28($fp)
$L9:
	lw	$3,28($fp)
	lw	$2,32($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L11
	nop

	lui	$2,%hi(instruction_count)
	lw	$16,%lo(instruction_count)($2)
	addiu	$3,$16,1
	lui	$2,%hi(instruction_count)
	sw	$3,%lo(instruction_count)($2)
	li	$6,16			# 0x10
	move	$5,$0
	lw	$4,24($fp)
	lw	$2,%call16(strtoul)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,strtoul
1:	jalr	$25
	nop

	lw	$28,16($fp)
	move	$4,$2
	lui	$2,%hi(instructions)
	sll	$3,$16,2
	addiu	$2,$2,%lo(instructions)
	addu	$2,$3,$2
	sw	$4,0($2)
	lui	$2,%hi($LC36)
	addiu	$5,$2,%lo($LC36)
	move	$4,$0
	lw	$2,%call16(strtok)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,strtok
1:	jalr	$25
	nop

	lw	$28,16($fp)
	sw	$2,24($fp)
$L7:
	lw	$2,24($fp)
	beq	$2,$0,$L12
	nop

	lui	$2,%hi(instruction_count)
	lw	$2,%lo(instruction_count)($2)
	slt	$2,$2,100
	bne	$2,$0,$L13
	nop

$L12:
	li	$2,1			# 0x1
$L14:
	move	$4,$2
	lw	$2,%got(__stack_chk_guard)($28)
	lw	$3,1060($fp)
	lw	$2,0($2)
	beq	$3,$2,$L15
	nop

	lw	$2,%call16(__stack_chk_fail)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,__stack_chk_fail
1:	jalr	$25
	nop

$L15:
	move	$2,$4
	move	$sp,$fp
	lw	$31,1076($sp)
	lw	$fp,1072($sp)
	lw	$16,1068($sp)
	addiu	$sp,$sp,1080
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	read_instructions
	.size	read_instructions, .-read_instructions
	.align	2
	.set	nomips16
	.set	nomicromips
	.ent	cmp_label
	.type	cmp_label, @function
cmp_label:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$5,20($fp)
	lw	$2,16($fp)
	sw	$2,0($fp)
	lw	$2,20($fp)
	sw	$2,4($fp)
	lw	$2,0($fp)
	lw	$3,0($2)
	lw	$2,4($fp)
	lw	$2,0($2)
	sltu	$2,$3,$2
	beq	$2,$0,$L17
	nop

	li	$2,-1			# 0xffffffffffffffff
	.option	pic0
	b	$L18
	nop

	.option	pic2
$L17:
	lw	$2,0($fp)
	lw	$3,0($2)
	lw	$2,4($fp)
	lw	$2,0($2)
	sltu	$2,$2,$3
	beq	$2,$0,$L19
	nop

	li	$2,1			# 0x1
	.option	pic0
	b	$L18
	nop

	.option	pic2
$L19:
	move	$2,$0
$L18:
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	cmp_label
	.size	cmp_label, .-cmp_label
	.rdata
	.align	2
$LC39:
	.ascii	"L%03d\000"
	.text
	.align	2
	.globl	collect_labels
	.set	nomips16
	.set	nomicromips
	.ent	collect_labels
	.type	collect_labels, @function
collect_labels:
	.frame	$fp,56,$31		# vars= 24, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-56
	sw	$31,52($sp)
	sw	$fp,48($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	li	$2,4194304			# 0x400000
	sw	$2,32($fp)
	sw	$0,36($fp)
	.option	pic0
	b	$L21
	nop

	.option	pic2
$L31:
	lui	$2,%hi(instructions)
	lw	$3,36($fp)
	sll	$3,$3,2
	addiu	$2,$2,%lo(instructions)
	addu	$2,$3,$2
	lw	$2,0($2)
	sw	$2,44($fp)
	lw	$2,44($fp)
	srl	$2,$2,26
	sb	$2,29($fp)
	lbu	$3,29($fp)
	li	$2,4			# 0x4
	beq	$3,$2,$L22
	nop

	lbu	$3,29($fp)
	li	$2,5			# 0x5
	bne	$3,$2,$L23
	nop

$L22:
	lw	$2,44($fp)
	sh	$2,30($fp)
	lh	$2,30($fp)
	sll	$2,$2,2
	move	$3,$2
	lw	$2,32($fp)
	addu	$2,$3,$2
	addiu	$2,$2,4
	sw	$2,40($fp)
	.option	pic0
	b	$L24
	nop

	.option	pic2
$L23:
	lbu	$3,29($fp)
	li	$2,2			# 0x2
	beq	$3,$2,$L25
	nop

	lbu	$3,29($fp)
	li	$2,3			# 0x3
	bne	$3,$2,$L26
	nop

$L25:
	lw	$2,44($fp)
	sll	$3,$2,2
	li	$2,268369920			# 0xfff0000
	ori	$2,$2,0xfffc
	and	$3,$3,$2
	lw	$2,32($fp)
	addiu	$4,$2,4
	li	$2,-268435456			# 0xfffffffff0000000
	and	$2,$4,$2
	or	$2,$3,$2
	sw	$2,40($fp)
	.option	pic0
	b	$L24
	nop

	.option	pic2
$L26:
	lbu	$3,29($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L27
	nop

	lw	$2,44($fp)
	sh	$2,30($fp)
	lh	$2,30($fp)
	sll	$2,$2,2
	move	$3,$2
	lw	$2,32($fp)
	addu	$2,$3,$2
	addiu	$2,$2,4
	sw	$2,40($fp)
	.option	pic0
	b	$L24
	nop

	.option	pic2
$L27:
	lbu	$3,29($fp)
	li	$2,6			# 0x6
	beq	$3,$2,$L28
	nop

	lbu	$3,29($fp)
	li	$2,7			# 0x7
	bne	$3,$2,$L34
	nop

$L28:
	lw	$2,44($fp)
	sh	$2,30($fp)
	lh	$2,30($fp)
	sll	$2,$2,2
	move	$3,$2
	lw	$2,32($fp)
	addu	$2,$3,$2
	addiu	$2,$2,4
	sw	$2,40($fp)
$L24:
	lw	$4,40($fp)
	.option	pic0
	jal	find_label_name
	nop

	.option	pic2
	lw	$28,16($fp)
	bne	$2,$0,$L30
	nop

	lui	$2,%hi(label_count)
	lw	$2,%lo(label_count)($2)
	slt	$2,$2,200
	beq	$2,$0,$L30
	nop

	lui	$2,%hi(label_count)
	lw	$3,%lo(label_count)($2)
	lui	$4,%hi(labels)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,2
	addiu	$3,$4,%lo(labels)
	addu	$2,$2,$3
	lw	$3,40($fp)
	sw	$3,0($2)
	lui	$2,%hi(label_count)
	lw	$2,%lo(label_count)($2)
	addiu	$3,$2,1
	lui	$2,%hi(label_count)
	sw	$3,%lo(label_count)($2)
	.option	pic0
	b	$L30
	nop

	.option	pic2
$L34:
	nop
$L30:
	lw	$2,36($fp)
	addiu	$2,$2,1
	sw	$2,36($fp)
	lw	$2,32($fp)
	addiu	$2,$2,4
	sw	$2,32($fp)
$L21:
	lui	$2,%hi(instruction_count)
	lw	$2,%lo(instruction_count)($2)
	lw	$3,36($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L31
	nop

	lui	$2,%hi(label_count)
	lw	$2,%lo(label_count)($2)
	move	$3,$2
	lui	$2,%hi(cmp_label)
	addiu	$7,$2,%lo(cmp_label)
	li	$6,12			# 0xc
	move	$5,$3
	lui	$2,%hi(labels)
	addiu	$4,$2,%lo(labels)
	lw	$2,%call16(qsort)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,qsort
1:	jalr	$25
	nop

	lw	$28,16($fp)
	sw	$0,36($fp)
	.option	pic0
	b	$L32
	nop

	.option	pic2
$L33:
	lw	$3,36($fp)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,2
	lui	$3,%hi(labels)
	addiu	$3,$3,%lo(labels)
	addu	$2,$2,$3
	addiu	$3,$2,4
	lw	$2,36($fp)
	addiu	$2,$2,1
	move	$6,$2
	lui	$2,%hi($LC39)
	addiu	$5,$2,%lo($LC39)
	move	$4,$3
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$2,36($fp)
	addiu	$2,$2,1
	sw	$2,36($fp)
$L32:
	lui	$2,%hi(label_count)
	lw	$2,%lo(label_count)($2)
	lw	$3,36($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L33
	nop

	nop
	nop
	move	$sp,$fp
	lw	$31,52($sp)
	lw	$fp,48($sp)
	addiu	$sp,$sp,56
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	collect_labels
	.size	collect_labels, .-collect_labels
	.align	2
	.globl	find_label_name
	.set	nomips16
	.set	nomicromips
	.ent	find_label_name
	.type	find_label_name, @function
find_label_name:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-16
	sw	$fp,12($sp)
	move	$fp,$sp
	sw	$4,16($fp)
	sw	$0,4($fp)
	.option	pic0
	b	$L36
	nop

	.option	pic2
$L39:
	lui	$4,%hi(labels)
	lw	$3,4($fp)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,2
	addiu	$3,$4,%lo(labels)
	addu	$2,$2,$3
	lw	$2,0($2)
	lw	$3,16($fp)
	bne	$3,$2,$L37
	nop

	lw	$3,4($fp)
	move	$2,$3
	sll	$2,$2,1
	addu	$2,$2,$3
	sll	$2,$2,2
	lui	$3,%hi(labels)
	addiu	$3,$3,%lo(labels)
	addu	$2,$2,$3
	addiu	$2,$2,4
	.option	pic0
	b	$L38
	nop

	.option	pic2
$L37:
	lw	$2,4($fp)
	addiu	$2,$2,1
	sw	$2,4($fp)
$L36:
	lui	$2,%hi(label_count)
	lw	$2,%lo(label_count)($2)
	lw	$3,4($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L39
	nop

	move	$2,$0
$L38:
	move	$sp,$fp
	lw	$fp,12($sp)
	addiu	$sp,$sp,16
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	find_label_name
	.size	find_label_name, .-find_label_name
	.rdata
	.align	2
$LC40:
	.ascii	"[%08x] %08x\011\000"
	.align	2
$LC41:
	.ascii	"%s: \000"
	.text
	.align	2
	.globl	disassemble_all
	.set	nomips16
	.set	nomicromips
	.ent	disassemble_all
	.type	disassemble_all, @function
disassemble_all:
	.frame	$fp,48,$31		# vars= 16, regs= 2/0, args= 16, gp= 8
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$fp,40($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	16
	li	$2,4194304			# 0x400000
	sw	$2,28($fp)
	.option	pic0
	jal	collect_labels
	nop

	.option	pic2
	lw	$28,16($fp)
	sw	$0,24($fp)
	.option	pic0
	b	$L41
	nop

	.option	pic2
$L43:
	lw	$4,28($fp)
	.option	pic0
	jal	find_label_name
	nop

	.option	pic2
	lw	$28,16($fp)
	sw	$2,32($fp)
	lui	$2,%hi(instructions)
	lw	$3,24($fp)
	sll	$3,$3,2
	addiu	$2,$2,%lo(instructions)
	addu	$2,$3,$2
	lw	$2,0($2)
	lw	$5,28($fp)
	move	$4,$2
	.option	pic0
	jal	disassemble_instruction
	nop

	.option	pic2
	lw	$28,16($fp)
	sw	$2,36($fp)
	lui	$2,%hi(instructions)
	lw	$3,24($fp)
	sll	$3,$3,2
	addiu	$2,$2,%lo(instructions)
	addu	$2,$3,$2
	lw	$2,0($2)
	move	$6,$2
	lw	$5,28($fp)
	lui	$2,%hi($LC40)
	addiu	$4,$2,%lo($LC40)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$2,32($fp)
	beq	$2,$0,$L42
	nop

	lw	$5,32($fp)
	lui	$2,%hi($LC41)
	addiu	$4,$2,%lo($LC41)
	lw	$2,%call16(printf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,printf
1:	jalr	$25
	nop

	lw	$28,16($fp)
$L42:
	lw	$4,36($fp)
	lw	$2,%call16(puts)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,puts
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$4,36($fp)
	lw	$2,%call16(free)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,free
1:	jalr	$25
	nop

	lw	$28,16($fp)
	lw	$2,24($fp)
	addiu	$2,$2,1
	sw	$2,24($fp)
	lw	$2,28($fp)
	addiu	$2,$2,4
	sw	$2,28($fp)
$L41:
	lui	$2,%hi(instruction_count)
	lw	$2,%lo(instruction_count)($2)
	lw	$3,24($fp)
	slt	$2,$3,$2
	bne	$2,$0,$L43
	nop

	nop
	nop
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	disassemble_all
	.size	disassemble_all, .-disassemble_all
	.rdata
	.align	2
$LC42:
	.ascii	"sll %s,%s,%d\000"
	.align	2
$LC43:
	.ascii	"srl %s,%s,%d\000"
	.align	2
$LC44:
	.ascii	"sra %s,%s,%d\000"
	.align	2
$LC45:
	.ascii	"sllv %s,%s,%s\000"
	.align	2
$LC46:
	.ascii	"srlv %s,%s,%s\000"
	.align	2
$LC47:
	.ascii	"srav %s,%s,%s\000"
	.align	2
$LC48:
	.ascii	"jr %s\000"
	.align	2
$LC49:
	.ascii	"jalr %s,%s\000"
	.align	2
$LC50:
	.ascii	"syscall\000"
	.align	2
$LC51:
	.ascii	"mfhi %s\000"
	.align	2
$LC52:
	.ascii	"mthi %s\000"
	.align	2
$LC53:
	.ascii	"mflo %s\000"
	.align	2
$LC54:
	.ascii	"mtlo %s\000"
	.align	2
$LC55:
	.ascii	"mult %s,%s\000"
	.align	2
$LC56:
	.ascii	"multu %s,%s\000"
	.align	2
$LC57:
	.ascii	"div %s,%s\000"
	.align	2
$LC58:
	.ascii	"divu %s,%s\000"
	.align	2
$LC59:
	.ascii	"add %s,%s,%s\000"
	.align	2
$LC60:
	.ascii	"sub %s,%s,%s\000"
	.align	2
$LC61:
	.ascii	"addu %s,%s,%s\000"
	.align	2
$LC62:
	.ascii	"subu %s,%s,%s\000"
	.align	2
$LC63:
	.ascii	"and %s,%s,%s\000"
	.align	2
$LC64:
	.ascii	"or %s,%s,%s\000"
	.align	2
$LC65:
	.ascii	"xor %s,%s,%s\000"
	.align	2
$LC66:
	.ascii	"nor %s,%s,%s\000"
	.align	2
$LC67:
	.ascii	"slt %s,%s,%s\000"
	.align	2
$LC68:
	.ascii	"sltu %s,%s,%s\000"
	.align	2
$LC69:
	.ascii	"???\000"
	.align	2
$LC70:
	.ascii	"bltz %s,%s[%08x]\000"
	.align	2
$LC71:
	.ascii	"bgez %s,%s[%08x]\000"
	.align	2
$LC72:
	.ascii	"bltzal %s,%s[%08x]\000"
	.align	2
$LC73:
	.ascii	"bgezal %s,%s[%08x]\000"
	.align	2
$LC74:
	.ascii	"beq %s,%s,%s[%08x]\000"
	.align	2
$LC75:
	.ascii	"bne %s,%s,%s[%08x]\000"
	.align	2
$LC76:
	.ascii	"blez %s,%s[%08x]\000"
	.align	2
$LC77:
	.ascii	"bgtz %s,%s[%08x]\000"
	.align	2
$LC78:
	.ascii	"j %s[%08x]\000"
	.align	2
$LC79:
	.ascii	"jal %s[%08x]\000"
	.align	2
$LC80:
	.ascii	"addi %s,%s,%d\000"
	.align	2
$LC81:
	.ascii	"addiu %s,%s,%d\000"
	.align	2
$LC82:
	.ascii	"slti %s,%s,%d\000"
	.align	2
$LC83:
	.ascii	"sltiu %s,%s,%d\000"
	.align	2
$LC84:
	.ascii	"andi %s,%s,%d\000"
	.align	2
$LC85:
	.ascii	"ori %s,%s,%d\000"
	.align	2
$LC86:
	.ascii	"xori %s,%s,%d\000"
	.align	2
$LC87:
	.ascii	"lui %s,%d\000"
	.align	2
$LC88:
	.ascii	"lb %s,%d(%s)\000"
	.align	2
$LC89:
	.ascii	"lh %s,%d(%s)\000"
	.align	2
$LC90:
	.ascii	"lwl %s,%d(%s)\000"
	.align	2
$LC91:
	.ascii	"lw %s,%d(%s)\000"
	.align	2
$LC92:
	.ascii	"lbu %s,%d(%s)\000"
	.align	2
$LC93:
	.ascii	"lhu %s,%d(%s)\000"
	.align	2
$LC94:
	.ascii	"lwr %s,%d(%s)\000"
	.align	2
$LC95:
	.ascii	"sb %s,%d(%s)\000"
	.align	2
$LC96:
	.ascii	"sh %s,%d(%s)\000"
	.align	2
$LC97:
	.ascii	"swl %s,%d(%s)\000"
	.align	2
$LC98:
	.ascii	"sw %s,%d(%s)\000"
	.align	2
$LC99:
	.ascii	"swr %s,%d(%s)\000"
	.text
	.align	2
	.globl	disassemble_instruction
	.set	nomips16
	.set	nomicromips
	.ent	disassemble_instruction
	.type	disassemble_instruction, @function
disassemble_instruction:
	.frame	$fp,72,$31		# vars= 24, regs= 4/0, args= 24, gp= 8
	.mask	0xc0030000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-72
	sw	$31,68($sp)
	sw	$fp,64($sp)
	sw	$17,60($sp)
	sw	$16,56($sp)
	move	$fp,$sp
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
	.cprestore	24
	sw	$4,72($fp)
	sw	$5,76($fp)
	li	$4,128			# 0x80
	lw	$2,%call16(malloc)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,malloc
1:	jalr	$25
	nop

	lw	$28,24($fp)
	sw	$2,40($fp)
	lw	$2,72($fp)
	srl	$2,$2,26
	sb	$2,33($fp)
	lw	$2,72($fp)
	srl	$2,$2,21
	andi	$2,$2,0x00ff
	andi	$2,$2,0x1f
	sb	$2,34($fp)
	lw	$2,72($fp)
	srl	$2,$2,16
	andi	$2,$2,0x00ff
	andi	$2,$2,0x1f
	sb	$2,35($fp)
	lw	$2,72($fp)
	srl	$2,$2,11
	andi	$2,$2,0x00ff
	andi	$2,$2,0x1f
	sb	$2,36($fp)
	lw	$2,72($fp)
	srl	$2,$2,6
	andi	$2,$2,0x00ff
	andi	$2,$2,0x1f
	sb	$2,37($fp)
	lw	$2,72($fp)
	sh	$2,38($fp)
	lw	$2,72($fp)
	andi	$2,$2,0x3f
	sw	$2,44($fp)
	lbu	$2,33($fp)
	bne	$2,$0,$L45
	nop

	lw	$2,44($fp)
	sltu	$2,$2,44
	beq	$2,$0,$L46
	nop

	lw	$2,44($fp)
	sll	$3,$2,2
	lui	$2,%hi($L48)
	addiu	$2,$2,%lo($L48)
	addu	$2,$3,$2
	lw	$2,0($2)
	jr	$2
	nop

	.rdata
	.align	2
	.align	2
$L48:
	.word	$L74
	.word	$L46
	.word	$L73
	.word	$L72
	.word	$L71
	.word	$L46
	.word	$L70
	.word	$L69
	.word	$L68
	.word	$L67
	.word	$L46
	.word	$L46
	.word	$L66
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L65
	.word	$L64
	.word	$L63
	.word	$L62
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L61
	.word	$L60
	.word	$L59
	.word	$L58
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L46
	.word	$L57
	.word	$L56
	.word	$L55
	.word	$L54
	.word	$L53
	.word	$L52
	.word	$L51
	.word	$L50
	.word	$L46
	.word	$L46
	.word	$L49
	.word	$L47
	.text
$L74:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lbu	$2,37($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC42)
	addiu	$5,$2,%lo($LC42)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L73:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lbu	$2,37($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC43)
	addiu	$5,$2,%lo($LC43)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L72:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lbu	$2,37($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC44)
	addiu	$5,$2,%lo($LC44)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L71:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC45)
	addiu	$5,$2,%lo($LC45)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L70:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC46)
	addiu	$5,$2,%lo($LC46)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L69:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC47)
	addiu	$5,$2,%lo($LC47)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L68:
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$6,$2
	lui	$2,%hi($LC48)
	addiu	$5,$2,%lo($LC48)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L67:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$7,$2
	move	$6,$16
	lui	$2,%hi($LC49)
	addiu	$5,$2,%lo($LC49)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L66:
	lw	$2,40($fp)
	lui	$3,%hi($LC50)
	lw	$4,%lo($LC50)($3)
	addiu	$3,$3,%lo($LC50)
	lw	$3,4($3)
	swl	$4,0($2)
	swr	$4,3($2)
	swl	$3,4($2)
	swr	$3,7($2)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L65:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$6,$2
	lui	$2,%hi($LC51)
	addiu	$5,$2,%lo($LC51)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L64:
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$6,$2
	lui	$2,%hi($LC52)
	addiu	$5,$2,%lo($LC52)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L63:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$6,$2
	lui	$2,%hi($LC53)
	addiu	$5,$2,%lo($LC53)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L62:
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$6,$2
	lui	$2,%hi($LC54)
	addiu	$5,$2,%lo($LC54)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L61:
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$7,$2
	move	$6,$16
	lui	$2,%hi($LC55)
	addiu	$5,$2,%lo($LC55)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L60:
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$7,$2
	move	$6,$16
	lui	$2,%hi($LC56)
	addiu	$5,$2,%lo($LC56)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L59:
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$7,$2
	move	$6,$16
	lui	$2,%hi($LC57)
	addiu	$5,$2,%lo($LC57)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L58:
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$7,$2
	move	$6,$16
	lui	$2,%hi($LC58)
	addiu	$5,$2,%lo($LC58)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L57:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC59)
	addiu	$5,$2,%lo($LC59)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L55:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC60)
	addiu	$5,$2,%lo($LC60)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L56:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC61)
	addiu	$5,$2,%lo($LC61)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L54:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC62)
	addiu	$5,$2,%lo($LC62)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L53:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC63)
	addiu	$5,$2,%lo($LC63)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L52:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC64)
	addiu	$5,$2,%lo($LC64)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L51:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC65)
	addiu	$5,$2,%lo($LC65)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L50:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC66)
	addiu	$5,$2,%lo($LC66)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L49:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC67)
	addiu	$5,$2,%lo($LC67)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L47:
	lbu	$2,36($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$17
	move	$6,$16
	lui	$2,%hi($LC68)
	addiu	$5,$2,%lo($LC68)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L46:
	lw	$2,40($fp)
	lui	$3,%hi($LC69)
	lw	$3,%lo($LC69)($3)
	swl	$3,0($2)
	swr	$3,3($2)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L45:
	lbu	$2,33($fp)
	sltu	$3,$2,47
	beq	$3,$0,$L77
	nop

	sll	$3,$2,2
	lui	$2,%hi($L79)
	addiu	$2,$2,%lo($L79)
	addu	$2,$3,$2
	lw	$2,0($2)
	jr	$2
	nop

	.rdata
	.align	2
	.align	2
$L79:
	.word	$L77
	.word	$L102
	.word	$L101
	.word	$L100
	.word	$L99
	.word	$L99
	.word	$L99
	.word	$L99
	.word	$L98
	.word	$L97
	.word	$L96
	.word	$L95
	.word	$L94
	.word	$L93
	.word	$L92
	.word	$L91
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L77
	.word	$L90
	.word	$L89
	.word	$L88
	.word	$L87
	.word	$L86
	.word	$L85
	.word	$L84
	.word	$L77
	.word	$L83
	.word	$L82
	.word	$L81
	.word	$L80
	.word	$L77
	.word	$L77
	.word	$L78
	.text
$L102:
	lh	$2,38($fp)
	sll	$2,$2,2
	move	$3,$2
	lw	$2,76($fp)
	addu	$2,$3,$2
	addiu	$2,$2,4
	sw	$2,48($fp)
	lw	$4,48($fp)
	.option	pic0
	jal	find_label_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,52($fp)
	lbu	$2,35($fp)
	bne	$2,$0,$L103
	nop

	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$4,$2
	lw	$2,52($fp)
	beq	$2,$0,$L104
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L105
	nop

	.option	pic2
$L104:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L105:
	lw	$3,48($fp)
	sw	$3,16($sp)
	move	$7,$2
	move	$6,$4
	lui	$2,%hi($LC70)
	addiu	$5,$2,%lo($LC70)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L103:
	lbu	$3,35($fp)
	li	$2,1			# 0x1
	bne	$3,$2,$L107
	nop

	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$4,$2
	lw	$2,52($fp)
	beq	$2,$0,$L108
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L109
	nop

	.option	pic2
$L108:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L109:
	lw	$3,48($fp)
	sw	$3,16($sp)
	move	$7,$2
	move	$6,$4
	lui	$2,%hi($LC71)
	addiu	$5,$2,%lo($LC71)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L107:
	lbu	$3,35($fp)
	li	$2,16			# 0x10
	bne	$3,$2,$L110
	nop

	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$4,$2
	lw	$2,52($fp)
	beq	$2,$0,$L111
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L112
	nop

	.option	pic2
$L111:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L112:
	lw	$3,48($fp)
	sw	$3,16($sp)
	move	$7,$2
	move	$6,$4
	lui	$2,%hi($LC72)
	addiu	$5,$2,%lo($LC72)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L110:
	lbu	$3,35($fp)
	li	$2,17			# 0x11
	bne	$3,$2,$L113
	nop

	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$4,$2
	lw	$2,52($fp)
	beq	$2,$0,$L114
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L115
	nop

	.option	pic2
$L114:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L115:
	lw	$3,48($fp)
	sw	$3,16($sp)
	move	$7,$2
	move	$6,$4
	lui	$2,%hi($LC73)
	addiu	$5,$2,%lo($LC73)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L113:
	lw	$2,40($fp)
	lui	$3,%hi($LC69)
	lw	$3,%lo($LC69)($3)
	swl	$3,0($2)
	swr	$3,3($2)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L99:
	lh	$2,38($fp)
	sll	$2,$2,2
	move	$3,$2
	lw	$2,76($fp)
	addu	$2,$3,$2
	addiu	$2,$2,4
	sw	$2,48($fp)
	lw	$4,48($fp)
	.option	pic0
	jal	find_label_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,52($fp)
	lbu	$3,33($fp)
	li	$2,4			# 0x4
	bne	$3,$2,$L116
	nop

	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$4,$2
	lw	$2,52($fp)
	beq	$2,$0,$L117
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L118
	nop

	.option	pic2
$L117:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L118:
	lw	$3,48($fp)
	sw	$3,20($sp)
	sw	$2,16($sp)
	move	$7,$4
	move	$6,$16
	lui	$2,%hi($LC74)
	addiu	$5,$2,%lo($LC74)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
$L116:
	lbu	$3,33($fp)
	li	$2,5			# 0x5
	bne	$3,$2,$L119
	nop

	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$4,$2
	lw	$2,52($fp)
	beq	$2,$0,$L120
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L121
	nop

	.option	pic2
$L120:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L121:
	lw	$3,48($fp)
	sw	$3,20($sp)
	sw	$2,16($sp)
	move	$7,$4
	move	$6,$16
	lui	$2,%hi($LC75)
	addiu	$5,$2,%lo($LC75)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
$L119:
	lbu	$3,33($fp)
	li	$2,6			# 0x6
	bne	$3,$2,$L122
	nop

	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$4,$2
	lw	$2,52($fp)
	beq	$2,$0,$L123
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L124
	nop

	.option	pic2
$L123:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L124:
	lw	$3,48($fp)
	sw	$3,16($sp)
	move	$7,$2
	move	$6,$4
	lui	$2,%hi($LC76)
	addiu	$5,$2,%lo($LC76)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
$L122:
	lbu	$3,33($fp)
	li	$2,7			# 0x7
	bne	$3,$2,$L133
	nop

	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$4,$2
	lw	$2,52($fp)
	beq	$2,$0,$L126
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L127
	nop

	.option	pic2
$L126:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L127:
	lw	$3,48($fp)
	sw	$3,16($sp)
	move	$7,$2
	move	$6,$4
	lui	$2,%hi($LC77)
	addiu	$5,$2,%lo($LC77)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L133
	nop

	.option	pic2
$L101:
	lw	$2,72($fp)
	sll	$3,$2,2
	li	$2,268369920			# 0xfff0000
	ori	$2,$2,0xfffc
	and	$3,$3,$2
	lw	$2,76($fp)
	addiu	$4,$2,4
	li	$2,-268435456			# 0xfffffffff0000000
	and	$2,$4,$2
	or	$2,$3,$2
	sw	$2,48($fp)
	lw	$4,48($fp)
	.option	pic0
	jal	find_label_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,52($fp)
	lw	$2,52($fp)
	beq	$2,$0,$L128
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L129
	nop

	.option	pic2
$L128:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L129:
	lw	$7,48($fp)
	move	$6,$2
	lui	$2,%hi($LC78)
	addiu	$5,$2,%lo($LC78)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L100:
	lw	$2,72($fp)
	sll	$3,$2,2
	li	$2,268369920			# 0xfff0000
	ori	$2,$2,0xfffc
	and	$3,$3,$2
	lw	$2,76($fp)
	addiu	$4,$2,4
	li	$2,-268435456			# 0xfffffffff0000000
	and	$2,$4,$2
	or	$2,$3,$2
	sw	$2,48($fp)
	lw	$4,48($fp)
	.option	pic0
	jal	find_label_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,52($fp)
	lw	$2,52($fp)
	beq	$2,$0,$L130
	nop

	lw	$2,52($fp)
	.option	pic0
	b	$L131
	nop

	.option	pic2
$L130:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L131:
	lw	$7,48($fp)
	move	$6,$2
	lui	$2,%hi($LC79)
	addiu	$5,$2,%lo($LC79)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L98:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lh	$2,38($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC80)
	addiu	$5,$2,%lo($LC80)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L97:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lh	$2,38($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC81)
	addiu	$5,$2,%lo($LC81)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L96:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lh	$2,38($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC82)
	addiu	$5,$2,%lo($LC82)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L95:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lh	$2,38($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC83)
	addiu	$5,$2,%lo($LC83)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L94:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lh	$2,38($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC84)
	addiu	$5,$2,%lo($LC84)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L93:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lh	$2,38($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC85)
	addiu	$5,$2,%lo($LC85)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L92:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$16,$2
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lh	$2,38($fp)
	sw	$2,16($sp)
	move	$7,$3
	move	$6,$16
	lui	$2,%hi($LC86)
	addiu	$5,$2,%lo($LC86)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L91:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$3,$2
	lh	$2,38($fp)
	move	$7,$2
	move	$6,$3
	lui	$2,%hi($LC87)
	addiu	$5,$2,%lo($LC87)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L90:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC88)
	addiu	$5,$2,%lo($LC88)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L89:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC89)
	addiu	$5,$2,%lo($LC89)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L88:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC90)
	addiu	$5,$2,%lo($LC90)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L87:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC91)
	addiu	$5,$2,%lo($LC91)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L86:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC92)
	addiu	$5,$2,%lo($LC92)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L85:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC93)
	addiu	$5,$2,%lo($LC93)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L84:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC94)
	addiu	$5,$2,%lo($LC94)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L83:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC95)
	addiu	$5,$2,%lo($LC95)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L82:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC96)
	addiu	$5,$2,%lo($LC96)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L81:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC97)
	addiu	$5,$2,%lo($LC97)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L80:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC98)
	addiu	$5,$2,%lo($LC98)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L78:
	lbu	$2,35($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	move	$17,$2
	lh	$16,38($fp)
	lbu	$2,34($fp)
	move	$4,$2
	.option	pic0
	jal	get_reg_name
	nop

	.option	pic2
	lw	$28,24($fp)
	sw	$2,16($sp)
	move	$7,$16
	move	$6,$17
	lui	$2,%hi($LC99)
	addiu	$5,$2,%lo($LC99)
	lw	$4,40($fp)
	lw	$2,%call16(sprintf)($28)
	move	$25,$2
	.reloc	1f,R_MIPS_JALR,sprintf
1:	jalr	$25
	nop

	lw	$28,24($fp)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L77:
	lw	$2,40($fp)
	lui	$3,%hi($LC69)
	lw	$3,%lo($LC69)($3)
	swl	$3,0($2)
	swr	$3,3($2)
	.option	pic0
	b	$L76
	nop

	.option	pic2
$L133:
	nop
$L76:
	lw	$2,40($fp)
	move	$sp,$fp
	lw	$31,68($sp)
	lw	$fp,64($sp)
	lw	$17,60($sp)
	lw	$16,56($sp)
	addiu	$sp,$sp,72
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	disassemble_instruction
	.size	disassemble_instruction, .-disassemble_instruction
	.align	2
	.globl	get_reg_name
	.set	nomips16
	.set	nomicromips
	.ent	get_reg_name
	.type	get_reg_name, @function
get_reg_name:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	addiu	$sp,$sp,-8
	sw	$fp,4($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
	bltz	$2,$L135
	nop

	lw	$2,8($fp)
	slt	$2,$2,32
	beq	$2,$0,$L135
	nop

	lui	$2,%hi(reg_names)
	lw	$3,8($fp)
	sll	$3,$3,2
	addiu	$2,$2,%lo(reg_names)
	addu	$2,$3,$2
	lw	$2,0($2)
	.option	pic0
	b	$L136
	nop

	.option	pic2
$L135:
	lui	$2,%hi($LC69)
	addiu	$2,$2,%lo($LC69)
$L136:
	move	$sp,$fp
	lw	$fp,4($sp)
	addiu	$sp,$sp,8
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	get_reg_name
	.size	get_reg_name, .-get_reg_name
	.ident	"GCC: (Ubuntu 10.3.0-1ubuntu1) 10.3.0"
	.section	.note.GNU-stack,"",@progbits
