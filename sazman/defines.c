    //float temp=0;
    //char i=0;
    //char a=0;
    //char buffer[16];

    char c=1;
    //char j=250;
    char _hour=0;
    char _min=0;
    char _sec=0;
    char _wday,_year,_month,_day;
    int sh_year;
    char _weekday[7][4]={{"Sat"},{"Sun"},{"Mon"},{"Tue"},{"Wed"},{"Thu"},{"Fri"}};
    char lastsec=0;
    char strsec[12];
    bit a=1;

    //#define led1 PORTD.6;

    #define led PORTD.6
    #define up PIND.5
    #define down PIND.4
    #define menu PIND.3

    typedef unsigned char byte;
    typedef unsigned int  word;
    

           
    bit blank=false,issame;
    byte selection,j;
    char lsec,str[10],state[7]="cooler"; 
    
    #include "logo.c"
    #include "snow.c"
    #include "settingicon2.c"
    #include "heater.c"
    #include "cooler.c"
    #include "sheater.c"
    #include "scooler.c"    