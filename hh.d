import std.datetime, std.string, std.regex, std.exception, std.conv, std.range;
/+
Работа с DateTime
+/

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
 static if ( is( TP2 == TP1 ))
  return tp1<tp2 ? Interval!TP1( tp1, tp2 ) : Interval!TP1( tp2 , tp1 );
 else{
  auto tp2_ = tp2.to!TP1;
  return tp1 < tp2_ ? Interval!TP1( tp1, tp2_ ) : Interval!TP1( tp2_ , tp1 );
 }  
}

///
unittest{
 assert( "2017-07-18T04".ymdh.lasts( "2017-07-18T02".ymdh ) == Interval!DateTime( "2017-07-18T04".ymdh, 2.hours) );
}

///
auto rng( string units, string direction, TP )( Interval!TP interval )
if ( isTimePoint!TP && 
  (units == "seconds" || units == "minutes" || units == "hours" || units == "days" || units == "weeks"))
{
 static if (direction == "fwd")
  return interval.fwdRange( tp => tp + dur!units(1) );
 else
  return interval.bwdRange( tp => tp - dur!units(1) );
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).rng!("hours","fwd") == DateTime(2017,05,15,4,0,0).lasts(2.hours).fwdRange( t=>t+1.hours ) );
}

///
auto ss(string d = "fwd", TP )( Interval!TP i)
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{ 
 return rng!("seconds",d)( i ); 
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).ss!"bwd" == DateTime(2017,05,15,4,0,0).lasts(2.hours).bwdRange( t=>t-1.seconds ) );
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).ss == DateTime(2017,05,15,4,0,0).lasts(2.hours).fwdRange( t=>t+1.seconds ) );
}

///
auto mm( string d = "fwd", TP )( Interval!TP i)
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{ 
 return rng!("minutes",d)( i ); 
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).mm!"bwd" == DateTime(2017,05,15,4,0,0).lasts(2.hours).bwdRange( t=>t-1.minutes ) );
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).mm == DateTime(2017,05,15,4,0,0).lasts(2.hours).fwdRange( t=>t+1.minutes ) );
}


auto hh(string d = "fwd", TP )( Interval!TP i )
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{ 
 return rng!("hours",d)( i ); 
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).hh!"bwd" == DateTime(2017,05,15,4,0,0).lasts(2.hours).bwdRange( t=>t-1.hours ) );
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).hh == DateTime(2017,05,15,4,0,0).lasts(2.hours).fwdRange( t=>t+1.hours ) );
}

///
auto dd( string d = "fwd", TP )( Interval!TP i )
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{
 return rng!("days",d)( i );
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(3.days).dd!"bwd" == DateTime(2017,05,15,4,0,0).lasts(3.days).bwdRange( t=>t-1.days ) );
 assert( DateTime(2017,05,15,4,0,0).lasts(3.days).dd == DateTime(2017,05,15,4,0,0).lasts(3.days).fwdRange( t=>t+1.days ) );
}

///
auto ww(string d = "fwd", TP )( Interval!TP i)
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{
 return rng!("weeks",d)( i );
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(20.days).ww!"bwd" == DateTime(2017,05,15,4,0,0).lasts(20.days).bwdRange( t=>t-1.weeks ) );
 assert( DateTime(2017,05,15,4,0,0).lasts(20.days).ww == DateTime(2017,05,15,4,0,0).lasts(20.days).fwdRange( t=>t+1.weeks ) );
}

unittest{
 assert(false);
}