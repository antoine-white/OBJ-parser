%{ 
  #include "parser.tab.hh"
%} 


%% 


if  {return IF;}

else  {return ELSE;}

var {return VAR;}

while {return WHILE;}

[a-zA-Z]+ {return ID;}

[0-9]+ {return INTEGER;} 

"=" {return STOCK;}

";" {return PV;}

"==" {return EQUALCOMP;}

"<" {return MINCOMP;}

">"  {return MAXCOMP;}

"(" {return OPENPAR;}

")" {return CLOSEPAR;}

"{" {return OPENBLOCK;}

"}" {return CLOSEBLOCK;}

"+" {return PLUS;}

"-" {return MINUS;}

"*" {return MULTI;}

"/" {return DIVIDE;}

./\n {}

%% 
