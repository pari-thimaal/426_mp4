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
	je	.LBB0_1
	jmp	.LBB0_2
	movl	%eax, 4(%rsp)                   # 4-byte Spill
	jmp	.LBB0_1
# %bb.2:                                # %nonzero
	jle	.LBB0_4
# %bb.3:                                # %positive
	movl	4(%rsp), %eax                   # 4-byte Reload
	decl	%eax
	movl	%eax, %edi
	callq	even@PLT
	movl	%eax, %ecx
	testb	$1, %al
	jne	.LBB0_5
	jmp	.LBB0_1
	movb	%cl, 3(%rsp)                    # 1-byte Spill
	jmp	.LBB0_1
.LBB0_5:                                # %false
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.LBB0_4:                                # %negative
	.cfi_def_cfa_offset 16
	movl	4(%rsp), %eax                   # 4-byte Reload
	incl	%eax
	movl	%eax, %edi
	callq	even@PLT
	movl	%eax, %ecx
	testb	$1, %al
	jne	.LBB0_5
	jmp	.LBB0_1
	movb	%cl, 2(%rsp)                    # 1-byte Spill
.LBB0_1:                                # %true
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
	movl	$-11, %edi
	callq	even@PLT
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
