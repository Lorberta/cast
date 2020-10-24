#!/usr/bin/env bash

# Step 1:
docker build --tag=lorberta/cast .

# Step 2: 
docker image ls

# Step 3: 
# docker run -it mymikutestlocal bash
docker run -p 8000:80 -d lorberta/cast
