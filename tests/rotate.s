	.text
	.file	"rotate.ll"
	.globl	rotate                          # -- Begin function rotate
	.p2align	4, 0x90
	.type	rotate,@function
rotate:                                 # @rotate
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r14
	.cfi_def_cfa_offset 24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -32
	.cfi_offset %r14, -24
	.cfi_offset %rbp, -16
	movl	%esi, %eax
	movl	%edi, %ecx
	movb	%al, %dl
	movb	%cl, %r8b
	movb	%dl, %r9b
	andb	$7, %r9b
	movl	%ecx, -4(%rsp)                  # 4-byte Spill
	movb	%r9b, %cl
	movb	%r8b, %r10b
	shrb	%cl, %r10b
	movb	$8, %r11b
	movb	%r11b, %bl
	subb	%r9b, %bl
	movb	%bl, %cl
	movb	%r8b, %bpl
	shlb	%cl, %bpl
	movb	%bpl, %r14b
	orb	%r10b, %r14b
	movl	%eax, -8(%rsp)                  # 4-byte Spill
	movb	%r14b, %al
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
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
	movl	$251, %eax
	movl	$3, %ecx
	movl	%eax, %edi
	movl	%ecx, %esi
	movl	%eax, 4(%rsp)                   # 4-byte Spill
	movl	%ecx, (%rsp)                    # 4-byte Spill
	callq	rotate@PLT
	movb	%al, %dl
	movb	%dl, %al
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
