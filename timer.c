#include<signal.h>
#include<unistd.h>
#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>
#include<getopt.h>
#include<time.h>
int hour_now,min_now,sec_now;
int totalsec;
int flag=0;
int i=0;
int time_now=0;
int sit=0;

void handler(int signo)
{
   FILE *pp=popen("aplay -q birdsong.wav ","r");
   FILE *p2=popen("./trash_clean.sh -s 50 -p /home/zhangwenjum/alarm2 -t *.png","w");
}
void init_sigaction(void)
{
    struct sigaction tact;
    tact.sa_handler=handler;
    tact.sa_flags=0;
    sigemptyset(&tact.sa_mask);
    sigaction(SIGALRM,&tact,NULL);
}
void init_time(void)
{
    struct itimerval value;
    value.it_value.tv_sec=totalsec;
    value.it_value.tv_usec=0;
    value.it_interval=value.it_value;
    setitimer(ITIMER_REAL,&value,NULL);
        
}
static const struct option long_option[]={
    {"days",optional_argument,NULL,'d'},
    {"hours",optional_argument,NULL,'h'},
    {"mins",optional_argument,NULL,'m'},
    {"secs",optional_argument,NULL,'s'},
    {"time",optional_argument,NULL,'t'},
    {"function",optional_argument,NULL,'f'}
};
int main(int argc,char** argv)
{
    int ttotalsec=0;
    int days=0,hours=0,mins=0,secs=0;
    int daysec=0,hoursec=0,minutesec=0;
    int ch;
    char h[2],m[2],s[2];
    int hour_set=0,min_set=0,sec_set=0;
    time_t timep;
    struct tm *p;
    time(&timep);
    p=localtime(&timep);
    hour_now=p->tm_hour,min_now=p->tm_min,sec_now=p->tm_sec;
    while((ch=getopt_long(argc,argv,"d::h::m::s::t::",long_option,NULL))!=-1)
    {
        switch(ch)
        {
            case 'd':
                days=atoi(optarg);
		        break;
            case 'h':
                hours=atoi(optarg);
                break;
            case 'm':
                mins=atoi(optarg);
                break;
            case 's':
                secs=atoi(optarg);
                break;
            case 't':
                sit=1;
                h[0]=optarg[0];
                h[1]=optarg[1];
                hour_set=atoi(h);
                m[0]=optarg[3];
                m[1]=optarg[4];
                min_set=atoi(m);
                s[0]=optarg[6];
                s[1]=optarg[7];
                sec_set=atoi(s);
                ttotalsec=hour_set*3600+min_set*60+sec_set-hour_now*3600-min_now*60-sec_now;




        }
    }
    daysec=days*86400;
    hoursec=hours*3600;
    minutesec=mins*60;
    if(sit==0)totalsec=daysec+hoursec+minutesec+secs;
    else totalsec=ttotalsec-1;
    init_sigaction();
    init_time();
    while(1)
    {
    };
    return 0;
}
