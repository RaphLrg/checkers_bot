program tournoi;

{$Q-}
{$R-}
{$S-}
{$R tournoi.res}

uses TypeSdl, init, ia_raphael, sysutils, crt;


var tab : tableau_tournoi;
    i, nb_ia, delais : integer;
	nb_parties, nb_tours_total : longint;
    nom_tournoi : string;
    affichage, enregistrement, securite ,debug_init : boolean;
	t_1, t_2 : TSystemTime;
	fichier, fichier_2 : text;
	// table : table_hash;
	// fichier : file of tableau_table_transposition;
	// tab_enorme : tableau_table_transposition;

begin

	randomize;

	assign(fichier, 'Ressources/ressources_raphael/temps_param_f.txt');
	rewrite(fichier);
	assign(fichier_2, 'Ressources/ressources_raphael/temps_param_f_machine.txt');
	rewrite(fichier_2);
	// for i := -32768 to 32767 do
	// begin
	// 	tab_enorme[i].indice_coup := 1;
	// 	tab_enorme[i].profondeur := -1;
	// 	tab_enorme[i].valeur := 0;
	// 	tab_enorme[i].min := -30000;
	// 	tab_enorme[i].max := 30000;
	// end;

	// DateTimeToSystemTime(Now,t_1);
	// write(fichier, tab_enorme);
	// reset(fichier);
	// read(fichier, tab_enorme);
	// close(fichier);
	// DateTimeToSystemTime(Now,t_2);
	// writeln(diffTemps(t_2, t_1));


    // Entrer les noms des IAs concurrentes et le nombre total d'IAs

	
	tab[1].ia := @ia_raphael_vr3;
	tab[2].ia := @ia_raphael_v6_temoin;//ia_random;

	tab[1].nom := 'ia_raphael_v6_temoin';
	tab[2].nom := 'ia_raphael_vr3';

	nb_ia := 2; //Nombre d'IAs concurrentes dans le tournoi compris entre 2 et 20

    nb_parties := 1; //Nombre de parties par match entre 2 IAs (Nombre impair conseillé car le cas des égalités n'est pas traité)

    delais := 0; //Délais entre chaque tours en millisecondes

    nom_tournoi := 'Test influence centre'; //Nom du tournoi

    affichage := false; //Affichage en SDL (calcul beaucoup plus long)

    enregistrement := false; //Enregistre chaque parties du tournoi dans un fichier

	debug_init := false; //Active ou non le débugage de la partie Raphaël de l'unité init.pas

	param_pion_1 := 50;
	param_pion_2 := 5;//100;
	param_1 := 200;
    param_2 := 20;//5570;
    param_3 := 0;
    param_4 := 0;
    param_5 := 1;
    param_6 := 19;//-20;
	param_1_2 := 190;
	param_2_2 := 19;
	param_pion_1_2 := 40;
	param_pion_2_2 := 4;
	max_tri := 2;
	profondeur_ia_6 := 2;
	profondeur_ia_6_temoin := 4;
	debut_alpha := -100;//-100;//-6;
	debut_alpha_temoin := -6;
    debut_beta := 100;//100;//10;
    debut_beta_temoin := 10;
	param_case_autour := 1;
	profondeur_ia_7 := 4;

	//Sécurités
	securite := false; //Mettre sur false pour autoriser des affichages longs (plusieurs minutes) A UTILISER AVEC PRUDENCE !!!

	if securite then
	begin
		if delais > 500 then delais := 500;
		if (nb_parties > 5) or (nb_ia > 4) then affichage := false;
		if (not affichage) or (nb_parties > 5) or (nb_ia > 5) then delais := 0;
	end;

	write('Choisissez votre profondeur de calcul : ');
	readln(profondeur_ia_6_temoin);

	if (2 <= nb_ia) and (nb_ia <= 20) then
	for i := 1 to 1000 do
	begin
		// append(fichier);
		// append(fichier_2);
		// writeln('Profondeur = ', debut_beta);
		compteur_global := 0;
		DateTimeToSystemTime(Now,t_1);
		tournoi_ia(tab, nb_ia, nb_parties, delais, nom_tournoi, affichage, enregistrement, debug_init, nb_tours_total);
		DateTimeToSystemTime(Now,t_2);
		write('Temps d''execution total : ', trunc(diffTemps(t_2, t_1) / 1000), ',');
		if round((diffTemps(t_2, t_1) - trunc(diffTemps(t_2, t_1) / 1000)*1000)) < 100 then write('0') else if round((diffTemps(t_2, t_1) - trunc(diffTemps(t_2, t_1) / 1000)*1000)) < 10 then write('00');
		write(round((diffTemps(t_2, t_1) - trunc(diffTemps(t_2, t_1) / 1000)*1000)), ' secondes || temps moyen par partie : ', trunc((diffTemps(t_2, t_1) / 1000)/nb_parties), ',');
		if round(((diffTemps(t_2, t_1) - trunc((diffTemps(t_2, t_1) / 1000)/nb_parties)*1000*nb_parties)/nb_parties)) < 100 then write('0') else if round(((diffTemps(t_2, t_1) - trunc((diffTemps(t_2, t_1) / 1000)/nb_parties)*1000*nb_parties)/nb_parties)) < 10 then write('00');
		writeln(round(((diffTemps(t_2, t_1) - trunc((diffTemps(t_2, t_1) / 1000)/nb_parties)*1000*nb_parties)/nb_parties)), ' secondes || temps moyen par coup : ', diffTemps(t_2, t_1) div nb_tours_total, ',', round(((diffTemps(t_2, t_1) / nb_tours_total) - (diffTemps(t_2, t_1) div nb_tours_total))*100), ' millisecondes.');
		evaluation_remplissage_tableau_transposition('vr3++', true, true);
		writeln(compteur_global div nb_parties, ' collisions par parties, ', compteur_global div nb_tours_total, ' collisions par tours, ', nb_tours_total div nb_parties, ' tours');
		writeln('');
		// writeln(fichier, 'f = ', debut_beta, ', temps = ', round(diffTemps(t_2, t_1) / nb_parties), ' millisecondes.');
		// writeln(fichier_2, debut_beta, ' ', round(diffTemps(t_2, t_1) / nb_parties));
		// close(fichier);
		// close(fichier_2);
	end
	else 
		writeln('Mauvais nombre d''IAs indique');

end.