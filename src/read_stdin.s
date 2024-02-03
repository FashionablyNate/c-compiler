.global strlen

strlen:
    mov x20, #0

loop:
    ldrb w21, [x0, x20]
    cbz w21, done
    add x20, x20, #1
    b loop

done:
    mov x0, x20
	ret
