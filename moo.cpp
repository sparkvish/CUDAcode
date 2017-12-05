/*	C++ Program to manipulate images
 *  By Vishwas S
 *  sparkvish1@gmail.com
 *  Don't flicketh without due credit.
 */
 
 #include<stdio.h>
 #include<stdlib.h>
 #include<math.h>
 #define STB_IMAGE_IMPLEMENTATION
 #define STB_IMAGE_WRITE_IMPLEMENTATION
 #include "stb_image.h"
 #include "stb_image_write.h"
 
 typedef unsigned char rawbyte;
 
 rawbyte* loadImage(const char *filename, int width, int height, int bitsperpixel)
 {
	rawbyte* image = stbi_load(filename,&width,&height,&bitsperpixel,3);
	return image;
 }
 
 void writeImage(rawbyte* image,const char *filename, int width, int height, int bitsperpixel, int channels)
 {
	stbi_write_png(filename,width,height,channels,image,width*channels);
 }
 
 
 int main(int argc, char **argv)
 {
	int width, height, n = 3;  //WORKS WITH ONLY RGB
	scanf("%d%d",&width,&height);
	 
	rawbyte *in, *out;
	out = (rawbyte *)malloc(width*height*n);
	long i;
	in = loadImage("input.png",width,height,n);
	
	for( i = 0; i<width*height*n-3; i++)
		out[i] = out[i+1] = out[i+2] = (in[i]+in[i+1]+in[i+2])/3;
	
	writeImage(out,"output.png",width,height,n,3);
 
 }
