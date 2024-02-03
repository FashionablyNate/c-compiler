.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 2
	.globl	_main                           ; -- Begin function main
	.p2align	2

.align 8

_main: 
	sub	sp, sp, #64			// allocate 64 bytes on the stack
	stp	x29, x30, [sp, #48] // store fp and lr in last 16 bytes
	add	x29, sp, #48		// move fp back 16 bytes

	str x0, [sp]			// store argc address on the stack
	str	x1, [sp, #4]		// store argv address on the stack

	ldr	x8, [sp, #4]		// load argv address from the stack into register 8
	ldr	x0, [x8, #8]		// load argv[1] from address into register 1
	bl strlen

	mov x2, x0				// set the length to write to the length of the string
	ldr	x1, [x8, #8]		// load argv[1] from address into register 1
	mov	w0, #1				// File descriptor 1 for stdout
	bl	_write

	mov	w0, #0				// set return value to 0
	ldp	x29, x30, [sp, #48]	// load the fp and lr from the stack
	add	sp, sp, #64			// deallocate 112 bytes from the stack
	ret						// return