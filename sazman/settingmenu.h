void menusetting(void){


        j=0;
        selection=1;
        delay_ms(50);
            glcd_clear();
            while(menu==0){
            } 
            
            while(1){ 
            
                if (onhour>23 & onhour<25)onhour=0;
                if (onhour>25)onhour=23;
                
                if (onmin>59 & onmin<61)onmin=0;
                if (onmin>61)onmin=59;

                if (offhour>23 & offhour<25)offhour=0;
                if (offhour>25)offhour=23;
                
                if (offmin>59 & offmin<61)offmin=0;
                if (offmin>61)offmin=59; 
                            
                delay_ms(50);
                j++;
                if (j==10){
                    blank=!blank;
                    j=0;
                } 
                strcpyf(str,"ON  >>");
                lcd_gotoxy(0,0);
                lcd_puts(str);
                if (selection==1 & blank==0)sprintf(str,"%02d:",onhour);
                else if(selection==1 & blank==1) strcpyf(str,"  ");
                else if(selection!=1) sprintf(str,"%02d:",onhour);
                lcd_gotoxy(7,0);
                lcd_puts(str);

                if (selection==2 & blank==0)sprintf(str,"%02d",onmin);
                else if(selection==2 & blank==1) strcpyf(str,"  ");
                else if(selection!=2) sprintf(str,"%02d",onmin);
                lcd_gotoxy(10,0);
                lcd_puts(str);
                
                //sprintf(str,"%02d",_wday);
                //lcd_gotoxy(11,1);
                //lcd_puts(str);
                strcpyf(str,"Off >>");
                lcd_gotoxy(0,1);
                lcd_puts(str);                
                if (selection==3 & blank==0)sprintf(str,"%02d:",offhour);
                else if(selection==3 & blank==1) strcpyf(str,"  ");
                else if(selection!=3) sprintf(str,"%02d:",offhour);
                lcd_gotoxy(7,1);
                lcd_puts(str);                
                
                if (selection==4 & blank==0)sprintf(str,"%02d",offmin);
                else if(selection==4 & blank==1) strcpyf(str,"  ");
                else if(selection!=4) sprintf(str,"%02d",offmin);
                lcd_gotoxy(10,1);
                lcd_puts(str);                                                
                  
                              
                if(up==0) {
                    delay_ms(150);
                    if(up==0) {
                        blank=0;
                        j=0;
                        if(selection==1)onhour++;
                        if(selection==2)onmin++;
                        if(selection==3)offhour++;
                        if(selection==4)offmin++;

                    }    
                }  
                
                if(down==0) {
                    delay_ms(150);
                    if(down==0) {
                        blank=0;
                        j=0;                    
                        if(selection==1) onhour--;
                        if(selection==2)onmin--;
                        if(selection==3)offhour--;
                        if(selection==4)offmin--;
                                                               
                    }    
                }  
                          
                                      
                if(menu==0) {
                    do{
                    blank=0;
                    delay_ms(25);           
                    }
                    while(menu==0);
                        selection++;
                        if(selection==5){
                           glcd_clear();
                           lcd_puts("all saved");
                           delay_ms(3000);     
                           glcd_clear();
                           
                           break;
                        }                        
                }                                                                                                                                
            }
       
}