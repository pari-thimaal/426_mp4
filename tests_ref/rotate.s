	.text
	.file	"rotate.ll"
	.globl	rotate                          # -- Begin function rotate
	.p2align	4, 0x90
	.type	rotate,@function
rotate:                                 # @rotate
	.cfi_startproc
# %bb.0:                                # %entry
	movl	%esi, %eax
	movl	%edi, %ecx
	movl	%ecx, -8(%rsp)                  # 4-byte Spill
	movl	%eax, %ecx
	movl	-8(%rsp), %edx                  # 4-byte Reload
	rorb	%cl, %dl
	movl	%eax, -4(%rsp)                  # 4-byte Spill
	movl	%edx, %eax
	retq
.Lfunc_end0:
	.size	rotate, .Lfunc_end0-rotate
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
	movl	$251, %edi
	movl	$3, %esi
	callq	rotate@PLT
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
