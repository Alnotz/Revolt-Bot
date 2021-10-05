#!/usr/bin/env/ python3
#NOTE : pour cURL et la partie Python
#```bash
#sudo apt install curl
#pip install py-ulid
#```
from ulid import ULID
ulid = ULID()
print(ulid.generate())
