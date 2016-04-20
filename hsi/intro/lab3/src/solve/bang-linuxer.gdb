break getbuf
break Gets
run -u linuxer
print /a $ebp+4
continue
print /a *(void**)($ebp+8)
print /a (void*)bang
print /a (void*)&global_value
quit
