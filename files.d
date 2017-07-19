import std.datetime, std.string, std.regex, std.exception, std.conv, std.range;

auto files( R )( R i)
if ( isInputRange!R )
{
 return i;
}