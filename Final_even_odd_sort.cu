#include <stdio.h>
#include <cuda.h>



    __global__ void testKernel(int *in, int *out, int size)

    {

    bool oddeven=true;

    __shared__ bool swappedodd;

    __shared__ bool swappedeven;
    int temp,i,rem1;

    swappedodd=true;

    swappedeven=true;


    while(true)

    {

    if(oddeven==true)

    {

	     __syncthreads();

	     swappedodd=false;

	     __syncthreads();

	     if (threadIdx.y == 0) {

	      int idx=threadIdx.x;
	     if(idx<(size/2))

	  {

	   if (in[2*idx]>in[2*idx+1])

	   {

	   // swap(in[],in[2*idx+1]);
		temp= in[2*idx];
	    	      	   in[2*idx]=in[2*idx+1];
	    	      	   in[2*idx+1]=temp;
	    swappedodd=true;

	   }

	  }

	 }


	 __syncthreads();

    }

    else

    {

	     __syncthreads();

	     swappedeven=false;

	     __syncthreads();

	     if (threadIdx.y == 0) {

	      int idx=threadIdx.x;
	       if(idx<(size/2)-1)

	  {

	   if (in[2*idx+1]>in[2*idx+2])

	   {

	  //  swap(in[2*idx+1],in[2*idx+2]);
		temp= in[2*idx+1];
	    	      	   in[2*idx+1]=in[2*idx+2];
	    	      	   in[2*idx+2]=temp;
	    swappedeven=true;

	   }

	  }


	}

     __syncthreads();

    }

    if(!(swappedodd||swappedeven))

      break;

    oddeven=!oddeven;//switch mode of sorting

    }



    __syncthreads();



    int idx=threadIdx.x;

    if ( idx <size )

    out[idx]=in[idx];

    }


int main(void)
{
	int *a,*a_sorted,i;
	int *d_a,*d_sorted;
	int n=20;
	int size = sizeof(int)*n;

	cudaMalloc((void**)&d_a,size);
	cudaMalloc( (void**)&d_sorted, size);

   a=(int*)malloc(size);
   a_sorted=(int*)malloc(size);


	cudaMalloc((void**)&d_sorted, size);

	printf("enter the unsorted numbers\n");
	for(i=0;i<n;i++)
	{
		scanf("%d",&a[i]);

	}

	cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);



	testKernel<<<1,n>>>(d_a, d_sorted,n);

	cudaMemcpy(a, d_a, size, cudaMemcpyDeviceToHost);


	cudaMemcpy(a_sorted, d_sorted, size, cudaMemcpyDeviceToHost);
	for (i=0;i<n;i++)
		{

		printf("%d",a_sorted[i]);
		printf("\t");

		}

free(a);

free(a_sorted);
cudaFree(d_sorted);
cudaFree(d_a);
}

