main:
  PUSH main:0
  JMP spiral
main:0:
  POP 1
  PUSH 0
  POP 2
  RET 1
square:
  PUSH square:0
  DUP 2
  DUP 3
  DUP 3
  POP 2
  ALU ADD
  DUP 5
  JMP horiz
square:0:
  POP 1
  PUSH square:1
  DUP 2
  DUP 3
  DUP 3
  POP 2
  ALU ADD
  PUSH 1
  POP 2
  ALU ADD
  DUP 5
  DUP 4
  POP 2
  ALU ADD
  JMP horiz
square:1:
  POP 1
  PUSH square:2
  DUP 2
  DUP 4
  DUP 5
  DUP 4
  POP 2
  ALU ADD
  JMP vert
square:2:
  POP 1
  PUSH square:3
  DUP 2
  DUP 2
  POP 2
  ALU ADD
  DUP 4
  DUP 5
  DUP 4
  POP 2
  ALU ADD
  JMP vert
square:3:
  POP 1
  PUSH 0
  YANK 1,3
  POP 2
  RET 1
spiral:
  PUSH spiral:0
  PUSH 15
  PUSH 15
  PUSH 1
  JMP square
spiral:0:
  PUSH spiral:1
  PUSH 14
  PUSH 14
  PUSH 3
  JMP square
spiral:1:
  PUSH spiral:2
  PUSH 3
  PUSH 29
  PUSH 3
  JMP horiz
spiral:2:
  PUSH spiral:3
  PUSH 29
  PUSH 3
  PUSH 29
  JMP vert
spiral:3:
  PUSH spiral:4
  PUSH 29
  PUSH 3
  PUSH 28
  JMP horiz
spiral:4:
  PUSH spiral:5
  PUSH 3
  PUSH 28
  PUSH 7
  JMP vert
spiral:5:
  PUSH spiral:6
  PUSH 3
  PUSH 25
  PUSH 7
  JMP horiz
spiral:6:
  PUSH spiral:7
  PUSH 25
  PUSH 7
  PUSH 24
  JMP vert
spiral:7:
  PUSH spiral:8
  PUSH 25
  PUSH 7
  PUSH 24
  JMP horiz
spiral:8:
  PUSH spiral:9
  PUSH 7
  PUSH 24
  PUSH 15
  JMP vert
spiral:9:
  PUSH spiral:10
  PUSH 7
  PUSH 15
  PUSH 15
  JMP horiz
spiral:10:
  PUSH 0
  YANK 1,11
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
  DUP 3
  DUP 1
  POP 2
  ALU ADD
  DUP 3
  DUP 3
  YANK 3,4
  JMP horiz
  JMP horiz:6
horiz:4:
  PUSH 0
horiz:6:
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
  DUP 3
  DUP 3
  DUP 2
  POP 2
  ALU ADD
  DUP 3
  YANK 3,4
  JMP vert
  JMP vert:6
vert:4:
  PUSH 0
vert:6:
  YANK 1,1
  YANK 1,3
  POP 2
  RET 1
