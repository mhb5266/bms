    //float temp=0;
    //char i=0;
    //char a=0;
    //char buffer[16];

    char c=1,i;
    //char j=250;
    char _hour=0,_min=0,_sec=0,_wday,_year,_month,_day;
    int sh_year;
    char _weekday[7][4]={{"Sat"},{"Sun"},{"Mon"},{"Tue"},{"Wed"},{"Thu"},{"Fri"}};
    char lastsec=0,strsec[12];

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
    char lsec,str[10],state=0,buffer[16];
    float temp;
    unsigned char ds1820_rom_codes[MAX_DS1820][9]; 
    
    char outs[9];
    
    eeprom char onhour=15,offhour=15,onmin=45,offmin=47,edays;
 /*
    struct outs{
        bit chiller;
        bit heateng;
        bit motor;
        bit non3;
        bit non4;
        bit non5;
        bit non6;
        bit non7;      
    }     
 */
 
 

        bit motor;
        bit heateng;
        bit chiller;
        bit non3;
        bit non4;
        bit non5;
        bit non6;
        bit non7; 
        
        bit heaters,coolers;                                                

        

   
    #include "logo.c"
    #include "snow.c"
    #include "settingicon2.c"
    #include "heater.c"
    #include "cooler.c"
    #include "sheater.c"
    #include "scooler.c"    
    #include "days.c"
    #include "clock.c" 