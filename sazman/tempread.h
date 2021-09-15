void readtemp(){
//unsigned char address;
//ftemp=ds18b20_temperature(address);
      a=w1_init();
      ds1820_devices=w1_search(0xf0,ds1820_rom_codes);      
      if (a>0) {      
        temp=ds18b20_temperature(0);

      }
              //sprintf(str,"%2.1f%`C",temp);
              //lcd_gotoxy(10,1);
              //lcd_puts(str);
//return ftemp;
}