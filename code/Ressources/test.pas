program test;

var a,b,c,i : longint;

begin
a := 0;
b := 1;
writeln(a);
writeln(b);
for i := 1 to 30 do
	begin
	c := a;
	a := b;
	b := c+b;
	writeln(b,'   ',b/a:1:10,'   ',(1+sqrt(5))/2:1:10);
	
	end;
end.
