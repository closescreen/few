import std.datetime, std.string, std.regex, std.exception, std.conv, std.range, std.range, std.algorithm;



auto strftimeLike(TP)( TP tp, string fmt )
if ( isTimePoint!TP ){
 
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
 
 auto re = regex(`%[FHYmdMS]`,"g");
 
 return fmt.replaceAll!repl(re);
  	
}

auto files(string fmt, I)( I r)
//if ( isTimePoint!TP )
{
 return r.map!( tp=>tp.strftimeLike( fmt ));
}
