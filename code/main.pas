program main;
{$S-}
	
uses crt, sysutils, TypeSdl, sdl, sdl_image, sdl_ttf, sdl_mixer,init;
var i,j,k,cases,mode : integer;
	fin_partie : boolean;
	p : array[1..2] of integer;
begin
	mode := 1;
	if mode = 1 then
	begin
	randomize;
	initSdl;
{
for k := 1 to 1 do
begin
	p[1] := 0;
	p[2] := 0;
for j := 1 to 1 do
	begin
}
	initPlateau;
	initPartie;
	//chargerPartie('test');

	delay(1000);
	
	

	assign(fic,'ressources/partie.txt');
	rewrite(fic);
	
	i := 0;
	repeat
		i := i + 1 ;
		write(fic,i,' ',((i+1) mod 2)+1,' ');
		for cases := 1 to 50 do write(fic,plateau[cases],' ');
		writeln(fic);
{
		writeln(fic,'Tour ',i,' J',((i+1) mod 2)+1);
}
		tour(((i+1) mod 2)+1,fin_partie);
		//delay(10);
	until fin_partie;
{
	p[(i mod 2)+1] := p[(i mod 2)+1] + 1;

	end;
}
	delay(1000);
	write(fic,-1);
	close(fic);

{
	writeln(p[1],'   ',p[2]);
}
{
end;
}
	end
	else if mode = 2 then
		begin
		initSdl;
		initPlateau;
		lire_partie('partie');
		end;
end.

