; zx0/salvador depacker for PlayStation R5900 converted by Franck 'hitchhikr' Charlet.
; (but should also work for any MIPS32).
; ----------------
; 288 bytes
; ----------------
; this version for naken_asm
; Mainly made for ASM programmers. Would need some work to include in C code.

            .ps2_ee
; $a0 = source
; $a1 = dest
zx0_depacker:
            li          $t1, 0x80
            li          $t2, -1
literals:
            bal         get_elias
            lui         $t6, 0xFFFF
copy_lits:
            lbu         $t3, ($a0)
            addiu       $a0, $a0, 1
            sb          $t3, ($a1)
            addiu       $t0, $t0, -1
            addiu       $a1, $a1, 1             ; this can be moved below to replace the nop
            bgtz        $t0, copy_lits          ; on others mips32 procs to win a couple of bytes
            nop
            add         $t1, $t1, $t1
            andi        $t8, $t1, 0x100
            bne         $t8, $zero, get_offset
            nop
            bal         get_elias
            nop
            addiu       $t0, $t0, -1
copy_match:
            add         $t3, $a1, $t2
            lbu         $t4, ($t3)
            sb          $t4, ($a1)
            addiu       $t0, $t0, -1
            addiu       $a1, $a1, 1             ; this can be moved below to replace the nop
            bgez        $t0, copy_match         ; on others mips32 procs to win a couple of bytes
            nop
            add         $t1, $t1, $t1
            andi        $t8, $t1, 0x100
            beq         $t8, $zero, literals
            nop
get_offset:
            bal         elias_loop
            li          $t0, -2
            addiu       $t0, $t0, 1
            andi        $t8, $t0, 0xFF
            beq         $t8, $zero, done
            sll         $t0, $t0, 8
            andi        $t0, $t0, 0xFFFF
            and         $t2, $t2, $t6
            or          $t2, $t2, $t0
            li          $t0, 1
            lbu         $t3, ($a0)
            addiu       $a0, $a0, 1
            andi        $t3, $t3, 0xFF
            or          $t2, $t2, $t3
            andi        $t8, $t2, 1
            bne         $t8, $zero, copy_match
            sra         $t2, $t2, 1
            bal         elias_bt
            nop
            b           copy_match
            nop
get_elias:
            li          $t0, 1
elias_loop:
            add         $t1, $t1, $t1
            andi        $t8, $t1, 0x100
            srl         $t8, $t8, 8
            andi        $t5, $t1, 0xff
            bne         $t5, $zero, got_bit
            nop
            lbu         $t1, ($a0)
            addiu       $a0, $a0, 1
            add         $t1, $t1, $t1
            addu        $t1, $t1, $t8
            andi        $t8, $t1, 0x100
got_bit:
            bne         $t8, $zero, got_elias
            nop
elias_bt:
            add         $t1, $t1, $t1
            andi        $t8, $t1, 0x100
            srl         $t8, $t8, 8
            add         $t0, $t0, $t0
            b           elias_loop
            addu        $t0, $t0, $t8
got_elias:
            jr          $ra
            nop
done:
