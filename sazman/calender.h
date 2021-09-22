char readcalender(char year){
    char kabise,esfand=29,day;
    
    kabise=_year%33;
    if (kabise==1||kabise==5||kabise==9||kabise==13||kabise==17||kabise==22||kabise==26||kabise==30){
        esfand=30;
        kabise=1;
    }
    else {
        esfand=29;
        kabise=0;    
    }       
    
}