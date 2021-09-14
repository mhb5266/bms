
void changeclock(void){
        j=0;
        selection=1;
        delay_ms(50);
        if(menu==0){
            glcd_clear();
            while(menu==0){
            } 
            while(1){
                delay_ms(50);
                j++;
                if (j==10){
                    blank=!blank;
                    j=0;
                } 
                strcpyf(str,"          ");
                sh_year=1400+_year;
                if (selection==1 & blank==0)sprintf(str,"%04d/",sh_year);
                else if(selection==1 & blank==1) strcpyf(str,"    ");
                else if(selection!=1) sprintf(str,"%04d/",sh_year);
                lcd_gotoxy(0,0);
                lcd_puts(str);

                if (selection==2 & blank==0)sprintf(str,"%02d/",_month);
                else if(selection==2 & blank==1) strcpyf(str,"  ");
                else if(selection!=2) sprintf(str,"%02d/",_month);
                lcd_gotoxy(5,0);
                lcd_puts(str);
                
                if (selection==3 & blank==0)sprintf(str,"%02d",_day);
                else if(selection==3 & blank==1) strcpyf(str,"  ");
                else if(selection!=3) sprintf(str,"%02d",_day);
                lcd_gotoxy(8,0);
                lcd_puts(str);
                
                if (selection==4 & blank==0) strcpy(str,_weekday[_wday]);
                else if(selection==4 & blank==1) strcpyf(str,"   ");
                else if(selection!=4)strcpy(str,_weekday[_wday]);
                lcd_gotoxy(11,0);
                lcd_puts(str);
                //sprintf(str,"%02d",_wday);
                //lcd_gotoxy(11,1);
                //lcd_puts(str);
                
                if (selection==5 & blank==0)sprintf(str,"%02d:",_hour);
                else if(selection==5 & blank==1) strcpyf(str,"  ");
                else if(selection!=5) sprintf(str,"%02d:",_hour);
                lcd_gotoxy(0,1);
                lcd_puts(str);                
                
                if (selection==6 & blank==0)sprintf(str,"%02d:",_min);
                else if(selection==6 & blank==1) strcpyf(str,"  ");
                else if(selection!=6) sprintf(str,"%02d:",_min);
                lcd_gotoxy(3,1);
                lcd_puts(str);                                                
                
                if (selection==7 & blank==0)sprintf(str,"%02d",_sec);
                else if(selection==7 & blank==1) strcpyf(str,"  ");
                else if(selection!=7) sprintf(str,"%02d",_sec);
                lcd_gotoxy(6,1);
                lcd_puts(str);   
                              
                if(up==0) {
                    delay_ms(150);
                    if(up==0) {
                        blank=0;
                        j=0;
                        if(selection==1)_year++;
                        if(selection==2)_month++;
                        if(selection==3)_day++;
                        if(selection==4)_wday++;
                        if(selection==5)_hour++;
                        if(selection==6)_min++;
                        if(selection==7)_sec++;
                    }    
                }  
                
                if(down==0) {
                    delay_ms(150);
                    if(down==0) {
                        blank=0;
                        j=0;                    
                        if(selection==1) _year--;
                        if(selection==2)_month--;
                        if(selection==3)_day--;
                        if(selection==4)_wday--;
                        if(selection==5)_hour--;
                        if(selection==6)_min--;
                        if(selection==7)_sec--;                        
                    }    
                }  
                
                if (_year>99 & _year<101)_year=0;
                if (_year>101)_year=99;
                
                if (_month>12 & _month<14)_month=1;
                if (_month>14 )_month=12;
                
                if (_day>30 & _day<32)_day=0;
                if (_day>32)_day=31;
                
                if (_wday>6 & _wday<8) _wday=0;
                if (_wday>8)_wday=6;
                
                if (_hour>23 & _hour<25)_hour=0;
                if (_hour>25)_hour=23;
                
                if (_min>59 & _min<61)_min=0;
                if (_min>61)_min=59;
                
                if (_sec>59 & _sec<61)_sec=0;
                if (_sec>61)_sec=59;
                
                
                
                if(menu==0) {
                    do{
                    delay_ms(25);           
                    }
                    while(menu==0);
                        selection++;
                        if(selection==8){
                           //rtc_init(0,0,0);
                           delay_ms(100);
                           rtc_set_time(_hour,_min,_sec);
                           delay_ms(100);
                           rtc_set_date(_wday,_day,_month,_year);
                           glcd_clear();
                           lcd_puts("all saved");
                           delay_ms(3000);     
                           glcd_clear();
                           
                           break;
                        }                        
                }                                                                                                                                
            }
        }
}        