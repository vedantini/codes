#include<stdio.h>
#include<omp.h>
#include<string.h>
int main(int argc, char **argv)
{
	omp_set_num_threads(1);
	#pragma omp parallel
	{
		int tid=omp_get_thread_num();
		char inst[100];
		strcpy(inst,"./yacc_file ");
		//if(tid == 0)
			strcat(inst,argv[tid+1]);
		//else
			//strcat(inst,argv[tid]);
		system(inst);
	}
}
