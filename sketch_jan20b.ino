#include <LiquidCrystal.h>
LiquidCrystal lcd(2,3,4,5,6,7); //(rs,en,d4,d5,d6,d7)
int c;
int buzzer=13;
void setup() {
  pinMode(buzzer,OUTPUT);
//  pinMode(led,
  digitalWrite(buzzer,LOW);
lcd.begin(16,2);
Serial.begin(9600);
}
void loop() {
  if(Serial.available()){
    c=Serial.read();
    if(c=='A')
    {
      lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(" speed 40 ");
  digitalWrite(buzzer,HIGH);
  delay(2000);
  digitalWrite(buzzer,LOW);
  
    }
    else if(c=='B')
    {
      lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(" go slow ");
    }
    else if(c=='C')
    {
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(" road blocked ");
    }
    else if(c=='D')
    {
      lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(" speed breaker!! ");
    }
    else if(c=='E')
    {
      lcd.clear();
  lcd.setCursor(0,0);
  lcd.print(" Road work ");
    }
  }
}
