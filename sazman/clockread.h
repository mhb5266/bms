void readclock(void){          
          //glcd_clear();
          //delay_ms(1000);
          rtc_init(0,0,0);
          rtc_get_time(&_hour,&_min,&_sec);
          sprintf(strsec,"%02d:%02d:%02d",_hour,_min,_sec);
          //if(PIND.5==0){
          lcd_gotoxy(0,1);
          lcd_puts(strsec); 
          rtc_get_date(&_wday,&_day,&_month,&_year);
          //_wday--;
          sh_year=_year+1400;
          sprintf(strsec,"%4d/%02d/%02d",sh_year,_month,_day);
          lcd_gotoxy(0,0);
          lcd_puts(strsec); 
          //_weekday[]="s";     
          //if (_sec==2) a^;
          //glcd_display(a);
          if (_wday>6)_wday=0;
          strcpy(strsec,_weekday[_wday]);
          lcd_gotoxy(11,0);
          lcd_puts(strsec);
 
          

                          
          //if (state=="cooler")glcd_putimagef(0,32,scooler,1);
          //if (state=="heater")glcd_putimagef(0,32,sheater,1);
}          