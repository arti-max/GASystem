
void print_str(const char *str) {
    while (*str) {
        __asm {
            mov ah, 0x0e
            mov al, [str]
            xor bh, bh
            int 0x10
        };
        str++
    }
}


void main() {
    print("Hello From Kernel!");
}