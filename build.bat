@echo off

odin run . -debug -keep-executable -sanitize=address -show-timings -vet-shadowing
rem odin run . -debug -keep-executable -show-timings -vet-shadowing 
rem odin run . -o:speed -show-timings -vet-shadowing
