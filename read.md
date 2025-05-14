## 交叉编译
Ubuntu 22.04
apt-get update
apt install gcc-mips-linux-gnu qemu-user-static

mips-linux-gnu-gcc -S main1.c -o main1.s
mips-linux-gnu-gcc -no-pie -static -o test1 main1.s -lc
qemu-mips-static test

main1.c  
main1.s
test1

## Mars4.5汇编

main.asm

##  测试集

UnASM