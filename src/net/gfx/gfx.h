#include "../utils/types.h"

#define VGA_ADDRESS 0xB8000
#define BUFSIZE 2200

u16* vga_buffer;

uint32 vga_index;
static uint32 next_line_index = 1;
uint8 g_fore_color = WHITE, g_back_color = BLUE;
int digit_ascii_codes[10] = {0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39};

//Basic functions
u16 vga_entry(unsigned char ch, u8 fore_color, u8 back_color);
void clear_vga_buffer(u16 **buffer, u8 fore_color, u8 back_color);
void init_vga(u8 fore_color, u8 back_color);
void print_nl();
void print_c(char ch);
u32 strlen(const char *str);
u32 digit_count(int num);
void itoa(int num, char *number);
void print_s(char *str);
void print_i(int num);