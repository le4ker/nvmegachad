#include <stdio.h>
#include "greeter.h"
int main(void){
int unused;
    const char *names[]={"Ada","Linus","Grace"};
for(int i=0;i<3;i++){ char buf[64]; greet(names[i],buf,sizeof buf); printf("%s\n",buf);}
return 0;}
