#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>

// 最大指令数
#define MAX_INSTRUCTIONS 100
// 最大标签数（每条指令最多产生一个目标标签，乘以2以防保守）
#define MAX_LABELS       (MAX_INSTRUCTIONS * 2)
// 程序起始地址（MIPS 默认文本段起始）
#define START_ADDRESS    0x00400000

// 寄存器名称表：根据寄存器号(0~31)映射到对应的 MIPS 汇编名称
const char* reg_names[32] = {
    "$zero","$at","$v0","$v1","$a0","$a1","$a2","$a3",
    "$t0","$t1","$t2","$t3","$t4","$t5","$t6","$t7",
    "$s0","$s1","$s2","$s3","$s4","$s5","$s6","$s7",
    "$t8","$t9","$k0","$k1","$gp","$sp","$fp","$ra"
};

// 存放读取到的机器码指令
uint32_t instructions[MAX_INSTRUCTIONS];
// 实际读取到的指令数量
int instruction_count = 0;

// 标签结构体：addr -- 标签对应的目标地址；name -- 标签名称（如 "L001"）
typedef struct {
    uint32_t addr;      // 目标地址
    char     name[8];   // 标签名称
} Label;

// 存放所有分支/跳转目标标签
Label  labels[MAX_LABELS];
// 实际生成的标签数量
int    label_count = 0;

// 函数声明
int   read_instructions(void);
void  collect_labels(void);
char* find_label_name(uint32_t addr);
void  disassemble_all(void);
char* disassemble_instruction(uint32_t instr, uint32_t addr);
const char* get_reg_name(int reg);
static int cmp_label(const void* a, const void* b);

int main(void) {
    printf("Input MIPS machine code: ");
    // 读取用户输入的机器码列表
    if (!read_instructions()) return 1;
    printf("%d instructions loaded\n", instruction_count);
    // 反汇编并输出所有指令
    disassemble_all();
    printf("please input any key to stop..."); getchar();
    return 0;
}

// 读取并解析用户输入的机器码字符串
int read_instructions(void) {
    char input[1024];
    char *token;
    int len, i;
    // 从标准输入读取一行
    if (!fgets(input, sizeof(input), stdin)) return 0;
    // 去除行尾换行
    input[strcspn(input, "\r\n")] = '\0';
    token = strtok(input, " ");
    while (token && instruction_count < MAX_INSTRUCTIONS) {
        len = strlen(token);
        // 检查长度是否为8个十六进制字符
        if (len != 8) { printf("Invalid length: %s\n", token); return 0; }
        for (i = 0; i < len; i++) {
            // 检查是否为十六进制字符
            if (!isxdigit((unsigned char)token[i])) {
                printf("Invalid hex '%c' in %s\n", token[i], token);
                return 0;
            }
            token[i] = toupper((unsigned char)token[i]); // 转为大写
        }
        // 解析为32位无符号整数并存储
        instructions[instruction_count++] = (uint32_t)strtoul(token, NULL, 16);
        token = strtok(NULL, " ");
    }
    return 1;
}

// qsort 比较函数：按标签地址升序排序
static int cmp_label(const void* a, const void* b) {
    const Label* la = (const Label*)a;
    const Label* lb = (const Label*)b;
    if (la->addr < lb->addr) return -1;
    if (la->addr > lb->addr) return 1;
    return 0;
}

// 收集所有分支/跳转指令的目标地址并生成标签
void collect_labels(void) {
    uint32_t addr = START_ADDRESS;
    int i;
    uint8_t op;
    uint32_t instr, target;
    int16_t imm;

    // 扫描所有指令，计算分支/跳转目标地址
    for (i = 0; i < instruction_count; i++, addr += 4) {
        instr = instructions[i];
        op    = (instr >> 26) & 0x3F; // 取高6位为操作码
        // BEQ/BNE
        if (op == 0x04 || op == 0x05) {
            imm    = instr & 0xFFFF;
            target = addr + 4 + ((int32_t)imm << 2);
        }
        // J / JAL
        else if (op == 0x02 || op == 0x03) {
            target = ((instr & 0x03FFFFFF) << 2)
                   | ((addr + 4) & 0xF0000000);
        }
        // BLTZ/BGEZ/BLTZAL/BGEZAL (op = 0x01)
        else if (op == 0x01) {
            imm    = instr & 0xFFFF;
            target = addr + 4 + ((int32_t)imm << 2);
        }
        // BLEZ/BGTZ
        else if (op == 0x06 || op == 0x07) {
            imm    = instr & 0xFFFF;
            target = addr + 4 + ((int32_t)imm << 2);
        }
        else continue;

        // 如果标签不存在且未超出数组
        if (!find_label_name(target) && label_count < MAX_LABELS) {
            labels[label_count].addr = target;
            label_count++;
        }
    }

    // 对标签按地址排序，并生成名称 L001, L002...
    qsort(labels, label_count, sizeof(Label), cmp_label);
    for (i = 0; i < label_count; i++) {
        sprintf(labels[i].name, "L%03d", i+1);
    }
}

// 查找给定地址对应的标签名，未找到返回 NULL
char* find_label_name(uint32_t addr) {
    int j;
    for (j = 0; j < label_count; j++) {
        if (labels[j].addr == addr) return labels[j].name;
    }
    return NULL;
}

// 对所有指令进行反汇编并输出，包括标签 （左边标签)
void disassemble_all(void) {
    int i;
    uint32_t addr = START_ADDRESS;
    char* lbl;
    char* asm_txt;

    collect_labels(); // 先收集并命名所有标签
    for (i = 0; i < instruction_count; i++, addr += 4) {
        lbl     = find_label_name(addr); // 检查当前地址是否为标签目标
        asm_txt = disassemble_instruction(instructions[i], addr);
        printf("[%08x] %08x\t", addr, instructions[i]);
        if (lbl) printf("%s: ", lbl);
        printf("%s\n", asm_txt);
        free(asm_txt); // 释放动态分配的指令字符串
    }
}

// 反汇编单条指令，返回动态分配的字符串，调用者需 free
char* disassemble_instruction(uint32_t instr, uint32_t addr) {
    char*   res = malloc(128);
    uint8_t op  = (instr >> 26) & 0x3F; //操作码
    uint8_t rs  = (instr >> 21) & 0x1F;  //第一个源操作数
    uint8_t rt  = (instr >> 16) & 0x1F;  //第二个源操作数
    uint8_t rd  = (instr >> 11) & 0x1F;  //目标寄存器（存结果）
    uint8_t sh  = (instr >> 6)  & 0x1F;   //偏移量
    int16_t imm = instr & 0xFFFF;     //立即数
    uint32_t tgt;   //分支/跳转目标地址
    char*    lbl;     //标签
    int funct = instr & 0x3F;      //函数码

    if (op == 0) {
        // R 型指令，根据 funct 字段区分
        switch (funct) {
        case 0x00: sprintf(res, "sll %s,%s,%d",  get_reg_name(rd), get_reg_name(rt), sh); break; // 逻辑左移
        case 0x02: sprintf(res, "srl %s,%s,%d",  get_reg_name(rd), get_reg_name(rt), sh); break; // 逻辑右移
        case 0x03: sprintf(res, "sra %s,%s,%d",  get_reg_name(rd), get_reg_name(rt), sh); break; // 算术右移
        case 0x04: sprintf(res, "sllv %s,%s,%s", get_reg_name(rd), get_reg_name(rt), get_reg_name(rs)); break; //可变逻辑左移
        case 0x06: sprintf(res, "srlv %s,%s,%s", get_reg_name(rd), get_reg_name(rt), get_reg_name(rs)); break;  //可变逻辑右移
        case 0x07: sprintf(res, "srav %s,%s,%s", get_reg_name(rd), get_reg_name(rt), get_reg_name(rs)); break; // 可变算术右移
        case 0x08: sprintf(res, "jr %s",         get_reg_name(rs)); break;              // 寄存器跳转
        case 0x09: sprintf(res, "jalr %s,%s",    get_reg_name(rd), get_reg_name(rs)); break; // 寄存器链接跳转
        case 0x0C: strcpy(res, "syscall"); break;                                       // 系统调用
        case 0x10: sprintf(res, "mfhi %s",       get_reg_name(rd)); break;               // 从 HI 寄存器读取
        case 0x11: sprintf(res, "mthi %s",       get_reg_name(rs)); break;               // 写入 HI 寄存器
        case 0x12: sprintf(res, "mflo %s",       get_reg_name(rd)); break;               // 从 LO 寄存器读取
        case 0x13: sprintf(res, "mtlo %s",       get_reg_name(rs)); break;               // 写入 LO 寄存器
        case 0x18: sprintf(res, "mult %s,%s",    get_reg_name(rs), get_reg_name(rt)); break; // 有符号乘法
        case 0x19: sprintf(res, "multu %s,%s",   get_reg_name(rs), get_reg_name(rt)); break; // 无符号乘法
        case 0x1A: sprintf(res, "div %s,%s",     get_reg_name(rs), get_reg_name(rt)); break; // 有符号除法
        case 0x1B: sprintf(res, "divu %s,%s",    get_reg_name(rs), get_reg_name(rt)); break; // 无符号除法
        case 0x20: sprintf(res, "add %s,%s,%s",  get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break; // 加法
        case 0x22: sprintf(res, "sub %s,%s,%s",  get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break; // 减法
        case 0x21: sprintf(res, "addu %s,%s,%s", get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break; // 无符号加法
        case 0x23: sprintf(res, "subu %s,%s,%s",get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break;  //无符号减法
        case 0x24: sprintf(res, "and %s,%s,%s",  get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break;    // 位与
        case 0x25: sprintf(res, "or %s,%s,%s",   get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break;   // 位或
        case 0x26: sprintf(res, "xor %s,%s,%s",  get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break;  // 位异或
        case 0x27: sprintf(res, "nor %s,%s,%s",  get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break;    // 位或非
        case 0x2A: sprintf(res, "slt %s,%s,%s",  get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break; // 有符号比较
        case 0x2B: sprintf(res, "sltu %s,%s,%s", get_reg_name(rd), get_reg_name(rs), get_reg_name(rt)); break; // 无符号比较
        default:   strcpy(res, "???"); break; // 未知指令
        }
    } else {
        // I/J 型指令，根据 op 区分
        switch (op) {
        case 0x01: // BLTZ/BGEZ/BLTZAL/BGEZAL
            tgt = addr + 4 + ((int32_t)imm << 2);   
            lbl = find_label_name(tgt);  //跳转的目标地址标签
            if      (rt==0)  sprintf(res, "bltz %s,%s[%08x]",  get_reg_name(rs), lbl?lbl:"???", tgt); //小于零时分支
            else if (rt==1)  sprintf(res, "bgez %s,%s[%08x]",  get_reg_name(rs), lbl?lbl:"???", tgt); //大于等于零时分支
            else if (rt==16) sprintf(res, "bltzal %s,%s[%08x]",get_reg_name(rs), lbl?lbl:"???", tgt); // 小于零时分支并链接
            else if (rt==17) sprintf(res, "bgezal %s,%s[%08x]",get_reg_name(rs), lbl?lbl:"???", tgt);  // 大于等于零时分支并链接
            else strcpy(res, "???");
            break;
        case 0x04: case 0x05: case 0x06: case 0x07:
            tgt = addr + 4 + ((int32_t)imm << 2);
            lbl = find_label_name(tgt);
            if (op==0x04) sprintf(res, "beq %s,%s,%s[%08x]", get_reg_name(rs),get_reg_name(rt), lbl?lbl:"???", tgt);  // 等于时分支
            if (op==0x05) sprintf(res, "bne %s,%s,%s[%08x]", get_reg_name(rs),get_reg_name(rt), lbl?lbl:"???", tgt); // 不等于时分支
            if (op==0x06) sprintf(res, "blez %s,%s[%08x]",   get_reg_name(rs), lbl?lbl:"???", tgt); // 小于等于零时分支
            if (op==0x07) sprintf(res, "bgtz %s,%s[%08x]",   get_reg_name(rs), lbl?lbl:"???", tgt);    // 大于零时分支
            break;
        case 0x02: // j       // 跳转
            tgt = ((instr & 0x03FFFFFF)<<2) | ((addr+4)&0xF0000000);
            lbl = find_label_name(tgt);
            sprintf(res, "j %s[%08x]", lbl?lbl:"???", tgt);
            break;
        case 0x03: // jal  // 跳转并链接(跳转到函数的入口地址，同时将返回地址保存到 $ra)
            tgt = ((instr & 0x03FFFFFF)<<2) | ((addr+4)&0xF0000000);
            lbl = find_label_name(tgt);
            sprintf(res, "jal %s[%08x]", lbl?lbl:"???", tgt);
            break;
        case 0x08: sprintf(res, "addi %s,%s,%d",  get_reg_name(rt),get_reg_name(rs), imm); break; // 立即数加法
        case 0x09: sprintf(res, "addiu %s,%s,%d", get_reg_name(rt),get_reg_name(rs), imm); break; // 无符号立即数加
        case 0x0A: sprintf(res, "slti %s,%s,%d",  get_reg_name(rt),get_reg_name(rs), imm); break;// 立即数置位（小于则置位）
        case 0x0B: sprintf(res, "sltiu %s,%s,%d", get_reg_name(rt),get_reg_name(rs), imm); break; // 无符号立即数置位
        case 0x0C: sprintf(res, "andi %s,%s,%d",  get_reg_name(rt),get_reg_name(rs), imm); break; // 按位与立即数
        case 0x0D: sprintf(res, "ori %s,%s,%d",   get_reg_name(rt),get_reg_name(rs), imm); break;// 按位或立即数
        case 0x0E: sprintf(res, "xori %s,%s,%d",  get_reg_name(rt),get_reg_name(rs), imm); break; // 按位异或立即数
        case 0x0F: sprintf(res, "lui %s,%d",      get_reg_name(rt), imm);             break; //  加载上半字
        case 0x20: sprintf(res, "lb %s,%d(%s)",   get_reg_name(rt), imm, get_reg_name(rs)); break; //加载字节
        case 0x21: sprintf(res, "lh %s,%d(%s)",   get_reg_name(rt), imm, get_reg_name(rs)); break;  // 加载半字
        case 0x22: sprintf(res, "lwl %s,%d(%s)",  get_reg_name(rt), imm, get_reg_name(rs)); break; // 加载左对齐字
        case 0x23: sprintf(res, "lw %s,%d(%s)",   get_reg_name(rt), imm, get_reg_name(rs)); break;     // 加载字
        case 0x24: sprintf(res, "lbu %s,%d(%s)",  get_reg_name(rt), imm, get_reg_name(rs)); break; // 加载无符号字节
        case 0x25: sprintf(res, "lhu %s,%d(%s)",  get_reg_name(rt), imm, get_reg_name(rs)); break; // 加载无符号半字
        case 0x26: sprintf(res, "lwr %s,%d(%s)",  get_reg_name(rt), imm, get_reg_name(rs)); break; // 加载右对齐字
        case 0x28: sprintf(res, "sb %s,%d(%s)",   get_reg_name(rt), imm, get_reg_name(rs)); break;   // 存储字节
        case 0x29: sprintf(res, "sh %s,%d(%s)",   get_reg_name(rt), imm, get_reg_name(rs)); break;   // 存储半字
        case 0x2A: sprintf(res, "swl %s,%d(%s)",  get_reg_name(rt), imm, get_reg_name(rs)); break;// 存储左对齐字
        case 0x2B: sprintf(res, "sw %s,%d(%s)",   get_reg_name(rt), imm, get_reg_name(rs)); break;  // 存储字
        case 0x2E: sprintf(res, "swr %s,%d(%s)",  get_reg_name(rt), imm, get_reg_name(rs)); break;    // 存储右对齐字
        default:   strcpy(res, "???"); break; // 未知 I/J 指令
        }
    }
    return res;
}

// 根据寄存器号返回名称，超出范围返回 "???"
const char* get_reg_name(int r) {
    if (r >= 0 && r < 32) return reg_names[r];
    return "???";
}
