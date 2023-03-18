| MIT License - Copyright (c) 2019 Stephane Dallongeville
| 
| Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
| to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
| and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
| 
| The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
| 
| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
| DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
| OR OTHER DEALINGS IN THE SOFTWARE.

.global lz4w_unpack

.macro  LZ4W_NEXT
    moveq  #0, d1
    moveq  #0, d0
    move.b  (a0)+, d0          
    move.b  (a0)+, d1

    add.w  d0, d0
    add.w  d0, d0
    move.l  (a3,d0.w), a4
    jmp  (a4)
  .endm


lz4w_unpack:
    move.l  4(%sp),%a0              
    move.l  8(%sp),%a1              

lz4w_unpack_a:
    movem.l  a2-a4, -(sp)

    lea  .jump_table(pc), a3       

.next:
    LZ4W_NEXT

.jump_table:
  .long  .lit0_mat0, .lit0_mat1, .lit0_mat2, .lit0_mat3, .lit0_mat4, .lit0_mat5, .lit0_mat6, .lit0_mat7, .lit0_mat8, .lit0_mat9, .lit0_matA, .lit0_matB, .lit0_matC, .lit0_matD, .lit0_matE, .lit0_matF
  .long  .lit1_mat0, .lit1_mat1, .lit1_mat2, .lit1_mat3, .lit1_mat4, .lit1_mat5, .lit1_mat6, .lit1_mat7, .lit1_mat8, .lit1_mat9, .lit1_matA, .lit1_matB, .lit1_matC, .lit1_matD, .lit1_matE, .lit1_matF
  .long  .lit2_mat0, .lit2_mat1, .lit2_mat2, .lit2_mat3, .lit2_mat4, .lit2_mat5, .lit2_mat6, .lit2_mat7, .lit2_mat8, .lit2_mat9, .lit2_matA, .lit2_matB, .lit2_matC, .lit2_matD, .lit2_matE, .lit2_matF
  .long  .lit3_mat0, .lit3_mat1, .lit3_mat2, .lit3_mat3, .lit3_mat4, .lit3_mat5, .lit3_mat6, .lit3_mat7, .lit3_mat8, .lit3_mat9, .lit3_matA, .lit3_matB, .lit3_matC, .lit3_matD, .lit3_matE, .lit3_matF
  .long  .lit4_mat0, .lit4_mat1, .lit4_mat2, .lit4_mat3, .lit4_mat4, .lit4_mat5, .lit4_mat6, .lit4_mat7, .lit4_mat8, .lit4_mat9, .lit4_matA, .lit4_matB, .lit4_matC, .lit4_matD, .lit4_matE, .lit4_matF
  .long  .lit5_mat0, .lit5_mat1, .lit5_mat2, .lit5_mat3, .lit5_mat4, .lit5_mat5, .lit5_mat6, .lit5_mat7, .lit5_mat8, .lit5_mat9, .lit5_matA, .lit5_matB, .lit5_matC, .lit5_matD, .lit5_matE, .lit5_matF
  .long  .lit6_mat0, .lit6_mat1, .lit6_mat2, .lit6_mat3, .lit6_mat4, .lit6_mat5, .lit6_mat6, .lit6_mat7, .lit6_mat8, .lit6_mat9, .lit6_matA, .lit6_matB, .lit6_matC, .lit6_matD, .lit6_matE, .lit6_matF
  .long  .lit7_mat0, .lit7_mat1, .lit7_mat2, .lit7_mat3, .lit7_mat4, .lit7_mat5, .lit7_mat6, .lit7_mat7, .lit7_mat8, .lit7_mat9, .lit7_matA, .lit7_matB, .lit7_matC, .lit7_matD, .lit7_matE, .lit7_matF
  .long  .lit8_mat0, .lit8_mat1, .lit8_mat2, .lit8_mat3, .lit8_mat4, .lit8_mat5, .lit8_mat6, .lit8_mat7, .lit8_mat8, .lit8_mat9, .lit8_matA, .lit8_matB, .lit8_matC, .lit8_matD, .lit8_matE, .lit8_matF
  .long  .lit9_mat0, .lit9_mat1, .lit9_mat2, .lit9_mat3, .lit9_mat4, .lit9_mat5, .lit9_mat6, .lit9_mat7, .lit9_mat8, .lit9_mat9, .lit9_matA, .lit9_matB, .lit9_matC, .lit9_matD, .lit9_matE, .lit9_matF
  .long  .litA_mat0, .litA_mat1, .litA_mat2, .litA_mat3, .litA_mat4, .litA_mat5, .litA_mat6, .litA_mat7, .litA_mat8, .litA_mat9, .litA_matA, .litA_matB, .litA_matC, .litA_matD, .litA_matE, .litA_matF
  .long  .litB_mat0, .litB_mat1, .litB_mat2, .litB_mat3, .litB_mat4, .litB_mat5, .litB_mat6, .litB_mat7, .litB_mat8, .litB_mat9, .litB_matA, .litB_matB, .litB_matC, .litB_matD, .litB_matE, .litB_matF
  .long  .litC_mat0, .litC_mat1, .litC_mat2, .litC_mat3, .litC_mat4, .litC_mat5, .litC_mat6, .litC_mat7, .litC_mat8, .litC_mat9, .litC_matA, .litC_matB, .litC_matC, .litC_matD, .litC_matE, .litC_matF
  .long  .litD_mat0, .litD_mat1, .litD_mat2, .litD_mat3, .litD_mat4, .litD_mat5, .litD_mat6, .litD_mat7, .litD_mat8, .litD_mat9, .litD_matA, .litD_matB, .litD_matC, .litD_matD, .litD_matE, .litD_matF
  .long  .litE_mat0, .litE_mat1, .litE_mat2, .litE_mat3, .litE_mat4, .litE_mat5, .litE_mat6, .litE_mat7, .litE_mat8, .litE_mat9, .litE_matA, .litE_matB, .litE_matC, .litE_matD, .litE_matE, .litE_matF
  .long  .litF_mat0, .litF_mat1, .litF_mat2, .litF_mat3, .litF_mat4, .litF_mat5, .litF_mat6, .litF_mat7, .litF_mat8, .litF_mat9, .litF_matA, .litF_matB, .litF_matC, .litF_matD, .litF_matE, .litF_matF


  .rept  127
    move.l  (a2)+, (a1)+
  .endr
.lmr_len_01:
    move.l  (a2)+, (a1)+
    move.w  (a2)+, (a1)+
    LZ4W_NEXT

  .rept  127
    move.l  (a2)+, (a1)+
  .endr
.lmr_len_00:
    move.l  (a2)+, (a1)+
    LZ4W_NEXT

  .rept  255
    move.w  (a2)+, (a1)+
  .endr
.lm_len_00:
    move.w  (a2)+, (a1)+
    move.w  (a2)+, (a1)+
    LZ4W_NEXT

.litE_mat0:  move.l  (a0)+, (a1)+
.litC_mat0:  move.l  (a0)+, (a1)+
.litA_mat0:  move.l  (a0)+, (a1)+
.lit8_mat0:  move.l  (a0)+, (a1)+
.lit6_mat0:  move.l  (a0)+, (a1)+
.lit4_mat0:  move.l  (a0)+, (a1)+
.lit2_mat0:  move.l  (a0)+, (a1)+
    tst.b  d1                       | match offset null ?
    beq  .next                      | not a long match

.long_match_1:
    move.w  (a0)+, d0               | get long offset (already negated)

    add.w  d1, d1                   | len = len * 2

    add.w  d0, d0                   | bit 15 contains ROM source info
    bcs.s  .lm_rom

    lea  -2(a1,d0.w), a2            | a2 = dst - (match offset + 2)
    neg.w  d1
    lea  .lm_len_00(pc,d1.w), a4
    jmp  (a4)

.litF_mat0:  move.l  (a0)+, (a1)+
.litD_mat0:  move.l  (a0)+, (a1)+
.litB_mat0:  move.l  (a0)+, (a1)+
.lit9_mat0:  move.l  (a0)+, (a1)+
.lit7_mat0:  move.l  (a0)+, (a1)+
.lit5_mat0:  move.l  (a0)+, (a1)+
.lit3_mat0:  move.l  (a0)+, (a1)+
.lit1_mat0:  move.w  (a0)+, (a1)+

    tst.b  d1                       | match offset null ?
    beq  .next                      | not a long match

.long_match_2:
    move.w  (a0)+, d0               | get long offset (already negated)

    add.w  d1, d1                   | len = len * 2

    add.w  d0, d0                   | bit 15 contains ROM source info
    bcs.s  .lm_rom

    lea  -2(a1,d0.w), a2            | a2 = dst - (match offset + 2)
    neg.w  d1
    lea  .lm_len_00(pc,d1.w), a4
    jmp  (a4)

.lit0_mat0:                         | special case of lit=0 and mat=0
    tst.b  d1                       | match offset null ?
    beq  .done                      | not a long match --> done

.long_match_3:
    move.w  (a0)+, d0               | get long offset (already negated)

    add.w  d1, d1                   | len = len * 2

    add.w  d0, d0                   | bit 15 contains ROM source info
    bcs.s  .lm_rom

    lea  -2(a1,d0.w), a2            | a2 = dst - (match offset + 2)
    neg.w  d1
    lea  .lm_len_00(pc,d1.w), a4
    jmp  (a4)

.lm_rom:
    add.w  d1, d1                   | len = len * 4
    lea  -2(a0,d0.w), a2            | a2 = src - (match offset + 2)
    move.l  .lmr_jump_table(pc,d1.w), a4
    jmp     (a4)

.lmr_jump_table:
  .long  .lmr_len_00-0x00, .lmr_len_01-0x00, .lmr_len_00-0x02, .lmr_len_01-0x02, .lmr_len_00-0x04, .lmr_len_01-0x04, .lmr_len_00-0x06, .lmr_len_01-0x06, .lmr_len_00-0x08, .lmr_len_01-0x08, .lmr_len_00-0x0a, .lmr_len_01-0x0a, .lmr_len_00-0x0c, .lmr_len_01-0x0c, .lmr_len_00-0x0e, .lmr_len_01-0x0e
  .long  .lmr_len_00-0x10, .lmr_len_01-0x10, .lmr_len_00-0x12, .lmr_len_01-0x12, .lmr_len_00-0x14, .lmr_len_01-0x14, .lmr_len_00-0x16, .lmr_len_01-0x16, .lmr_len_00-0x18, .lmr_len_01-0x18, .lmr_len_00-0x1a, .lmr_len_01-0x1a, .lmr_len_00-0x1c, .lmr_len_01-0x1c, .lmr_len_00-0x1e, .lmr_len_01-0x1e
  .long  .lmr_len_00-0x20, .lmr_len_01-0x20, .lmr_len_00-0x22, .lmr_len_01-0x22, .lmr_len_00-0x24, .lmr_len_01-0x24, .lmr_len_00-0x26, .lmr_len_01-0x26, .lmr_len_00-0x28, .lmr_len_01-0x28, .lmr_len_00-0x2a, .lmr_len_01-0x2a, .lmr_len_00-0x2c, .lmr_len_01-0x2c, .lmr_len_00-0x2e, .lmr_len_01-0x2e
  .long  .lmr_len_00-0x30, .lmr_len_01-0x30, .lmr_len_00-0x32, .lmr_len_01-0x32, .lmr_len_00-0x34, .lmr_len_01-0x34, .lmr_len_00-0x36, .lmr_len_01-0x36, .lmr_len_00-0x38, .lmr_len_01-0x38, .lmr_len_00-0x3a, .lmr_len_01-0x3a, .lmr_len_00-0x3c, .lmr_len_01-0x3c, .lmr_len_00-0x3e, .lmr_len_01-0x3e
  .long  .lmr_len_00-0x40, .lmr_len_01-0x40, .lmr_len_00-0x42, .lmr_len_01-0x42, .lmr_len_00-0x44, .lmr_len_01-0x44, .lmr_len_00-0x46, .lmr_len_01-0x46, .lmr_len_00-0x48, .lmr_len_01-0x48, .lmr_len_00-0x4a, .lmr_len_01-0x4a, .lmr_len_00-0x4c, .lmr_len_01-0x4c, .lmr_len_00-0x4e, .lmr_len_01-0x4e
  .long  .lmr_len_00-0x50, .lmr_len_01-0x50, .lmr_len_00-0x52, .lmr_len_01-0x52, .lmr_len_00-0x54, .lmr_len_01-0x54, .lmr_len_00-0x56, .lmr_len_01-0x56, .lmr_len_00-0x58, .lmr_len_01-0x58, .lmr_len_00-0x5a, .lmr_len_01-0x5a, .lmr_len_00-0x5c, .lmr_len_01-0x5c, .lmr_len_00-0x5e, .lmr_len_01-0x5e
  .long  .lmr_len_00-0x60, .lmr_len_01-0x60, .lmr_len_00-0x62, .lmr_len_01-0x62, .lmr_len_00-0x64, .lmr_len_01-0x64, .lmr_len_00-0x66, .lmr_len_01-0x66, .lmr_len_00-0x68, .lmr_len_01-0x68, .lmr_len_00-0x6a, .lmr_len_01-0x6a, .lmr_len_00-0x6c, .lmr_len_01-0x6c, .lmr_len_00-0x6e, .lmr_len_01-0x6e
  .long  .lmr_len_00-0x70, .lmr_len_01-0x70, .lmr_len_00-0x72, .lmr_len_01-0x72, .lmr_len_00-0x74, .lmr_len_01-0x74, .lmr_len_00-0x76, .lmr_len_01-0x76, .lmr_len_00-0x78, .lmr_len_01-0x78, .lmr_len_00-0x7a, .lmr_len_01-0x7a, .lmr_len_00-0x7c, .lmr_len_01-0x7c, .lmr_len_00-0x7e, .lmr_len_01-0x7e
  .long  .lmr_len_00-0x80, .lmr_len_01-0x80, .lmr_len_00-0x82, .lmr_len_01-0x82, .lmr_len_00-0x84, .lmr_len_01-0x84, .lmr_len_00-0x86, .lmr_len_01-0x86, .lmr_len_00-0x88, .lmr_len_01-0x88, .lmr_len_00-0x8a, .lmr_len_01-0x8a, .lmr_len_00-0x8c, .lmr_len_01-0x8c, .lmr_len_00-0x8e, .lmr_len_01-0x8e
  .long  .lmr_len_00-0x90, .lmr_len_01-0x90, .lmr_len_00-0x92, .lmr_len_01-0x92, .lmr_len_00-0x94, .lmr_len_01-0x94, .lmr_len_00-0x96, .lmr_len_01-0x96, .lmr_len_00-0x98, .lmr_len_01-0x98, .lmr_len_00-0x9a, .lmr_len_01-0x9a, .lmr_len_00-0x9c, .lmr_len_01-0x9c, .lmr_len_00-0x9e, .lmr_len_01-0x9e
  .long  .lmr_len_00-0xa0, .lmr_len_01-0xa0, .lmr_len_00-0xa2, .lmr_len_01-0xa2, .lmr_len_00-0xa4, .lmr_len_01-0xa4, .lmr_len_00-0xa6, .lmr_len_01-0xa6, .lmr_len_00-0xa8, .lmr_len_01-0xa8, .lmr_len_00-0xaa, .lmr_len_01-0xaa, .lmr_len_00-0xac, .lmr_len_01-0xac, .lmr_len_00-0xae, .lmr_len_01-0xae
  .long  .lmr_len_00-0xb0, .lmr_len_01-0xb0, .lmr_len_00-0xb2, .lmr_len_01-0xb2, .lmr_len_00-0xb4, .lmr_len_01-0xb4, .lmr_len_00-0xb6, .lmr_len_01-0xb6, .lmr_len_00-0xb8, .lmr_len_01-0xb8, .lmr_len_00-0xba, .lmr_len_01-0xba, .lmr_len_00-0xbc, .lmr_len_01-0xbc, .lmr_len_00-0xbe, .lmr_len_01-0xbe
  .long  .lmr_len_00-0xc0, .lmr_len_01-0xc0, .lmr_len_00-0xc2, .lmr_len_01-0xc2, .lmr_len_00-0xc4, .lmr_len_01-0xc4, .lmr_len_00-0xc6, .lmr_len_01-0xc6, .lmr_len_00-0xc8, .lmr_len_01-0xc8, .lmr_len_00-0xca, .lmr_len_01-0xca, .lmr_len_00-0xcc, .lmr_len_01-0xcc, .lmr_len_00-0xce, .lmr_len_01-0xce
  .long  .lmr_len_00-0xd0, .lmr_len_01-0xd0, .lmr_len_00-0xd2, .lmr_len_01-0xd2, .lmr_len_00-0xd4, .lmr_len_01-0xd4, .lmr_len_00-0xd6, .lmr_len_01-0xd6, .lmr_len_00-0xd8, .lmr_len_01-0xd8, .lmr_len_00-0xda, .lmr_len_01-0xda, .lmr_len_00-0xdc, .lmr_len_01-0xdc, .lmr_len_00-0xde, .lmr_len_01-0xde
  .long  .lmr_len_00-0xe0, .lmr_len_01-0xe0, .lmr_len_00-0xe2, .lmr_len_01-0xe2, .lmr_len_00-0xe4, .lmr_len_01-0xe4, .lmr_len_00-0xe6, .lmr_len_01-0xe6, .lmr_len_00-0xe8, .lmr_len_01-0xe8, .lmr_len_00-0xea, .lmr_len_01-0xea, .lmr_len_00-0xec, .lmr_len_01-0xec, .lmr_len_00-0xee, .lmr_len_01-0xee
  .long  .lmr_len_00-0xf0, .lmr_len_01-0xf0, .lmr_len_00-0xf2, .lmr_len_01-0xf2, .lmr_len_00-0xf4, .lmr_len_01-0xf4, .lmr_len_00-0xf6, .lmr_len_01-0xf6, .lmr_len_00-0xf8, .lmr_len_01-0xf8, .lmr_len_00-0xfa, .lmr_len_01-0xfa, .lmr_len_00-0xfc, .lmr_len_01-0xfc, .lmr_len_00-0xfe, .lmr_len_01-0xfe


  .macro  COPY_MATCH  count
    add.w  d1, d1
    neg.w  d1
    lea  -2(a1,d1.w), a2            | a2 = dst - ((match offset + 1) * 2)

  .rept  ((\count)+1)
    move.w  (a2)+, (a1)+
  .endr
    LZ4W_NEXT
  .endm

.litE_mat1:  move.l  (a0)+, (a1)+
.litC_mat1:  move.l  (a0)+, (a1)+
.litA_mat1:  move.l  (a0)+, (a1)+
.lit8_mat1:  move.l  (a0)+, (a1)+
.lit6_mat1:  move.l  (a0)+, (a1)+
.lit4_mat1:  move.l  (a0)+, (a1)+
.lit2_mat1:  move.l  (a0)+, (a1)+
.lit0_mat1:
    COPY_MATCH 1

.litF_mat1:  move.l  (a0)+, (a1)+
.litD_mat1:  move.l  (a0)+, (a1)+
.litB_mat1:  move.l  (a0)+, (a1)+
.lit9_mat1:  move.l  (a0)+, (a1)+
.lit7_mat1:  move.l  (a0)+, (a1)+
.lit5_mat1:  move.l  (a0)+, (a1)+
.lit3_mat1:  move.l  (a0)+, (a1)+
.lit1_mat1:  move.w  (a0)+, (a1)+
    COPY_MATCH 1

.litE_mat2:  move.l  (a0)+, (a1)+
.litC_mat2:  move.l  (a0)+, (a1)+
.litA_mat2:  move.l  (a0)+, (a1)+
.lit8_mat2:  move.l  (a0)+, (a1)+
.lit6_mat2:  move.l  (a0)+, (a1)+
.lit4_mat2:  move.l  (a0)+, (a1)+
.lit2_mat2:  move.l  (a0)+, (a1)+
.lit0_mat2:
    COPY_MATCH 2

.litF_mat2:  move.l  (a0)+, (a1)+
.litD_mat2:  move.l  (a0)+, (a1)+
.litB_mat2:  move.l  (a0)+, (a1)+
.lit9_mat2:  move.l  (a0)+, (a1)+
.lit7_mat2:  move.l  (a0)+, (a1)+
.lit5_mat2:  move.l  (a0)+, (a1)+
.lit3_mat2:  move.l  (a0)+, (a1)+
.lit1_mat2:  move.w  (a0)+, (a1)+
    COPY_MATCH 2

.litE_mat3:  move.l  (a0)+, (a1)+
.litC_mat3:  move.l  (a0)+, (a1)+
.litA_mat3:  move.l  (a0)+, (a1)+
.lit8_mat3:  move.l  (a0)+, (a1)+
.lit6_mat3:  move.l  (a0)+, (a1)+
.lit4_mat3:  move.l  (a0)+, (a1)+
.lit2_mat3:  move.l  (a0)+, (a1)+
.lit0_mat3:
    COPY_MATCH 3

.litF_mat3:  move.l  (a0)+, (a1)+
.litD_mat3:  move.l  (a0)+, (a1)+
.litB_mat3:  move.l  (a0)+, (a1)+
.lit9_mat3:  move.l  (a0)+, (a1)+
.lit7_mat3:  move.l  (a0)+, (a1)+
.lit5_mat3:  move.l  (a0)+, (a1)+
.lit3_mat3:  move.l  (a0)+, (a1)+
.lit1_mat3:  move.w  (a0)+, (a1)+
    COPY_MATCH 3

.litE_mat4:  move.l  (a0)+, (a1)+
.litC_mat4:  move.l  (a0)+, (a1)+
.litA_mat4:  move.l  (a0)+, (a1)+
.lit8_mat4:  move.l  (a0)+, (a1)+
.lit6_mat4:  move.l  (a0)+, (a1)+
.lit4_mat4:  move.l  (a0)+, (a1)+
.lit2_mat4:  move.l  (a0)+, (a1)+
.lit0_mat4:
    COPY_MATCH 4

.litF_mat4:  move.l  (a0)+, (a1)+
.litD_mat4:  move.l  (a0)+, (a1)+
.litB_mat4:  move.l  (a0)+, (a1)+
.lit9_mat4:  move.l  (a0)+, (a1)+
.lit7_mat4:  move.l  (a0)+, (a1)+
.lit5_mat4:  move.l  (a0)+, (a1)+
.lit3_mat4:  move.l  (a0)+, (a1)+
.lit1_mat4:  move.w  (a0)+, (a1)+
    COPY_MATCH 4

.litE_mat5:  move.l  (a0)+, (a1)+
.litC_mat5:  move.l  (a0)+, (a1)+
.litA_mat5:  move.l  (a0)+, (a1)+
.lit8_mat5:  move.l  (a0)+, (a1)+
.lit6_mat5:  move.l  (a0)+, (a1)+
.lit4_mat5:  move.l  (a0)+, (a1)+
.lit2_mat5:  move.l  (a0)+, (a1)+
.lit0_mat5:
    COPY_MATCH 5

.litF_mat5:  move.l  (a0)+, (a1)+
.litD_mat5:  move.l  (a0)+, (a1)+
.litB_mat5:  move.l  (a0)+, (a1)+
.lit9_mat5:  move.l  (a0)+, (a1)+
.lit7_mat5:  move.l  (a0)+, (a1)+
.lit5_mat5:  move.l  (a0)+, (a1)+
.lit3_mat5:  move.l  (a0)+, (a1)+
.lit1_mat5:  move.w  (a0)+, (a1)+
    COPY_MATCH 5

.litE_mat6:  move.l  (a0)+, (a1)+
.litC_mat6:  move.l  (a0)+, (a1)+
.litA_mat6:  move.l  (a0)+, (a1)+
.lit8_mat6:  move.l  (a0)+, (a1)+
.lit6_mat6:  move.l  (a0)+, (a1)+
.lit4_mat6:  move.l  (a0)+, (a1)+
.lit2_mat6:  move.l  (a0)+, (a1)+
.lit0_mat6:
    COPY_MATCH 6

.litF_mat6:  move.l  (a0)+, (a1)+
.litD_mat6:  move.l  (a0)+, (a1)+
.litB_mat6:  move.l  (a0)+, (a1)+
.lit9_mat6:  move.l  (a0)+, (a1)+
.lit7_mat6:  move.l  (a0)+, (a1)+
.lit5_mat6:  move.l  (a0)+, (a1)+
.lit3_mat6:  move.l  (a0)+, (a1)+
.lit1_mat6:  move.w  (a0)+, (a1)+
    COPY_MATCH 6

.litE_mat7:  move.l  (a0)+, (a1)+
.litC_mat7:  move.l  (a0)+, (a1)+
.litA_mat7:  move.l  (a0)+, (a1)+
.lit8_mat7:  move.l  (a0)+, (a1)+
.lit6_mat7:  move.l  (a0)+, (a1)+
.lit4_mat7:  move.l  (a0)+, (a1)+
.lit2_mat7:  move.l  (a0)+, (a1)+
.lit0_mat7:
    COPY_MATCH 7

.litF_mat7:  move.l  (a0)+, (a1)+
.litD_mat7:  move.l  (a0)+, (a1)+
.litB_mat7:  move.l  (a0)+, (a1)+
.lit9_mat7:  move.l  (a0)+, (a1)+
.lit7_mat7:  move.l  (a0)+, (a1)+
.lit5_mat7:  move.l  (a0)+, (a1)+
.lit3_mat7:  move.l  (a0)+, (a1)+
.lit1_mat7:  move.w  (a0)+, (a1)+
    COPY_MATCH 7

.litE_mat8:  move.l  (a0)+, (a1)+
.litC_mat8:  move.l  (a0)+, (a1)+
.litA_mat8:  move.l  (a0)+, (a1)+
.lit8_mat8:  move.l  (a0)+, (a1)+
.lit6_mat8:  move.l  (a0)+, (a1)+
.lit4_mat8:  move.l  (a0)+, (a1)+
.lit2_mat8:  move.l  (a0)+, (a1)+
.lit0_mat8:
    COPY_MATCH 8

.litF_mat8:  move.l  (a0)+, (a1)+
.litD_mat8:  move.l  (a0)+, (a1)+
.litB_mat8:  move.l  (a0)+, (a1)+
.lit9_mat8:  move.l  (a0)+, (a1)+
.lit7_mat8:  move.l  (a0)+, (a1)+
.lit5_mat8:  move.l  (a0)+, (a1)+
.lit3_mat8:  move.l  (a0)+, (a1)+
.lit1_mat8:  move.w  (a0)+, (a1)+
    COPY_MATCH 8

.litE_mat9:  move.l  (a0)+, (a1)+
.litC_mat9:  move.l  (a0)+, (a1)+
.litA_mat9:  move.l  (a0)+, (a1)+
.lit8_mat9:  move.l  (a0)+, (a1)+
.lit6_mat9:  move.l  (a0)+, (a1)+
.lit4_mat9:  move.l  (a0)+, (a1)+
.lit2_mat9:  move.l  (a0)+, (a1)+
.lit0_mat9:
    COPY_MATCH 9

.litF_mat9:  move.l  (a0)+, (a1)+
.litD_mat9:  move.l  (a0)+, (a1)+
.litB_mat9:  move.l  (a0)+, (a1)+
.lit9_mat9:  move.l  (a0)+, (a1)+
.lit7_mat9:  move.l  (a0)+, (a1)+
.lit5_mat9:  move.l  (a0)+, (a1)+
.lit3_mat9:  move.l  (a0)+, (a1)+
.lit1_mat9:  move.w  (a0)+, (a1)+
    COPY_MATCH 9

.litE_matA:  move.l  (a0)+, (a1)+
.litC_matA:  move.l  (a0)+, (a1)+
.litA_matA:  move.l  (a0)+, (a1)+
.lit8_matA:  move.l  (a0)+, (a1)+
.lit6_matA:  move.l  (a0)+, (a1)+
.lit4_matA:  move.l  (a0)+, (a1)+
.lit2_matA:  move.l  (a0)+, (a1)+
.lit0_matA:
    COPY_MATCH 10

.litF_matA:  move.l  (a0)+, (a1)+
.litD_matA:  move.l  (a0)+, (a1)+
.litB_matA:  move.l  (a0)+, (a1)+
.lit9_matA:  move.l  (a0)+, (a1)+
.lit7_matA:  move.l  (a0)+, (a1)+
.lit5_matA:  move.l  (a0)+, (a1)+
.lit3_matA:  move.l  (a0)+, (a1)+
.lit1_matA:  move.w  (a0)+, (a1)+
    COPY_MATCH 10

.litE_matB:  move.l  (a0)+, (a1)+
.litC_matB:  move.l  (a0)+, (a1)+
.litA_matB:  move.l  (a0)+, (a1)+
.lit8_matB:  move.l  (a0)+, (a1)+
.lit6_matB:  move.l  (a0)+, (a1)+
.lit4_matB:  move.l  (a0)+, (a1)+
.lit2_matB:  move.l  (a0)+, (a1)+
.lit0_matB:
    COPY_MATCH 11

.litF_matB:  move.l  (a0)+, (a1)+
.litD_matB:  move.l  (a0)+, (a1)+
.litB_matB:  move.l  (a0)+, (a1)+
.lit9_matB:  move.l  (a0)+, (a1)+
.lit7_matB:  move.l  (a0)+, (a1)+
.lit5_matB:  move.l  (a0)+, (a1)+
.lit3_matB:  move.l  (a0)+, (a1)+
.lit1_matB:  move.w  (a0)+, (a1)+
    COPY_MATCH 11

.litE_matC:  move.l  (a0)+, (a1)+
.litC_matC:  move.l  (a0)+, (a1)+
.litA_matC:  move.l  (a0)+, (a1)+
.lit8_matC:  move.l  (a0)+, (a1)+
.lit6_matC:  move.l  (a0)+, (a1)+
.lit4_matC:  move.l  (a0)+, (a1)+
.lit2_matC:  move.l  (a0)+, (a1)+
.lit0_matC:
    COPY_MATCH 12

.litF_matC:  move.l  (a0)+, (a1)+
.litD_matC:  move.l  (a0)+, (a1)+
.litB_matC:  move.l  (a0)+, (a1)+
.lit9_matC:  move.l  (a0)+, (a1)+
.lit7_matC:  move.l  (a0)+, (a1)+
.lit5_matC:  move.l  (a0)+, (a1)+
.lit3_matC:  move.l  (a0)+, (a1)+
.lit1_matC:  move.w  (a0)+, (a1)+
    COPY_MATCH 12

.litE_matD:  move.l  (a0)+, (a1)+
.litC_matD:  move.l  (a0)+, (a1)+
.litA_matD:  move.l  (a0)+, (a1)+
.lit8_matD:  move.l  (a0)+, (a1)+
.lit6_matD:  move.l  (a0)+, (a1)+
.lit4_matD:  move.l  (a0)+, (a1)+
.lit2_matD:  move.l  (a0)+, (a1)+
.lit0_matD:
    COPY_MATCH 13

.litF_matD:  move.l  (a0)+, (a1)+
.litD_matD:  move.l  (a0)+, (a1)+
.litB_matD:  move.l  (a0)+, (a1)+
.lit9_matD:  move.l  (a0)+, (a1)+
.lit7_matD:  move.l  (a0)+, (a1)+
.lit5_matD:  move.l  (a0)+, (a1)+
.lit3_matD:  move.l  (a0)+, (a1)+
.lit1_matD:  move.w  (a0)+, (a1)+
    COPY_MATCH 13

.litE_matE:  move.l  (a0)+, (a1)+
.litC_matE:  move.l  (a0)+, (a1)+
.litA_matE:  move.l  (a0)+, (a1)+
.lit8_matE:  move.l  (a0)+, (a1)+
.lit6_matE:  move.l  (a0)+, (a1)+
.lit4_matE:  move.l  (a0)+, (a1)+
.lit2_matE:  move.l  (a0)+, (a1)+
.lit0_matE:
    COPY_MATCH 14

.litF_matE:  move.l  (a0)+, (a1)+
.litD_matE:  move.l  (a0)+, (a1)+
.litB_matE:  move.l  (a0)+, (a1)+
.lit9_matE:  move.l  (a0)+, (a1)+
.lit7_matE:  move.l  (a0)+, (a1)+
.lit5_matE:  move.l  (a0)+, (a1)+
.lit3_matE:  move.l  (a0)+, (a1)+
.lit1_matE:  move.w  (a0)+, (a1)+
    COPY_MATCH 14

.litE_matF:  move.l  (a0)+, (a1)+
.litC_matF:  move.l  (a0)+, (a1)+
.litA_matF:  move.l  (a0)+, (a1)+
.lit8_matF:  move.l  (a0)+, (a1)+
.lit6_matF:  move.l  (a0)+, (a1)+
.lit4_matF:  move.l  (a0)+, (a1)+
.lit2_matF:  move.l  (a0)+, (a1)+
.lit0_matF:
    COPY_MATCH 15

.litF_matF:  move.l  (a0)+, (a1)+
.litD_matF:  move.l  (a0)+, (a1)+
.litB_matF:  move.l  (a0)+, (a1)+
.lit9_matF:  move.l  (a0)+, (a1)+
.lit7_matF:  move.l  (a0)+, (a1)+
.lit5_matF:  move.l  (a0)+, (a1)+
.lit3_matF:  move.l  (a0)+, (a1)+
.lit1_matF:  move.w  (a0)+, (a1)+
    COPY_MATCH 15

.done:
    move.w  (a0)+, d0               | need to copy a last byte ?
    bpl.s  .no_byte
    move.b  d0, (a1)+               | copy last byte
.no_byte:
    move.l  a1, d0
    sub.l  20(sp), d0               | return op - dest

    movem.l (sp)+, a2-a4
    rts
