# CUDAcode
A bunch of programs to work with CUDA for beginners.

This repository has a few programs, mainly dealing with images, in CUDA to work with, for beginners who are learning to parallelize with GPUs.
The reason I wrote these programs was because it was hard to find programs for CUDA, which worked on parallelizing image manipulation algorithms, without having to install a library like OpenCV.

This code uses stbi_image and stbi_image_write, which are single file libraries by Sean Barret, and can be downloaded here: https://github.com/nothings/stb

There are kernels for the following functions:
 1. Color to greyscale 
 2. Color to Sepia Tone
 3. Color to negative
 
I will add more when I find time to do so, and hope this repository helps a few people who are trying to learn CUDA programming
