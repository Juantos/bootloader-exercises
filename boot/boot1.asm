bits 16             ; 16 bit code
org 0x7c00          ; BIOS bootloader standard address. org means origin, "start the program in this address"

boot:
    mov si, hello   ; si register is commonly used as a pointer to string data
    mov ah, 0x0e    ; ah is the 8-bit high register from ax. Works as a function selector for BIOS video services interrupts.
                    ; tells the BIOS to show this as teletype (tty)

.loop:
    lodsb           ; load byte from [si] into al, that is, a letter, and increments si pointer to latter load the next letter.
    or al, al       ; more efficient than cmp al, 0
    jz halt         ; if alt == 0, it's the null terminator and the loop shall end
    int 0x10        ; runs bios interrupt 0x10 for video services, looks at ah for function
    jmp .loop

halt:
    cli             ; clears interrupt flag
    hlt             ; enters halt state

; creates a label for a memory location and tells it to store the string at that location.
; ,0 is a null terminator, tells the loop where to stop.
hello: db "Hello world! This is Juantos first bootloader",0

times 510 - ($-$$) db 0 ; pads memory with zeros until 510 bytes have been written. $$ is org address, $ is current.
dw 0xaa55 ; marks 512bytes sector as bootable. words are 2bytes, so 510+2 = 512