/*	CUDA Program to manipulate images
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
 
 //Converts image to grayscale
 __global__ void grayscale(rawbyte* image, rawbyte* grey, int width, int height)
 {
	int col = blockIdx.x*blockDim.x + threadIdx.x;
	int row = blockIdx.y*blockDim.y + threadIdx.y;
	
	int id = row * gridDim.y*blockDim.y + col;
	
	if(id < (width*height -2))
	{
		double t = (0.144*image[id]+0.587*image[id+1]+0.299*image[id+2])/3.0;
		grey[id] = grey[id+1] = grey[id+2] = (rawbyte) t; 
	}
	 
	 
 }
 //Converts image to Sepia Tone
 __global__ void sepia(rawbyte* image, rawbyte* grey, int width, int height)
 {
	int x = blockIdx.x*blockDim.x + threadIdx.x;
	int y = blockIdx.y*blockDim.y + threadIdx.y;
	
	int id = y * gridDim.x*blockDim.x + x;
	
	if(x < width && y < height && id < (width*height))
	{
		double r = (0.393*image[id]+0.769*image[id+1]+0.189*image[id+2]);
		double g = (0.349*image[id]+0.686*image[id+1]+0.168*image[id+2]);
		double b = (0.272*image[id]+0.534*image[id+1]+0.131*image[id+2]);
		grey[id] = (rawbyte)r;
		grey[id+1] = (rawbyte)g;
		grey[id+2] = (rawbyte) b; 
	}
	 
	 
 }
 Converts image to negative
 __global__ void negative(rawbyte* image, rawbyte* grey, int width, int height)
 {
	int x = blockIdx.x*blockDim.x + threadIdx.x;
	int y = blockIdx.y*blockDim.y + threadIdx.y;
	
	int id = y * gridDim.x*blockDim.x + x;
	
	if(id<(width*height*3-2))
	{
		
		grey[id] = 255-image[id];
		grey[id+1] = 255 - image[id+1];
		grey[id+2] =  255-image[id+2];
	}
	 
}
 
//Aux function to load an image. 
 rawbyte* loadImage(const char *filename, int width, int height, int bitsperpixel)
 {
	rawbyte* image = stbi_load(filename,&width,&height,&bitsperpixel,3);
	return image;
 }

//Aux fn to save an image
 void writeImage(rawbyte* image,const char *filename, int width, int height, int bitsperrpixel, int channels)
 {
	stbi_write_png(filename,width,height,channels,image,width*channels);
 }
 
 
 int main(int argc, char **argv)
 {
	int width, height, n = 3;  //WORKS WITH ONLY RGB: TODO, modify ASAP for sRGB
	scanf("%d%d",&width,&height);
	 
	rawbyte *in, *out, *din, *dout;
	if(argc != 2)
	{
		printf("Usage:\t<executable> <input image>\n");
		exit(-1);
	}
	in = loadImage(argv[1],width,height,n);
	out = (rawbyte*)malloc(n*width*height*sizeof(rawbyte));
	cudaMalloc((void**) &din, width*height*n);
	cudaMalloc((void**) &dout, width*height*n);
 	cudaMemcpy(din, in, width*height*n*sizeof(rawbyte), cudaMemcpyHostToDevice);
 	dim3 block(16,16);
 	dim3 grid((width+1)/16,(height+1)/16);
 	grayscale<<<grid,block>>>(din, dout, width, height);
 	cudaMemcpy(out, dout, width*height*n*sizeof(rawbyte), cudaMemcpyDeviceToHost);
 	writeImage(out,"output.png",width,height,n,3);
 
	cudaFree(din);
	cudaFree(dout);
 }
