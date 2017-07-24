import std.stdio, std.datetime, std.string, std.regex, std.exception, std.conv, std.range, std.algorithm;
/+
Работа с DateTime
+/

///
template rymd( string standart = "ISOExt" ){
  static if (standart=="ISOExt"){
    auto rymd(){
      return ctRegex!(`(?P<year>\d{4})\D(?P<month>\d\d)\D(?P<day>\d\d)`);
    }
  }
}

///
unittest{
 assert( rymd == ctRegex!(`(?P<year>\d{4})\D(?P<month>\d\d)\D(?P<day>\d\d)`) );
}

///
static template rymdh( string standart = "ISOExt" ){
  static if (standart=="ISOExt"){
    auto rymdh(){
      return ctRegex!(`(?P<year>\d{4})\D(?P<month>\d\d)\D(?P<day>\d\d)\D(?P<hour>\d\d)`);
    }
  }
}

///
unittest{
 assert( rymdh == ctRegex!(`(?P<year>\d{4})\D(?P<month>\d\d)\D(?P<day>\d\d)\D(?P<hour>\d\d)`) );
}


///
auto ymdh(T)(T time ) 
if( is(typeof(time)==SysTime) || is(typeof(time)==DateTime))
{
  return  DateTime( time.year, time.month, time.day, time.hour, 0, 0 );
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
  auto m = matchFirst( ymdh, rymdh );
  if (m) return DateTime( m[1].to!int, m[2].to!int, m[3].to!int, m[4].to!int, 0, 0 );
  else throw new DateTimeException( format( "Can't parse %s", ymdh));
}

///
unittest{
 assert( "../RESULT/2017-05-15/22.gz".ymdh == DateTime(2017,5,15,22,0,0) );
}

///
auto ymd(T)(T time ) 
if( is(typeof(time)==SysTime) || is(typeof(time)==DateTime))
{
  return  DateTime( time.year, time.month, time.day, 0, 0, 0 );
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
  auto m = matchFirst( ymd, rymd );
  if (m) return DateTime( m[1].to!int, m[2].to!int, m[3].to!int, 0, 0, 0 );
  else throw new DateTimeException( format( "Can't parse %s", ymd));
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
 assert( "2017-07-18T02".ymdh.lasts( "2017-07-18T04".ymdh ) == Interval!DateTime( "2017-07-18T02".ymdh, 2.hours) );
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
 auto r1 = DateTime(2017,05,15,4,0,0).lasts(2.hours).rng!("hours","fwd").array; 
 auto r2 = DateTime(2017,05,15,4,0,0).lasts(2.hours).fwdRange( t=>t+1.hours ).array; 
 assert( r1 == r2 );
}

///
auto ss(string d = "fwd", TP )( Interval!TP i)
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{ 
 return rng!("seconds",d)( i ); 
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).ss!"bwd".array == DateTime(2017,05,15,4,0,0).lasts(2.hours).bwdRange( t=>t-1.seconds ).array );
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).ss.array == DateTime(2017,05,15,4,0,0).lasts(2.hours).fwdRange( t=>t+1.seconds ).array );
}

///
auto mm( string d = "fwd", TP )( Interval!TP i)
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{ 
 return rng!("minutes",d)( i ); 
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).mm!"bwd".array == DateTime(2017,05,15,4,0,0).lasts(2.hours).bwdRange( t=>t-1.minutes ).array );
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).mm.array == DateTime(2017,05,15,4,0,0).lasts(2.hours).fwdRange( t=>t+1.minutes ).array );
}


auto hh(string d = "fwd", TP )( Interval!TP i )
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{ 
 return rng!("hours",d)( i ); 
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).hh!"bwd".array == DateTime(2017,05,15,4,0,0).lasts(2.hours).bwdRange( t=>t-1.hours ).array );
 assert( DateTime(2017,05,15,4,0,0).lasts(2.hours).hh.array == DateTime(2017,05,15,4,0,0).lasts(2.hours).fwdRange( t=>t+1.hours ).array );
}

///
auto dd( string d = "fwd", TP )( Interval!TP i )
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{
 return rng!("days",d)( i );
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(3.days).dd!"bwd".array == DateTime(2017,05,15,4,0,0).lasts(3.days).bwdRange( t=>t-1.days ).array );
 assert( DateTime(2017,05,15,4,0,0).lasts(3.days).dd.array == DateTime(2017,05,15,4,0,0).lasts(3.days).fwdRange( t=>t+1.days ).array );
}

///
auto ww(string d = "fwd", TP )( Interval!TP i)
if (isTimePoint!TP && (d == "fwd" || d == "bwd"))
{
 return rng!("weeks",d)( i );
}

///
unittest{
 assert( DateTime(2017,05,15,4,0,0).lasts(20.days).ww!"bwd".array == DateTime(2017,05,15,4,0,0).lasts(20.days).bwdRange( t=>t-1.weeks ).array );
 assert( DateTime(2017,05,15,4,0,0).lasts(20.days).ww.array == DateTime(2017,05,15,4,0,0).lasts(20.days).fwdRange( t=>t+1.weeks ).array );
}


///
auto fstring(string fmt, TP)( TP tp )
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
 assert( DateTime(2017,05,22,19,45,55).fstring!"date:%F hour:%H min/sec:%M/%S" == "date:2017-05-22 hour:19 min/sec:45/55" );
}

///
auto ff(string fmt, IR )( IR r)
if ( isInputRange!IR && isTimePoint!(typeof(r.front)) )
{
 return r.map!( tp=>tp.fstring!fmt );
}

