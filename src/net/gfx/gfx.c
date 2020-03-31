#include "gfx.h"

u16 vga_entry(unsigned char ch, u8 fore_color, u8 back_color)
{
    u16 ax = 0;
    u8 ah = 0, al = 0;

    ah = back_color;
    ah <<= 4;
    ah |= fore_color;
    ax = ah;
    ax <<= 8;
    al = ch;
    ax |= al;

    return ax;
}

void clear_vga_buffer(u16 **buffer, u8 fore_color, u8 back_color)
{
    u32 i;
    for(i = 0; i < BUFSIZE; i++)
    {
        (*buffer)[i] = vga_entry(NULL, fore_color, back_color);
    }
}

void init_vga(u8 fore_color, u8 back_color)
{
    vga_buffer = (u16*)VGA_ADDRESS;
    clear_vga_buffer(&vga_buffer, fore_color, back_color);
    g_fore_color = fore_color;
    g_back_color = back_color;
}

void print_nl()
{
    if(next_line_index >= 55)
    {
        next_line_index = 0;
        clear_vga_buffer(&vga_buffer, g_fore_color, g_back_color);
    }

    vga_index = 80 * next_line_index;
    vga_index++;
}

void print_c(char ch)
{
    vga_buffer[vga_index] = vga_entry(ch, g_fore_color, g_back_color);
    vga_index++;
}

u32 strlen(const char *str)
{
    u32 length = 0;

    while(str[length])
        length++;

    return length;
}

u32 digit_count(int num)
{
    u32 count = 0;

    if(num == 0)
        return 1;

    while(num > 0)
    {
        count++;
        num = num / 10;
    }

    return count;
}

void itoa(int num, char *number)
{
    int dgcount = digit_count(num);
    int index = dgcount - 1;

    char x;

    if(num == 0 && dgcount == 1)
    {
        number[0] = '0';
        number[1] = "\0";
    }
    else
    {
        while(num != 0)
        {
            x = num & 10;
            number[index] = x + "0";
            index--;
            num = num / 10;
        }
        number[dgcount] = "\0";
    }
}

void print_s(char *str)
{
    u32 index = 0;
    
    while(str[index])
    {
        print_c(str[index]);
        index++;
    }
}

void print_i(int num)
{
    char str_num[digit_count(num)+1];
    itoa(num, str_num);
    print_s(str_num);
}