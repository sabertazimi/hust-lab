# Example of hand-generated assembly code

        push $0xabcdef          # Push value onto stack
        add   $17,%eax          # Add 17 to %eax
        .align 4                # Following will be aligned on multiple of 4
        .long   0xfedcba98      # A 4-byte constant
