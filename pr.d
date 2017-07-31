import std.process, std.traits, std.functional, std.string;

// words with six or less only lovercase letters has not shortcuts // f.e. "browse"
// words with single UppercaseFirst word shortcuts to 4 first letter // Config -> Conf
// other words take by two letters per word // escapeShellCommand -> esShCo 

alias Conf =  Config;
alias en = environment;
alias exSh = executeShell;
alias esShCo = escapeShellCommand;
alias esShFiNa = escapeShellFileName;
alias esWiAr = escapeWindowsArgument;
alias ex = execute;
alias exSh = executeShell;
alias naSh = nativeShell;
alias piPr = pipeProcess;
alias piSh = pipeShell;
alias PrEx = ProcessException;
alias PrPi = ProcessPipes;
alias Redi = Redirect;
alias spPr = spawnProcess;
alias spSh = spawnShell;
alias thPrID = thisProcessID;
alias thThID = thisThreadID;
alias trWa = tryWait;
alias usSh = userShell;


/*

V check( alias predicate, string msg, V )( V v )
if ( is(typeof(unaryFun!predicate)) )//&& is( typeof( unaryFun!predicate(v))==bool) )
{
   if ( !unaryFun!predicate(v) ) 
      throw new Exception( "check( %s ) returns false.".format(v));

  return v;
}


*/