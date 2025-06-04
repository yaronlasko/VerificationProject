main:
  PUSH 11
  PUSH 20
  PUSH main:0
  DUP 2
  DUP 2
  PUSH 1
  POP 2
  ALU ADD
  DUP 4
  JMP horiz
main:0:
  POP 1
  PUSH main:1
  DUP 1
  DUP 3
  PUSH 1
  POP 2
  ALU ADD
  DUP 3
  PUSH 1
  POP 2
  ALU ADD
  JMP vert
main:1:
  POP 1
  PUSH main:2
  DUP 1
  PUSH 1
  POP 2
  ALU SUB
  DUP 3
  DUP 3
  JMP horiz
main:2:
  POP 1
  PUSH main:3
  DUP 2
  DUP 2
  DUP 4
  JMP vert
main:3:
  POP 1
  PUSH 0
  YANK 1,2
  POP 2
  RET 1
memset_skip:
  PUSH 0
  DUP 2
  POP 2
  ALU LT
  POP 1
  JZ memset_skip:0
  PUSH memset_skip:1
  DUP 1
  DUP 5
  JMP mem_poke
memset_skip:1:
  DUP 4
  DUP 4
  POP 2
  ALU ADD
  DUP 4
  DUP 4
  PUSH 1
  POP 2
  ALU SUB
  DUP 4
  YANK 4,5
  JMP memset_skip
  JMP memset_skip:2
memset_skip:0:
  PUSH 0
memset_skip:2:
  YANK 1,4
  POP 2
  RET 1
memor_skip:
  PUSH 0
  DUP 2
  POP 2
  ALU LT
  POP 1
  JZ memor_skip:0
  PUSH memor_skip:1
  DUP 1
  PUSH memor_skip:2
  DUP 6
  JMP mem_peek
memor_skip:2:
  POP 2
  ALU OR
  DUP 5
  JMP mem_poke
memor_skip:1:
  DUP 4
  DUP 4
  POP 2
  ALU ADD
  DUP 4
  DUP 4
  PUSH 1
  POP 2
  ALU SUB
  DUP 4
  YANK 4,5
  JMP memor_skip
  JMP memor_skip:3
memor_skip:0:
  PUSH 0
memor_skip:3:
  YANK 1,4
  POP 2
  RET 1
wait:
  PUSH wait:0
  PUSH 49153
  JMP mem_peek
wait:0:
  PUSH wait:1
  JMP wait_aux
wait:1:
  YANK 1,1
  POP 2
  RET 1
wait_aux:
  PUSH wait_aux:0
  PUSH 49153
  JMP mem_peek
wait_aux:0:
  DUP 2
  POP 2
  ALU SUB
  POP 1
  JZ wait_aux:1
  PUSH wait_aux:2
  PUSH 49152
  JMP mem_peek
wait_aux:2:
  JMP wait_aux:3
wait_aux:1:
  JMP wait_aux
wait_aux:3:
  POP 2
  RET 1
block:
  DUP 1
  PUSH 1
  POP 2
  ALU AND
  POP 1
  JZ block:0
  PUSH 65280
  JMP block:1
block:0:
  PUSH 255
block:1:
  PUSH block:2
  PUSH 40960
  PUSH 128
  DUP 4
  POP 2
  ALU MUL
  POP 2
  ALU ADD
  DUP 4
  PUSH 1
  POP 2
  ALU SHR
  POP 2
  ALU ADD
  PUSH 16
  PUSH 8
  DUP 4
  JMP memor_skip
block:2:
  YANK 1,1
  YANK 1,2
  POP 2
  RET 1
memor_shr_skip:
  PUSH 0
  DUP 3
  POP 2
  ALU LT
  POP 1
  JZ memor_shr_skip:0
  PUSH memor_shr_skip:1
  DUP 2
  DUP 2
  POP 2
  ALU SHL
  PUSH memor_shr_skip:2
  DUP 7
  JMP mem_peek
memor_shr_skip:2:
  POP 2
  ALU OR
  DUP 6
  JMP mem_poke
memor_shr_skip:1:
  POP 1
  PUSH memor_shr_skip:3
  DUP 5
  DUP 5
  POP 2
  ALU ADD
  DUP 5
  DUP 5
  PUSH 1
  POP 2
  ALU SUB
  DUP 5
  PUSH 1
  POP 2
  ALU SHR
  DUP 5
  JMP memor_shr_skip
memor_shr_skip:3:
  JMP memor_shr_skip:4
memor_shr_skip:0:
  PUSH 0
memor_shr_skip:4:
  YANK 1,5
  POP 2
  RET 1
memor_shl_skip:
  PUSH 0
  DUP 3
  POP 2
  ALU LT
  POP 1
  JZ memor_shl_skip:0
  PUSH memor_shl_skip:1
  DUP 2
  DUP 2
  POP 2
  ALU SHR
  PUSH memor_shl_skip:2
  DUP 7
  JMP mem_peek
memor_shl_skip:2:
  POP 2
  ALU OR
  DUP 6
  JMP mem_poke
memor_shl_skip:1:
  POP 1
  PUSH memor_shl_skip:3
  DUP 5
  DUP 5
  POP 2
  ALU ADD
  DUP 5
  DUP 5
  PUSH 1
  POP 2
  ALU SUB
  DUP 5
  PUSH 1
  POP 2
  ALU SHL
  DUP 5
  JMP memor_shl_skip
memor_shl_skip:3:
  JMP memor_shl_skip:4
memor_shl_skip:0:
  PUSH 0
memor_shl_skip:4:
  YANK 1,5
  POP 2
  RET 1
horiz:
  DUP 2
  DUP 2
  POP 2
  ALU LT
  POP 1
  JZ horiz:0
  PUSH 1
  JMP horiz:1
horiz:0:
  DUP 1
  DUP 3
  POP 2
  ALU LT
  POP 1
  JZ horiz:2
  PUSH 65535
  JMP horiz:3
horiz:2:
  PUSH 0
horiz:3:
horiz:1:
  DUP 0
  POP 1
  JZ horiz:4
  PUSH horiz:5
  DUP 4
  DUP 3
  JMP block
horiz:5:
  POP 1
  PUSH horiz:6
  JMP wait
horiz:6:
  POP 1
  DUP 3
  DUP 1
  POP 2
  ALU ADD
  DUP 3
  DUP 3
  YANK 3,4
  JMP horiz
  JMP horiz:7
horiz:4:
  PUSH 0
horiz:7:
  YANK 1,1
  YANK 1,3
  POP 2
  RET 1
vert:
  DUP 1
  DUP 1
  POP 2
  ALU LT
  POP 1
  JZ vert:0
  PUSH 1
  JMP vert:1
vert:0:
  DUP 0
  DUP 2
  POP 2
  ALU LT
  POP 1
  JZ vert:2
  PUSH 65535
  JMP vert:3
vert:2:
  PUSH 0
vert:3:
vert:1:
  DUP 0
  POP 1
  JZ vert:4
  PUSH vert:5
  DUP 4
  DUP 4
  JMP block
vert:5:
  POP 1
  PUSH vert:6
  JMP wait
vert:6:
  POP 1
  DUP 3
  DUP 3
  DUP 2
  POP 2
  ALU ADD
  DUP 3
  YANK 3,4
  JMP vert
  JMP vert:7
vert:4:
  PUSH 0
vert:7:
  YANK 1,1
  YANK 1,3
  POP 2
  RET 1
skewed_l:
  DUP 1
  PUSH 1
  POP 2
  ALU AND
  POP 1
  JZ skewed_l:0
  PUSH skewed_l:1
  PUSH 40960
  PUSH 128
  DUP 3
  POP 2
  ALU MUL
  POP 2
  ALU ADD
  DUP 3
  PUSH 1
  POP 2
  ALU SHR
  POP 2
  ALU ADD
  PUSH 16
  PUSH 8
  PUSH 65280
  PUSH 8
  JMP memor_shr_skip
skewed_l:1:
  POP 1
  PUSH skewed_l:2
  PUSH 40961
  PUSH 128
  DUP 3
  POP 2
  ALU MUL
  POP 2
  ALU ADD
  DUP 3
  PUSH 1
  POP 2
  ALU SHR
  POP 2
  ALU ADD
  PUSH 16
  PUSH 8
  PUSH 255
  PUSH 0
  JMP memor_shr_skip
skewed_l:2:
  JMP skewed_l:3
skewed_l:0:
  PUSH skewed_l:4
  PUSH 40960
  PUSH 128
  DUP 3
  POP 2
  ALU MUL
  POP 2
  ALU ADD
  DUP 3
  PUSH 1
  POP 2
  ALU SHR
  POP 2
  ALU ADD
  PUSH 16
  PUSH 8
  PUSH 65280
  PUSH 0
  JMP memor_shr_skip
skewed_l:4:
skewed_l:3:
  YANK 1,2
  POP 2
  RET 1
skewed_r:
  DUP 1
  PUSH 1
  POP 2
  ALU AND
  POP 1
  JZ skewed_r:0
  PUSH skewed_r:1
  PUSH 40960
  PUSH 128
  DUP 3
  POP 2
  ALU MUL
  POP 2
  ALU ADD
  DUP 3
  PUSH 1
  POP 2
  ALU SHR
  POP 2
  ALU ADD
  PUSH 16
  PUSH 8
  PUSH 65280
  PUSH 0
  JMP memor_shl_skip
skewed_r:1:
  POP 1
  PUSH skewed_r:2
  PUSH 40961
  PUSH 128
  DUP 3
  POP 2
  ALU MUL
  POP 2
  ALU ADD
  DUP 3
  PUSH 1
  POP 2
  ALU SHR
  POP 2
  ALU ADD
  PUSH 16
  PUSH 8
  PUSH 255
  PUSH 8
  JMP memor_shl_skip
skewed_r:2:
  JMP skewed_r:3
skewed_r:0:
  PUSH skewed_r:4
  PUSH 40960
  PUSH 128
  DUP 3
  POP 2
  ALU MUL
  POP 2
  ALU ADD
  DUP 3
  PUSH 1
  POP 2
  ALU SHR
  POP 2
  ALU ADD
  PUSH 16
  PUSH 8
  PUSH 255
  PUSH 0
  JMP memor_shl_skip
skewed_r:4:
skewed_r:3:
  YANK 1,2
  POP 2
  RET 1
