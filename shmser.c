#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
 

#define SHMSZ     27

int main()
{
    char c;
    int shmid,ch;
    key_t key;
    char *shm, *s;
	int i,n=52;
    /*
     * We'll name our shared memory segment
     * "5678".
     */
    key = 5678;

    /*
     * Create the segment.
     */
    if ((shmid = shmget(key, SHMSZ, IPC_CREAT | 0666)) < 0) {
        perror("shmget");
        return 1;
    }

    /*
     * Now we attach the segment to our data space.
     */
    if ((shm = shmat(shmid, NULL, 0)) == NULL) {
        perror("shmat");
        return 1;
    }
    
   
     while (*shm != '*')
        sleep(1);
    
    printf("Enter your choice \n 1.Method_1 \n 2.Method_2\n");
    scanf("%d",&ch);
        
    s = shm;
 
   s++;
   char m=*s;
  int r;
   n=(int)m;
  
  if (ch == 1)
  {
    r=square(n);
  }
  
  if (ch == 2)
  {
    r=square_m2(n);
  }
    s=shm;
    s++;
    
    int a=1000;
    for (i=0;i<4;i++){
        *s = (char)(r/a+48);
        r=r%a;
        a=a/10;
        s++;
        }
    s = NULL;
    *shm='%';
   
    while (*shm != '$')
        sleep(1);

    return 0;
}

int square_m2(int n)
{
 	int dea , num;
 	dea = n - 10;
 	num = (n + dea)*10;
 	dea = dea*dea;
 	num = num + dea;
 	return num;
}
int square(int n){
	int a,b;
	a=n/10;
	b=n%10;
	int res=a*a*100+a*b*2*10+b*b;
	return res;
}
