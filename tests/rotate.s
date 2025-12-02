	.text
	.file	"rotate.ll"
	.globl	rotate                          # -- Begin function rotate
	.p2align	4, 0x90
	.type	rotate,@function
rotate:                                 # @rotate
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	movl	%esi, %eax
	movl	%edi, %ecx
	movb	%al, %dl
	movb	%cl, %r8b
	movb	%dl, %r9b
	andb	$7, %r9b
	movl	%ecx, -4(%rsp)                  # 4-byte Spill
	movb	%r9b, %cl
	movb	%r8b, %cl
	movb	%cl, -5(%rsp)                   # 1-byte Spill
	movb	-5(%rsp), %r10b                 # 1-byte Reload
	shrb	%cl, %r10b
	movb	$8, %cl
	movb	%cl, %r11b
	subb	%r9b, %r11b
	movb	%cl, -6(%rsp)                   # 1-byte Spill
	movb	%r11b, %cl
	movb	%r8b, %cl
	movb	%cl, -7(%rsp)                   # 1-byte Spill
	movb	-7(%rsp), %bl                   # 1-byte Reload
	shlb	%cl, %bl
	movb	%bl, %cl
	orb	%r10b, %cl
	movl	%eax, -12(%rsp)                 # 4-byte Spill
	movb	%cl, %al
	popq	%rbx
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
	movb	%al, %cl
	movb	%cl, %al
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.section	".note.GNU-stack","",@progbits
