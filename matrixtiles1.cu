//Matrix multiplication using shared and non shared kernal



#include <stdio.h>

#include <math.h>

#define TILE_WIDTH 2

/*matrix multiplication kernels*/

 //non shared
__global__ void MatrixMul( float *Md , float *Nd , float *Pd , const int WIDTH )
{

           // calculate thread id

           unsigned int col = TILE_WIDTH*blockIdx.x + threadIdx.x ;

           unsigned int row = TILE_WIDTH*blockIdx.y + threadIdx.y ;

         for (int k = 0 ; k<WIDTH ; k++ )
         {
                  Pd[row*WIDTH + col]+= Md[row * WIDTH + k ] * Nd[ k * WIDTH + col] ;
          }
}



// shared
__global__ void MatrixMulSh( float *Md , float *Nd , float *Pd , const int WIDTH )
{

        //Taking shared array to break the MAtrix in Tile widht and fatch them in that array per ele

          __shared__ float Mds [TILE_WIDTH][TILE_WIDTH] ;

           __shared__ float Nds [TILE_WIDTH][TILE_WIDTH] ;

         // calculate thread id
          unsigned int col = TILE_WIDTH*blockIdx.x + threadIdx.x ;
          unsigned int row = TILE_WIDTH*blockIdx.y + threadIdx.y ;
          float Pvalue = 0;
        for (int m = 0 ; m<WIDTH/TILE_WIDTH ; m++ ) // m indicate number of phase
       {
            Mds[threadIdx.y][threadIdx.x] =  Md[row*WIDTH + (m*TILE_WIDTH + threadIdx.x)]  ;
            Nds[threadIdx.y][threadIdx.x] =  Nd[ col+( m*TILE_WIDTH + threadIdx.y) * WIDTH ] ;
           __syncthreads() ; // for syncronizeing the threads


        for (int k = 0; k < TILE_WIDTH; ++k)
        {
                Pvalue += Mds[threadIdx.x][k] * Nds[k][threadIdx.y];
             
        }
       __syncthreads();
       }

         Pd[row*WIDTH + col] = Pvalue;
  }

// main routine
int main ()
{
   const int WIDTH = 6 ;
   float array1_h[WIDTH][WIDTH] ,array2_h[WIDTH][WIDTH],M_result_array_h[WIDTH][WIDTH] ;
   float *array1_d,*array2_d ,*M_result_array_d ; // device array  *result_array_d
   int i , j ;
  //input in host array
  for ( i = 0 ; i<WIDTH ; i++ )
  {
     for (j = 0 ; j<WIDTH ; j++ )
     {
        array1_h[i][j] = 1 ;
        array2_h[i][j] = 2 ;
     }
  }

  //create device array cudaMalloc ( (void **)&array_name, sizeofmatrixinbytes) ;

  cudaMalloc((void **) &array1_d , WIDTH*WIDTH*sizeof (int) ) ;

  cudaMalloc((void **) &array2_d , WIDTH*WIDTH*sizeof (int) ) ;



  //copy host array to device array; cudaMemcpy ( dest , source , WIDTH , direction )

  cudaMemcpy ( array1_d , array1_h , WIDTH*WIDTH*sizeof (int) , cudaMemcpyHostToDevice ) ;

  cudaMemcpy ( array2_d , array2_h , WIDTH*WIDTH*sizeof (int) , cudaMemcpyHostToDevice ) ;



  //allocating memory for resultent device array

 // cudaMalloc((void **) &result_array_d , WIDTH*WIDTH*sizeof (int) ) ;

  cudaMalloc((void **) &M_result_array_d , WIDTH*WIDTH*sizeof (int) ) ;



  //calling kernal

  dim3 dimGrid ( WIDTH/TILE_WIDTH , WIDTH/TILE_WIDTH ,1 ) ;

  dim3 dimBlock( TILE_WIDTH, TILE_WIDTH, 1 ) ;

// Change if 0 to if 1 for running non shared code and make if 0 for shared memory code
#if 0

                MatrixMul<<<dimGrid,dimBlock>>> ( array1_d , array2_d ,M_result_array_d , WIDTH) ;

#endif

#if 1

               MatrixMulSh<<<dimGrid,dimBlock>>> ( array1_d , array2_d ,M_result_array_d , WIDTH) ;

#endif

  // all gpu function blocked till kernel is working
  //copy back result_array_d to result_array_h

  cudaMemcpy(M_result_array_h , M_result_array_d , WIDTH*WIDTH*sizeof(int),cudaMemcpyDeviceToHost) ;

cudaFree(array1_d);
cudaFree(array2_d);
//cudaFree(result_array_d);
cudaFree(M_result_array_d);

  //printf the result array
  for ( i = 0 ; i<WIDTH ; i++ )
  {
      for ( j = 0 ; j < WIDTH ; j++ )
     {
        printf ("%f   ",M_result_array_h[i][j] ) ;
     }
 printf ("\n") ;
}
cudaFree(M_result_array_h);
 //system("pause") ;
}
