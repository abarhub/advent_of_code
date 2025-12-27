nasm hello.asm -o hello.obj -f win64
link hello.obj kernel32.lib user32.lib /subsystem:console /entry:main

