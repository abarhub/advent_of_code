nasm test1.asm -o test1.obj -f win64
link test1.obj kernel32.lib user32.lib /subsystem:console /entry:main