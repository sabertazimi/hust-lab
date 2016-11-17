## File API notes

### realease

```bash
#!/bin/bash
# only work in bash(not work in sh)
read -s -p "[ sudo ] input $(whoami)'s password: " password
echo $password | sudo -S cp -fr ./bin/lsr /usr/local/bin/lsr
```
