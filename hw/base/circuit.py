# we should implement the function net_to_smt here?
# input: workingBlock, mems
# output: wires, ops, assertions
import z3


# def net_to_smt(wb, mems):
    

def net_to_smt(wb):
    """
    Convert PyRTL working block to SMT formulas for Z3 verification.
    
    Returns:
    - wires: dict mapping wire names to Z3 BitVec variables
    - ops: list of Z3 operations/constraints 
    - assertions: list of Z3 assertions representing the circuit logic
    """
    
    wires = {}
    ops = []
    assertions = []
    
    # First pass: create Z3 BitVec variables for all wires
    for net in wb:
        # Create BitVec for destination wires
        for dest in net.dests:
            if dest.name not in wires:
                wires[dest.name] = z3.BitVec(dest.name, dest.bitwidth)
        
        # Create BitVec for argument wires (inputs)
        for arg in net.args:
            if arg.name not in wires:
                wires[arg.name] = z3.BitVec(arg.name, arg.bitwidth)
    
    # Second pass: create Z3 constraints based on operations
    for net in wb:
        op = net.op
        args = [wires[arg.name] for arg in net.args]
        dest = wires[net.dests[0].name]  # Most operations have single destination
        
        match op:
            case 'w': # Wire assignment
                # TODO wire width adaption
                assertions.append(dest.size() == args[0].size())

                assertion = dest == args[0]
                assertions.append(assertion)
                ops.append(('assign', args[0], dest))
            
            case '&':  # Bitwise AND
                if len(args) == 2:
                    # TODO assert input width are same
                    assertions.append(z3.And(args[0].size() == args[1].size(),
                                             dest.size() == args[0].size()))
                    
                    assertion = dest == (args[0] & args[1])
                    assertions.append(assertion)
                    ops.append(('and', args[0], args[1], dest))
            
            case '|':  # Bitwise OR
                if len(args) == 2:
                    # TODO assert input width are same
                    assertions.append(z3.And(args[0].size() == args[1].size(),
                                             dest.size() == args[0].size()))
                    
                    assertion = dest == (args[0] | args[1])
                    assertions.append(assertion)
                    ops.append(('or', args[0], args[1], dest))
                    
            case '^':  # Bitwise XOR
                if len(args) == 2:
                    # TODO assert input width are same
                    assertions.append(z3.And(args[0].size() == args[1].size(),
                                             dest.size() == args[0].size()))

                    assertion = dest == (args[0] ^ args[1])
                    assertions.append(assertion)
                    ops.append(('xor', args[0], args[1], dest))
                    
            case '~':  # Bitwise NOT
                # assert input and output widths match
                assertions.append(dest.size() == args[0].size())
                
                assertion = dest == (~args[0])
                assertions.append(assertion)
                ops.append(('not', args[0], dest))
                
            case 'c':  # Concatenation
                # Concatenate arguments from left to right (most significant first)
                if len(args) >= 2:
                    result = args[0]
                    result_bitwidth = args[0].size()
                    for i in range(1, len(args)):
                        result = z3.Concat(result, args[i])
                        result_bitwidth += args[i].size()

                    # TODO assert dest width is the sum of the input widths
                    assertions.append(dest.size() == result_bitwidth)

                    assertion = dest == result
                    assertions.append(assertion)
                    ops.append(('concat', args, dest))
                    
            case 's':  # Select/Extract bits
                # Format: select(wire, high_bit, low_bit)
                if len(args) == 1 and net.op_param is not None:
                    if isinstance(net.op_param, tuple) and len(net.op_param) == 2:
                        high_bit, low_bit = net.op_param

                        # TODO assert dest width is highbit-lowbit+1
                        assertions.append(dest.size() == (high_bit - low_bit + 1))

                        assertion = dest == z3.Extract(high_bit, low_bit, args[0])
                        assertions.append(assertion)
                        ops.append(('extract', args[0], high_bit, low_bit, dest))
                        
            case 'm':  # Multiplexer
                # Format: mux(select, *options)
                if len(args) >= 3:
                    select = args[0]
                    options = args[1:]
                    # Build nested if-then-else for mux
                    result = options[-1]  # default case
                    for i in range(len(options)-2, -1, -1):
                        condition = select == i
                        result = z3.If(condition, options[i], result)
                    assertion = dest == result
                    assertions.append(assertion)
                    ops.append(('mux', select, options, dest))
                    
            case '*':
                if len(args) == 2:
                    # TODO assert dest width 2*n than the input width n
                    assertions.append(z3.And(args[0].size() == args[1].size(),
                                             dest.size() == args[0].size() * 2))
                    
                    assertion = dest == (args[0] * args[1])
                    assertions.append(assertion)
                    ops.append(('mul', args[0], args[1], dest))

            case '+':  # Addition
                if len(args) == 2:
                    # TODO assert dest width is one bit more than the input width
                    assertions.append(z3.And(args[0].size() == args[1].size(),
                                             dest.size() == args[0].size() + 1))
                    
                    assertion = dest == (args[0] + args[1])
                    assertions.append(assertion)
                    ops.append(('add', args[0], args[1], dest))
                    
            case '-':  # Subtraction
                if len(args) == 2:
                    # TODO assert dest width is one bit more than the input width
                    assertions.append(z3.And(args[0].size() == args[1].size(),
                                             dest.size() == args[0].size() + 1))
                    
                    assertion = dest == (args[0] - args[1])
                    assertions.append(assertion)
                    ops.append(('sub', args[0], args[1], dest))
                    
            case '=':  # Equality comparison
                if len(args) == 2:
                    assertion = dest == z3.If(args[0] == args[1], 
                                                  z3.BitVecVal(1, dest.size()), 
                                                  z3.BitVecVal(0, dest.size()))
                    assertions.append(assertion)
                    ops.append(('eq', args[0], args[1], dest))
                    
            case '<':  # Less than comparison
                if len(args) == 2:
                    assertion = dest == z3.If(z3.ULT(args[0], args[1]), 
                                                  z3.BitVecVal(1, dest.size()), 
                                                  z3.BitVecVal(0, dest.size()))
                    assertions.append(assertion)
                    ops.append(('lt', args[0], args[1], dest))                    

            case _:
                # Unknown operation - to handle unsupported ops
                ops.append(('unknown_op', op, net.op_param, args, dest))
    
    return wires, ops, assertions


# # Example usage for your CPU verification:
# def verify_cpu_instruction(wb, specification):
#     """
#     Verify that a CPU instruction implementation meets its specification.
    
#     Args:
#     - wb: PyRTL working block containing the CPU circuit
#     - specification: Z3 formula expressing the expected behavior
    
#     Returns:
#     - z3.sat if counterexample found (verification failed)
#     - z3.unsat if no counterexample (verification passed)
#     """
#     wires, ops, assertions = net_to_smt(wb)
    
#     solver = z3.Solver()
    
#     # Add circuit constraints
#     for assertion in assertions:
#         solver.add(assertion)
    
#     # Add negation of specification (looking for counterexamples)
#     solver.add(z3.Not(specification))
    
#     return solver.check()


# # Example specification for POP 2; ALU ADD sequence:
# def create_pop_add_spec(wires):
#     """
#     Example specification: POP 2; ALU ADD should compute sum of top two stack elements
#     This is a template - you'll need to adapt based on your CPU's actual wire names
#     """
#     # Assuming you have wires for:
#     # - initial stack state
#     # - final stack state  
#     # - stack pointer
    
#     # This is pseudocode - adapt to your actual wire names:
#     # initial_stack_top = wires['initial_stack_top']
#     # initial_stack_second = wires['initial_stack_second'] 
#     # final_stack_top = wires['final_stack_top']
#     # 
#     # spec = final_stack_top == (initial_stack_top + initial_stack_second)
#     # return spec
    
#     pass  # Replace with actual implementation