#include <stdio.h>
#include <iostream>
#define MAX_THREADS 128

using namespace std;
const int threshold =25;

__global__ void bubble_sort(int *a, int left, int right)
{
	int temp;
	 for(int i=left;i<right;i++)
    	for(int j=i+1;j<=right;j++)
    		if(a[i]>a[j])
    		{
    			temp=a[i];
    			a[i]=a[j];
    			a[j]=temp;
    		}
}
__global__ void partition(int *a,int left,int right,int pivot,int *al,int *ah)
{
	int l,h;
	int size=(right-left+1);
	int k1=threadIdx.x*size+left;
	int k2=k1+size-1;

	if(threadIdx.x==MAX_THREADS-1)
		k2=right;
	l=h=k1;
	for(int i=k1;i<=k2;i++)
		{
			al[i]=ah[i]=-999;
		}
	for(int i=k1;i<=k2;i++)
	{
		if(a[i]<pivot)
		{
			al[l++]=a[i];
		}
		else
		{
			if(a[i]>pivot)
			{
				ah[h++]=a[i];
			}
		}
	}
}

void quicksort(int *a, const int left, const int right)
{
    
    if (right-left <= threshold)
    {
    	int *ad;
    	cudaMalloc((void **)&ad,(right-left+1)*sizeof(int));
    	cudaMemcpy(ad,a,(right-left+1)*sizeof(int),cudaMemcpyHostToDevice);
        bubble_sort<<<1,1>>>(ad, left, right);
        cudaMemcpy(a,ad,(right-left+1)*sizeof(int),cudaMemcpyDeviceToHost);
        return;
    }
    int pivot = a[left];
    int size = (right-left+1)*sizeof(int);
    int *al,*ah,*ad;

    cudaMalloc((void **)&ad,size);
    cudaMalloc((void **)&al,size);
    cudaMalloc((void **)&ah,size);
    cudaMemcpy(ad,a,size,cudaMemcpyHostToDevice);
    
    partition<<<1,MAX_THREADS>>>(ad,left,right,pivot,al,ah);
    int al_h[right-left+1],ah_h[right-left+1];
    cudaMemcpy(al_h,al,size,cudaMemcpyDeviceToHost);
    cudaMemcpy(ah_h,ah,size,cudaMemcpyDeviceToHost);
    int i=0,k=0;
    while(i<right-left+1)
    {
    	while(al_h[i]==-999 && i<right-left+1)
    			i++;
    	while(al_h[i]!=-999 && i<right-left+1)
    	{
    		al_h[k++]=al_h[i++];
    	}
    }
    
    quicksort(al_h,0,k-1);
    int p=left;
    int x=0;

        while(x<k)
        {
        	a[p++]=al_h[x++];

        }
        a[p]=pivot;
    	i=0;
    	k=0;
    while(i<right-left+1)
    {
      	while(ah_h[i]==-999 && i<right-left+1)
    		i++;
       	while(ah_h[i]!=-999 && i<right-left+1)
       	{
       		ah_h[k++]=ah_h[i++];
       	}
    }
    quicksort(ah_h,0,k-1);
    i=0;
    p++;
        while(i<k)
        {
        	a[p++]=ah_h[i++];
        }
}
int main()
{
	int len,x,flag,choice;
	cout<<"ENTER SIZE OF ARRAY :"<<endl;
	cin>>len;
	int input_data[len];
	cout<<"*********** MENU ***************"<<endl;
	cout<<"1. INPUT USER DATA "<<endl;
	cout<<"2. RANDOM GENERATOR "<<endl;
	cout<<"ENTER YOUR CHOICE.......... "<<endl;
	cin>>choice;
	switch(choice)
	{
		case 1:
			for (int i = 0 ; i < len ; i++)
    			{
				cout<<"ENTER ELEMENTS :" <<endl;
				cin>>input_data[i];
			}
    			cout<<"ORIGINAL ARRAY :"<<endl;
			for(int i=0;i<len;i++)
				cout<<input_data[i]<<"\t";
			cout<<endl;
    			quicksort(input_data,0,len-1);
    			cout<<"AFTER SORTING "<<endl;
			for(int i=0;i<len;i++)
	        		cout<<input_data[i]<<"\t";
			cout<<endl;
			break;
		case 2:
			for (int i = 0 ; i < len ; i++)
    			{

				    x=rand()%len;
    				    flag=0;
    				for(int j=0;j<i;j++)
    				{
    					if(input_data[j]==x)
    					{
    						i--;
    						flag=1;
    						break;
    					}
    				}
    				if(flag==0)
    				input_data[i]=x;
			}
    			cout<<"ORIGINAL ARRAY :"<<endl;
			for(int i=0;i<len;i++)
				cout<<input_data[i]<<"\t";
			cout<<endl;

    			quicksort(input_data,0,len-1);
    			cout<<"AFTER SORTING "<<endl;
			for(int i=0;i<len;i++)
	        		cout<<input_data[i]<<"\t";
			cout<<endl;
			break;
	}
return 0;
}

