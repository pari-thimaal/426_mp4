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
	movl	%ecx, %edx
	movl	%eax, %r8d
	cmpl	%r8d, %edx
	movl	%ecx, -4(%rsp)                  # 4-byte Spill
	movl	%edx, -8(%rsp)                  # 4-byte Spill
	movl	%eax, -12(%rsp)                 # 4-byte Spill
	movl	%r8d, -16(%rsp)                 # 4-byte Spill
	jl	.LBB0_2
# %bb.1:                                # %then
	movl	-8(%rsp), %eax                  # 4-byte Reload
	movl	%eax, %ecx
	movl	%ecx, -20(%rsp)                 # 4-byte Spill
	jmp	.LBB0_3
.LBB0_2:                                # %else
	movl	-16(%rsp), %eax                 # 4-byte Reload
	movl	%eax, %ecx
	movl	%ecx, -20(%rsp)                 # 4-byte Spill
	jmp	.LBB0_3
.LBB0_3:                                # %end
	movl	-20(%rsp), %eax                 # 4-byte Reload
	movl	%eax, %ecx
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
	movl	$15, %eax
	movl	$24, %ecx
	movl	%eax, %edi
	movl	%ecx, %esi
	movl	%eax, 4(%rsp)                   # 4-byte Spill
	movl	%ecx, (%rsp)                    # 4-byte Spill
	callq	max@PLT
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
