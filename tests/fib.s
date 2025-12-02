	.text
	.file	"fib.ll"
	.globl	fib                             # -- Begin function fib
	.p2align	4, 0x90
	.type	fib,@function
fib:                                    # @fib
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	movl	%edi, %eax
	movl	%eax, %ecx
	cmpl	$2, %ecx
	movl	%eax, 20(%rsp)                  # 4-byte Spill
	movl	%ecx, 16(%rsp)                  # 4-byte Spill
	jg	.LBB0_2
# %bb.1:                                # %then
	movl	$1, %eax
	movl	%eax, 12(%rsp)                  # 4-byte Spill
	movl	12(%rsp), %ecx                  # 4-byte Reload
	movl	%ecx, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB0_2:                                # %else
	.cfi_def_cfa_offset 32
	movl	16(%rsp), %eax                  # 4-byte Reload
	movl	%eax, %ecx
	subl	$1, %ecx
	movl	%eax, %edx
	subl	$2, %edx
	movl	%ecx, %edi
	movl	%edx, 8(%rsp)                   # 4-byte Spill
	movl	%ecx, 4(%rsp)                   # 4-byte Spill
	callq	fib@PLT
	movl	%eax, %ecx
	movl	8(%rsp), %edx                   # 4-byte Reload
	movl	%edx, %edi
	movl	%ecx, (%rsp)                    # 4-byte Spill
	callq	fib@PLT
	movl	%eax, %ecx
	movl	(%rsp), %edx                    # 4-byte Reload
	movl	%edx, %esi
	addl	%ecx, %esi
	movl	%esi, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	fib, .Lfunc_end0-fib
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	$12, %eax
	movl	%eax, %edi
	movl	%eax, 4(%rsp)                   # 4-byte Spill
	callq	fib@PLT
	movl	%eax, %ecx
	movl	%ecx, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
