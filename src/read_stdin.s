.global read_stdin

read_stdin:
	sub	sp, sp, #32         // allocate 32 bytes on the stack
	stp	x29, x30, [sp, #16] // store the frame pointer and link register values in the first 16 bytes of the stack
	add	x29, sp, #16        // allocate 16 bytes from the stack to the stack frame
	str	x0, [sp, #8]        // store the buffer at an 8 byte offset on the stack
	str	w1, [sp, #4]        // store the length at a 4 byte offset on the stack
	ldr	x1, [sp, #8]        // load the address of the buffer from the stack
	ldrsw x2, [sp, #4]      // load the address of the length from the stack
	mov	w0, #0              // File descriptor set to STDIN
	bl	_read

	ldp	x29, x30, [sp, #16] // load the fp and lr from the stack
	add	sp, sp, #32         // deallocate 32 bytes from the stack
	ret
