break getbuf
break Gets
run -u linuxer
print /a $ebp+4
print /a *(void**)($ebp+4)
print /a *(void**)$ebp
continue
print /a *(void**)($ebp+8)
quit
