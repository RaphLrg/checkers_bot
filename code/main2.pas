program main;
{$S-}
	
uses crt, sysutils, TypeSdl, sdl, sdl_image, sdl_ttf, sdl_mixer,init,manger;

var fin : boolean;
	i,joueur : integer;
begin

	randomize;
	initSdl;

	initPlateau;

	//chargerPartie2('partie',joueur,56);
	chargerPartie('test');
	delay(3000);
	//assign(fic,'ressources/coup.txt');
	//rewrite(fic);
	tour(1,fin);
	//close(fic);
	//ecrire('Bonjour',1500,200,50,255,255,255);
	delay(3000);
end.

