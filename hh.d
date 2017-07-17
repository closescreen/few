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
unittest{
assert( ymdh == Clock.currTime.ymdh );
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
auto lasts(TP)(TP tp, Duration dur)
if (isTimePoint!TP)
{ 
 return Interval!TP( tp, dur );
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours) == Interval!DateTime(DateTime(2017,05,15,4,0,0), 2.hours) );
}

///
auto lasts( TP1, TP2 )( TP1 tp1, TP2 tp2 )
if ( isTimePoint!TP1 && isTimePoint!TP2 )
{
 return tp1<tp2 ? Interval!TP1( tp1, tp2 ) : Interval!TP1( tp2 , tp1 );
}

///
unittest{
 assert( "2017-07-18T04".ymdh.lasts( "2017-07-18T02".ymdh ) == Interval!DateTime( "2017-07-18T04".ymdh, 2.hours) );
}

///
auto hh(Direction d, I)( I i)
if (d != Direction.both)
{
 static if (d==Direction.fwd)
  return i.fwdRange( h=>h+1.hours );
 else 
  return i.bwdRange( h=>h-1.hours );
}

///
unittest{
 assert( Interval!DateTime( DateTime( 2017,05,15,4,0,0 ), 2.hours).hh == 
  Interval!DateTime(DateTime(2017,05,15,4,0,0), 2.hours).fwdRange(h=>h+1.hours) );
}

///
auto hh(string d = "fwd", I)( I i)
if (d == "fwd" || d == "bwd")
{
 static if (d=="fwd")
  return i.fwdRange( h=>h+1.hours );
 else 
  return i.bwdRange( h=>h-1.hours );
}

///
unittest{
 assert( Interval!DateTime( DateTime( 2017,05,15,4,0,0 ), 2.hours).hh!"bwd" == 
  Interval!DateTime(DateTime(2017,05,15,4,0,0), 2.hours).bwdRange(h=>h+1.hours) );
}

