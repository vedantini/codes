/*
 * narysearch.c
 *
 *  Created on: 01-Jan-2015
 *      Author: sumitra
 */


#include<stdio.h>
#include<omp.h>
#include<sched.h>
//#include<timer.h>
int a[30],s,test;
int global_size,global_x,n=4;

void nary_search(int,int);
void seq_search(int);
int main()
{
	int i,size=30,x=0;

	for(i=0;i<size;i++)
	a[i]=i*2;
	printf("Enter number to be searched\n");
	scanf("%d",&s);
	/*intf("enter the number of threads used\n");
	/*scanf("%d",&n)*/

	nary_search(size,x);
	return 0;
}

void nary_search(int size,int x)
{
	printf("size = %d\n",size);
	if(size<=2)
	{

		test=0;
		#pragma omp parallel
		{
			int tid=omp_get_thread_num();
			printf("%d",global_x);
			if(a[global_x+tid]==s)
			{

				printf("found at %d\n",global_x+tid);
				test=1;
			}
		}

		if(test==0)
		{

			printf("not found\n");
		}
	}
	else
	{
		test=0;
		#pragma omp parallel
		{
			int tid=omp_get_thread_num();
			printf("checking (%d --  %d)with thread %d on cpu %d \n",a[tid*size/n+x],a[tid*size/n+size/n-1+x],tid,sched_getcpu());
			if(s>=a[tid*size/n+x] && s<=a[tid*size/n+size/n-1+x])
			{
				printf("may be here  %d ---- %d  size=(   %d   )\n",a[tid*size/n+x],a[tid*size/n+size/n-1+x],+size/n);
				global_size=size/n;
				global_x=tid*global_size+x;
				test=1;
			}
		}
		if(test==1)
			nary_search(global_size,global_x);
		else
			printf("not found in");
	}
}
/*==========OUTPUT==============
trax@trax-Inspiron-3520:~/Desktop$ gcc -fopenmp narysearch.c 
trax@trax-Inspiron-3520:~/Desktop$ ./a.out
Enter number to be searched
40
size = 30
checking (44 --  56)with thread 3 on cpu 0 
checking (30 --  42)with thread 2 on cpu 3 
may be here  30 ---- 42  size=(   7   )
checking (0 --  12)with thread 0 on cpu 0 
checking (14 --  26)with thread 1 on cpu 1 
size = 7
checking (28 --  28)with thread 0 on cpu 0 
checking (30 --  30)with thread 1 on cpu 1 
checking (34 --  34)with thread 2 on cpu 3 
checking (38 --  38)with thread 3 on cpu 2 
not found */
