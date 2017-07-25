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
auto near( alias pred = sizegt )( string name1, string pattern )
if ( is(typeof(pred(pattern)) == bool))
{
  string repl( Captures!(string) m ){
    switch (m[0])
    {
	case "%b": return name1.baseName;
	case "%B": return name1.baseName.stripExtension;
	case "%E": return name1.extension;
	default: return m[0];
    }
  }
 
 static auto re = regex(`%[bBE]`,"g");
 auto pattern_expanded = pattern.baseName.replaceAll!repl(re);
 
 auto tested_name = name1.dirName.buildPath( pattern_expanded );
 return pred( tested_name ); 
}

///
unittest{
  auto f1 = "./aaa/mynoexistfilename1";
  auto f2 = "./aaa/mynoexistfilepattern";
  assert( f1.near(f2) == false );
  assert( f1.near!sizegt(f2) == false );
  assert( f1.near!sizele(f1) == true );
  assert( f1.near!sizele(f1.baseName) == true );
}


auto near( string pattern, alias pred = sizegt )( string name1 )
if ( is(typeof(pred(pattern)) == bool))
{ 

  string repl( Captures!(string) m ){
    switch (m[0])
    {
	case "%b": return name1.baseName;
	case "%B": return name1.baseName.stripExtension;
	case "%E": return name1.extension;
	default: return m[0];
    }
  }
 
 static auto re = regex(`%[bBE]`,"g");
 auto pattern_expanded = pattern.baseName.replaceAll!repl(re);
 
 auto tested_name = name1.dirName.buildPath( pattern_expanded );
 return pred( tested_name ); 

}


///
unittest{
  assert( "./aaa/mynoexistfilename1".near!"mynoexistfilename1" == false );
  assert( "./aaa/mynoexistfilename1".near!("mynoexistfilename1",sizele) == true );
}

