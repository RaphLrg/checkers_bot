Unit Init;

{$Q+}
{$R-}
{$S+}

INTERFACE
	
uses crt, sysutils, TypeSdl, sdl, sdl_image, sdl_ttf, sdl_mixer,manger;

Procedure initSdl;
Procedure initPlateau;
Procedure initPartie(var plateau : type_plateau);
Procedure chargerPartie(nom:string; var plateau : type_plateau);
procedure tour(joueur : integer; var fin_partie : boolean; var plateau : type_plateau);
procedure lire_partie(nom : string);
Procedure chargerPartie2(nom:string;var joueur : integer; tour : integer; var plateau : type_plateau);
procedure ecrire(texte : String; x,y,taille, rouge, vert, bleu : integer);
procedure match_ia(ia_1, ia_2 : type_ia; nb_parties : longint; delay_choisi : integer; affichage, enregistrement, debug : boolean; var nb_victoire_1, nb_victoire_2 : integer; var nb_tours_total : longint);
procedure tournoi_ia(var tab : tableau_tournoi; nb_ia : integer; nb_parties : longint; delay_choisi : integer; nom_tournoi: string; affichage, enregistrement, debug : boolean; var nb_tours_total : longint);
function ia_random(joueur,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau): integer;
procedure match_ia_evo(ia_1, ia_2 : type_ia_evo; nb_parties : integer; nb_1, nb_2, nom_monde : string; var nb_victoire_1, nb_victoire_2, nb_egalite : integer);
procedure match_ia_synthese(ia_1, ia_2 : type_ia_evo; nb_parties : integer; nb_1, nb_2, nom_monde_1, nom_monde_2 : string; var nb_victoire_1, nb_victoire_2, nb_egalite : longint);

IMPLEMENTATION

uses ia_raphael;

procedure ecrire(texte : String; x,y,taille, rouge, vert, bleu : integer);
var position : TSDL_Rect;
	police : pTTF_Font;
	zonetexte : PSDL_Surface;
	ptxt : pChar;
	couleur : PSDL_Color;

begin
	ttf_INIT;
	
	new(couleur);
	
	couleur ^.r := rouge;  
	couleur ^.g := vert;
	couleur ^.b := bleu;
	
	police := TTF_OPENFONT('ressources/police/game.ttf',taille );
	
	
	
	ptxt:= StrAlloc(length(texte)+1);
	StrPCopy(ptxt ,texte);
	
	zonetexte := TTF_RENDERTEXT_BLENDED(police , ptxt ,couleur ^);
	
	position.x := x;
	position.y := y;
	
	SDL_BlitSurface(zonetexte , NIL , window ,@position );
	
	DISPOSE(couleur);
	strDispose(ptxt);
	
	TTF_CloseFont(police);
	
	TTF_Quit ();
	SDL_FreeSurface(zonetexte);
	sdl_flip(window);


end;




Procedure initSdl;

var rectangle : tsdl_rect;
	str : string;
	pimage : pchar;

Begin

	str := 'ressources/blanc.png';
	pimage := StrAlloc(length(str)+1);
	strPCopy(pimage, str);
	blanc := IMG_Load(pimage);
	
	str := 'ressources/noir.png';
	pimage := StrAlloc(length(str)+1);
	strPCopy(pimage, str);
	noir := IMG_Load(pimage);
	
	str := 'ressources/dame_blanc.png';
	pimage := StrAlloc(length(str)+1);
	strPCopy(pimage, str);
	dame_blanche := IMG_Load(pimage);
	
	str := 'ressources/dame_noir.png';
	pimage := StrAlloc(length(str)+1);
	strPCopy(pimage, str);
	dame_noir := IMG_Load(pimage);
	
	str := 'ressources/fond_blanc.png';
	pimage := StrAlloc(length(str)+1);
	strPCopy(pimage, str);
	case_blanche := IMG_Load(pimage);
	
	str := 'ressources/fond_noir.png';
	pimage := StrAlloc(length(str)+1);
	strPCopy(pimage, str);
	case_noir := IMG_Load(pimage);
	
	str := 'ressources/plateau.png';
	pimage := StrAlloc(length(str)+1);
	strPCopy(pimage, str);
	fond := IMG_Load(pimage);
	
	
		
	window := SDL_SetVideoMode(0, 0, 32, SDL_FULLSCREEN);
	sdl_getcliprect(window,@rectangle);
	dimensionX := rectangle.w;
	dimensionY := rectangle.h;
end;









Procedure initPlateau;
var destination : TSDL_RECT;
	i,j : integer;
	c : PSDL_SURFACE;
begin
			// PARTIE GRAPHIQUE
		destination.x := (DimensionX-L_plateau)div 2;
		destination.y := (DimensionY-L_plateau)div 2;
		SDL_BlitSurface(fond,NIL,window,@destination);
		
		for j := 1 to 10 do
		for i := 1 to 10  do
			begin
				destination.x := (DimensionX-L_case*10)div 2 + (i-1)*L_case;
				destination.y := (Dimensiony-L_case*10)div 2 + (j-1)*L_case;
		if ((i+j)mod 2 = 0) then c := case_blanche
		else c := case_noir;	
				SDL_BlitSurface(c,NIL,window,@destination);
			end;
		sdl_flip(window);
end;

Procedure initPartie(var plateau : type_plateau);
var i : integer;
begin		

			// PARTIE LOGICIELLE
		for i := 1  to 20 do plateau[i] := 1;
		for i := 21 to 30 do plateau[i] := 0;
		for i := 31 to 50 do plateau[i] := 2;
		
			// affichage initial
			
		for i := 1 to 50 do affiche_pion(plateau[i],i);
		SDL_Flip(window);
end;

Procedure chargerPartie(nom:string; var plateau : type_plateau);
var fic : text;
	i,r : integer;
begin
nom := 'ressources/'+nom+'.txt';
if fileExists(nom) then 
	begin
	assign(fic,nom);
	reset (fic);
	for i := 1 to 50 do
		begin
		read(fic,r);
		readln(fic,plateau[i])
		end;
	close(fic);
	end
else initPartie(plateau);

	for i := 1 to 50 do affiche_pion(plateau[i],i);
	SDL_Flip(window);
end;


Procedure chargerPartie2(nom:string;var joueur : integer; tour : integer; var plateau : type_plateau);
var fic : text;
	i : integer;
begin
nom := 'ressources/'+nom+'.txt';
if fileExists(nom) then 
	begin
	assign(fic,nom);
	reset (fic);
	
	for i := 1 to tour-1 do 
		readln(fic);
		
	read(fic,i); // on passe le premier nombre qui est le tour
	read(fic,joueur); // on lit le joueur
	for i := 1 to 50 do
		read(fic,plateau[i]);
	
	close(fic);
	end
else initPartie(plateau);

	for i := 1 to 50 do affiche_pion(plateau[i],i);
	SDL_Flip(window);
end;




procedure affichage_tour(coup : type_coup; plateau : type_plateau);
var couleur : 1..2;
	pion : integer;
begin
couleur := plateau[coup.depart];

if ((couleur=1)and(coup.arrivee>=46))or((couleur=2)and(coup.arrivee<=5)) then couleur := couleur + 2;

	//on efface le pion de depart
affiche_pion(0, coup.depart);
	//on affiche le pion à sa case d'arrivee
affiche_pion(couleur, coup.arrivee);
	//on efface les pions manges
if coup.mange then
for pion in coup.pions_manges do
affiche_pion(0, pion);

SDL_Flip(window);
end;



function IA_raph (joueur,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau): integer;
begin
// si nb_coup = 3 alors la fonction renvoie 1, 2 ou 3
end;




procedure tour(joueur : integer; var fin_partie : boolean; var plateau : type_plateau);
var coup_retenu,nb_coup,i : integer;
	liste_coup : type_liste_coup;
begin

lister_coup(joueur,nb_coup,liste_coup,plateau);


fin_partie := nb_coup=0;

if not fin_partie then
	begin
	//PARTIE IA
	coup_retenu := random(nb_coup)+1;

	//writeln('coup retenu : ',coup_retenu,' ',liste_coup[coup_retenu].depart,' ',liste_coup[coup_retenu].arrivee,' ');
	//if liste_coup[coup_retenu].mange then for i in liste_coup[coup_retenu].pions_manges do write (i,' ');
	//writeln();

		//actualisation graphique
	affichage_tour(liste_coup[coup_retenu], plateau);
		//actualisation logicielle
	actualisation_plateau(liste_coup[coup_retenu],plateau);
	end;
end;



procedure lire_partie(nom : string);
var ligne,l_0,l_max,i : integer;
	partie: array[1..200,1..50] of 0..4;
	event: TSDL_Event;
	key:TSDL_KeyboardEvent;
	selectionner : boolean;
	t_0,tAction : TSystemTime;
begin
	//chargement de la partie
assign(fic,'ressources/'+nom+'.txt');
reset(fic);
repeat
	read(fic,ligne);
	writeln(ligne);
	read(fic,partie[ligne,1]);//on lit le joueur
	if not (ligne = -1) then 
		begin
		for i := 1 to 50 do read(fic,partie[ligne,i]);
		l_max := ligne
		end
until ligne=-1;
close(fic);


selectionner := false;

{
while  not selectionner do
	begin
		SDL_Delay (10);
		SDL_PollEvent(@event );
		if event.type_=SDL_MOUSEBUTTONDOWN
			then ;//processMouseEvent(event.button , suite );
		if event.type_ = SDL_QUITEV
			then selectionner:=True;
		
	end;
}
	
	DateTimeToSystemTime(Now,tAction);
	ligne := 1;
	l_0:=0;
	repeat 
		//SDL_Delay (10);
		SDL_PollEvent(@event);
		
		key := event.key;
		
		DateTimeToSystemTime(Now,t_0);
		if (event.type_ = SDL_Keydown)and(diffTemps(t_0, tAction) > 300) then
			case key.keysym.sym of	
				
			SDLK_RIGHT :
				begin
				if ligne<l_max then ligne := ligne + 1 ;
				DateTimeToSystemTime(Now,tAction);
				end;
			SDLK_LEFT :
				begin
				if ligne>1 then ligne := ligne - 1 ;
				DateTimeToSystemTime(Now,tAction);
				end;
				
			SDLK_SPACE :
				selectionner := true;

			end;
			
		if ligne<>l_0 then
			begin
			l_0 := ligne;
			for i := 1 to 50 do affiche_pion(partie[ligne,i],i);
			sdl_flip(window);
			writeln(ligne);
			end;
	until selectionner;

end;


//********************Ajout Raphaël********************//

function ia_random(joueur,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau): integer;
begin
	ia_random := random(nb_coup)+1;
end;

procedure quitSdl;
begin
	SDL_FreeSurface(blanc);
	SDL_FreeSurface(noir);
	SDL_FreeSurface(dame_blanche);
	SDL_FreeSurface(dame_noir);
	SDL_FreeSurface(case_blanche);
	SDL_FreeSurface(case_noir);
	SDL_FreeSurface(fond);
	SDL_FreeSurface(window);
	sdl_quit;
end;

Procedure initPartie_v2(var plateau : type_plateau);
var i : integer;
begin		

			// PARTIE LOGICIELLE
		for i := 1  to 20 do plateau[i] := 1;
		for i := 21 to 30 do plateau[i] := 0;
		for i := 31 to 50 do plateau[i] := 2;

end;

procedure tour_ia(joueur : integer; var fin_partie, affichage, debug : boolean; ia : type_ia; var plateau : type_plateau);
var coup_retenu,nb_coup,i : integer;
	liste_coup : type_liste_coup;
begin
	if debug then writeln('Tour_ia : ', 1);
	lister_coup(joueur,nb_coup,liste_coup,plateau);

	if debug then writeln('Tour_ia : ', 2);
	fin_partie := nb_coup=0;
	if debug then writeln('Tour_ia : ', 3);
	if not fin_partie then
	begin
			//PARTIE IA
		if debug then writeln('debut tour ia');
		coup_retenu := ia(joueur,nb_coup,liste_coup,plateau);
		if debug then writeln('fin tour ia');
			//actualisation graphique
		if affichage then affichage_tour(liste_coup[coup_retenu], plateau);
			//actualisation logicielle
		actualisation_plateau(liste_coup[coup_retenu],plateau);
	end;
end;

function deux_dames(plateau : type_plateau):boolean;
var i, nb_dame_blanche, nb_dame_noire, nb_pion_blanc, nb_pion_noir : integer;
begin
	nb_dame_blanche := 0;
	nb_dame_noire := 0;
	nb_pion_blanc := 0;
	nb_pion_noir := 0;
	
	for i := 1 to 50 do
		case plateau[i] of
			1 : nb_pion_blanc := nb_pion_blanc + 1;
			2 : nb_pion_noir := nb_pion_noir + 1;
			3 : nb_dame_blanche := nb_dame_blanche + 1;
			4 : nb_dame_noire := nb_dame_noire + 1;
		end;

	deux_dames := false;
	if (nb_pion_blanc = 0) and (nb_pion_noir = 0) and (nb_dame_blanche = 1) and (nb_dame_noire = 1) then
		deux_dames := true;
end;

procedure match_ia(ia_1, ia_2 : type_ia; nb_parties : longint; delay_choisi : integer; affichage, enregistrement, debug : boolean; var nb_victoire_1, nb_victoire_2 : integer; var nb_tours_total : longint);
var j, k, cases, num_dossier, nb_coup, nb_tours, coup_retenu, nb_egalite, fic_vic_1, fic_vic_2, fic_eg : integer;
	i : longint;
	fin_partie, vic_1, vic_2, eg : boolean;
	plateau : type_plateau;
	liste_coup : type_liste_coup;
	fichier : text;
	// table_verif : type_table_hash;

begin
	randomize;

	nb_tours_total := 0;

	assign(fichier, 'ressources/info_match.txt');
	if not fileExists('ressources/info_match.txt') then
	begin
		rewrite(fichier);
		writeln(fichier, 0);
		writeln(fichier, 0);
		writeln(fichier, 0);
		close(fichier);
	end;

	if affichage then initSdl;
	nb_victoire_1 := 0;
	nb_victoire_2 := 0;
	nb_egalite := 0;
	num_dossier := 0;
	fic_vic_1 := 0;
	fic_vic_2 := 0;
	fic_eg := 0;
	if enregistrement then
	begin
		while directoryExists('ressources/test_'+ inttostr(num_dossier)) do
			num_dossier := num_dossier + 1;
		createdir('ressources/test_'+ inttostr(num_dossier))
	end;
	for i := 1 to nb_parties do
	begin
		if enregistrement then
		begin
			assign(fic,'ressources/test_'+inttostr(num_dossier)+'/partie'+inttostr(i)+'.txt');
			rewrite(fic);
			j := 0
		end;

		if affichage then initPlateau;
		if affichage then initPartie(plateau)
		else initPartie_v2(plateau);
		fin_partie := false;
		nb_tours := 0;
		eg := false;
			
		// init_table_verif(table_verif);
		// writeln(hash_verif(plateau, table_verif));
		if debug then writeln('ok 1');
		while (not fin_partie) and (not eg) do
		begin
			nb_tours := nb_tours + 1;

			eg := (nb_tours > 200) or deux_dames(plateau);
			if eg then 
				nb_egalite := nb_egalite + 1;

			if enregistrement then
			begin
				j := j + 1 ;
				write(fic,j,' ',((j+1) mod 2)+1,' ');
				for cases := 1 to 50 do write(fic,plateau[cases],' ');
				writeln(fic)
			end;

			if (i mod 2) = 0 then
			begin
				delay(delay_choisi);
				if debug then writeln('debut tour ia 1');
				tour_ia(1, fin_partie, affichage, debug, ia_1, plateau);
				if debug then writeln('fin tour ia 1');
				delay(delay_choisi);
				vic_1 := false;
				vic_2 := false;
				if fin_partie then 
				begin
					nb_victoire_2 := nb_victoire_2 + 1;
					vic_2 := true;
				end
				else
				begin
					if debug then writeln('debut tour ia 2');
					tour_ia(2, fin_partie, affichage, debug, ia_2, plateau);
					if debug then writeln('fin tour ia 2');
					nb_tours := nb_tours + 1;
					if fin_partie then 
					begin
						nb_victoire_1 := nb_victoire_1 + 1;
						vic_1 := true;
					end;
				end;
			end
			else
			begin
				delay(delay_choisi);
				if debug then writeln('debut tour ia 2');
				tour_ia(1, fin_partie, affichage, debug, ia_2, plateau);
				if debug then writeln('fin tour ia 2');
				delay(delay_choisi);
				vic_1 := false;
				vic_2 := false;
				if fin_partie then 
				begin
					nb_victoire_1 := nb_victoire_1 + 1;
					vic_1 := true;
				end
				else
				begin
					if debug then writeln('debut tour ia 1');
					tour_ia(2, fin_partie, affichage, debug, ia_1, plateau);
					if debug then writeln('fin tour ia 1');
					nb_tours := nb_tours + 1;
					if fin_partie then 
					begin
						nb_victoire_2 := nb_victoire_2 + 1;
						vic_2 := true;
					end;
				end;
			end;
		end;

		if debug then writeln('ok 2');

		if debug then writeln('nombre de tours = ', nb_tours);

		nb_tours_total := nb_tours_total + nb_tours;

		if enregistrement then
		begin
			write(fic,-1);
			close(fic);
			writeln('ia_1 : ', nb_victoire_1, ' victoires.');
			writeln('ia_2 : ', nb_victoire_2, ' victoires.');
			writeln(nb_egalite, ' egalites.');
			reset(fichier);
			readln(fichier, fic_vic_1);
			readln(fichier, fic_vic_2);
			readln(fichier, fic_eg);
			if vic_1 then fic_vic_1 := fic_vic_1 + 1;
			if vic_2 then fic_vic_2 := fic_vic_2 + 1;
			if eg then fic_eg := fic_eg + 1;
			rewrite(fichier);
			writeln(fichier, fic_vic_1);
			writeln(fichier, fic_vic_2);
			writeln(fichier, fic_eg);
			close(fichier);
		end;
	end;
	if affichage then quitSdl;
	if enregistrement then
	begin
		writeln('ia_1 : ', nb_victoire_1, ' victoires');
		writeln('ia_2 : ', nb_victoire_2, ' victoires');
	end;
	
end;

procedure tournoi_ia(var tab : tableau_tournoi; nb_ia : integer; nb_parties : longint; delay_choisi : integer; nom_tournoi: string; affichage, enregistrement, debug : boolean; var nb_tours_total : longint);
var adversaire_1, adversaire_2, nb_victoire_1, nb_victoire_2 : integer;
	nb_tours : longint;
	fichier : text;

begin
	if debug then writeln('tournoi_ia 1');
	assign(fichier, 'ressources/enregistrement_tournoi/'+nom_tournoi+'.txt');
	adversaire_1 := 1;
	if not fileExists('ressources/enregistrement_tournoi/'+nom_tournoi+'.txt') then
		rewrite(fichier)
	else
		append(fichier);
	if debug then writeln('tournoi_ia 2');
	nb_tours_total := 0;

	for adversaire_1 := 1 to 20 do
		tab[adversaire_1].nb_victoire := 0;
	
	if debug then writeln('tournoi_ia 3');
	for adversaire_1 := 1 to nb_ia - 1 do
		for adversaire_2 := adversaire_1 + 1 to nb_ia do
		begin
			match_ia(tab[adversaire_1].ia, tab[adversaire_2].ia, nb_parties, delay_choisi, affichage, enregistrement, debug, nb_victoire_1, nb_victoire_2, nb_tours);
			nb_tours_total := nb_tours_total + nb_tours;
			writeln(fichier, 'IA ',tab[adversaire_1].nom, ' a ',nb_victoire_1,' victoires.');
			writeln(fichier, 'IA ',tab[adversaire_2].nom, ' a ',nb_victoire_2,' victoires.');
			writeln(fichier, ' ');
			writeln('IA 1 : ', nb_victoire_1, ', IA 2 : ', nb_victoire_2, ', nul : ', nb_parties - nb_victoire_1 - nb_victoire_2);
			if nb_victoire_1 > nb_victoire_2 then
				tab[adversaire_1].nb_victoire := tab[adversaire_1].nb_victoire + 1 
			else 
				if nb_victoire_1 < nb_victoire_2 then
					tab[adversaire_2].nb_victoire := tab[adversaire_2].nb_victoire + 1
		end;
	
	if debug then writeln('tournoi_ia 4');
	if enregistrement then
		for adversaire_1 := 1 to nb_ia do
		begin
			writeln('IA ',tab[adversaire_1].nom,' a ',tab[adversaire_1].nb_victoire,' victoires.');
			// writeln(fichier, 'IA ',tab[adversaire_1].nom,' a ',tab[adversaire_1].nb_victoire,' victoires.');
		end;

	close(fichier)
end;


procedure tour_ia_evo(joueur : integer; var fin_partie : boolean; ia : type_ia_evo; nb_ia, nom_monde : string; var plateau : type_plateau);
var coup_retenu,nb_coup : integer;
	liste_coup : type_liste_coup;
begin
	// writeln('tour ',1);
	lister_coup(joueur,nb_coup,liste_coup,plateau);
	fin_partie := nb_coup=0;
	// writeln('tour ',2);
	if not fin_partie then
	begin
		// writeln('tour ',3);
		coup_retenu := ia(joueur,nb_coup,liste_coup,plateau,nb_ia,nom_monde);
		// writeln('tour ',4);
		actualisation_plateau(liste_coup[coup_retenu],plateau);
	end;
	// writeln('tour ',5);
end;

procedure match_ia_evo(ia_1, ia_2 : type_ia_evo; nb_parties : integer; nb_1, nb_2, nom_monde : string; var nb_victoire_1, nb_victoire_2, nb_egalite : integer);
var i, nb_tours : integer;
	fin_partie, vic_1, vic_2, eg : boolean;
	plateau : type_plateau;

begin
	randomize;

	nb_victoire_1 := 0;
	nb_victoire_2 := 0;
	nb_egalite := 0;
	
	// writeln('match ',1);
	for i := 1 to nb_parties do
	begin
		initPartie_v2(plateau);

		fin_partie := false;
		nb_tours := 0;
		eg := false;
			
		// writeln('match ',2);		
		while (not fin_partie) and (not eg) do
		begin
			nb_tours := nb_tours + 1;
			// writeln('match ',3);
			eg := (nb_tours > 200) or deux_dames(plateau);
			if eg then 
				nb_egalite := nb_egalite + 1;


			if (i mod 2) = 0 then
			begin
				tour_ia_evo(1, fin_partie, ia_1, nb_1, nom_monde, plateau);
				vic_1 := false;
				vic_2 := false;
				if fin_partie then 
				begin
					nb_victoire_1 := nb_victoire_1 + 1;
					vic_2 := true;
				end
				else
				begin
					tour_ia_evo(2, fin_partie, ia_2, nb_2, nom_monde, plateau);
					nb_tours := nb_tours + 1;
					if fin_partie then 
					begin
						nb_victoire_2 := nb_victoire_2 + 1;
						vic_1 := true;
					end;
				end;
			end
			else
			begin
				tour_ia_evo(1, fin_partie, ia_2, nb_2, nom_monde, plateau);
				vic_1 := false;
				vic_2 := false;
				if fin_partie then 
				begin
					nb_victoire_2 := nb_victoire_2 + 1;
					vic_1 := true;
				end
				else
				begin
					tour_ia_evo(2, fin_partie, ia_1, nb_1, nom_monde, plateau);
					nb_tours := nb_tours + 1;
					if fin_partie then 
					begin
						nb_victoire_1 := nb_victoire_1 + 1;
						vic_2 := true;
					end;
				end;
			end;
		end;
		// writeln('ia_1 : ', nb_victoire_1, ' victoires.');
		// writeln('ia_2 : ', nb_victoire_2, ' victoires.');
		// writeln(nb_egalite, ' egalites.');
	end;
	// writeln('match ',4);
end;

procedure match_ia_synthese(ia_1, ia_2 : type_ia_evo; nb_parties : integer; nb_1, nb_2, nom_monde_1, nom_monde_2 : string; var nb_victoire_1, nb_victoire_2, nb_egalite : longint);
var i, nb_tours : integer;
	fin_partie, vic_1, vic_2, eg : boolean;
	plateau : type_plateau;

begin
	randomize;

	nb_victoire_1 := 0;
	nb_victoire_2 := 0;
	nb_egalite := 0;
	
	// writeln('match ',1);
	for i := 1 to nb_parties do
	begin
		initPartie_v2(plateau);

		fin_partie := false;
		nb_tours := 0;
		eg := false;
			
		// writeln('match ',2);		
		while (not fin_partie) and (not eg) do
		begin
			nb_tours := nb_tours + 1;
			// writeln('match ',3);
			eg := (nb_tours > 200) or deux_dames(plateau);
			if eg then 
				nb_egalite := nb_egalite + 1;


			if (i mod 2) = 0 then
			begin
				tour_ia_evo(1, fin_partie, ia_1, nb_1, nom_monde_1, plateau);
				vic_1 := false;
				vic_2 := false;
				if fin_partie then 
				begin
					nb_victoire_1 := nb_victoire_1 + 1;
					vic_2 := true;
				end
				else
				begin
					tour_ia_evo(2, fin_partie, ia_2, nb_2, nom_monde_2, plateau);
					nb_tours := nb_tours + 1;
					if fin_partie then 
					begin
						nb_victoire_2 := nb_victoire_2 + 1;
						vic_1 := true;
					end;
				end;
			end
			else
			begin
				tour_ia_evo(1, fin_partie, ia_2, nb_2, nom_monde_2, plateau);
				vic_1 := false;
				vic_2 := false;
				if fin_partie then 
				begin
					nb_victoire_2 := nb_victoire_2 + 1;
					vic_1 := true;
				end
				else
				begin
					tour_ia_evo(2, fin_partie, ia_1, nb_1, nom_monde_1, plateau);
					nb_tours := nb_tours + 1;
					if fin_partie then 
					begin
						nb_victoire_1 := nb_victoire_1 + 1;
						vic_2 := true;
					end;
				end;
			end;
		end;
		// writeln('ia_1 : ', nb_victoire_1, ' victoires.');
		// writeln('ia_2 : ', nb_victoire_2, ' victoires.');
		// writeln(nb_egalite, ' egalites.');
	end;
	// writeln('match ',4);
end;

END.


