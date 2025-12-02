	.text
	.file	"max.ll"
	.globl	max                             # -- Begin function max
	.p2align	4, 0x90
	.type	max,@function
max:                                    # @max
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%esi, %eax
	movl	%edi, %ecx
	cmpl	%esi, %edi
	jge	".LBB0_-1"
	jmp	".LBB0_-10"
	movl	%eax, -4(%rsp)                  # 4-byte Spill
	movl	%ecx, -8(%rsp)                  # 4-byte Spill
	movl	-8(%rsp), %ecx                  # 4-byte Reload
	movl	%ecx, %eax
	retq
.Lfunc_end0:
	.size	max, .Lfunc_end0-max
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
	movl	$15, %edi
	movl	$24, %esi
	callq	max@PLT
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
