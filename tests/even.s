	.text
	.file	"even.ll"
	.globl	even                            # -- Begin function even
	.p2align	4, 0x90
	.type	even,@function
even:                                   # @even
	.cfi_startproc
# %bb.0:                                # %entry
	subq	$40, %rsp
	.cfi_def_cfa_offset 48
	movl	%edi, %eax
	movl	%eax, %ecx
	cmpl	$0, %ecx
	movl	%eax, 36(%rsp)                  # 4-byte Spill
	movl	%ecx, 32(%rsp)                  # 4-byte Spill
	je	.LBB0_4
# %bb.1:                                # %nonzero
	movl	32(%rsp), %eax                  # 4-byte Reload
	cmpl	$0, %eax
	jle	.LBB0_3
# %bb.2:                                # %positive
	movl	32(%rsp), %eax                  # 4-byte Reload
	movl	%eax, %ecx
	subl	$1, %ecx
	movl	%ecx, %edi
	movl	%ecx, 28(%rsp)                  # 4-byte Spill
	callq	even@PLT
	movb	%al, %dl
	testb	$1, %dl
	movb	%dl, 27(%rsp)                   # 1-byte Spill
	jne	.LBB0_5
	jmp	.LBB0_4
.LBB0_3:                                # %negative
	movl	32(%rsp), %eax                  # 4-byte Reload
	movl	%eax, %ecx
	addl	$1, %ecx
	movl	%ecx, %edi
	movl	%ecx, 20(%rsp)                  # 4-byte Spill
	callq	even@PLT
	movb	%al, %dl
	testb	$1, %dl
	movb	%dl, 19(%rsp)                   # 1-byte Spill
	jne	.LBB0_5
.LBB0_4:                                # %true
	movb	$1, %al
	movb	%al, 18(%rsp)                   # 1-byte Spill
	movb	18(%rsp), %cl                   # 1-byte Reload
	movb	%cl, %al
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.LBB0_5:                                # %false
	.cfi_def_cfa_offset 48
	xorl	%eax, %eax
	movb	%al, %cl
	movl	%eax, 12(%rsp)                  # 4-byte Spill
	movb	%cl, %al
	addq	$40, %rsp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	even, .Lfunc_end0-even
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
	movl	$-10, %eax
	movl	%eax, %edi
	movl	%eax, 4(%rsp)                   # 4-byte Spill
	callq	even@PLT
	movb	%al, %cl
	movb	%cl, %dl
	movb	%cl, %al
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
