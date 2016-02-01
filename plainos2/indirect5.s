	.file	"indirect5.c"
	.text
.globl _main
_main:
	pushl	%ebp
	movl	%esp, %ebp
	andl	$-16, %esp
	subl	$16, %esp
	call	___main
	incl	8(%ebp)
	movl	$66, 12(%ebp)
	movl	$33, %eax
	leave
	ret
