import std.file, std.string, std.regex, std.conv, std.range, std.traits;
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



