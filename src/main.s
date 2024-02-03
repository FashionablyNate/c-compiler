.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 14, 0	sdk_version 14, 2
	.globl	_main                           ; -- Begin function main
	.p2align	2

.align 8

_main: 
	stp		x29, x30, [sp, #-16]!	// allocate 16 bytes, then store fp and lr
	mov		x29, sp					// set fp to sp addr
	sub		sp, sp, #224			// allocate 224 bytes on the stack
	
	mov		x8, x1					// move argv addr to reg 8
	mov		w1, #0					// set oflag to read only
	stur	wzr, [x29, #-12]		// store 4 bytes of zeroes 12 bytes from the bottom of the stack frame
	stur	w0, [x29, #-16]			// store argc 16 bytes from the bottom of the stack frame
	stur	x8, [x29, #-24]			// store argv addr 24 bytes from the bottom of the stack frame
	ldur	x8, [x29, #-24]			// load argv value from it's address
	ldr		x0, [x8, #8]			// load argv[1] into register 0
	bl		_open					// open the file named argv[1]

	stur	w0, [x29, #-28]			// store the file descriptor 28 bytes from stack frame bottom
	sub		x1, x29, #176			// give fstat an address 176 bytes from stack frame bottom
	bl		_fstat					// find out meta data of file named argv[1]

	ldur	x8, [x29, #-80]			// read size of file into reg 8
	stur	x8, [x29, #-184]		// store size of file 184 bytes from stack frame bottom
	mov		x9, sp					// store the sp in reg 9
	stur	x9, [x29, #-192]		// store the sp in the stack frame
	subs	x1, sp, x8				// allocate file length bytes on the stack
	stur	x1, [x29, #-216]        // store buffer address on the stack
	
	ldur	w0, [x29, #-28]			// load file descriptor into reg 0
									// buffer address already in reg 1
	ldur	x2, [x29, #-184]		// load file size into reg 2
	bl		_read					// read the full file into buffer on stack
	
	ldur	x2, [x29, #-184]		// store file size in reg 2
	ldur	x1, [x29, #-216]        // store buffer address in reg 1
	mov		w0, #1					// File descriptor set to STDOUT
	bl		_write					// write full buffer to stdout

	mov		w0, 0					// set return value to 0
	mov		sp, x29					// store fp in sp
	ldp		x29, x30, [sp], #16     // reload fp and lr from memory
	ret