import std.datetime, std.string, std.regex, std.exception, std.conv, std.range, std.range, std.algorithm;
/+
Форматирование резличных типов данных в строки с помощью задания формата
+/

///
auto toMyString(string fmt, TP)( TP tp )
if ( isTimePoint!TP )
{
 string repl( Captures!(string) m ){
  switch (m[0])
  {
	case "%F": return tp.date.toISOExtString;
	case "%H": return "%02d".format( tp.hour );
	case "%Y": return "%d".format( tp.year);
	case "%m": return "%02d".format( tp.month );
	case "%d": return "%02d".format( tp.day );
	case "%M": return "%02d".format( tp.minute );
	case "%S": return "%02d".format( tp.second );
	default: return m[0];
  }
 }
 
 static auto re = regex(`%[FHYmdMS]`,"g");
 return fmt.replaceAll!repl(re);
}

///
unittest{
 assert( DateTime(2017,05,22,19,45,55).strfDateTime("date:%F hour:%H min/sec:%M/%S") == "date:2017-05-22 hour:19 min/sec:45/55" );
}

///
auto ff(string fmt, IR )( IR r)
if ( isInputRange!IR && isTimePoint!(typeof(r.front)) )
{
 return r.map!( tp=>tp.toMyString!fmt );
}

