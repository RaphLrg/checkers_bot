unit manger;
{$Q+}
{$R-}
{$S+}
interface
uses crt, sysutils, TypeSdl, sdl, sdl_image, sdl_ttf, sdl_mixer;

type type_pions_manges = set of 1..50;

procedure lister_coup_manger(joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; plateau_tour : type_plateau);
procedure lister_coup_simple_pion(joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; plateau_tour : type_plateau);
procedure lister_coup_simple_dame(joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; plateau_tour : type_plateau);
function inverser_plateau(plateau : type_plateau): type_plateau;
procedure actualisation_plateau(coup : type_coup;var monPlateau : type_plateau);
procedure affiche_pion(couleur,n : integer);
function emplacement_case(n : integer) : position;
function haut_gauche(n:integer):integer;
procedure lister_coup(joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; mon_plateau : type_plateau);

implementation



function couleur_pion(x : integer) : integer;
begin
	case x of
		0 : couleur_pion := 0;
		1 : couleur_pion := 1;
		2 : couleur_pion := 2;
		3 : couleur_pion := 1;
		4 : couleur_pion := 2;
	end;
end;

function emplacement_case(n : integer) : position;
var i,j : integer;
begin
n := n-1;
j := 10 - (n div 5);
i := (n mod 5)*2 + 1;
if ((i+j)mod 2 = 0) then i := i+1;

	emplacement_case.x := (DimensionX-L_case*10)div 2 + (i-1)*L_case;
	emplacement_case.y := (Dimensiony-L_case*10)div 2 + (j-1)*L_case;
end;

procedure affiche_pion(couleur,n : integer);
var	destination : TSDL_RECT;
	c : PSDL_SURFACE;
begin
destination.x := emplacement_case(n).x;
destination.y := emplacement_case(n).y;

if      couleur = 1 then c := blanc
else if couleur = 2 then c := noir
else if couleur = 3 then c := dame_blanche
else if couleur = 4 then c := dame_noir
else c := case_noir;

SDL_BlitSurface(c,NIL,window,@destination);
end;


procedure actualisation_plateau(coup : type_coup;var monPlateau : type_plateau);
var couleur : 0..4;
	pion : integer;

begin
	couleur := monPlateau[coup.depart];
	if ((couleur=1)and(coup.arrivee>=46))or((couleur=2)and(coup.arrivee<=5)) then couleur := couleur + 2;
		//on efface le pion de depart
	monPlateau[coup.depart] := 0;

		//on efface les pions manges
	if coup.mange then
	for pion in coup.pions_manges do
	monPlateau[pion] := 0;

	//on affiche le pion à sa case d'arrivee
	monPlateau[coup.arrivee] := couleur;
end;






function inverse(n:integer):integer;
	begin
	inverse := 51-n;
	end;

function inverser_plateau(plateau : type_plateau): type_plateau;
var i : integer;
	begin
	for i := 1 to 50 do
	inverser_plateau[i] := plateau[inverse(i)];
	end;

function inverse_joueur(joueur,n : integer): integer;
	begin
	if joueur = 1 then inverse_joueur := n
	else inverse_joueur := inverse(n);
	end;






function parite(n : integer):integer;
begin
	parite := ((n-1+5) div 5) mod 2;
end;
function haut_gauche(n:integer):integer;
begin
	haut_gauche := n+5-parite(n);
end;
function haut_droite(n:integer):integer;
begin
	haut_droite := n+6-parite(n);
end;
function bas_gauche(n:integer):integer;
begin
	bas_gauche := n-5-parite(n);
end;
function bas_droite(n:integer):integer;
begin
	bas_droite := n-4-parite(n);
end;











procedure etudeArbre_dame_simple(monPlateau : type_plateau; joueur : integer; var coups_possibles : type_liste_coup;var nb_coup : integer; n,n0,direction  : integer);

begin
	//write('go  ',n,'  ');
	if 	((direction=0)or(direction=1))
		and (not(n mod 10 = 0)) 
		and (not(n<=5))     then
			begin
			//write('1*  ');
			if (monPlateau[bas_droite(n)]=0) 		then
				begin				
				//writeln('1/  ');
				etudeArbre_dame_simple(monPlateau,joueur,coups_possibles,nb_coup,bas_droite(n),n0,1);
				//writeln('1+');
				end;
			end;
	//write('after  ');		
	if 	((direction=0)or(direction=2))
		and (not(n mod 10 = 1))
		and (not(n<=5))   then
			begin
			//write('2* ');
			if (monPlateau[bas_gauche(n)]=0)		then
				begin
				//writeln('2+  ');
				etudeArbre_dame_simple(monPlateau,joueur,coups_possibles,nb_coup,bas_gauche(n),n0,2);
				//writeln('2/ ');
				end;
			end;
			
	if 	((direction=0)or(direction=3))
		and (not(n mod 10 = 0))
		and (not(n>=46))  then
			if (monPlateau[haut_droite(n)]=0)		then
				begin
				//writeln(fic,3);
				etudeArbre_dame_simple(monPlateau,joueur,coups_possibles,nb_coup,haut_droite(n),n0,3);
				end;
			
	if 	((direction=0)or(direction=4))
		and (not(n mod 10 = 1))
		and (not(n>=46))    then
			if (monPlateau[haut_gauche(n)]=0) 		then
				begin
				//writeln(fic,4);
				etudeArbre_dame_simple(monPlateau,joueur,coups_possibles,nb_coup,haut_gauche(n),n0,4);
				end;
			
	if (not(direction=0)) then 
		begin
		nb_coup := nb_coup + 1;
		//write('coups : ',nb_coup,' ');
		coups_possibles[nb_coup].depart := n0;
		coups_possibles[nb_coup].arrivee := n;
		coups_possibles[nb_coup].mange := false;
		//writeln(n0,' ',n,' ',direction);
		end
end;



procedure lister_coup_simple_dame(joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; plateau_tour : type_plateau);
var n : integer;
	
begin

	for n := 1 to 50 do
	if (plateau_tour[n]=joueur+2) then
		begin	
					//algo recursif
{
			assign(fic,'ressources/coups.txt');
			rewrite(fic);
}
			etudeArbre_dame_simple(plateau_tour,joueur,liste_coup,nb_coup,n,n,0);
{
			close(fic);
}
		end;
end;



procedure lister_coup_simple_pion(joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; plateau_tour : type_plateau);
var coup : type_coup;
	cases : integer;
begin
for cases := 1 to 45 do				//on ballaie toutes les cases
if plateau_tour[cases]=joueur then	// si c'est un de nos pions
	begin
		
			//colonne de gauche
		if (cases mod 10 = 1) and (plateau_tour[cases+5] = 0) then 
			begin
			coup.depart := inverse_joueur(joueur,cases);
			coup.arrivee:= inverse_joueur(joueur,cases+5);
			coup.mange  := false;
			nb_coup := nb_coup + 1;
			liste_coup[nb_coup] := coup;
			end;
		
			//colonne de droite
		if (cases mod 10 = 0) and (plateau_tour[cases+5] = 0) then 
			begin
			coup.depart := inverse_joueur(joueur,cases);
			coup.arrivee:= inverse_joueur(joueur,cases+5);
			coup.mange  := false;
			nb_coup := nb_coup + 1;
			liste_coup[nb_coup] := coup;
			end;
			
			//colonnes centrales
				//vers la gauche
		if (not(cases mod 10 = 0)) and (not(cases mod 10 = 1)) and (plateau_tour[haut_gauche(cases)] = 0) then
			begin
			coup.depart := inverse_joueur(joueur,cases);
			coup.arrivee:= inverse_joueur(joueur,haut_gauche(cases));
			coup.mange  := false;
			nb_coup := nb_coup + 1;
			liste_coup[nb_coup] := coup;
			end;
				//vers la droite
		if (not(cases mod 10 = 0)) and (not(cases mod 10 = 1)) and (plateau_tour[haut_droite(cases)] = 0) then 
			begin
			coup.depart := inverse_joueur(joueur,cases);
			coup.arrivee:= inverse_joueur(joueur,haut_droite(cases));
			coup.mange  := false;
			nb_coup := nb_coup + 1;
			liste_coup[nb_coup] := coup;
			end;
	end;
end;









function manger_haut_gauche(joueur:integer;n : integer;plateau_tour : type_plateau):boolean;
var adversaire : integer;
	begin
	adversaire := 3-couleur_pion(joueur);
	manger_haut_gauche :=   (n<=40)
						and	(not(n mod 5 =1))
						and (couleur_pion(plateau_tour[haut_gauche(n)])=adversaire)
						and (plateau_tour[haut_gauche(haut_gauche(n))]=0);
	end;
	
function manger_haut_droite(joueur:integer;n : integer;plateau_tour : type_plateau):boolean;
var adversaire : integer;
	begin
	adversaire := 3-couleur_pion(joueur);
	manger_haut_droite := (n<=40)
					  and (not(n mod 5 =0))
					  and (couleur_pion(plateau_tour[haut_droite(n)])=adversaire)
					  and (plateau_tour[haut_droite(haut_droite(n))]=0);
	end;
	
function manger_bas_gauche(joueur:integer;n : integer;plateau_tour : type_plateau):boolean;
var adversaire : integer;
	begin
	adversaire := 3-couleur_pion(joueur);
	manger_bas_gauche := (n>10)
					 and (not(n mod 5 =1))
					 and (couleur_pion(plateau_tour[bas_gauche(n)])=adversaire)
					 and (plateau_tour[bas_gauche(bas_gauche(n))]=0);
	end;
	
function manger_bas_droite(joueur:integer;n : integer;plateau_tour : type_plateau):boolean;
var adversaire : integer;
	begin
	adversaire := 3-couleur_pion(joueur);
	manger_bas_droite := (n>10)
					 and (not(n mod 5 =0))
					 and (couleur_pion(plateau_tour[bas_droite(n)])=adversaire)
					 and (plateau_tour[bas_droite(bas_droite(n))]=0);
	end;
	







	
Procedure etudeArbre(monPlateau : type_plateau; joueur : integer; var coups_possibles : type_liste_coup; n,n0 : integer; pions_manges,dernier_pion_mange : type_pions_manges);
var coup : type_coup;
	i,j : integer;
	//plateau_0 : type_plateau;
begin
	//plateau_0:=monPlateau;
	pions_manges := pions_manges + dernier_pion_mange;
	

	if manger_bas_droite(joueur,n,monPlateau) then
		begin
{
			write(1,' ');
}
			coup.depart  := n;
			coup.arrivee := bas_droite(bas_droite(n));
			coup.mange   := true;
			coup.pions_manges := [bas_droite(n)];
			actualisation_plateau(coup,monPlateau);
			

			etudeArbre(monPlateau,joueur,coups_possibles,coup.arrivee,n0,pions_manges,coup.pions_manges);
			

		end;
	if manger_bas_gauche(joueur,n,monPlateau) then
		begin
{
			write(2,' ');
}
			coup.depart  := n;
			coup.arrivee := bas_gauche(bas_gauche(n));
			coup.mange   := true;
			coup.pions_manges := [bas_gauche(n)];
			actualisation_plateau(coup,monPlateau);
			
{
			for i := 1 to 50 do affiche_pion(monplateau[i],i);
			SDL_Flip(window);
			delay(1000);
}
			
			//pions_manges := pions_manges+coup.pions_manges;
			
			//etudeArbre(monPlateau,joueur,coups_possibles,coup.arrivee,pions_manges);
			etudeArbre(monPlateau,joueur,coups_possibles,coup.arrivee,n0,pions_manges,coup.pions_manges);
			
			//monPlateau := plateau_0;
		end;
	if manger_haut_droite(joueur,n,monPlateau) then
		begin
{
			write(3,' ');
}
			coup.depart  := n;
			coup.arrivee := haut_droite(haut_droite(n));
			coup.mange   := true;
			coup.pions_manges := [haut_droite(n)];
			actualisation_plateau(coup,monPlateau);
			
{
			for i := 1 to 50 do affiche_pion(monplateau[i],i);
			SDL_Flip(window);
			delay(1000);
}
			//pions_manges := pions_manges+coup.pions_manges;
			
			//etudeArbre(monPlateau,joueur,coups_possibles,coup.arrivee,pions_manges);
			etudeArbre(monPlateau,joueur,coups_possibles,coup.arrivee,n0,pions_manges,coup.pions_manges);
			
			//monPlateau := plateau_0;
		end;
	if manger_haut_gauche(joueur,n,monPlateau) then
		begin
{
			write(4,' ');
}
			coup.depart  := n;
			coup.arrivee := haut_gauche(haut_gauche(n));
			coup.mange   := true;
			coup.pions_manges := [haut_gauche(n)];
			actualisation_plateau(coup,monPlateau);
			
{
			for i := 1 to 50 do affiche_pion(monplateau[i],i);
			SDL_Flip(window);
			delay(1000);
}
			//pions_manges := pions_manges+coup.pions_manges;
			
			//etudeArbre(monPlateau,joueur,coups_possibles,coup.arrivee,pions_manges);
			etudeArbre(monPlateau,joueur,coups_possibles,coup.arrivee,n0,pions_manges,coup.pions_manges);
			
			//monPlateau := plateau_0;
		end;
	if not(manger_bas_droite(joueur,n,monPlateau) or
		   manger_bas_gauche(joueur,n,monPlateau) or
		   manger_haut_droite(joueur,n,monPlateau) or
		   manger_haut_gauche(joueur,n,monPlateau)) then
		begin
{
			writeln(5);
}
			coup.arrivee := n;
			
			j := 0;
				repeat
				j := j+1;
				until (coups_possibles[j].arrivee=0);
			
			coup.mange   := true;
			coup.pions_manges := pions_manges;
			coup.depart := n0;
			
			if coup.pions_manges<>[] then
				begin			
					coup.nb_pions_manges := 0;
					for i in coup.pions_manges do coup.nb_pions_manges := coup.nb_pions_manges + 1;

					
					coups_possibles[j] := coup;
					
{
					write(coup.depart,' ',n,' ');
					for i in  pions_manges do write(i,' ');
					writeln('  ',coup.nb_pions_manges);
					writeln();
}				
					
				end;
		end;
end;
	


procedure lister_coup_manger_pions(n,joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; plateau_tour : type_plateau);
var i,j,max : integer;
	pions_manges, liste_cases_tab : type_pions_manges;
	coups_possibles : type_liste_coup;
	
	begin
			for i := 1 to 50 do 
			begin
			coups_possibles[i].depart := 0;
			coups_possibles[i].arrivee := 0;
			end;

					begin
					

							
						pions_manges := [];
						
						
								//algo recursif
{
						assign(fic,'ressources/coups.txt');
						rewrite(fic);
}
						etudeArbre(plateau_tour,joueur,coups_possibles,n,n,pions_manges,[]);
{
						close(fic);
}
						
						
								//on garde les meilleurs coups
{
						i := 0;
							repeat
							i := i+1;
							until (coups_possibles[i+1].arrivee=0);
}
						liste_cases_tab := [];
						for i := 1 to 50 do if coups_possibles[i].depart=n then include(liste_cases_tab,i);
						max := 0;
						for j in liste_cases_tab do
							if coups_possibles[j].nb_pions_manges>max then max := coups_possibles[j].nb_pions_manges;
						for j in liste_cases_tab do
							if coups_possibles[j].nb_pions_manges=max then 
								begin
									nb_coup := nb_coup + 1;
									liste_coup[nb_coup] := coups_possibles[j];
								end;
								
					end;
				
{
		writeln('pre tri');
		writeln(nb_coup);
		for j := 1 to nb_coup do
			begin
				write(liste_coup[j].depart,' ',liste_coup[j].arrivee,' ');
				for i in liste_coup[j].pions_manges do write(i,' ');
				write('  ',liste_coup[j].nb_pions_manges);
				writeln;
				writeln;
			end;
}
	end;
	
	

	
	procedure etudeArbre_dame_manger(monPlateau : type_plateau; joueur : integer; var coups_possibles : type_liste_coup_etendue; n,n0,direction : integer; pions_manges : type_pions_manges; deja_tourne : boolean);
	var coup : type_coup;
		i : integer;
	begin

		if ((direction=0)or(direction=1)or(not(deja_tourne)))and(not(direction=4)) then
		begin
			if (n>5)and(not(n mod 10 = 0)) then
				if monPlateau[bas_droite(n)]=0 then
					etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,bas_droite(n),n0,1,pions_manges,(deja_tourne) or (direction<>1));
			if (n>10) and (not(n mod 5 =0)) then
				if manger_bas_droite(joueur,n,monPlateau)and(not(bas_droite(n) in pions_manges)) then
					etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,bas_droite(bas_droite(n)),n0,1,pions_manges+[bas_droite(n)],false)
		end;


		if ((direction=0)or(direction=2)or(not(deja_tourne)))and(not(direction=3)) then
		begin
			if (n>5)and(not(n mod 10 = 1)) then
				if monPlateau[bas_gauche(n)]=0 then
					etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,bas_gauche(n),n0,2,pions_manges,(deja_tourne) or (direction<>2));
			if (n>10) and (not(n mod 5 =1)) then
				if manger_bas_gauche(joueur,n,monPlateau)and(not(bas_gauche(n) in pions_manges)) then
					etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,bas_gauche(bas_gauche(n)),n0,2,pions_manges+[bas_gauche(n)],false)
		end;
		
		if ((direction=0)or(direction=3)or(not(deja_tourne)))and(not(2=direction)) then
		begin
			if (n<46)and(not(n mod 10 = 0)) then
				if monPlateau[haut_droite(n)]=0 then
					etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,haut_droite(n),n0,3,pions_manges,(deja_tourne) or (direction<>3));
			if (n<41) and (not(n mod 5 =0)) then
				if manger_haut_droite(joueur,n,monPlateau)and(not(haut_droite(n) in pions_manges)) then
					etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,haut_droite(haut_droite(n)),n0,3,pions_manges+[haut_droite(n)],false)
		end;
			
		if ((direction=0)or(direction=4)or(not(deja_tourne)))and(not(1=direction)) then
		begin
			if (n<46)and(not(n mod 10 = 1)) then
				if monPlateau[haut_gauche(n)]=0 then
					etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,haut_gauche(n),n0,4,pions_manges,(deja_tourne) or (direction<>4));
			if (n<41) and (not(n mod 5 =1)) then
				if manger_haut_gauche(joueur,n,monPlateau)and(not(haut_gauche(n) in pions_manges)) then
					etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,haut_gauche(haut_gauche(n)),n0,4,pions_manges+[haut_gauche(n)],false);
		end;
		
			

		if	(pions_manges <> []) and (not(deja_tourne)) then
		begin
			coup.depart  := n0;
			coup.arrivee := n;
			coup.mange   := true;
			coup.pions_manges := pions_manges;
			
			coup.nb_pions_manges := 0;
			for i in coup.pions_manges do coup.nb_pions_manges := coup.nb_pions_manges + 1;
			
			i := 0;
			repeat
				i := i+1;
			until (coups_possibles[i].arrivee=0);
				
			// writeln(i);
			coups_possibles[i] := coup;
		end;
	end;
	
	
{
procedure etudeArbre_dame_manger(monPlateau : type_plateau; joueur : integer; var coups_possibles : type_liste_coup; n,n0,direction : integer; pions_manges,dernier_pion_mange : type_pions_manges;deja_tourne : boolean);
var coup : type_coup;
	i : integer;
begin

pions_manges := pions_manges + dernier_pion_mange;
//writeln('  case :  ',n,'   ',direction);
if ((direction=0)or(direction=1)or(not(deja_tourne)))and(not(direction=4)) then
	begin
	//writeln('   dir entree 1 : ',direction);
		if (n>5)and(not(n mod 10 = 0)) then
			begin
			//write('  *  ');
			if monPlateau[bas_droite(n)]=0 then
				etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,bas_droite(n),n0,1,pions_manges,dernier_pion_mange,(deja_tourne) or (direction<>1))
			end;
		if (n>10) and (not(n mod 5 =0)) then
			begin
			//write('  -  ');
			if manger_bas_droite(joueur,n,monPlateau)and(not(bas_droite(n) in pions_manges)) then
				etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,bas_droite(bas_droite(n)),n0,1,pions_manges,[bas_droite(n)],false)
			end;
	//writeln('   dir sortie  1 : ',direction);
	end;

if ((direction=0)or(direction=2)or(not(deja_tourne)))and(not(direction=3)) then
	begin
	//writeln('   dir entree 2 : ',direction);
		if (n>5)and(not(n mod 10 = 1)) then
			begin
			//write('  *  ');
			if monPlateau[bas_gauche(n)]=0 then
				etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,bas_gauche(n),n0,2,pions_manges,dernier_pion_mange,(deja_tourne) or (direction<>2))
			end;
		if (n>10) and (not(n mod 5 =1)) then
			begin
			//write('  -  ');
			if manger_bas_gauche(joueur,n,monPlateau)and(not(bas_gauche(n) in pions_manges)) then
				etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,bas_gauche(bas_gauche(n)),n0,2,pions_manges,[bas_gauche(n)],false)
			end;
	//writeln('   dir sortie 2 : ',direction);
	end;
	
if ((direction=0)or(direction=3)or(not(deja_tourne)))and(not(2=direction)) then
	begin
	//writeln('   dir entree 3 : ',direction);
		if (n<46)and(not(n mod 10 = 0)) then
			begin
			//write('  *  ');
			if monPlateau[haut_droite(n)]=0 then
				etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,haut_droite(n),n0,3,pions_manges,dernier_pion_mange,(deja_tourne) or (direction<>3))
			end;
		if (n<41) and (not(n mod 5 =0)) then
			begin
			//write('  -  ');
			if manger_haut_droite(joueur,n,monPlateau)and(not(haut_droite(n) in pions_manges)) then
				etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,haut_droite(haut_droite(n)),n0,3,pions_manges,[haut_droite(n)],false)
			end;
	//writeln('   dir sortie 3 : ',direction);
	end;
	
if ((direction=0)or(direction=4)or(not(deja_tourne)))and(not(1=direction)) then
	begin
	//write('   dir 4 entree : ',direction);
		if (n<46)and(not(n mod 10 = 1)) then
			begin
			//write('  4*  ');
			if monPlateau[haut_gauche(n)]=0 then
				etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,haut_gauche(n),n0,4,pions_manges,dernier_pion_mange,(deja_tourne) or (direction<>4))
			end;
		if (n<41) and (not(n mod 5 =1)) then
			begin
			//write('  4-  ');
			if manger_haut_gauche(joueur,n,monPlateau)and(not(haut_gauche(n) in pions_manges)) then
				begin
				//write('  4/  ');
				etudeArbre_dame_manger(monPlateau,joueur,coups_possibles,haut_gauche(haut_gauche(n)),n0,4,pions_manges,[haut_gauche(n)],false);
				
				end;
			end;
	//writeln('   dir sortie 4 : ',direction);
	end;
	
if	(pions_manges<>[])and(not(deja_tourne)) then
	begin
		coup.depart  := n0;
		coup.arrivee := n;
		coup.mange   := true;
		coup.pions_manges := pions_manges;
		
		
		//write('  5  ');
		//write(n0,' ',n);
		//for i in coup.pions_manges do write(' ',i);
		//writeln;
		coup.nb_pions_manges := 0;
			for i in coup.pions_manges do coup.nb_pions_manges := coup.nb_pions_manges + 1;
		
		i := 0;
			repeat
			i := i+1;
			until (coups_possibles[i].arrivee=0);
			
		coups_possibles[i] := coup
		
	end;
end;
}



procedure lister_coup_manger_dames(n,joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; plateau_tour : type_plateau);
var i,j,max : integer;
	pions_manges, liste_cases_tab : type_pions_manges;
	coups_possibles : type_liste_coup_etendue;
	
	begin
			for i := 1 to Max_coup_etendu do 
			begin
			coups_possibles[i].depart := 0;
			coups_possibles[i].arrivee := 0;
			end;
					begin
					

							
						pions_manges := [];
						
						
								//algo recursif
{
						assign(fic,'ressources/coups.txt');
						rewrite(fic);
}
						//etudeArbre_dame_manger(plateau_tour,joueur,coups_possibles,n,n,0,pions_manges,[],true);
						etudeArbre_dame_manger(plateau_tour,joueur,coups_possibles,n,n,0,pions_manges,true);
{
						close(fic);
}
						
						
								//on garde les meilleurs coups
{
						i := 0;
							repeat
							i := i+1;
							until (coups_possibles[i+1].arrivee=0);
}
						liste_cases_tab := [];
						for i := 1 to 50 do if coups_possibles[i].depart=n then include(liste_cases_tab,i);
						max := 0;
						for j in liste_cases_tab do
							if coups_possibles[j].nb_pions_manges>max then max := coups_possibles[j].nb_pions_manges;
						for j in liste_cases_tab do
							if coups_possibles[j].nb_pions_manges=max then 
								begin
									nb_coup := nb_coup + 1;
									liste_coup[nb_coup] := coups_possibles[j];
								end;
								
					end;
				
{
		writeln('pre tri');
		writeln(nb_coup);
		for j := 1 to nb_coup do
			begin
				write(liste_coup[j].depart,' ',liste_coup[j].arrivee,' ');
				for i in liste_coup[j].pions_manges do write(i,' ');
				write('  ',liste_coup[j].nb_pions_manges);
				writeln;
				writeln;
			end;
}
	end;
	
	
	
procedure lister_coup_manger(joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; plateau_tour : type_plateau);
var i,n,max,nb_coup_retenu : integer;
	coups_retenus : type_liste_coup;
begin
			
			//on ballaie toutes les cases
			//si c'est un pion qui peut manger, alors : lister_coup_manger_pions
			//si c'est une dame alors  : lister_coup_manger_dames
		for n := 1 to 50 do
				if (plateau_tour[n]=joueur)and
				  (manger_bas_droite (joueur,n,plateau_tour) or
				   manger_bas_gauche (joueur,n,plateau_tour) or
				   manger_haut_droite(joueur,n,plateau_tour) or
				   manger_haut_gauche(joueur,n,plateau_tour)) then 
							lister_coup_manger_pions(n,joueur,nb_coup,liste_coup,plateau_tour)
				else if (plateau_tour[n]=joueur+2) then
							lister_coup_manger_dames(n,joueur,nb_coup,liste_coup,plateau_tour);


	nb_coup_retenu :=0;
	max := 0;
	for i := 1 to nb_coup do
		if liste_coup[i].nb_pions_manges>max then max := liste_coup[i].nb_pions_manges;
	for i := 1 to nb_coup do
		if liste_coup[i].nb_pions_manges=max then 
			begin
				nb_coup_retenu := nb_coup_retenu + 1;
				coups_retenus[nb_coup_retenu] := liste_coup[i];
			end;
	nb_coup := nb_coup_retenu;
	liste_coup := coups_retenus;				

end;

procedure lister_coup(joueur : integer;var nb_coup : integer; var liste_coup : type_liste_coup; mon_plateau : type_plateau);

var i : integer;
	plateau_tour : type_plateau;
begin
//on adapte en fonction du joueur
if joueur = 1 then plateau_tour := mon_plateau
else plateau_tour := inverser_plateau(mon_plateau);

nb_coup := 0;
lister_coup_manger(joueur,nb_coup,liste_coup,mon_plateau);
//writeln(nb_coup);
if nb_coup=0 then 
	begin
	lister_coup_simple_pion(joueur,nb_coup,liste_coup,plateau_tour);
	lister_coup_simple_dame(joueur,nb_coup,liste_coup,mon_plateau);
	end;
	


//for i := 1 to nb_coup do writeln(i,' ',liste_coup[i].depart,' ',liste_coup[i].arrivee);


end;

end.
