break getbufn
break Gets
run -n -u linuxer
print /a $ebp+8
print /a $ebp+4
print /a *(void**)($ebp+4)
print /a *(void**)$ebp
continue
print /a *(void**)($ebp+8)
quit
