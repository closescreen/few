import std.file, std.path, std.string, std.regex, std.conv, std.range, std.traits;
/+
Имена (файлов, директорий)
+/

///
bool sizele( size_t size = 0, R )( R name )
if (isInputRange!R && !isInfinite!R && isSomeChar!(ElementEncodingType!R) && !isConvertibleToString!R)
{
  return !exists(name) || !isFile(name) || getSize(name)<=size;
}

///
unittest{
 auto f = "mynoexistfilename";
 assert( sizele(f)==true );
}


///
bool sizegt( size_t size = 0, R )( R name )
if (isInputRange!R && !isInfinite!R && isSomeChar!(ElementEncodingType!R) && !isConvertibleToString!R)
{
 return exists(name) && isFile(name) && getSize(name)>size;
}

///
unittest{
 auto f = "mynoexistfilename";
 assert( sizegt(f)==false );
}

///
auto near( alias pred = sizegt )( string name1, string name2 )
if ( is(typeof(pred(name2)) == bool))
{ import std.stdio;
 auto tested_name = name1.dirName.buildPath( name2.baseName );
 return pred( tested_name ); 
}

///
unittest{
  auto f1 = "./aaa/mynoexistfilename1";
  auto f2 = "./aaa/mynoexistfilename2";
  assert( f1.near(f2) == false );
  assert( f1.near!sizegt(f2) == false );
  assert( f1.near!sizele(f1) == true );
}

