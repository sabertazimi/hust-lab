#!/usr/bin/env python

"""
assembler.py: rather primitive two-pass assembler. Get the labels, then
assemble the instructions.
"""

import re
import sys
import optparse

symbols = {}

instructions = []

relocations = []

class AssemblerError(Exception):
  pass

class AssemblerSyntaxError(AssemblerError):
  def __init__(self,line,reason):
    self.line = line
    self.reason = reason
  def __str__(self):
    return "Syntax error on line %d: %s" % (self.line,self.reason)

class AssemblerRangeError(AssemblerError):
  def __init__(self,line,reason):
    self.line = line
    self.reason = reason
  def __str__(self):
    return "Range error on line %d: %s" % (self.line,self.reason)

labelre = re.compile(r"""^(?P<labels>.*:)?(?P<gunk>[^:]*)$""")
commentre = re.compile(r"""^(?P<important>[^#]*)(?P<comment>#.*)?$""")
alnumunderre = re.compile(r"""^\w+$""")

#sll srl sra
shift_re  = re.compile(r'''^(?P<instr>(sll|srl|sra))\s+(?P<rd>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<rt>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<immed>-?(0x)?[0-9a-fA-F]+)$''')
#jr jalr
jr_re     = re.compile(r'''^(?P<instr>(jr|jalr))\s+(?P<rs>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))$''')
#mfhi mflo
mf_re    = re.compile(r'''^(?P<instr>(mfhi|mflo))\s+(?P<rd>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))$''')
#mult divu
mult_re    = re.compile(r'''^(?P<instr>(mult|divu))\s+(?P<rs>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<rt>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))$''')
#or and add sub slt sltu addu subu xor nor
rtype_re  = re.compile(r'''^(?P<instr>(or|and|add|sub|slt|sltu|addu|subu|xor|nor))\s+(?P<rd>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<rs>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<rt>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))$''')
#j jal
j_re      = re.compile(r'''^(?P<instr>(j|jal))\s+(?P<label>\w+)$''')
#beq bne beqinc
branch_re = re.compile(r'''^(?P<instr>(beq|beqinc|bne))\s+(?P<rs>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|sp|fp|ra))\s+(?P<rt>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|sp|fp|ra))\s+(?P<label>\w+)$''') #note switch
#ori addi addiu andi slti sltiu xori
immed_re  = re.compile(r'''^(?P<instr>(ori|addi|addiu|andi|slti|sltiu|xori))\s+(?P<rt>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<rs>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|sp|fp|ra))\s+(?P<immed>-?(0x)?[0-9a-fA-F]+)$''')
#lui
lui_re    = re.compile(r'''^(?P<instr>lui)\s+(?P<rt>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<immed>-?(0x)?[0-9a-fA-F]+)$''')
#sw lw 
mem_re    = re.compile(r'''^(?P<instr>(lw|sw))\s+(?P<rt>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<immed>-?(0x)?[0-9a-fA-F]+)\s*\(\s*(?P<rs>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s*\)$''')

#la
la_re     = re.compile(r'''^(?P<instr>(la))\s+(?P<rt>\$(0|zero|at|v[0,1]|a[0-3]|t[0-9]|s[0-7]|k[0-1]|gp|fp|sp|ra))\s+(?P<label>\w+)$''')
signed_re = re.compile(r'addi|addiu|slti|sltiu|lw|sw|beq|bne|beqinc')
both_allowed_re = re.compile(r'ori|andi')


opcodes = {
  'j':0x2,
  'jal':0x3,
  'beq':0x4,
  'bne':0x5,
  'beqinc':0x6,
  'addi':0x8,
  'addiu':0x9,
  'slti': 0xa,
  'sltiu':0xb,
  'andi':0xc,
  'ori':0xd,
  'xori':0xe,
  'lui':0xf,
  'lw':0x23,
  'sw':0x2b,
}

functs = {
  'sll':0,
  'srl':2,
  'sra':3,
  'jr':8,
  'jalr':9,
  'mfhi': 0x10,
  'mflo': 0x12,
  'mult': 0x18,
  'divu': 0x1b,
  'add':0x20,
  'addu':0x21,
  'sub':0x22,
  'subu':0x23,
  'and':0x24,
  'or':0x25,
  'xor':0x26,
  'nor':0x27,
  'slt':0x2a,
  'sltu':0x2b,
}

registers = {
  '0':0,
  'zero':0,
  'at':1,
  'v0':2,
  'v1':3,
  'a0':4,
  'a1':5,
  'a2':6,
  'a3':7,
  't0':8,
  't1':9,
  't2':10,
  't3':11,
  't4':12,
  't5':13,
  't6':14,
  't7':15,
  's0':16,
  's1':17,
  's2':18,
  's3':19,
  's4':20,
  's5':21,
  's6':22,
  's7':23,
  't8':24,
  't9':25,
  'k0':26,
  'k1':27,
  'gp':28,
  'sp':29,
  'fp':30,
  'ra':31,
  '1':1,
  '2':2,
  '3':3,
  '4':4,
  '5':5,
  '6':6,
  '7':7,
  '8':8,
  '9':9,
  '10':10,
  '11':11,
  '12':12,
  '13':13,
  '14':14,
  '15':15,
  '16':16,
  '17':17,
  '18':18,
  '19':19,
  '20':20,
  '21':21,
  '22':22,
  '23':23,
  '24':24,
  '25':25,
  '26':26,
  '27':27,
  '28':28,
  '29':29,
  '30':30,
  '31':31,
} 
def isPseudoInstruction(s):
  return la_re.match(s) 

def validLabel(s):
  return alnumunderre.match(s) != None

def fill_symbol_table(inputFile):
  lineNo = 1
  instructionsSeen = 0
  for line in inputFile:
    #strip any comments
    match = commentre.match(line)
    
    if not match:
      raise AssemblerSyntaxError(lineNo,"Unable to parse line: %s" % line)
    
    line = match.group('important')
    
    line = line.strip()
    
    match = labelre.match(line)
    
    if not match:
      raise AssemblerSyntaxError(lineNo,"Unable to parse line: %s" % line)
    
    labels_string = match.group('labels')
    
    if labels_string:
      labels = labels_string[:-1].split(':')
    else:
      labels = []
    
    for label in labels:
      if not validLabel(label):
        raise AssemblerSyntaxError(lineNo,"Invalid label: '%s'"%label)
      if label in symbols:
        raise AssemblerSyntaxError(lineNo,"Label %s already defined" % label)
      symbols[label] = instructionsSeen
    
    instruction = match.group('gunk').replace(',',' ').strip()
    if len(instruction) != 0:
      #there's an instruction here, so increment the number of instructions
      #if we had any pseudoinstructions, we'd do analysis and increment by
      #more than one here
      instructionsSeen += 1
    lineNo+=1

def imm_check(signed,both_allowed,immediate,lineNo):
  if both_allowed:
    if (immediate > 2 ** 16 - 1 or immediate < -(2 ** 16)):
        raise AssemblerSyntaxError(lineNo,"immediate out of range")
  else:
    if signed and (immediate > 2 ** 16 - 1 or immediate < -(2 ** 16)):
        raise AssemblerSyntaxError(lineNo,"signed immediate out of range")
    if (not signed) and (immediate > 2 ** 16 - 1 or immediate < 0):
        raise AssemblerSyntaxError(lineNo,"unsigned immediate out of range")

def shamt_check(shamt,lineNo):
  if(shamt > 31 or shamt < 0):
    raise AssemblerSyntaxError(lineNo,"shamt out of range")


def assemble_instructions(inputFile):
  lineNo = 1
  instructionsSeen = 0
  instructions = []
  for line in inputFile:
    #strip any comments
    match = commentre.match(line)
    assert(match)
    line = match.group('important')
    
    line = line.strip()
    
    match = labelre.match(line)
    
    instruction = match.group('gunk').replace(',',' ').strip()


    rtype    = rtype_re.match(instruction)
    mult     = mult_re.match(instruction)
    move     = mf_re.match(instruction)
    shift    = shift_re.match(instruction)
    immed    = immed_re.match(instruction)
    lui      = lui_re.match(instruction)
    mem      = mem_re.match(instruction)
    j        = j_re.match(instruction)
    branch   = branch_re.match(instruction)
    jr       = jr_re.match(instruction)
    signed   = signed_re.match(instruction)
    both_allowed = both_allowed_re.match(instruction)
     
    if len(instruction) != 0:
      num = 0
      if rtype:
        rs = registers[rtype.group('rs')[1:]]
        rt = registers[rtype.group('rt')[1:]]
        rd = registers[rtype.group('rd')[1:]]
        funct = functs[rtype.group('instr')]
        num = 0 << 26 | rs << 21 | rt << 16 | rd << 11 | 0 << 6 | funct
        debug("instruction: %s rtype: rs: %d rt: %d rd: %d funct:%d num: %04x" % (instruction,rs,rt,rd,funct,num))
      elif mult:
        rs = registers[mult.group('rs')[1:]]
        rt = registers[mult.group('rt')[1:]]
        funct = functs[mult.group('instr')]
        num = 0 << 26 | rs << 21 | rt << 16 | 0 << 11 | 0 << 6 | funct
        debug("instruction: %s rtype: rs: %d rt: %d funct:%d num: %04x" % (instruction,rs,rt,funct,num))
      elif move:
        rd = registers[move.group('rd')[1:]]
        funct = functs[move.group('instr')]
        num = 0 << 26 | 0 << 21 | 0 << 16 | rd << 11 | 0 << 6 | funct
        debug("instruction: %s rtype: rd: %d funct:%d num: %04x" % (instruction,rd,funct,num))

      elif shift:
        rt = registers[shift.group('rt')[1:]]
        rd = registers[shift.group('rd')[1:]]
        immediate = int(shift.group('immed'),0)
        funct = functs[shift.group('instr')]
        shamt_check(immediate,lineNo)
        num = 0 << 26 | 0 << 21 | rt << 16 | rd << 11 | (immediate & 31) << 6 | funct
        debug("instruction: %s rtype: rs: %d rd: %d shamt: %d funct:%d num: %04x" % (instruction,rt,rd,immediate,funct,num))
      elif immed:
        rs = registers[immed.group('rs')[1:]]
        rt = registers[immed.group('rt')[1:]]
        opcode = opcodes[immed.group('instr')]
        immediate = int(immed.group('immed'),0)
        imm_check(signed,both_allowed,immediate,lineNo)
        num = opcode << 26 | rs << 21 | rt << 16 | (immediate & 0xFFFF)
        debug("instruction: %s rs: %d rt: %d opcode: %d immediate: %d num: %04x" % (instruction,rs,rt,opcode,immediate,num))
      elif lui:
        rt = registers[lui.group('rt')[1:]]
        opcode = opcodes[lui.group('instr')]
        immediate = int(lui.group('immed'),0)
        imm_check(signed,both_allowed,immediate,lineNo)
        num = opcode << 26 | 0 << 21 | rt << 16 | (immediate & 0xFFFF)
        debug("instruction: %s rt: %d opcode: %d immediate: %d num: %04x" % (instruction,rt,opcode,immediate,num))
      elif mem:
        opcode = opcodes[mem.group('instr')]
        rs = registers[mem.group('rs')[1:]]
        rt = registers[mem.group('rt')[1:]]
        immediate = int(mem.group('immed'),0)
        imm_check(signed,both_allowed,immediate,lineNo)
        num = opcode << 26 | rs << 21 | rt << 16 | (immediate & 0xFFFF)
        debug("instruction: %s rs: %d rt: %d opcode: %d immediate: %d num: %04x" % (instruction,rs,rt,opcode,immediate,num))
      elif j:
        opcode = opcodes[j.group('instr')]
        #find label
        label = j.group('label')
        if label not in symbols:
          raise AssemblerSyntaxError(lineNo,"unknown label %s" % j.group('label'))
        instructionNo = symbols[label]
        thisInstruction = instructionsSeen
        if thisInstruction & 0x3000000 != instructionNo & 0x3000000:
          raise AssemblerRangeError(lineNo,"label %s is in another jump zone (instr: %04x, target:%04x)" % (label,thisInstruction,instructionNo))
        num = opcode << 26 | (instructionNo & 0x3FFFFFF)
        debug("instruction: %s addr: %d num: %04x" % (instruction,instructionNo & 0x3FFFFFF,num))
      elif branch:
        rs = registers[branch.group('rs')[1:]]
        rt = registers[branch.group('rt')[1:]]
        opcode = opcodes[branch.group('instr')]
        #find label
        label = branch.group('label')
        if label not in symbols:
          raise AssemblerSyntaxError(lineNo,"unknown label %s" % branch.group('label'))
        instructionNo = symbols[label]
        offset = instructionNo - (instructionsSeen + 1)
        if offset > 2 ** 16 - 1 or offset < -(2 ** 16):
          raise AssemblerRangeError(lineNo,"label %s is too far away: %d instructions from pc+1" % (label,offset))
        num = opcode << 26 | rs << 21 | rt << 16 | (offset & 0xFFFF)
        debug("instruction: %s rs: %d rt: %d opcode: %d offset: %d num: %04x" % (instruction,rs,rt,opcode,offset,num))
      elif jr:
        rs = registers[jr.group('rs')[1:]]
        funct = functs[jr.group('instr')]
        num = 0 << 26 | rs << 21 | 0 << 16 | 0 << 11 | 0 << 6 | funct
        debug("instruction: %s rs: %d num: %04x" % (instruction,rs,num))
      else:
        raise AssemblerSyntaxError(lineNo,"Can't parse instruction '%s'" % instruction)
      #there's an instruction here, so increment the number of instructions
      #if we had any pseudoinstructions, we'd do analysis and increment by
      #more than one here
      instructionsSeen += 1
      instructions.append(num)
    lineNo+=1
  return instructions

def print_instructions(instructions,outfile):
  print >> outfile, "v2.0 raw"
  for instruction in instructions:
    print >> outfile, "%04x" % instruction

verbose = False

def debug(*args):
  if verbose:
    sys.stdout.write(' '.join([str(arg) for arg in args]) + '\n')

if __name__ == "__main__":
  usage = "%prog infile [options]"
  parser = optparse.OptionParser(usage=usage)
  parser.add_option('-o','--out',dest='output_file',type='string',
                    default='a.hex',help="Specify output filename")
  parser.add_option('-v','--verbose',dest='verbose',
                    action='store_true',default=False, help='verbose debug mode')
  options,args = parser.parse_args()
  if len(args) != 1:
    parser.error("Incorrect command line arguments")
    sys.exit(1)
  
  verbose = options.verbose
  
  output_file = options.output_file
  input_file = args[0]
  if re.match(r""".*(?P<extension>\.s)$""",input_file,re.I) and output_file == 'a.hex':
    output_file = input_file[:-1] + "hex"
  
  try:
    infile = open(input_file)
  except IOError,e:
    print >> sys.stderr, "Unable to open input file %s" % input_file
    sys.exit(1)
  try:
    fill_symbol_table(infile)
    infile.seek(0)
    instructions = assemble_instructions(infile)
    infile.close()
  except AssemblerError, e:
    print >> sys.stderr, str(e)
    sys.exit(1)
  try:
    outfile = open(output_file,'w')
    print_instructions(instructions,outfile)
    outfile.close()
  except IOError,e:
    print >> sys.stderr, "Unable to write to output file %s" % output_file
    sys.exit(1)
  sys.exit(0)
