import std.datetime, std.string, std.regex, std.exception, std.conv, std.range;

///
auto ymdh(T)(T time ) 
if( is(typeof(time)==SysTime) || is(typeof(time)==DateTime))
{
  with(time){ minute=0; second=0; }
  return time;
}
///
unittest{
 assert( DateTime(2017,05,15,4,7,8).ymdh == DateTime(2017,05,15,4,0,0) );
}

///
auto ymdh(){
 return Clock.currTime.ymdh;
}

///
auto ymdh(string ymdh){
  auto r = r".*(\d{4})\D(\d{2})\D(\d{2})\D(\d{2})";
  auto m = matchFirst( ymdh, regex( r ));
  if (m) return DateTime( m[1].to!int, m[2].to!int, m[3].to!int, m[4].to!int, 0, 0 );
  else throw new DateTimeException( format( "Can't parse %s with %s", ymdh, r));
}

///
unittest{
 assert( "../RESULT/2017-05-15/22.gz".ymdh == DateTime(2017,5,15,22,0,0) );
}

///
auto ymd(T)(T time ) 
if( is(typeof(time)==SysTime) || is(typeof(time)==DateTime))
{
  with(time){ hour=0; minute=0; second=0; }
  return time;
}
///
unittest{
 assert( DateTime(2017,05,15,4,7,8).ymd == DateTime(2017,05,15,0,0,0) );
}

///
auto ymd(){
 return Clock.currTime.ymd;
}

///
auto ymd(string ymd){
  auto r = r".*(\d{4})\D(\d{2})\D(\d{2})";
  auto m = matchFirst( ymd, regex( r ));
  if (m) return DateTime( m[1].to!int, m[2].to!int, m[3].to!int, 0, 0, 0 );
  else throw new DateTimeException( format( "Can't parse %s with %s", ymd, r));
}

///
unittest{
 assert( "../RESULT/2017-05-15.gz".ymd == DateTime(2017,5,15,0,0,0) );
}

///
auto lasts(TP)(TP tp, Duration dur){ 
 return Interval!TP( tp, dur );
}

