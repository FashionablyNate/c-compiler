.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 2
	.globl	_main                           ; -- Begin function main
	.p2align	2

.align 8

_main: 
	sub	sp, sp, #112		// allocate 112 bytes on the stack
	stp	x29, x30, [sp, #96] // store the fp and lr in the first 16 bytes
	add	x29, sp, #96		// move the fp passed where we stored the fp and lr
	str	wzr, [sp, #20]		// store 4 bytes of zero on the stack at an offset of 20 bytes

	add	x0, sp, #24			// record the address of the 24th byte of the stack in register 0
	str	x0, [sp, #8]        // store that address on the stack at byte 8
	mov	w1, #64				// store 64 in register 1
	bl	read_stdin

	ldr	x1, [sp, #8]        // load the address of the buffer into register 1
	mov	x8, x0				// move the return of read_stdin into register 8
	sxtw	x2, w8			// extendthe first 4 bytes of register 8 and store it in register 2
	mov	w0, #1				// File descriptor 1 for stdout
	bl	_write

	mov	w0, #0				// set return value to 0
	ldp	x29, x30, [sp, #96]	// load the fp and lr from the stack
	add	sp, sp, #112		// deallocate 112 bytes from the stack
	ret						// return