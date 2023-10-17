unit TypeSdl;

{$Q+}
{$R-}
{$S-}

interface

uses crt, sdl, sdl_image, sdl_ttf, sdl_mixer, sysutils;

const Max_coup_etendu = 5000;
	MAX_PARAM_EVO = 22;

type type_plateau = array [1..50] of 0..4;   // 0 = vide    1 = J1   2 = J2
type position = record
	x,y : integer
end;

type type_coup = record
	depart,arrivee : integer;		// cases de depart et d'arrivee
	mange : boolean;				// vrai si on mange au moins un pion dans le coup
	pions_manges : set of 1..50;
	nb_pions_manges : integer;
end;


			//les cases entre 1 et n inclus seront les coups possibles
			//les cases suivantes seront vides ou avec des infos non correctes
			//le nombre 50 est choisi au pif juste assez grand pour stocker un max de coup
type type_liste_coup = array [1..100] of type_coup;

type type_liste_coup_etendue = array [1..Max_coup_etendu] of type_coup;

type type_ia = function(joueur, nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

type info_tournoi = record
	ia : type_ia;
	nom : string;
	nb_victoire : integer
end;

type type_data_poids = record
	debut_alpha, debut_beta : integer;
	tab : array[1..MAX_PARAM_EVO] of integer;
	tab_mutation : array[1..MAX_PARAM_EVO+2] of integer;
end;

type type_ia_evo = function(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau; numero_data, nom_dossier : string):integer;

type tableau_tournoi = array[1..20] of info_tournoi;

var window: PSDL_SURFACE;
	musique : pmix_music;
	blanc, noir, dame_blanche, dame_noir, case_blanche, case_noir, fond :  PSDL_SURFACE;			
	
	// plateau : type_plateau;
	DimensionX, DimensionY : integer;
	fic : text;

const L_plateau =1000;
	  L_case    = 80;

function diffTemps(temps2, temps1 : TSystemTime {Temps1 - Temps2}):longint;


implementation


function diffTemps(temps2, temps1 : TSystemTime {Temps1 - Temps2}):longint;
begin
	diffTemps := (temps2.millisecond - temps1.millisecond) + 1000*(temps2.second - temps1.second) + 60000*(temps2.minute - temps1.minute) + 3600*1000*(temps2.hour - temps1.hour) + 3600*1000*24*(temps2.day - temps1.day); //  + 3600*1000*24*30*(temps2.month - temps1.month) + 3600*1000*24*12(temps2.year - temps1.year)
end;
// DateTimeToSystemTime(Now,temps1);


END.

