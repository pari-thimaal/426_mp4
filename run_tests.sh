#!/bin/bash

# test_allocator.sh
# Tests register allocator on all .ll files in tests/

for llfile in tests/*.ll; do
    # Get base name without extension
    basename=$(basename "$llfile" .ll)
    
    echo "================================"
    echo "Testing: $basename"
    echo "================================"
    
    # Step 1: Run llc with simple register allocator
    echo "Running llc..."
    llc -O0 -regalloc=simple -stats "$llfile" -o "tests/${basename}.s"
    
    # Step 2: Compile with gcc
    echo "Compiling with gcc..."
    gcc "tests/${basename}.s" -o "tests/${basename}"
    
    # Step 3: Run executable
    echo "Running executable..."
    "./tests/${basename}"
    
    # Step 4: Print exit code
    echo "Exit code: $?"
    echo ""
done