# MIPS反汇编器实现 - 主要功能是将MIPS机器码反汇编为可读的汇编指令
# 可在MARS平台运行

# 文件结构:
#主要函数实现
#   - main: 程序入口点
#   - read_instructions: 读取MIPS机器码
#   - collect_labels: 收集和处理跳转标签
#    - disassemble_all: 反汇编所有指令
#   - disassemble_instruction: 反汇编单条指令
#   - print_reg:从寄存器号获得寄存器名                     


.data
    # 常量定义
    MAX_INSTRUCTIONS: .word 100        # 最多支持100条指令
    MAX_LABELS:      .word 200         # 最多支持200个标签
    START_ADDRESS:   .word 0x00400000  # 程序起始地址
    
    # 存储区
    instructions:    .space 400        # 100条指令 × 4字节/条
    instr_count:     .word 0           # 指令计数器
    
    # 标签结构: 地址(4字节) + 名称(8字节)
    labels:          .space 2400       # 200个标签 × 12字节/标签
    label_count:     .word 0           # 标签计数器
    
	my_hex_str: .space 8    # 8字符
	  
    # 消息
    prompt_msg:      .asciiz "Input MIPS machine code: "
    loaded_msg:      .asciiz " instructions loaded\n"
    continue_msg:    .asciiz "please input any key to stop..."
    addr_label:      .asciiz "["
    instr_sep:       .asciiz "] "
    tab:             .asciiz "\t"
    colon:           .asciiz ": "
    newline:         .asciiz "\n"
    space:           .asciiz " "
    comma:           .asciiz ","
    comma_space:     .asciiz ", "
    lparen:          .asciiz "("
    rparen:          .asciiz ")"
    lbracket:        .asciiz "["
    rbracket:        .asciiz "]"
    unknown:         .asciiz "???"
    
    # 输入缓冲区
    input_buffer:    .space 1024       # 输入缓冲区
    token_buffer:    .space 9          # 存储单个指令的十六进制字符 (8位+\0)
    
    # 寄存器名称
    reg_zero:        .asciiz "$zero"
    reg_at:          .asciiz "$at"
    reg_v0:          .asciiz "$v0"
    reg_v1:          .asciiz "$v1"
    reg_a0:          .asciiz "$a0"
    reg_a1:          .asciiz "$a1"
    reg_a2:          .asciiz "$a2"
    reg_a3:          .asciiz "$a3"
    reg_t0:          .asciiz "$t0"
    reg_t1:          .asciiz "$t1"
    reg_t2:          .asciiz "$t2"
    reg_t3:          .asciiz "$t3"
    reg_t4:          .asciiz "$t4"
    reg_t5:          .asciiz "$t5"
    reg_t6:          .asciiz "$t6"
    reg_t7:          .asciiz "$t7"
    reg_s0:          .asciiz "$s0"
    reg_s1:          .asciiz "$s1"
    reg_s2:          .asciiz "$s2"
    reg_s3:          .asciiz "$s3"
    reg_s4:          .asciiz "$s4"
    reg_s5:          .asciiz "$s5"
    reg_s6:          .asciiz "$s6"
    reg_s7:          .asciiz "$s7"
    reg_t8:          .asciiz "$t8"
    reg_t9:          .asciiz "$t9"
    reg_k0:          .asciiz "$k0"
    reg_k1:          .asciiz "$k1"
    reg_gp:          .asciiz "$gp"
    reg_sp:          .asciiz "$sp"
    reg_fp:          .asciiz "$fp"
    reg_ra:          .asciiz "$ra"
    
    # 指令助记符
    # R型指令
    mnem_sll:        .asciiz "sll"
    mnem_srl:        .asciiz "srl"
    mnem_sra:        .asciiz "sra"
    mnem_sllv:       .asciiz "sllv"
    mnem_srlv:       .asciiz "srlv"
    mnem_srav:       .asciiz "srav"
    mnem_jr:         .asciiz "jr"
    mnem_jalr:       .asciiz "jalr"
    mnem_syscall:    .asciiz "syscall"
    mnem_mult:       .asciiz "mult"
    mnem_multu:      .asciiz "multu"
    mnem_div:        .asciiz "div"
    mnem_divu:       .asciiz "divu"
    mnem_mfhi:       .asciiz "mfhi"
    mnem_mthi:       .asciiz "mthi"
    mnem_mflo:       .asciiz "mflo"
    mnem_mtlo:       .asciiz "mtlo"
    mnem_add:        .asciiz "add"
    mnem_addu:       .asciiz "addu"
    mnem_sub:        .asciiz "sub"
    mnem_subu:       .asciiz "subu"
    mnem_and:        .asciiz "and"
    mnem_or:         .asciiz "or"
    mnem_xor:        .asciiz "xor"
    mnem_nor:        .asciiz "nor"
    mnem_slt:        .asciiz "slt"
    mnem_sltu:       .asciiz "sltu"
    
    # I型和J型指令
    mnem_addi:       .asciiz "addi"
    mnem_addiu:      .asciiz "addiu"
    mnem_slti:       .asciiz "slti"
    mnem_sltiu:      .asciiz "sltiu"
    mnem_andi:       .asciiz "andi"
    mnem_ori:        .asciiz "ori"
    mnem_xori:       .asciiz "xori"
    mnem_lui:        .asciiz "lui"
    mnem_beq:        .asciiz "beq"
    mnem_bne:        .asciiz "bne"
    mnem_blez:       .asciiz "blez"
    mnem_bgtz:       .asciiz "bgtz"
    mnem_bltz:       .asciiz "bltz"
    mnem_bgez:       .asciiz "bgez"
    mnem_bltzal:     .asciiz "bltzal"
    mnem_bgezal:     .asciiz "bgezal"
    mnem_j:          .asciiz "j"
    mnem_jal:        .asciiz "jal"
    mnem_lb:         .asciiz "lb"
    mnem_lh:         .asciiz "lh"
    mnem_lw:         .asciiz "lw"
    mnem_lbu:        .asciiz "lbu"
    mnem_lhu:        .asciiz "lhu"
    mnem_sb:         .asciiz "sb"
    mnem_sh:         .asciiz "sh"
    mnem_sw:         .asciiz "sw"
    mnem_swr:        .asciiz "swr"
    
    # 标签格式
    label_fmt:       .asciiz "L%03d"   # 标签格式: L001, L002, ...

.text
main:
    # 输出提示信息
    li $v0, 4
    la $a0, prompt_msg
    syscall
    
    # 读取指令
    jal read_instructions
    beqz $v0, exit_program    # 如果读取失败，退出程序
    
    # 输出已加载指令数
    li $v0, 1
    lw $a0, instr_count
    syscall
    
    li $v0, 4
    la $a0, loaded_msg
    syscall
    
    # 反汇编并输出所有指令
    jal disassemble_all
    
    # 等待用户按键退出
    li $v0, 4
    la $a0, continue_msg
    syscall
    
    li $v0, 5  # 读取整数，实际上只是等待用户输入
    syscall
    
exit_program:
    li $v0, 10  # 退出程序
    syscall

# 函数: read_instructions
# 读取用户输入的十六进制机器码，格式化并存储
# 返回值:
#   $v0 - 1表示成功，0表示失败
read_instructions:
    # 保存返回地址
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    # 初始化
    li $s1, 0                 # 指令计数
    
read_more_input:
    # 读取一行输入
    li $v0, 8
    la $a0, input_buffer
    li $a1, 1024
    syscall
    
    # 初始化指针
    la $s0, input_buffer      # 输入缓冲区指针
    
parse_loop:
    # 跳过空白字符
    lb $t2, 0($s0)
    beqz $t2, check_more_input  # 如果是NULL，检查是否需要读更多输入
    beq $t2, ' ', skip_space
    beq $t2, '\t', skip_space
    beq $t2, '\n', check_more_input
    beq $t2, '\r', check_more_input
    
    # 检查是否达到最大指令数
    lw $t3, MAX_INSTRUCTIONS
    beq $s1, $t3, end_parse
    
    # 解析一个token (8个十六进制数字)
    la $t4, token_buffer      # token缓冲区
    li $t5, 0                 # 字符计数
    
token_loop:
    lb $t2, 0($s0)
    beqz $t2, end_token
    beq $t2, ' ', end_token
    beq $t2, '\t', end_token
    beq $t2, '\n', end_token
    beq $t2, '\r', end_token
    
    # 检查是否是有效的十六进制字符
    li $t6, '0'
    blt $t2, $t6, invalid_token
    li $t6, '9'
    ble $t2, $t6, valid_hex_digit
    
    li $t6, 'A'
    blt $t2, $t6, check_lowercase
    li $t6, 'F'
    ble $t2, $t6, valid_hex_digit
    
check_lowercase:
    li $t6, 'a'
    blt $t2, $t6, invalid_token
    li $t6, 'f'
    bgt $t2, $t6, invalid_token
    
valid_hex_digit:
    # 转换为大写字母
    li $t6, 'a'
    blt $t2, $t6, store_char
    li $t6, 'z'
    bgt $t2, $t6, store_char
    
    # 将小写字母转换为大写
    addi $t2, $t2, -32
    
store_char:
    # 存储字符
    sb $t2, 0($t4)
    
    # 移动到下一个字符
    addi $s0, $s0, 1
    addi $t4, $t4, 1
    addi $t5, $t5, 1
    
    # 检查是否已读取8个字符
    li $t6, 8
    blt $t5, $t6, token_loop
    j end_token_read
    
skip_space:
    addi $s0, $s0, 1
    j parse_loop
    
invalid_token:
    # 处理无效token (简单地跳过)
    addi $s0, $s0, 1
    j parse_loop
    
end_token:
    # 检查是否读取至少一个字符
    beqz $t5, skip_space
    
    # 检查是否达到8个字符
    li $t6, 8
    bne $t5, $t6, invalid_token
    
end_token_read:
    # Null结束token
    sb $zero, 0($t4)
    
    # 调用hex_to_int转换token
    la $a0, token_buffer
    jal hex_to_int
    move $s2, $v0             # 保存转换后的值
    
    # 存储指令
    la $t6, instructions
    sll $t7, $s1, 2          # t7 = s1 * 4 (每个指令4字节)
    add $t6, $t6, $t7        # t6 = 存储指令的地址
    sw $s2, 0($t6)           # 存储指令
    
    # 增加指令计数
    addi $s1, $s1, 1
    
    # 继续解析
    j skip_space
    
check_more_input:
    # 如果已经读取了一些指令，就结束
    bnez $s1, end_parse
    
    # 否则尝试读取更多输入
    j read_more_input
    
end_parse:
    # 保存指令计数
    sw $s1, instr_count
    
    # 返回成功
    li $v0, 1
    
read_instructions_done:
    # 恢复返回地址并返回
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# 函数: hex_to_int
# 将16进制字符串转换为整数
# 参数:
#   $a0 - 十六进制字符串地址
# 返回值:
#   $v0 - 整数值
hex_to_int:
    li $v0, 0                # 结果
    move $t0, $a0            # 当前字符指针
    
hex_loop:
    lb $t1, 0($t0)           # 加载字符
    beqz $t1, hex_done       # 如果为NULL，结束
    
    # 将结果左移4位
    sll $v0, $v0, 4
    
    # 将字符转换为值
    li $t2, '0'
    blt $t1, $t2, hex_error
    li $t2, '9'
    ble $t1, $t2, hex_digit
    
    li $t2, 'A'
    blt $t1, $t2, hex_error
    li $t2, 'F'
    ble $t1, $t2, hex_upper
    
    j hex_error
    
hex_digit:
    addi $t1, $t1, -48       # '0' = 48
    add $v0, $v0, $t1
    j hex_next
    
hex_upper:
    addi $t1, $t1, -55       # 'A' = 65, 65 - 10 = 55
    add $v0, $v0, $t1
    
hex_next:
    addi $t0, $t0, 1
    j hex_loop
    
hex_error:
    # 出错返回0
    li $v0, 0
    
hex_done:
    jr $ra

# 函数: collect_labels
# 扫描所有指令，为分支和跳转目标生成标签
collect_labels:
    # 保存返回地址
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    
    # 初始化
    lw $s0, START_ADDRESS    # 当前地址
    li $s1, 0                # 指令索引
    
collect_loop:
    # 检查是否已处理所有指令
    lw $t0, instr_count
    beq $s1, $t0, sort_labels
    
    # 获取当前指令
    la $t1, instructions
    sll $t2, $s1, 2          # t2 = s1 * 4
    add $t1, $t1, $t2
    lw $t3, 0($t1)           # t3 = 当前指令
    
    # 提取操作码
    srl $t4, $t3, 26
    andi $t4, $t4, 0x3F      # t4 = opcode
    
    # 检查是否是分支或跳转指令
    li $t5, 0                # 目标地址
    
    # 处理条件分支: beq, bne, blez, bgtz (opcode 4-7)
    li $t6, 4
    blt $t4, $t6, check_j
    li $t6, 8
    bge $t4, $t6, check_j
    
    # 计算分支目标地址: PC + 4 + (imm << 2)
    andi $t6, $t3, 0xFFFF    # 获取immediate字段
    # 检查是否为负数并符号扩展
    andi $t7, $t6, 0x8000
    beqz $t7, branch_pos
    lui $t7, 0xFFFF
    or $t6, $t6, $t7
    
branch_pos:
    sll $t6, $t6, 2          # imm << 2
    addi $t7, $s0, 4         # PC + 4
    add $t5, $t7, $t6        # PC + 4 + (imm << 2)
    j check_target
    
check_j:
    # 检查是否是无条件跳转: j, jal (opcode 2-3)
    li $t6, 2
    beq $t4, $t6, j_type
    li $t6, 3
    beq $t4, $t6, j_type
    
    # 检查是否是特殊分支: REGIMM (opcode 1)
    li $t6, 1
    bne $t4, $t6, next_instruction
    
    # REGIMM指令 - 计算分支地址
    andi $t6, $t3, 0xFFFF    # 获取immediate字段
    # 检查是否为负数并符号扩展
    andi $t7, $t6, 0x8000
    beqz $t7, regimm_pos
    lui $t7, 0xFFFF
    or $t6, $t6, $t7
    
regimm_pos:
    sll $t6, $t6, 2          # imm << 2
    addi $t7, $s0, 4         # PC + 4
    add $t5, $t7, $t6        # PC + 4 + (imm << 2)
    j check_target
    
j_type:
    # J型指令地址计算: ((instr & 0x03FFFFFF) << 2) | ((PC + 4) & high order bits)
    andi $t6, $t3, 0x03FFFFFF  # 获取target字段
    sll $t6, $t6, 2           # target << 2
    addi $t7, $s0, 4          # PC + 4
    li $t8, 0xF0000000
    and $t7, $t7, $t8         # (PC + 4) & 0xF0000000
    or $t5, $t6, $t7          # 组合得到目标地址
    
check_target:
    # 检查目标地址是否为0 (无效目标)
    beqz $t5, next_instruction
    
    # 检查是否已经有这个目标地址的标签
    move $a0, $t5
    jal find_label_name
    bnez $v0, next_instruction  # 如果已存在标签，继续下一条指令
    
    # 添加新标签
    lw $t6, label_count
    lw $t7, MAX_LABELS
    bge $t6, $t7, next_instruction  # 如果标签已满，跳过
    
    # 计算标签结构的地址
    la $t7, labels
    li $t8, 12
    mul $t8, $t6, $t8         # 每个标签12字节 (4地址 + 8名称)
    add $t7, $t7, $t8
    
    # 存储标签地址
    sw $t5, 0($t7)
    
    # 增加标签计数
    addi $t6, $t6, 1
    sw $t6, label_count
    
next_instruction:
    addi $s0, $s0, 4         # 增加地址 (PC + 4)
    addi $s1, $s1, 1         # 增加指令索引
    j collect_loop
    
sort_labels:
    # 实现标签排序 (使用简单的冒泡排序)
    lw $t0, label_count
    beqz $t0, name_labels    # 如果没有标签，跳过排序
    
    # 冒泡排序
    li $t1, 0                # 外循环计数器
    
sort_outer_loop:
    addi $t2, $t0, -1
    bge $t1, $t2, name_labels
    
    li $t2, 0                # 内循环计数器
    
sort_inner_loop:
    addi $t3, $t0, -1
    sub $t3, $t3, $t1        # t3 = (count - 1 - i)
    bge $t2, $t3, sort_outer_next
    
    # 计算当前和下一个标签的地址
    la $t4, labels
    li $t5, 12
    mul $t5, $t2, $t5         # t5 = j * 12
    add $t4, $t4, $t5        # t4 = &labels[j]
    
    addi $t5, $t4, 12        # t5 = &labels[j+1]
    
    # 比较地址
    lw $t6, 0($t4)           # t6 = labels[j].addr
    lw $t7, 0($t5)           # t7 = labels[j+1].addr
    
    ble $t6, $t7, sort_inner_next
    
    # 交换标签
    # 交换地址
    sw $t7, 0($t4)
    sw $t6, 0($t5)
    
    # 交换名称 (每次交换4字节)
    lw $t6, 4($t4)
    lw $t7, 4($t5)
    sw $t7, 4($t4)
    sw $t6, 4($t5)
    
    lw $t6, 8($t4)
    lw $t7, 8($t5)
    sw $t7, 8($t4)
    sw $t6, 8($t5)
    
sort_inner_next:
    addi $t2, $t2, 1         # j++
    j sort_inner_loop
    
sort_outer_next:
    addi $t1, $t1, 1         # i++
    j sort_outer_loop
    
name_labels:
    # 为排序后的标签命名: L001, L002, ...
    lw $t0, label_count
    beqz $t0, collect_done
    
    li $t1, 0                # 标签索引
    
name_loop:
    bge $t1, $t0, collect_done
    
    # 计算当前标签地址
    la $t2, labels
    li $t3, 12
    mul $t3, $t1, $t3         # t3 = i * 12
    add $t2, $t2, $t3        # t2 = &labels[i]
    
    # 格式化标签名称: L%03d
    addi $t3, $t1, 1         # t3 = i + 1
    addi $t4, $t2, 4         # t4 = 标签名称位置
    
    # 格式化名称 "L%03d"
    li $t5, 'L'
    sb $t5, 0($t4)
    
    # 百位数字
    li $t5, '0'
    li $t9, 100
    div $t3, $t9      # $t3 除以 100
    mflo $t6          # 获取商
    add $t5, $t5, $t6
    sb $t5, 1($t4)
    
    # 更新剩余数值
    li $t9, 100
    mul $t6, $t6, $t9  # 百位数 * 100
    sub $t3, $t3, $t6  # 减去百位份分
    
    # 十位数字
    li $t5, '0'
    li $t9, 10
    div $t3, $t9      # $t3 除以 10
    mflo $t6          # 获取商
    add $t5, $t5, $t6
    sb $t5, 2($t4)
    
    # 更新剩余数值
    li $t9, 10
    mul $t6, $t6, $t9  # 十位数 * 10
    sub $t3, $t3, $t6  # 减去十位份分
    
    # 个位数字
    li $t5, '0'
    add $t5, $t5, $t3        # 个位
    sb $t5, 3($t4)
    
    # 结束字符串
    sb $zero, 4($t4)
    
    addi $t1, $t1, 1         # i++
    j name_loop
    
collect_done:
    # 恢复寄存器和返回
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12
    jr $ra

# 函数: find_label_name
# 根据地址查找标签
# 参数:
#   $a0 - 要查找的地址
# 返回值:
#   $v0 - 标签名称地址，或0表示未找到
find_label_name:
    # 遍历标签列表
    lw $t0, label_count
    beqz $t0, label_not_found
    
    li $t1, 0                # 标签索引
    
find_label_loop:
    bge $t1, $t0, label_not_found
    
    # 计算当前标签地址
    la $t2, labels
    li $t3, 12
    mul $t3, $t1, $t3         # t3 = i * 12
    add $t2, $t2, $t3        # t2 = &labels[i]
    
    # 比较地址
    lw $t4, 0($t2)           # t4 = labels[i].addr
    bne $t4, $a0, find_label_next
    
    # 找到标签，返回名称地址
    addi $v0, $t2, 4         # 标签名称在地址后4字节
    jr $ra
    
find_label_next:
    addi $t1, $t1, 1         # i++
    j find_label_loop
    
label_not_found:
    li $v0, 0                # 未找到
    jr $ra

# 函数: disassemble_all
# 先收集标签，然后反汇编并打印所有指令
disassemble_all:
    # 保存返回地址
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    
    # 先收集标签
    jal collect_labels
    
    # 初始化
    lw $s0, START_ADDRESS    # 当前地址
    li $s1, 0                # 指令索引
    lw $s2, instr_count      # 指令总数
    
disassemble_loop:
    # 检查是否已处理所有指令
    beq $s1, $s2, disassemble_done
    
    # 获取当前指令
    la $t0, instructions
    sll $t1, $s1, 2          # t1 = s1 * 4
    add $t0, $t0, $t1
    lw $t0, 0($t0)           # t0 = 当前指令
    
    # 打印地址
    li $v0, 4
    la $a0, addr_label
    syscall
    
     #li $v0, 34               # 以十六进制非0x打印
    #move $a0, $s0
    #syscall
	move $a0, $s0
    jal my_print_hex_no_prefix
	
    
    # 打印机器码
    li $v0, 4
    la $a0, instr_sep
    syscall
    
    #li $v0, 34              
    #move $a0, $t0
    #syscall
	
	move $a0, $t0
    jal my_print_hex_no_prefix   # 以十六进制打印
	
    
    # 打印制表符
    li $v0, 4
    la $a0, tab
    syscall
    
    # 检查该地址是否有标签
    move $a0, $s0
    jal find_label_name
    beqz $v0, no_label_here
    
    # 打印标签
    move $a0, $v0
    li $v0, 4
    syscall
    
    # 打印冒号
    li $v0, 4
    la $a0, colon
    syscall
    
no_label_here:
    # 反汇编当前指令
    la $t0, instructions
    sll $t1, $s1, 2          # t1 = s1 * 4
    add $t0, $t0, $t1
    lw $a0, 0($t0)           # 指令
    move $a1, $s0            # 当前地址
    jal disassemble_instruction
    
    # 打印换行
    li $v0, 4
    la $a0, newline
    syscall
    
    # 移动到下一条指令
    addi $s0, $s0, 4         # 增加地址
    addi $s1, $s1, 1         # 增加索引
    j disassemble_loop
    
disassemble_done:
    # 恢复寄存器和返回
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    addi $sp, $sp, 16
    jr $ra

# 函数: disassemble_instruction
# 反汇编单条指令
# 参数:
#   $a0 - 指令
#   $a1 - 当前地址
disassemble_instruction:
    # 保存返回地址和寄存器
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    
    # 提取指令字段
    move $s0, $a0            # 保存指令
    
    # 提取各个字段
    srl $s1, $s0, 26
    andi $s1, $s1, 0x3F      # s1 = opcode
    
    srl $s2, $s0, 21
    andi $s2, $s2, 0x1F      # s2 = rs
    
    srl $s3, $s0, 16
    andi $s3, $s3, 0x1F      # s3 = rt
    
    srl $s4, $s0, 11
    andi $s4, $s4, 0x1F      # s4 = rd
    
    srl $t5, $s0, 6
    andi $t5, $t5, 0x1F      # t5 = shamt
    
    andi $t6, $s0, 0x3F      # t6 = funct
    
    andi $t7, $s0, 0xFFFF    # t7 = immediate
    
    # 解码指令
    beqz $s1, r_type         # 如果opcode为0，则为R型指令
    
    # J型指令: j, jal
    li $t8, 2
    beq $s1, $t8, j_instr
    li $t8, 3
    beq $s1, $t8, jal_instr
    
    # I型指令
    li $t8, 1
    beq $s1, $t8, regimm_type # REGIMM类型 (rt字段确定具体指令)
    
    # 其他I型指令
    li $t8, 4
    beq $s1, $t8, beq_instr
    li $t8, 5
    beq $s1, $t8, bne_instr
    li $t8, 6
    beq $s1, $t8, blez_instr
    li $t8, 7
    beq $s1, $t8, bgtz_instr
    
    li $t8, 8
    beq $s1, $t8, addi_instr
    li $t8, 9
    beq $s1, $t8, addiu_instr
    li $t8, 10
    beq $s1, $t8, slti_instr
    li $t8, 11
    beq $s1, $t8, sltiu_instr
    
    li $t8, 12
    beq $s1, $t8, andi_instr
    li $t8, 13
    beq $s1, $t8, ori_instr
    li $t8, 14
    beq $s1, $t8, xori_instr
    li $t8, 15
    beq $s1, $t8, lui_instr
    
    li $t8, 32
    beq $s1, $t8, lb_instr
    li $t8, 33
    beq $s1, $t8, lh_instr
    li $t8, 35
    beq $s1, $t8, lw_instr
    li $t8, 36
    beq $s1, $t8, lbu_instr
    li $t8, 37
    beq $s1, $t8, lhu_instr
    
    li $t8, 40
    beq $s1, $t8, sb_instr
    li $t8, 41
    beq $s1, $t8, sh_instr
    li $t8, 43
    beq $s1, $t8, sw_instr
    li $t8, 46
    beq $s1, $t8, swr_instr
    
    # 未知指令
    li $v0, 4
    la $a0, unknown
    syscall
    j disasm_instr_done

# R型指令处理
r_type:
    li $t8, 0
    beq $t6, $t8, sll_instr
    li $t8, 2
    beq $t6, $t8, srl_instr
    li $t8, 3
    beq $t6, $t8, sra_instr
    
    li $t8, 4
    beq $t6, $t8, sllv_instr
    li $t8, 6
    beq $t6, $t8, srlv_instr
    li $t8, 7
    beq $t6, $t8, srav_instr
    
    li $t8, 8
    beq $t6, $t8, jr_instr
    li $t8, 9
    beq $t6, $t8, jalr_instr
    
    li $t8, 12
    beq $t6, $t8, syscall_instr
    
    li $t8, 16
    beq $t6, $t8, mfhi_instr
    li $t8, 17
    beq $t6, $t8, mthi_instr
    li $t8, 18
    beq $t6, $t8, mflo_instr
    li $t8, 19
    beq $t6, $t8, mtlo_instr
    
    li $t8, 24
    beq $t6, $t8, mult_instr
    li $t8, 25
    beq $t6, $t8, multu_instr
    li $t8, 26
    beq $t6, $t8, div_instr
    li $t8, 27
    beq $t6, $t8, divu_instr
    
    li $t8, 32
    beq $t6, $t8, add_instr
    li $t8, 33
    beq $t6, $t8, addu_instr
    li $t8, 34
    beq $t6, $t8, sub_instr
    li $t8, 35
    beq $t6, $t8, subu_instr
    
    li $t8, 36
    beq $t6, $t8, and_instr
    li $t8, 37
    beq $t6, $t8, or_instr
    li $t8, 38
    beq $t6, $t8, xor_instr
    li $t8, 39
    beq $t6, $t8, nor_instr
    
    li $t8, 42
    beq $t6, $t8, slt_instr
    li $t8, 43
    beq $t6, $t8, sltu_instr
    
    # 未知R型指令
    li $v0, 4
    la $a0, unknown
    syscall
    j disasm_instr_done

# REGIMM类型指令处理
regimm_type:
    li $t8, 0
    beq $s3, $t8, bltz_instr
    li $t8, 1
    beq $s3, $t8, bgez_instr
    li $t8, 16
    beq $s3, $t8, bltzal_instr
    li $t8, 17
    beq $s3, $t8, bgezal_instr
    
    # 未知REGIMM指令
    li $v0, 4
    la $a0, unknown
    syscall
    j disasm_instr_done

# 以下是各种指令的处理函数

# 新增的R型指令
mult_instr:
    li $v0, 4
    la $a0, mnem_mult
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

multu_instr:
    li $v0, 4
    la $a0, mnem_multu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

div_instr:
    li $v0, 4
    la $a0, mnem_div
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

divu_instr:
    li $v0, 4
    la $a0, mnem_divu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

mfhi_instr:
    li $v0, 4
    la $a0, mnem_mfhi
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    j disasm_instr_done

mthi_instr:
    li $v0, 4
    la $a0, mnem_mthi
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    j disasm_instr_done

mflo_instr:
    li $v0, 4
    la $a0, mnem_mflo
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    j disasm_instr_done

mtlo_instr:
    li $v0, 4
    la $a0, mnem_mtlo
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    j disasm_instr_done

# R型指令
add_instr:
    li $v0, 4
    la $a0, mnem_add
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

addu_instr:
    li $v0, 4
    la $a0, mnem_addu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

sub_instr:
    li $v0, 4
    la $a0, mnem_sub
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

subu_instr:
    li $v0, 4
    la $a0, mnem_subu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

and_instr:
    li $v0, 4
    la $a0, mnem_and
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

or_instr:
    li $v0, 4
    la $a0, mnem_or
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

xor_instr:
    li $v0, 4
    la $a0, mnem_xor
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

nor_instr:
    li $v0, 4
    la $a0, mnem_nor
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

slt_instr:
    li $v0, 4
    la $a0, mnem_slt
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

sltu_instr:
    li $v0, 4
    la $a0, mnem_sltu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    j disasm_instr_done

sll_instr:
    li $v0, 4
    la $a0, mnem_sll
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # shamt
    li $v0, 1
    move $a0, $t5
    syscall
    
    j disasm_instr_done

srl_instr:
    li $v0, 4
    la $a0, mnem_srl
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # shamt
    li $v0, 1
    move $a0, $t5
    syscall
    
    j disasm_instr_done

sra_instr:
    li $v0, 4
    la $a0, mnem_sra
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # shamt
    li $v0, 1
    move $a0, $t5
    syscall
    
    j disasm_instr_done

sllv_instr:
    li $v0, 4
    la $a0, mnem_sllv
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    j disasm_instr_done

srlv_instr:
    li $v0, 4
    la $a0, mnem_srlv
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    j disasm_instr_done

srav_instr:
    li $v0, 4
    la $a0, mnem_srav
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    j disasm_instr_done

jr_instr:
    li $v0, 4
    la $a0, mnem_jr
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    j disasm_instr_done

jalr_instr:
    li $v0, 4
    la $a0, mnem_jalr
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rd
    move $a0, $s4
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    j disasm_instr_done

syscall_instr:
    li $v0, 4
    la $a0, mnem_syscall
    syscall
    
    j disasm_instr_done

# I型指令
addi_instr:
    li $v0, 4
    la $a0, mnem_addi
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # immediate
    # 检查是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, addi_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
addi_pos:
    li $v0, 1
    move $a0, $t7
    syscall
    
    j disasm_instr_done

addiu_instr:
    li $v0, 4
    la $a0, mnem_addiu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # immediate
    # 检查是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, addiu_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
addiu_pos:
    li $v0, 1
    move $a0, $t7
    syscall
    
    j disasm_instr_done

slti_instr:
    li $v0, 4
    la $a0, mnem_slti
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # immediate
    # 检查是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, slti_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
slti_pos:
    li $v0, 1
    move $a0, $t7
    syscall
    
    j disasm_instr_done

sltiu_instr:
    li $v0, 4
    la $a0, mnem_sltiu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # immediate
    # 检查是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, sltiu_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
sltiu_pos:
    li $v0, 1
    move $a0, $t7
    syscall
    
    j disasm_instr_done

andi_instr:
    li $v0, 4
    la $a0, mnem_andi
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # immediate (无符号)
    li $v0, 1
    move $a0, $t7
    syscall
    
    j disasm_instr_done

ori_instr:
    li $v0, 4
    la $a0, mnem_ori
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # immediate (无符号)
    li $v0, 1
    move $a0, $t7
    syscall
    
    j disasm_instr_done

xori_instr:
    li $v0, 4
    la $a0, mnem_xori
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # immediate (无符号)
    li $v0, 1
    move $a0, $t7
    syscall
    
    j disasm_instr_done

lui_instr:
    li $v0, 4
    la $a0, mnem_lui
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    j disasm_instr_done

# 分支跳转指令
beq_instr:
    li $v0, 4
    la $a0, mnem_beq
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # 计算目标地址
    # imm << 2
    sll $t8, $t7, 2
    
    # 检查immediate是否为负数并符号扩展
    andi $t9, $t7, 0x8000
    beqz $t9, beq_pos
    
    # 负数扩展
    li $t9, 0xFFFC0000  # 0xFFFF0000 << 2
    or $t8, $t8, $t9
    
beq_pos:
    # PC + 4 + offset
    addi $t9, $a1, 4
    add $t8, $t9, $t8
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    

    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall
	
	#增加标签地址
	li $v0, 4
    la $a0, lbracket
    syscall
	
	move $a0, $t8
    jal my_print_hex_no_prefix
	
    li $v0, 4
    la $a0, rbracket
    syscall
	
    
    j disasm_instr_done
    


bne_instr:
    li $v0, 4
    la $a0, mnem_bne
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # 计算目标地址
    # imm << 2
    sll $t8, $t7, 2
    
    # 检查immediate是否为负数并符号扩展
    andi $t9, $t7, 0x8000
    beqz $t9, bne_pos
    
    # 负数扩展
    li $t9, 0xFFFC0000  # 0xFFFF0000 << 2
    or $t8, $t8, $t9
    
bne_pos:
    # PC + 4 + offset
    addi $t9, $a1, 4
    add $t8, $t9, $t8
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall
	
	#增加标签地址
	li $v0, 4
    la $a0, lbracket
    syscall
	
	move $a0, $t8
    jal my_print_hex_no_prefix
	
    li $v0, 4
    la $a0, rbracket
    syscall
	
    j disasm_instr_done

blez_instr:
    li $v0, 4
    la $a0, mnem_blez
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # 计算目标地址
    # imm << 2
    sll $t8, $t7, 2
    
    # 检查immediate是否为负数并符号扩展
    andi $t9, $t7, 0x8000
    beqz $t9, blez_pos
    
    # 负数扩展
    li $t9, 0xFFFC0000  # 0xFFFF0000 << 2
    or $t8, $t8, $t9
    
blez_pos:
    # PC + 4 + offset
    addi $t9, $a1, 4
    add $t8, $t9, $t8
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall
	
	#增加标签地址
	
	li $v0, 4
    la $a0, lbracket
    syscall
	
	move $a0, $t8
    jal my_print_hex_no_prefix
	
    li $v0, 4
    la $a0, rbracket
    syscall
    
    j disasm_instr_done

bgtz_instr:
    li $v0, 4
    la $a0, mnem_bgtz
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # 计算目标地址
    # imm << 2
    sll $t8, $t7, 2
    
    # 检查immediate是否为负数并符号扩展
    andi $t9, $t7, 0x8000
    beqz $t9, bgtz_pos
    
    # 负数扩展
    li $t9, 0xFFFC0000  # 0xFFFF0000 << 2
    or $t8, $t8, $t9
    
bgtz_pos:
    # PC + 4 + offset
    addi $t9, $a1, 4
    add $t8, $t9, $t8
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall
	
	#解决调试发现的问题，增加标签地址
	li $v0, 4
    la $a0, lbracket
    syscall
    
	move $a0, $t8
    jal my_print_hex_no_prefix
	
    li $v0, 4
    la $a0, rbracket
    syscall
    
    j disasm_instr_done

bltz_instr:
    li $v0, 4
    la $a0, mnem_bltz
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # 计算目标地址
    # imm << 2
    sll $t8, $t7, 2
    
    # 检查immediate是否为负数并符号扩展
    andi $t9, $t7, 0x8000
    beqz $t9, bltz_pos
    
    # 负数扩展
    li $t9, 0xFFFC0000  # 0xFFFF0000 << 2
    or $t8, $t8, $t9
    
bltz_pos:
    # PC + 4 + offset
    addi $t9, $a1, 4
    add $t8, $t9, $t8
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall
    
	#解决调试发现的问题，增加标签地址
	li $v0, 4
    la $a0, lbracket
    syscall
    
    # li $v0, 34  # 十六进制打印
    #move $a0, $t8
    #syscall
	
	move $a0, $t8
    jal my_print_hex_no_prefix
	
    li $v0, 4
    la $a0, rbracket
    syscall
	
    j disasm_instr_done

bgez_instr:
    li $v0, 4
    la $a0, mnem_bgez
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # 计算目标地址
    # imm << 2
    sll $t8, $t7, 2
    
    # 检查immediate是否为负数并符号扩展
    andi $t9, $t7, 0x8000
    beqz $t9, bgez_pos
    
    # 负数扩展
    li $t9, 0xFFFC0000  # 0xFFFF0000 << 2
    or $t8, $t8, $t9
    
bgez_pos:
    # PC + 4 + offset
    addi $t9, $a1, 4
    add $t8, $t9, $t8
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall
	
	#解决调试发现的问题，增加标签地址
	li $v0, 4
    la $a0, lbracket
    syscall
    
	move $a0, $t8
    jal my_print_hex_no_prefix
	
    li $v0, 4
    la $a0, rbracket
    syscall
    
    j disasm_instr_done

bltzal_instr:
    li $v0, 4
    la $a0, mnem_bltzal
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # 计算目标地址
    # imm << 2
    sll $t8, $t7, 2
    
    # 检查immediate是否为负数并符号扩展
    andi $t9, $t7, 0x8000
    beqz $t9, bltzal_pos
    
    # 负数扩展
    li $t9, 0xFFFC0000  # 0xFFFF0000 << 2
    or $t8, $t8, $t9
    
bltzal_pos:
    # PC + 4 + offset
    addi $t9, $a1, 4
    add $t8, $t9, $t8
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
	#打印地址
    syscall
	li $v0, 4
    la $a0, lbracket
    syscall
    
    #li $v0, 34  # 十六进制打印
    #move $a0, $t8
    #syscall

	#增加标签地址
	move $a0, $t8
    jal my_print_hex_no_prefix
	
    li $v0, 4
    la $a0, rbracket
    syscall
	
    j disasm_instr_done

bgezal_instr:
    li $v0, 4
    la $a0, mnem_bgezal
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, comma_space
    syscall
    
    # 计算目标地址
    # imm << 2
    sll $t8, $t7, 2
    
    # 检查immediate是否为负数并符号扩展
    andi $t9, $t7, 0x8000
    beqz $t9, bgezal_pos
    
    # 负数扩展
    li $t9, 0xFFFC0000  # 0xFFFF0000 << 2
    or $t8, $t8, $t9
    
bgezal_pos:
    # PC + 4 + offset
    addi $t9, $a1, 4
    add $t8, $t9, $t8
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall
    
    j disasm_instr_done

j_instr:
    li $v0, 4
    la $a0, mnem_j
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # 计算目标地址 (instr_index << 2) | (PC & 0xF0000000)
    andi $t8, $s0, 0x03FFFFFF
    sll $t8, $t8, 2
    
    # (PC & 0xF0000000)
    li $t9, 0xF0000000
    and $t9, $a1, $t9
    
    # 合并地址
    or $t8, $t8, $t9
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall
	
	#增加标签地址
	li $v0, 4
    la $a0, lbracket
    syscall
	
	move $a0, $t8
    jal my_print_hex_no_prefix
	
    li $v0, 4
    la $a0, rbracket
    syscall
	
    
    j disasm_instr_done

jal_instr:
    li $v0, 4
    la $a0, mnem_jal
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # 计算目标地址 (instr_index << 2) | (PC & 0xF0000000)
    andi $t8, $s0, 0x03FFFFFF
    sll $t8, $t8, 2
    
    # (PC & 0xF0000000)
    li $t9, 0xF0000000
    and $t9, $a1, $t9
    
    # 合并地址
    or $t8, $t8, $t9
    
    # 查找目标标签
    move $a0, $t8
    jal find_label_name
    
    
    # 打印标签名
    move $a0, $v0
    li $v0, 4
    syscall

    #增加标签地址
    li $v0, 4
    la $a0, lbracket
    syscall
    
    move $a0, $t8
    jal my_print_hex_no_prefix
    
    li $v0, 4
    la $a0, rbracket
    syscall
    
    j disasm_instr_done
    

# 加载/存储指令
lb_instr:
    li $v0, 4
    la $a0, mnem_lb
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, lb_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
lb_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

lh_instr:
    li $v0, 4
    la $a0, mnem_lh
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, lh_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
lh_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

lw_instr:
    li $v0, 4
    la $a0, mnem_lw
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, lw_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
lw_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

lbu_instr:
    li $v0, 4
    la $a0, mnem_lbu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, lbu_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
lbu_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

lhu_instr:
    li $v0, 4
    la $a0, mnem_lhu
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, lhu_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
lhu_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

sb_instr:
    li $v0, 4
    la $a0, mnem_sb
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, sb_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
sb_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

sh_instr:
    li $v0, 4
    la $a0, mnem_sh
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, sh_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
sh_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

sw_instr:
    li $v0, 4
    la $a0, mnem_sw
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, sw_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
sw_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

swr_instr:
    li $v0, 4
    la $a0, mnem_swr
    syscall
    
    li $v0, 4
    la $a0, space
    syscall
    
    # rt
    move $a0, $s3
    jal print_reg
    
    li $v0, 4
    la $a0, comma
    syscall
    
    # 检查immediate是否为负数
    andi $t8, $t7, 0x8000
    beqz $t8, swr_pos
    
    # 负数，进行符号扩展
    li $t8, 0xFFFF0000
    or $t7, $t7, $t8
    
swr_pos:
    # 打印immediate
    li $v0, 1
    move $a0, $t7
    syscall
    
    li $v0, 4
    la $a0, lparen
    syscall
    
    # rs
    move $a0, $s2
    jal print_reg
    
    li $v0, 4
    la $a0, rparen
    syscall
    
    j disasm_instr_done

disasm_instr_done:
    # 恢复寄存器并返回
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    lw $s2, 12($sp)
    lw $s3, 16($sp)
    lw $s4, 20($sp)
    addi $sp, $sp, 24
    jr $ra

# 函数: print_reg
# 打印寄存器名称
# 参数: $a0 - 寄存器编号 (0-31)
print_reg:
    # 检查寄存器编号是否合法
    li $t0, 0
    blt $a0, $t0, invalid_reg
    li $t0, 31
    bgt $a0, $t0, invalid_reg
    
    # 使用简单的条件分支来获取正确的寄存器名称
    beq $a0, 0, print_reg_0
    beq $a0, 1, print_reg_1
    beq $a0, 2, print_reg_2
    beq $a0, 3, print_reg_3
    beq $a0, 4, print_reg_4
    beq $a0, 5, print_reg_5
    beq $a0, 6, print_reg_6
    beq $a0, 7, print_reg_7
    beq $a0, 8, print_reg_8
    beq $a0, 9, print_reg_9
    beq $a0, 10, print_reg_10
    beq $a0, 11, print_reg_11
    beq $a0, 12, print_reg_12
    beq $a0, 13, print_reg_13
    beq $a0, 14, print_reg_14
    beq $a0, 15, print_reg_15
    beq $a0, 16, print_reg_16
    beq $a0, 17, print_reg_17
    beq $a0, 18, print_reg_18
    beq $a0, 19, print_reg_19
    beq $a0, 20, print_reg_20
    beq $a0, 21, print_reg_21
    beq $a0, 22, print_reg_22
    beq $a0, 23, print_reg_23
    beq $a0, 24, print_reg_24
    beq $a0, 25, print_reg_25
    beq $a0, 26, print_reg_26
    beq $a0, 27, print_reg_27
    beq $a0, 28, print_reg_28
    beq $a0, 29, print_reg_29
    beq $a0, 30, print_reg_30
    beq $a0, 31, print_reg_31
    j invalid_reg
    
print_reg_0:
    la $a0, reg_zero
    j print_reg_done
print_reg_1:
    la $a0, reg_at
    j print_reg_done
print_reg_2:
    la $a0, reg_v0
    j print_reg_done
print_reg_3:
    la $a0, reg_v1
    j print_reg_done
print_reg_4:
    la $a0, reg_a0
    j print_reg_done
print_reg_5:
    la $a0, reg_a1
    j print_reg_done
print_reg_6:
    la $a0, reg_a2
    j print_reg_done
print_reg_7:
    la $a0, reg_a3
    j print_reg_done
print_reg_8:
    la $a0, reg_t0
    j print_reg_done
print_reg_9:
    la $a0, reg_t1
    j print_reg_done
print_reg_10:
    la $a0, reg_t2
    j print_reg_done
print_reg_11:
    la $a0, reg_t3
    j print_reg_done
print_reg_12:
    la $a0, reg_t4
    j print_reg_done
print_reg_13:
    la $a0, reg_t5
    j print_reg_done
print_reg_14:
    la $a0, reg_t6
    j print_reg_done
print_reg_15:
    la $a0, reg_t7
    j print_reg_done
print_reg_16:
    la $a0, reg_s0
    j print_reg_done
print_reg_17:
    la $a0, reg_s1
    j print_reg_done
print_reg_18:
    la $a0, reg_s2
    j print_reg_done
print_reg_19:
    la $a0, reg_s3
    j print_reg_done
print_reg_20:
    la $a0, reg_s4
    j print_reg_done
print_reg_21:
    la $a0, reg_s5
    j print_reg_done
print_reg_22:
    la $a0, reg_s6
    j print_reg_done
print_reg_23:
    la $a0, reg_s7
    j print_reg_done
print_reg_24:
    la $a0, reg_t8
    j print_reg_done
print_reg_25:
    la $a0, reg_t9
    j print_reg_done
print_reg_26:
    la $a0, reg_k0
    j print_reg_done
print_reg_27:
    la $a0, reg_k1
    j print_reg_done
print_reg_28:
    la $a0, reg_gp
    j print_reg_done
print_reg_29:
    la $a0, reg_sp
    j print_reg_done
print_reg_30:
    la $a0, reg_fp
    j print_reg_done
print_reg_31:
    la $a0, reg_ra
    j print_reg_done
    
print_reg_done:
    li $v0, 4
    syscall
    jr $ra
    
invalid_reg:
    la $a0, unknown
    li $v0, 4
    syscall
    jr $ra

my_print_hex_no_prefix:   #函数功能 打印非0x的16进制数
    # 保存返回地址和可能被修改的寄存器
    addi $sp, $sp, -24
    sw $ra, 0($sp)
    sw $t0, 4($sp)
    sw $t1, 8($sp)
    sw $t2, 12($sp)
    sw $t4, 16($sp)
    sw $a0, 20($sp)  # 保存原始参数值
	
    move $t0, $a0        # 传入数值
    la $t1, my_hex_str   # 缓冲区地址
    
    li $t2, 8            # 处理8个字符
    
my_convert_loop:
    # 获取最高4位
    srl $t4, $t0, 28     # 提取高4位
    move $a0, $t4        # 准备转换的数字
    
    jal my_convert_digit # 转换为ASCII
    sb $v0, 0($t1)       # 存储字符
    
    sll $t0, $t0, 4      # 左移4位，准备下一轮
    addi $t1, $t1, 1     # 指针后移
    addi $t2, $t2, -1    # 计数器减1
    bnez $t2, my_convert_loop
    
    # 添加空终止符
    sb $zero, 0($t1)
    
    # 打印结果
    li $v0, 4
    la $a0, my_hex_str
    syscall

    
    # 恢复所有寄存器和返回地址
    lw $ra, 0($sp)
    lw $t0, 4($sp)
    lw $t1, 8($sp)
    lw $t2, 12($sp)
    lw $t4, 16($sp)
    lw $a0, 20($sp)
    addi $sp, $sp, 24
    jr $ra

my_convert_digit:
    # 保存可能被修改的寄存器
    addi $sp, $sp, -8
    sw $t9, 0($sp)
    sw $a0, 4($sp)
    
    slti $t9, $a0, 10
    bnez $t9, my_digit_case
    
    # 字母情况 (A-F)
    addi $v0, $a0, 87    # 'a'(97) - 10 = 87，所以加87可以得到对应的小写字母ASCII
    
    # 恢复寄存器并返回
    lw $t9, 0($sp)
    lw $a0, 4($sp)
    addi $sp, $sp, 8
    jr $ra
    
my_digit_case:
    # 数字情况 (0-9)
    addi $v0, $a0, 48    # '0' = 48
    
    # 恢复寄存器并返回
    lw $t9, 0($sp)
    lw $a0, 4($sp)
    addi $sp, $sp, 8
    jr $ra