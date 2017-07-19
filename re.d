/+ 
регексы
+/
import std.regex;


template ymd( string standart = "ISOExt" ){
 static if (standart=="ISOExt"){
  auto ymd(){
   return ctRegex!(`(?P<year>\d{4})\D(?P<month>\d\d)\D(?P<day>\d\d)`);
  }
 }
}

template ymdh( string standart = "ISOExt" ){
 static if (standart=="ISOExt"){
  auto ymdh(){
   return ctRegex!(`(?P<year>\d{4})\D(?P<month>\d\d)\D(?P<day>\d\d)\D(?P<hour>\d\d)`);
  }
 }
}


//auto day(string sep) = ctRegex!(`(\d{4})\D(\d\d)\D(\d\d)`);


