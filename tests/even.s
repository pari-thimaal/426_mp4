	.text
	.file	"even.ll"
	.globl	even                            # -- Begin function even
	.p2align	4, 0x90
	.type	even,@function
even:                                   # @even
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rax
	.cfi_def_cfa_offset 16
	movl	%edi, %eax
	testl	%edi, %edi
	movl	%eax, (%rsp)                    # 4-byte Spill
	je	.LBB0_5
# %bb.1:                                # %nonzero
	jle	.LBB0_4
# %bb.2:                                # %positive
	movl	(%rsp), %eax                    # 4-byte Reload
	decl	%eax
	movl	%eax, %edi
	movl	%eax, (%rsp)                    # 4-byte Spill
	callq	even@PLT
	movl	%eax, %ecx
	testb	$1, %al
	movb	%cl, 7(%rsp)                    # 1-byte Spill
	je	.LBB0_5
.LBB0_3:                                # %false
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.LBB0_4:                                # %negative
	.cfi_def_cfa_offset 16
	movl	(%rsp), %eax                    # 4-byte Reload
	incl	%eax
	movl	%eax, %edi
	movl	%eax, (%rsp)                    # 4-byte Spill
	callq	even@PLT
	movl	%eax, %ecx
	testb	$1, %al
	movb	%cl, 6(%rsp)                    # 1-byte Spill
	jne	.LBB0_3
.LBB0_5:                                # %true
	movb	$1, %al
	popq	%rcx
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
	movl	$-10, %edi
	callq	even@PLT
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
