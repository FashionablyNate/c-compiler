.global _start 
.p2align 2

_start: 
        // manage the stack
        sub sp, sp, #64                 // Subtract 64 from the stack pointer to allocate stack space
        stp	x29, x30, [sp, #48]     // Save the frame pointer and return address on the stack
        add	x29, sp, #48            // Set up the new frame pointer
        mov	w0, #0                  // Set the return value of the function to 0
	str	wzr, [sp, #24]          // Clear a space on the stack (zero register to stack)

        // read from stdin
	sub	x1, x29, #18    // Calculate the buffer address
	str	x1, [sp, #8]    // Store buffer address for read operation
	mov	x2, #10         // Set the buffer size
	str	x2, [sp, #16]   // Store buffer size for read operation
	bl	_read           // Call read function

        // write to stdout
	ldr	x1, [sp, #8]    // Reload buffer address
	ldr	x2, [sp, #16]   // Reload buffer size
	mov	w0, #1          // Set file descriptor to STDOUT
	bl	_write          // Call write function

        // return
	mov     X0, #0          // Use 0 return code
        mov     X16, #1         // Service command code 1 terminates this program
        svc     0               // Call MacOS to terminate the program