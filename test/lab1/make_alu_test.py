import sys

def switch(x):
    return {
        'sll':0,
        'srl':1,
        'sra':2,
        'mult':3,
        'divu':4,
        'add':5,
        'addu':6,
        'sub':7,
        'subu':8,
        'and':9,
        'or':10,
        'xor':11,
        'nor':12,
        'slt':13,
        'sltu':14,
    }.get(x, 15)

user_input = raw_input("Test name: ")
name = user_input
f_X = open("tests/"+name+".X", 'w')
f_Y = open("tests/"+name+".Y", 'w')
f_S = open("tests/"+name+".S", 'w')
f_out = open("tests/"+name+".out", 'w')
f_X.write("v2.0 raw\n")
f_Y.write("v2.0 raw\n")
f_S.write("v2.0 raw\n")
print("Created files "+name+".X, .Y, .S and .out in your tests folder")
print("For X, Y, Expected Result and Expected Result 2 values, you may enter values in hex, decimal, or binary. Please include approripate previxes.")
success = 0
#CYCLES
while success==0:
    user_input = raw_input("Number of cycles: ")
    try:
        cycles = int(user_input)
        print(user_input+" cycles")
        success = 1
    except ValueError:
        print("Please enter a valid base-10 number.")
for t in range(cycles):
    success = 0
    #X
    while success==0:
        user_input = raw_input("Time "+str(t)+"\tX: ")
        try:
            if user_input[0:2] == "0x":
                val = int(user_input[2:], 16)
            elif user_input[0:2] == "0b":
                val = int(user_input[2:], 2)
            else:
                val = int(user_input)
                if val < 0:
                    val = 2**32 + val
            s = format(val, '08x')
            f_X.write(s+"\n")
            success = 1
        except ValueError:
            print("Please enter a valid number.")
    success = 0
    #Y
    while success==0:
        user_input = raw_input("Time "+str(t)+"\tY: ")
        try:
            if user_input[0:2] == "0x":
                val = int(user_input[2:], 16)
            elif user_input[0:2] == "0b":
                val = int(user_input[2:], 2)
            else:
                val = int(user_input)
                if val < 0:
                    val = 2**32 + val
            s = format(val, '08x')
            f_Y.write(s+"\n")
            success = 1
        except ValueError:
            print("Please enter a valid number.")
    success = 0
    #S
    while success==0:
        user_input = raw_input("Time "+str(t)+"\tFunction: ")
        if user_input == 'mult' or user_input == 'divu':
            result2 = 1
        else:
            result2 = 0
        val = switch(user_input)
        if val != 15:
            s = format(val, '01x')
            f_S.write(s+"\n")
            success = 1
        else:
            print("Please enter valid instruction name. Ex: 'add'")    
    success = 0
    #TIME
    s = format(t, '08b')
    s = " ".join(s[i:i+4] for i in range(0, len(s), 4))
    f_out.write(s+"\t") 
    #OVERFLOW
    while success == 0:
        user_input = raw_input("Expected Signed Overflow: ")
        try:
            val = int(user_input, 2)
            s = format(val, '01b')
            f_out.write(s+"\t") 
            success = 1
        except ValueError:
            print("Please enter a '1' or a '0'") 
    success = 0
    #EQUAL
    while success == 0:
        user_input = raw_input("Expected Equal: ")
        try:
            val = int(user_input, 2)
            s = format(val, '01b')
            f_out.write(s+"\t")
            success = 1
        except ValueError:
            print("Please enter a '1' or a '0'") 
    success = 0
    #RESULT
    while success == 0:
        user_input = raw_input("Expected Result: ")
        try:
            if user_input[0:2] == "0x":
                val = int(user_input[2:], 16)
            elif user_input[0:2] == "0b":
                val = int(user_input[2:], 2)
            else:
                val = int(user_input)
                if val < 0:
                    val = 2**32 + val
            s = format(val, '032b')
            s = " ".join(s[i:i+4] for i in range(0, len(s), 4))
            f_out.write(s+"\t")
            success = 1
        except ValueError:
            print("Please enter a valid number.")
    #RESULT2
    if result2:
        success = 0
        while success == 0:
            user_input = raw_input("Expected Result2: ")
            try:
                if user_input[0:2] == "0x":
                    val = int(user_input[2:], 16)
                elif user_input[0:2] == "0b":
                    val = int(user_input[2:], 2)
                else:
                    val = int(user_input)
                    if val < 0:
                        val = 2**32 + val
                s = format(val, '032b')
                s = " ".join(s[i:i+4] for i in range(0, len(s), 4))
                f_out.write(s+"\n")
                success = 1
            except ValueError:
                print("Please enter a valid number.")
    else:
        f_out.write(".... .... .... .... .... .... .... ....\n")

print("Tests created. Load your "+name+".X, .Y and .S files into a copy of your alu harness, which you should call '"+name+".circ'.")
print("Move your '"+name+".circ' file into your 'tests' folder.")
print("Add the following line to the list called 'tests' at the end of 'tests/sanity_test.py'")
print("(\""+name+" test\",TestCase(os.path.join(file_locations,'"+name+".circ'), os.path.join(file_locations,'"+name+".out'))),") 
f_X.close()
f_Y.close()
f_S.close()
f_out.close() 
