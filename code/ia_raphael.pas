unit ia_raphael;

{$Q-}
{$R-}
{$S-}

interface
    uses typesdl, manger, sysutils, math, crt, strutils; 

    var param_pion_1, param_pion_2, param_1, param_2, param_3, param_4, param_5, param_6, param_1_2, param_pion_1_2, debut_alpha, debut_beta, param_case_autour, param_pion_2_2, debut_alpha_temoin, debut_beta_temoin, param_2_2, profondeur_ia_6_temoin, profondeur_ia_7 : integer;
        compteur_global : longint;
        max_tri, profondeur_ia_6 : byte; 

    type type_indices_liste_coup = array[1..100] of integer;

    type type_cout = function(plateau : type_plateau; joueur_ref : integer):integer;

    const   max_tab = 32767;
            min_tab = -32768;
            max_dim = 20;
    //type type_plateau = array [1..50] of integer;

    type type_table_transposition = record 
        profondeur : shortint;
        alpha, beta : integer;
        hash_verif : longint;
    end;        

    type type_tableau_table_transposition = array[min_tab..max_tab] of array [1..max_dim] of type_table_transposition;

    type type_test_tab_p_table = array[-134217728..134217727] of ^type_tableau_table_transposition;
    
    type type_tab_p_table = array[-256..255] of ^type_tableau_table_transposition;

    type type_table_hash = array[1..50,0..4] of longint;

    type type_selection = array[1..2] of integer;

    type type_tab_data = array[1..100] of type_data_poids;

    type enum_cases = set of 1..50;

//fonction et procedure//
    function bordure(ma_case : integer):boolean;

    function cases_sous_control(plateau : type_plateau; nb_joueur : integer; mes_pions : enum_cases; var nb_cases_sous_control : integer):enum_cases;

    function ensemble_pions(plateau : type_plateau; nb_joueur : integer; var nb_pions : integer):enum_cases;

    function minmax(plateau : type_plateau; coup_a_jouer : type_coup; etage : boolean; joueur_ref, joueur_courant, profondeur : integer):integer;

    function ia_raphael_v1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_v2(joueur_ref, nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    // function ia_raphael_v3(joueur_ref, nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_v4(joueur_ref, nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_v5(joueur_ref, nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function alpha_beta_v6(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur, alpha, beta : integer; var data_poids : type_data_poids):integer;

    function ia_raphael_v6(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau; numero_data, nom_dossier : string):integer;

    function ia_raphael_v6_1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau; numero_data, nom_dossier : string):integer;

    function ia_raphael_v6_temoin(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_v2_temoin(joueur_ref, nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_v7(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_memo_v1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_memo_mtd_v1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_v8(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_vr1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_vr2(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_vr3(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_vr3t(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function ia_raphael_vr4(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;

    function cout_v3(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref : integer):integer;

    function cout_v4(plateau : type_plateau; joueur_ref : integer):integer;

    function cout_v4_tri(plateau : type_plateau; var coup_a_jouer : type_coup; joueur_ref : integer):integer;

    procedure init_table_hash(var table_hash : type_table_hash);

    procedure init_table_verif(var table_verif : type_table_hash);

    function hash(plateau : type_plateau; table_hash : type_table_hash):integer;

    function hash_verif(plateau : type_plateau; table_verif : type_table_hash):longint;

    function stable(plateau : type_plateau; joueur_courant : integer):boolean;

    procedure evaluation_remplissage_tableau_transposition(nom_version : string; rapport, save : boolean);

    function cout_vcr1(plateau : type_plateau; joueur_ref : integer; var data_poids : type_data_poids):integer;

    procedure affichage_data(nom_monde : string);

    function selection(ia : type_ia_evo; nom_monde : string):type_selection;

    function heredite(survivant : type_selection; tab_data : type_tab_data; nb_ia_fille, nb_ia_alea : integer; nom_monde : string):type_tab_data;

    function heredite_v2(survivant : type_selection; tab_data : type_tab_data; nb_ia_fille, nb_ia_alea : integer; nom_monde : string):type_tab_data;

    function init_tab_data(nb_total_ia : integer; nom_monde : string; enregistrement : boolean):type_tab_data;

    function init_data_poids():type_data_poids;

    procedure variance_evo();

implementation

//************************************ EVOLUTION ************************************\\

    uses init;

    procedure variance_evo();
    const Nombre_data = 10;
    var tab_nom : array[1..5] of string;
        i, j : integer;
        fichier_data : file of type_data_poids;
        tab_data : array[1..10] of type_data_poids;
        tab_moyenne, tab_variance : array[1..24] of float;

    begin
        tab_nom[1] := 'jurassic';
        tab_nom[2] := 'cretace';
        tab_nom[3] := 'trias';
        tab_nom[4] := 'mesozoique';
        tab_nom[5] := 'paleozoique';
        for i := 1 to 5 do
        begin
            for j := 1 to 2 do
            begin
                assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ tab_nom[i] +'/rapport/dataset_'+ inttostr(j+((j-1)*4)) +'.poi');
                reset(fichier_data);
                read(fichier_data, tab_data[((i-1)*2) + j]);
                close(fichier_data);
            end;
        end;

        for i := 1 to 24 do
        begin
            tab_moyenne[i] := 0;
            tab_variance[i] := 0;
        end;

        for i := 1 to 24 do
        begin
            for j := 1 to Nombre_data do
            begin
                if i < 23 then
                    tab_moyenne[i] := tab_moyenne[i] + tab_data[j].tab[i]
                else
                    if i = 23 then
                        tab_moyenne[i] := tab_moyenne[i] + tab_data[j].debut_alpha
                    else
                        tab_moyenne[i] := tab_moyenne[i] + tab_data[j].debut_beta;
            end;
            tab_moyenne[i] := tab_moyenne[i] / Nombre_data;
        end;

        for i := 1 to 24 do
        begin
            for j := 1 to Nombre_data do
            begin
                if i < 23 then
                    tab_variance[i] := tab_variance[i] + sqr(tab_data[j].tab[i] - tab_moyenne[i])
                else
                    if i = 23 then
                        tab_variance[i] := tab_variance[i] + sqr(tab_data[j].debut_alpha - tab_moyenne[i])
                    else
                        tab_variance[i] := tab_variance[i] + sqr(tab_data[j].debut_beta - tab_moyenne[i]);
            end;
            tab_variance[i] := tab_variance[i] / Nombre_data;
        end;

        // for i := 1 to 24 do
        //     write(tab_moyenne[i]:3:2,' ');
        // writeln('');
        writeln('');

        for i := 1 to 24 do
        begin
            if tab_variance[i]**(1/5) <= 1.25 then
            begin
                textbackground(yellow);
                textcolor(white);
            end
            else
                if (1.25 < tab_variance[i]**(1/5)) and (tab_variance[i]**(1/5) <= 3) then
                begin
                    textbackground(brown);
                    textcolor(black);
                end
                else
                    if (3 < tab_variance[i]**(1/5)) and (tab_variance[i]**(1/5) <= 5) then
                    begin
                        textbackground(red);
                        textcolor(black);
                    end
                    else
                        if (5 < tab_variance[i]**(1/5)) and (tab_variance[i]**(1/5) <= 7.5) then
                        begin
                            textbackground(magenta);
                            textcolor(black);
                        end
                        else
                            if (7.5 < tab_variance[i]**(1/5)) and (tab_variance[i]**(1/5) <= 10) then
                            begin
                                textbackground(cyan);
                                textcolor(black);
                            end
                            else
                                if (10 < tab_variance[i]**(1/5)) and (tab_variance[i]**(1/5) <= 15) then
                                begin
                                    textbackground(green);
                                    textcolor(black);
                                end
                                else
                                    if (15 < tab_variance[i]**(1/5)) and (tab_variance[i]**(1/5) <= 20) then
                                    begin
                                        textbackground(blue);
                                        textcolor(black);
                                    end
                                    else
                                    begin
                                        textbackground(lightgray);
                                        textcolor(black);
                                    end;

            if (i >= 23) or (i = 1) then
                write(' ');

            if i > 1 then
                write(' ');

            if tab_variance[i]**(1/5) < 100 then 
                write('  ')
            else
                if tab_variance[i]**(1/5) < 10 then
                    write('   ')
                else
                    write(' ');

            write((tab_variance[i])**(1/5):3:2);

            if tab_variance[i]**(1/5) < 100 then 
                write(' ')
            else
                if tab_variance[i]**(1/5) < 10 then
                    write('  ');

            textbackground(black);
            textcolor(white);

            write(' ');
        end;
        writeln('');

    end;

    procedure affichage_data(nom_monde : string);
    var i, j, nb_generation, y_debut, x_debut : integer;
        fichier_data : file of type_data_poids;
        fichier_generation : file of integer;
        data : type_data_poids;

    begin
        writeln('');
        writeln(nom_monde);
        assign(fichier_generation, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/nb_generation.int');
        reset(fichier_generation);
        read(fichier_generation, nb_generation);
        close(fichier_generation); 
        writeln(nb_generation, ' generations');
        i := 1;
        y_debut := whereY;
        repeat
            assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/dataset_'+ inttostr(i) +'.poi');
            reset(fichier_data);
            read(fichier_data, data);
            close(fichier_data);
            with data do
            begin
                for j := 1 to MAX_PARAM_EVO do
                begin
                    //gotoxy(j*20-9, i + y_debut);
                    if abs(tab[j]) = tab[j] then 
                        write(' ');
                    if abs(tab[j]) < 10 then 
                        write('  ') 
                    else
                        if abs(tab[j]) < 100 then 
                            write(' ');
                    write(tab[j],'|',tab_mutation[j]);
                    if abs(tab_mutation[j]) = tab_mutation[j] then 
                            write(' ');
                        if abs(tab_mutation[j]) < 10 then 
                            write('  ')
                        else
                            if abs(tab_mutation[j]) < 100 then 
                                write(' ');
                end;
                x_debut := j*20-9;
                for j := MAX_PARAM_EVO + 1 to MAX_PARAM_EVO + 2 do
                begin
                    // gotoxy(x_debut + (j-21)*10 - 11, i + y_debut);
                    if j = MAX_PARAM_EVO + 1 then 
                    begin
                        if abs(debut_alpha) = debut_alpha then 
                            write(' ');
                        if abs(debut_alpha) < 10 then 
                            write('    ')
                        else
                            if abs(debut_alpha) < 100 then 
                                write('   ')
                            else
                                if abs(debut_alpha) < 1000 then 
                                    write('  ')
                                else
                                    if abs(debut_alpha) < 10000 then 
                                        write(' ');
                        write(debut_alpha,'|',tab_mutation[j]);
                        if abs(tab_mutation[j]) = tab_mutation[j] then 
                            write(' ');
                        if abs(tab_mutation[j]) < 10 then 
                            write(' ')
                        else
                            if abs(tab_mutation[j]) < 100 then 
                                write(' ');
                    end
                    else
                    begin
                        if abs(debut_beta) = debut_beta then 
                            write(' ');
                        if abs(debut_beta) < 10 then 
                            write('    ')
                        else
                            if abs(debut_beta) < 100 then 
                                write('   ')
                            else
                                if abs(debut_beta) < 1000 then 
                                    write('  ')
                                else
                                    if abs(debut_beta) < 10000 then 
                                        write(' ');
                        write(debut_beta,'|',tab_mutation[j]);
                        if abs(tab_mutation[j]) = tab_mutation[j] then 
                            write(' ');
                        if abs(tab_mutation[j]) < 10 then 
                            write('  ')
                        else
                            if abs(tab_mutation[j]) < 100 then 
                                write(' ');
                    end;
                end;
            end;
            writeln('');
            i := i + 1;
        until not fileExists('Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi');
    end;

    function init_data_poids():type_data_poids;
    var i : integer;
    begin
        for i := 1 to 24 do
        begin
            if i < 23 then
            begin
                if random(2) = 0 then
                    init_data_poids.tab[i] := random(300)
                else
                    init_data_poids.tab[i] := - random(300);
            end
            else
                if i = 23 then
                    init_data_poids.debut_alpha := -30000
                else
                    init_data_poids.debut_beta := 30000;

            init_data_poids.tab_mutation[i] := 100; 
        end;
    end;

    function init_tab_data(nb_total_ia : integer; nom_monde : string; enregistrement : boolean):type_tab_data;
    var fichier_data, fichier_rapport : file of type_data_poids;
        i : integer;
    begin
        for i := 1 to 100 do
            init_tab_data[i] := init_data_poids;
        if enregistrement then
            for i := 1 to nb_total_ia do
            begin
                assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi');
                rewrite(fichier_data);
                write(fichier_data, init_tab_data[i]);
                close(fichier_data);
                assign(fichier_rapport, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/dataset_'+ inttostr(i) +'.poi');
                rewrite(fichier_rapport);
                write(fichier_rapport, init_tab_data[i]);
                close(fichier_rapport);
            end;
    end;

    function mutation(data : type_data_poids):type_data_poids;
    var i : integer;
    begin
        for i := 1 to 24 do
            if random(3) = 0 then
            begin
                if i < 23 then
                begin
                    if random(2) = 0 then
                    begin
                        if data.tab[i] + round(data.tab[i] * data.tab_mutation[i] / 1000) <= 290 then
                            mutation.tab[i] := data.tab[i] + round(data.tab[i] * (random(data.tab_mutation[i]) / 1000)) + random(10);
                    end
                    else
                        if data.tab[i] - round(data.tab[i] * data.tab_mutation[i] / 1000) >= -290 then
                            mutation.tab[i] := data.tab[i] - round(data.tab[i] * (random(data.tab_mutation[i]) / 1000)) - random(10);
                    mutation.tab[i] := mutation.tab[i] mod 301;
                end
                else
                    if i = 23 then
                    begin
                        if random(2) = 0 then
                        begin
                            if data.debut_alpha <= -10 then
                                mutation.debut_alpha := data.debut_alpha + round(data.debut_alpha * (random(data.tab_mutation[i]) / 1000)) + random(10);
                        end
                        else
                            if data.debut_alpha >= -29990 then
                                mutation.debut_alpha := data.debut_alpha - round(data.debut_alpha * (random(data.tab_mutation[i]) / 1000)) - random(10);
                        mutation.debut_alpha := - abs(mutation.debut_alpha mod 30001);
                    end
                    else
                    begin
                        if random(2) = 0 then
                        begin
                            if data.debut_beta >= 10 then
                                mutation.debut_beta := data.debut_beta - round(data.debut_beta * (random(data.tab_mutation[i]) / 1000)) - random(10);
                        end
                        else
                            if data.debut_beta <= 29990 then
                                mutation.debut_beta := data.debut_beta + round(data.debut_beta * (random(data.tab_mutation[i]) / 1000)) + random(10);
                        mutation.debut_beta := abs(mutation.debut_beta mod 30001);
                    end; 
                mutation.tab_mutation[i] := data.tab_mutation[i]
            end;
    end;

    function heredite_v2(survivant : type_selection; tab_data : type_tab_data; nb_ia_fille, nb_ia_alea : integer; nom_monde : string):type_tab_data;
    var fichier_data, fichier_rapport : file of type_data_poids;
        tab_data_sortie : type_tab_data;
        i, j : integer;

    begin
        tab_data_sortie := init_tab_data(nb_ia_fille + nb_ia_alea, nom_monde, false);
        
        for i := 1 to nb_ia_fille + nb_ia_alea do
        begin
            if (i = 1) or (i = (nb_ia_fille div 2) + 1) then
            begin
                if i = 1 then
                    tab_data_sortie[i] := tab_data[survivant[1]]
                else
                    tab_data_sortie[i] := tab_data[survivant[2]]
            end
            else
            begin
                if i <= nb_ia_fille div 2 then
                begin
                    tab_data_sortie[i] := mutation(tab_data[survivant[1]]);
                end
                else
                begin
                    if i <= nb_ia_fille then
                    begin
                        tab_data_sortie[i] := mutation(tab_data[survivant[2]]);
                    end
                    else
                        tab_data_sortie[i] := init_data_poids;                    
                end;
            end;
            assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi');
            rewrite(fichier_data);
            write(fichier_data, tab_data_sortie[i]);
            close(fichier_data);
            assign(fichier_rapport, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/dataset_'+ inttostr(i) +'.poi');
            rewrite(fichier_rapport);
            write(fichier_rapport, tab_data_sortie[i]);
            close(fichier_rapport);
        end;
        heredite_v2 := tab_data_sortie;
    end;

    function heredite(survivant : type_selection; tab_data : type_tab_data; nb_ia_fille, nb_ia_alea : integer; nom_monde : string):type_tab_data;
    var fichier_data : file of type_data_poids;
        tab_data_sortie : type_tab_data;
        i, j : integer;

    begin
        for i := 1 to nb_ia_fille div 2 do 
        begin
            if i = 1 then 
                tab_data_sortie[i] := tab_data[survivant[1]]
            else
            begin
                for j := 1 to 22 do
                begin
                    if random(3) = 0 then
                        if random(2) = 0 then
                            tab_data_sortie[i].tab[j] := tab_data[survivant[1]].tab[j] + round(tab_data[survivant[1]].tab[j] * (random(tab_data[survivant[1]].tab_mutation[j]) / 1000)) + random(4)
                        else
                            tab_data_sortie[i].tab[j] := tab_data[survivant[1]].tab[j] - round(tab_data[survivant[1]].tab[j] * (random(tab_data[survivant[1]].tab_mutation[j]) / 1000)) - random(4)
                    else
                        tab_data_sortie[i].tab[j] := tab_data[survivant[1]].tab[j];

                    tab_data_sortie[i].tab[j] := tab_data_sortie[i].tab[j] mod 501;
                end;

                if random(3) = 0 then
                    if random(2) = 0 then
                        tab_data_sortie[i].debut_alpha := tab_data[survivant[1]].debut_alpha + round(tab_data[survivant[1]].debut_alpha * (random(tab_data[survivant[1]].tab_mutation[23]) / 1000)) + random(4)
                    else
                        tab_data_sortie[i].debut_alpha := tab_data[survivant[1]].debut_alpha - round(tab_data[survivant[1]].debut_alpha * (random(tab_data[survivant[1]].tab_mutation[23]) / 1000)) - random(4)
                else
                    tab_data_sortie[i].debut_alpha := tab_data[survivant[1]].debut_alpha;

                tab_data_sortie[i].debut_alpha := -abs(tab_data_sortie[i].debut_alpha mod 30001);

                if random(3) = 0 then
                    if random(2) = 0 then
                        tab_data_sortie[i].debut_beta := tab_data[survivant[1]].debut_beta + round(tab_data[survivant[1]].debut_beta * (random(tab_data[survivant[1]].tab_mutation[24]) / 1000)) + random(4)
                    else
                        tab_data_sortie[i].debut_beta := tab_data[survivant[1]].debut_beta - round(tab_data[survivant[1]].debut_beta * (random(tab_data[survivant[1]].tab_mutation[24]) / 1000)) - random(4)
                else    
                    tab_data_sortie[i].debut_beta := tab_data[survivant[1]].debut_beta;
                
                tab_data_sortie[i].debut_beta := abs(tab_data_sortie[i].debut_beta mod 30001);

                for j := 1 to 24 do
                begin
                    if tab_data[survivant[1]].tab_mutation[j] = 0 then
                    begin
                        if j in [1..22] then
                            if tab_data[survivant[1]].tab[j] = 0 then
                                tab_data_sortie[i].tab_mutation[j] := 100
                        else
                            if j = 23 then
                                if tab_data[survivant[1]].debut_alpha = 0 then
                                    tab_data_sortie[i].tab_mutation[j] := 100
                            else
                                if tab_data[survivant[1]].debut_beta = 0 then
                                    tab_data_sortie[i].tab_mutation[j] := 100
                                else
                                    if (random(2) = 0) then
                                        tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[1]].tab_mutation[j] - random(20)
                                    else
                                        if (tab_data[survivant[1]].tab_mutation[j] < 500) then
                                            tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[1]].tab_mutation[j] + random(20)
                                        else
                                            tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[1]].tab_mutation[j];
                    end
                    else
                        if (random(2) = 0) then
                            tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[1]].tab_mutation[j] - random(20)
                        else
                            if (tab_data[survivant[1]].tab_mutation[j] < 500) then
                                tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[1]].tab_mutation[j] + random(20)
                            else
                                tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[1]].tab_mutation[j];
                    
                    tab_data_sortie[i].tab_mutation[j] := abs(tab_data_sortie[i].tab_mutation[j] mod 501);
                end;

            end;
        end;
        for i := (nb_ia_fille div 2) + 1 to nb_ia_fille do 
        begin
            if i = (nb_ia_fille div 2) + 1 then 
                tab_data_sortie[i] := tab_data[survivant[2]]
            else
            begin
                for j := 1 to 22 do
                begin
                    if random(3) = 0 then
                        if random(2) = 0 then
                            tab_data_sortie[i].tab[j] := tab_data[survivant[2]].tab[j] + round(tab_data[survivant[2]].tab[j] * (random(tab_data[survivant[2]].tab_mutation[j]) / 1000)) + random(4)
                        else
                            tab_data_sortie[i].tab[j] := tab_data[survivant[2]].tab[j] - round(tab_data[survivant[2]].tab[j] * (random(tab_data[survivant[2]].tab_mutation[j]) / 1000)) - random(4)
                    else
                        tab_data_sortie[i].tab[j] := tab_data[survivant[2]].tab[j];

                    tab_data_sortie[i].tab[j] := tab_data_sortie[i].tab[j] mod 501;

                    if tab_data_sortie[i].tab[j] > 500 then
                        tab_data_sortie[i].tab[j] := 500;
                    if tab_data_sortie[i].tab[j] < -500 then
                        tab_data_sortie[i].tab[j] := -500;
                end;

                if random(3) = 0 then
                    if random(2) = 0 then
                        tab_data_sortie[i].debut_alpha := tab_data[survivant[2]].debut_alpha + round(tab_data[survivant[2]].debut_alpha * (random(tab_data[survivant[2]].tab_mutation[23]) / 1000)) + random(4)
                    else
                        tab_data_sortie[i].debut_alpha := tab_data[survivant[2]].debut_alpha - round(tab_data[survivant[2]].debut_alpha * (random(tab_data[survivant[2]].tab_mutation[23]) / 1000)) - random(4)
                else
                    tab_data_sortie[i].debut_alpha := tab_data[survivant[2]].debut_alpha;

                tab_data_sortie[i].debut_alpha := -abs(tab_data_sortie[i].debut_alpha mod 30001);
                
                if random(3) = 0 then
                    if random(2) = 0 then
                        tab_data_sortie[i].debut_beta := tab_data[survivant[2]].debut_beta + round(tab_data[survivant[2]].debut_beta * (random(tab_data[survivant[2]].tab_mutation[24]) / 1000)) + random(4)
                    else
                        tab_data_sortie[i].debut_beta := tab_data[survivant[2]].debut_beta - round(tab_data[survivant[2]].debut_beta * (random(tab_data[survivant[2]].tab_mutation[24]) / 1000)) - random(4)
                else
                    tab_data_sortie[i].debut_beta := tab_data[survivant[2]].debut_beta;

                tab_data_sortie[i].debut_beta := abs(tab_data_sortie[i].debut_beta mod 30001);

                for j := 1 to 24 do
                begin
                    if tab_data[survivant[2]].tab_mutation[j] <= 0 then
                    begin
                        if j in [1..22] then
                            if tab_data[survivant[2]].tab[j] = 0 then
                                tab_data_sortie[i].tab_mutation[j] := 50
                        else
                            if j = 23 then
                                if tab_data[survivant[2]].debut_alpha >= -10 then
                                    tab_data_sortie[i].tab_mutation[j] := 50
                            else
                                if tab_data[survivant[2]].debut_beta <= 10 then
                                    tab_data_sortie[i].tab_mutation[j] := 50
                                else
                                    tab_data_sortie[i].tab_mutation[j] := random(20)
                    end
                    else
                        if (random(2) = 0) then
                            tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[2]].tab_mutation[j] - random(20)
                        else
                            if (tab_data[survivant[2]].tab_mutation[j] < 500) then
                                tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[2]].tab_mutation[j] + random(20)
                            else
                                tab_data_sortie[i].tab_mutation[j] := tab_data[survivant[2]].tab_mutation[j];
                    
                    tab_data_sortie[i].tab_mutation[j] := abs(tab_data_sortie[i].tab_mutation[j] mod 501);
                end;
            end;
        end;
        for i := nb_ia_fille + 1 to nb_ia_fille + nb_ia_alea do
        begin
            for j := 1 to 22 do
                if random(2) = 0 then
                    tab_data_sortie[i].tab[j] := random(400)
                else
                    tab_data_sortie[i].tab[j] := -random(400);

            tab_data_sortie[i].debut_alpha := -30000;
            tab_data_sortie[i].debut_beta := 30000;
            
            for j := 1 to 24 do
            begin
                tab_data_sortie[i].tab_mutation[j] := 100;
            end;
        end;
        for i := 1 to nb_ia_fille + nb_ia_alea do
        begin
            assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi');
            rewrite(fichier_data);
            write(fichier_data, tab_data_sortie[i]);
            close(fichier_data);
            assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/dataset_'+ inttostr(i) +'.poi');
            rewrite(fichier_data);
            write(fichier_data, tab_data_sortie[i]);
            close(fichier_data);
        end;
        heredite := tab_data_sortie;
    end;

    function selection(ia : type_ia_evo; nom_monde : string):type_selection;
    const MAX_PARTIES = 20;

    var data_poids : type_data_poids;
        i, j, nb_total_ia, numero_ia_1, numero_ia_2, nb_victoire_1, nb_victoire_2, nb_egalite : integer;
        tab_victoire : array[1..100,1..2] of integer;
        tab_survivant : array[1..2,1..2] of integer;
        fichier_data : file of type_data_poids;
        tab_data : array[1..100] of type_data_poids;
        sortie : boolean;

    begin
        i := 1;
        // for i := 1 to MAX_IA do
        repeat
            for j := 1 to 2 do
                tab_victoire[i,j] := 0;
            assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi');
            reset(fichier_data);
            read(fichier_data, tab_data[i]);
            close(fichier_data);
            i := i + 1;
        until (not fileExists('Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi')) or (i > 100);

        nb_total_ia := i - 1;

        for numero_ia_1 := 1 to nb_total_ia - 1 do
            for numero_ia_2 := numero_ia_1 + 1 to nb_total_ia do
            begin
                // writeln(0.1:1:1);
                match_ia_evo(ia, ia, MAX_PARTIES, inttostr(numero_ia_1), inttostr(numero_ia_2), nom_monde, nb_victoire_1, nb_victoire_2, nb_egalite);
                // writeln(0.2:1:1);

                tab_victoire[numero_ia_1,1] := tab_victoire[numero_ia_1,1] + nb_victoire_1;
                tab_victoire[numero_ia_1,2] := tab_victoire[numero_ia_1,2] + nb_egalite;
                tab_victoire[numero_ia_2,1] := tab_victoire[numero_ia_2,1] + nb_victoire_2;
                tab_victoire[numero_ia_2,2] := tab_victoire[numero_ia_2,2] + nb_egalite;

                for i := 1 to nb_total_ia do
                    write('IA',i, ' ', tab_victoire[i,1], '-', tab_victoire[i,2], '|');
                writeln('');
            end;
        
        // writeln(1);
        tab_survivant[1,1] := 0;
        tab_survivant[1,2] := 0;
        tab_survivant[2,1] := 0;
        tab_survivant[2,2] := 0;
        selection[1] := 1;
        selection[2] := 2;

        // writeln(2);
        for i := 1 to nb_total_ia do
        begin
            sortie := false;
            j := 1;
            repeat
                if tab_survivant[j,1] < tab_victoire[i,1] then
                begin
                    if j = 1 then
                    begin
                        tab_survivant[2,1] := tab_survivant[1,1];
                        tab_survivant[2,2] := tab_survivant[1,2];
                        selection[2] := selection[1];
                    end;
                    tab_survivant[j,1] := tab_victoire[i,1];
                    tab_survivant[j,2] := tab_victoire[i,2];
                    selection[j] := i;
                    sortie := true;
                end
                else
                    if (tab_survivant[j,1] = tab_victoire[i,1]) and (tab_survivant[j,2] < tab_victoire[i,2]) then
                    begin
                        if j = 1 then
                        begin
                            tab_survivant[2,1] := tab_survivant[1,1];
                            tab_survivant[2,2] := tab_survivant[1,2];
                            selection[2] := selection[1];
                        end;
                        tab_survivant[j,1] := tab_victoire[i,1];
                        tab_survivant[j,2] := tab_victoire[i,2];
                        selection[j] := i;
                        sortie := true;
                    end
                    else
                        if (tab_survivant[j,1] = tab_victoire[i,1]) and (tab_survivant[j,2] = tab_victoire[i,2]) and (random(2) = 1) then
                        begin
                            if j = 1 then
                            begin
                                tab_survivant[2,1] := tab_survivant[1,1];
                                tab_survivant[2,2] := tab_survivant[1,2];
                                selection[2] := selection[1];
                            end;
                            tab_survivant[j,1] := tab_victoire[i,1];
                            tab_survivant[j,2] := tab_victoire[i,2];
                            selection[j] := i;
                            sortie := true;
                        end;
                j := j + 1;
            until sortie or (j > 2);
        end;
        
    end;

//************************************ HEURISTIQUES ************************************\\

    procedure evaluation_remplissage_tableau_transposition(nom_version : string; rapport, save : boolean);
    var tableau_table_transposition : type_tableau_table_transposition;
        fichier, backup : file of type_tableau_table_transposition;
        i, j, k, profondeur : integer;
        total, compteur : longint;
        enregistrement : text;

    begin
        if rapport then 
        begin
            assign(enregistrement, 'Ressources/ressources_raphael/rapport_remplissage/rapport_'+ nom_version +'.txt');
            if not fileExists('Ressources/ressources_raphael/rapport_remplissage/rapport_'+ nom_version +'.txt') then
                rewrite(enregistrement);
            append(enregistrement);
            writeln(enregistrement, '');
        end;
        if fileExists('Ressources/ressources_raphael/tableau_table_transposition_'+ nom_version +'.ttt') then
        begin
            assign(fichier, 'Ressources/ressources_raphael/tableau_table_transposition_'+ nom_version +'.ttt');
            reset(fichier);
            read(fichier, tableau_table_transposition);
            close(fichier);

            if save then
            begin
                assign(backup, 'Ressources/ressources_raphael/backup/tableau_table_transposition_'+ nom_version + '.ttt');
                rewrite(backup);
                write(backup, tableau_table_transposition);
                close(backup);
            end;

            profondeur := 1;
            compteur := 1;
            total := 0;
            while (compteur > 0) or (profondeur < 10) do
            begin
                compteur := 0;
                for i := min_tab to max_tab do
                    for j := 1 to max_dim do
                        if tableau_table_transposition[i,j].profondeur = profondeur then
                            compteur := compteur + 1;
                if compteur > 0 then
                begin
                    writeln('Profondeur : ', profondeur, ' -> ',(compteur/(65536*max_dim))*100 :3:3, '% || ', compteur);
                    if rapport then writeln(enregistrement, 'Profondeur : ', profondeur, ' -> ',(compteur/(65536*max_dim))*100 :3:3, '% || ', compteur);
                end;
                profondeur := profondeur + 1;
                total := total + compteur;
            end;
            writeln((total/(65536*max_dim))*100 :3:5, '% du fichier est rempli.');
            if rapport then writeln(enregistrement, (total/(65536*max_dim))*100 :3:5, '% du fichier est rempli.');
        end
        else
            writeln('Cette version n''a pas de tables de transposition.');
        if rapport then close(enregistrement);
    end;

    procedure init_table_hash(var table_hash : type_table_hash);
    var i, j : byte;
        fichier : file of type_table_hash;

    begin
        assign(fichier, 'Ressources/ressources_raphael/table_hash.ths');
        if not fileExists('Ressources/ressources_raphael/table_hash.ths') then
        begin
            rewrite(fichier);
            for i := 1 to 50 do
                for j := 0 to 4 do
                    table_hash[i,j] := random(4294967296)-2147483648;
        write(fichier, table_hash);
        end
        else
        begin
            reset(fichier);
            read(fichier, table_hash);
        end;
        
        close(fichier);
    end;

    procedure init_table_verif(var table_verif : type_table_hash);
    var i, j : byte;
        fichier : file of type_table_hash;

    begin
        assign(fichier, 'Ressources/ressources_raphael/table_verif.ths');
        if not fileExists('Ressources/ressources_raphael/table_verif.ths') then
        begin
            rewrite(fichier);
            for i := 1 to 50 do
                for j := 0 to 4 do
                    table_verif[i,j] := random(2147483648);
        write(fichier, table_verif);
        end
        else
        begin
            reset(fichier);
            read(fichier, table_verif);
        end;
        
        close(fichier);
    end;

    procedure init_tableau_table_transposition(var tableau_table_transposition : type_tableau_table_transposition; nom_version : string);
    var i, j : longint;
        fichier : file of type_tableau_table_transposition;

    begin
        assign(fichier, 'Ressources/ressources_raphael/tableau_table_transposition_'+ nom_version +'.ttt');
        if not fileExists('Ressources/ressources_raphael/tableau_table_transposition_'+ nom_version +'.ttt') then//or (nom_version = 'vr1') then
        begin
            rewrite(fichier);
            i := min_tab;
            while i <= max_tab do
            begin
                for j := 1 to max_dim do
                begin
                    // tableau_table_transposition[i,j].indice_coup := 1;
                    // tableau_table_transposition[i,j].max_coup := 0;
                    tableau_table_transposition[i,j].profondeur := -100;
                    // tableau_table_transposition[i,j].deja_vu := false;
                    // tableau_table_transposition[i,j].score := 0;
                    tableau_table_transposition[i,j].alpha := -30000;
                    tableau_table_transposition[i,j].beta := 30000;
                    tableau_table_transposition[i,j].hash_verif := 0;
                end;
                i := i + 1;
            end;
            write(fichier, tableau_table_transposition);
        end
        else
        begin
            reset(fichier);
            read(fichier, tableau_table_transposition);
        end;
        close(fichier);
    end;

    procedure enregistrement_tableau_table_transposition(var tableau_table_transposition : type_tableau_table_transposition; nom_version : string);
    var i : integer;
        fichier : file of type_tableau_table_transposition;

    begin
        assign(fichier, 'Ressources/ressources_raphael/tableau_table_transposition_'+ nom_version +'.ttt');
        rewrite(fichier);
        write(fichier, tableau_table_transposition);
        close(fichier);
    end;

    function hash(plateau : type_plateau; table_hash : type_table_hash):integer;
    var i : integer;
        h : longint;
        bin : string;

    begin
        h := 351;
        for i := 1 to 50 do
            h := (h XOR table_hash[i,plateau[i]]);
        bin := binstr(h, 32);
        setlength(bin, 16);
        h := strtoint('%'+bin);
        hash := h;
    end;

    function hash_verif(plateau : type_plateau; table_verif : type_table_hash):longint;
    var i : integer;
        h : longint;

    begin
        h := 351;
        for i := 1 to 50 do
        begin
            h := (h XOR table_verif[i,plateau[i]]);
            h := h mod 89478485;
        end;
        hash_verif := h;
    end;

    function centre(ma_case : integer):boolean;
    begin
        centre := false;
        if (16 <= ma_case) and (ma_case <= 35) and (not((ma_case mod 10) = 1)) and (not((ma_case mod 10) = 0)) then
            centre := true;
    end;

    function bordure(ma_case : integer):boolean;
    begin
        bordure := false;
        if ((1 <= ma_case) and (ma_case <= 50)) and ((ma_case <= 5) or (ma_case >= 46) or ((ma_case mod 10) = 0) or ((ma_case mod 10) = 1)) then
            bordure := true;
    end;

    function ensemble_pions(plateau : type_plateau; nb_joueur : integer; var nb_pions : integer):enum_cases;
    var i : integer;
    begin
        nb_pions := 0;
        ensemble_pions := [];
        for i := 1 to 50 do
            if nb_joueur = plateau[i] then
            begin
                ensemble_pions := ensemble_pions + [i];
                nb_pions := nb_pions + 1
            end
    end;

    function cases_sous_control(plateau : type_plateau; nb_joueur : integer; mes_pions : enum_cases; var nb_cases_sous_control : integer):enum_cases;
    var i : integer;
    begin
        cases_sous_control := [];
        for i in mes_pions do
            if bordure(i) then
            case i of
                1 : cases_sous_control := cases_sous_control + [i+5, i];
                2..5 : cases_sous_control := cases_sous_control + [i+4, i+5, i];
                11, 21, 31, 41, 10, 20, 30, 40 : cases_sous_control := cases_sous_control + [i-5, i+5, i];
                46..49 : cases_sous_control := cases_sous_control + [i-4, i-5, i];
                50 : cases_sous_control := cases_sous_control + [i-5, i];
            end
            else
                if (((i-1) div 5) mod 2) = 1 then 
                    cases_sous_control := cases_sous_control + [i-5, i-4, i+5, i+6, i]
                else
                    cases_sous_control := cases_sous_control + [i-6, i-5, i+4, i+5, i];

        nb_cases_sous_control := 0;
        for i in cases_sous_control do
            nb_cases_sous_control := nb_cases_sous_control + 1;
    end;



    function tri_decroissant_indices_liste_coup(plateau : type_plateau; var liste_coup : type_liste_coup; nb_coup, joueur_ref : integer) : type_indices_liste_coup;
    var scores : array[1..100] of integer;
        i, j, valeur, indices_retenu, valeur_retenu, alea : integer;
        indice_passe : boolean;

    begin
        
        alea := random(nb_coup-1);
        // writeln('nb coup : ',nb_coup,' || alea : ',alea);
        for i := 1 to nb_coup do
        begin
            // write(((i + alea) mod nb_coup) + 1, ' ');
            tri_decroissant_indices_liste_coup[i] := ((i + alea) mod nb_coup) + 1;
        end;

        for i := 1 to nb_coup do
            scores[i] := cout_v4_tri(plateau, liste_coup[i], joueur_ref);
        // writeln('');

        for j := 1 to max_tri do
        begin

            valeur := -31000;
            for i := 1 to nb_coup do
                if scores[i] > valeur then
                begin
                    valeur := scores[i];
                    indices_retenu := i;
                    valeur_retenu := tri_decroissant_indices_liste_coup[i];
                end;

            scores[indices_retenu] := -31000;
            indice_passe := false;

            for i := indices_retenu downto j+1 do
                tri_decroissant_indices_liste_coup[i] := tri_decroissant_indices_liste_coup[i-1];

            tri_decroissant_indices_liste_coup[j] := valeur_retenu; 
            
            // writeln(valeur_retenu);
            // for i := 1 to nb_coup do
            //     write(tri_decroissant_indices_liste_coup[i], ' ');
            // writeln('');

        end;
    end;

    function tri_croissant_indices_liste_coup(plateau : type_plateau; var liste_coup : type_liste_coup; nb_coup, joueur_ref : integer) : type_indices_liste_coup;
    var scores : array[1..100] of integer;
        i, j, valeur, indices_retenu : integer;
        indice_passe : boolean;

    begin
        
        for i := 1 to nb_coup do
            tri_croissant_indices_liste_coup[i] := i;

        for i := 1 to nb_coup do
            scores[i] := cout_v4_tri(plateau, liste_coup[i], joueur_ref);
        
        for j := 1 to max_tri do
        begin

            valeur := 31000;
            for i := 1 to nb_coup do
                if scores[i] < valeur then
                begin
                    valeur := scores[i];
                    indices_retenu := i;
                end;
                
            scores[indices_retenu] := 31000;
            indice_passe := false;

            tri_croissant_indices_liste_coup[j] := indices_retenu; 
            
            for i := j+1 to indices_retenu do
                tri_croissant_indices_liste_coup[i] := tri_croissant_indices_liste_coup[i] - 1;

        end;
    end;

    function tri_decroissant_indices_liste_coup_vcr1(plateau : type_plateau; var liste_coup : type_liste_coup; nb_coup, joueur_ref : integer; var data_poids : type_data_poids) : type_indices_liste_coup;
    var scores : array[1..100] of integer;
        i, j, valeur, indices_retenu, valeur_retenu, alea : integer;
        indice_passe : boolean;
        plateau_test : type_plateau;

    begin
        randomize;
        alea := random(nb_coup-1);
        // writeln('nb coup : ',nb_coup,' || alea : ',alea);
        for i := 1 to nb_coup do
        begin
            // write(((i + alea) mod nb_coup) + 1, ' ');
            tri_decroissant_indices_liste_coup_vcr1[i] := ((i + alea) mod nb_coup) + 1;
        end;
        // writeln('de',1);
        for i := 1 to nb_coup do
        begin
            plateau_test := plateau;
            actualisation_plateau(liste_coup[i], plateau_test);
            scores[i] := cout_vcr1(plateau_test, joueur_ref, data_poids);
        end;
        // writeln(2);

        for j := 1 to max_tri do
        begin

            valeur := -31000;
            for i := 1 to nb_coup do
                if scores[i] > valeur then
                begin
                    valeur := scores[i];
                    indices_retenu := i;
                    valeur_retenu := tri_decroissant_indices_liste_coup_vcr1[i];
                end;

            scores[indices_retenu] := -31000;
            indice_passe := false;

            for i := indices_retenu downto j+1 do
                tri_decroissant_indices_liste_coup_vcr1[i] := tri_decroissant_indices_liste_coup_vcr1[i-1];

            tri_decroissant_indices_liste_coup_vcr1[j] := valeur_retenu; 
            
            // writeln(valeur_retenu);
            // for i := 1 to nb_coup do
            //     write(tri_decroissant_indices_liste_coup_vcr1[i], ' ');
            // writeln('');

        end;
    end;

    function tri_croissant_indices_liste_coup_vcr1(plateau : type_plateau; var liste_coup : type_liste_coup; nb_coup, joueur_ref : integer; var data_poids : type_data_poids) : type_indices_liste_coup;
    var scores : array[1..100] of integer;
        i, j, valeur, indices_retenu, alea : integer;
        indice_passe : boolean;
        plateau_test : type_plateau;

    begin
        randomize;
        alea := random(nb_coup-1);
        // writeln('nb coup : ',nb_coup,' || alea : ',alea);
        for i := 1 to nb_coup do
        begin
            // write(((i + alea) mod nb_coup) + 1, ' ');
            tri_croissant_indices_liste_coup_vcr1[i] := ((i + alea) mod nb_coup) + 1;
        end;
        
        for i := 1 to nb_coup do
            tri_croissant_indices_liste_coup_vcr1[i] := i;
        // writeln('cr',1);
        for i := 1 to nb_coup do
        begin
            // writeln('a');
            plateau_test := plateau;
            // writeln('b');
            actualisation_plateau(liste_coup[i], plateau_test);
            // writeln('c', cout_vcr1(plateau_test, joueur_ref, data_poids));
            scores[i] := cout_vcr1(plateau_test, joueur_ref, data_poids);
            // writeln('d');
        end;
        // writeln(2);
        for j := 1 to max_tri do
        begin

            valeur := 31000;
            for i := 1 to nb_coup do
                if scores[i] < valeur then
                begin
                    valeur := scores[i];
                    indices_retenu := i;
                end;
                
            scores[indices_retenu] := 31000;
            indice_passe := false;

            tri_croissant_indices_liste_coup_vcr1[j] := indices_retenu; 
            
            for i := j+1 to indices_retenu do
                tri_croissant_indices_liste_coup_vcr1[i] := tri_croissant_indices_liste_coup_vcr1[i] - 1;

        end;
        // writeln(3);
    end;

    function nb_cases_autour(plateau : type_plateau; nb_case, joueur_ref : integer):integer;
    var i, valeur : integer;

    begin
        valeur := 0;
        if not bordure(nb_case) then
            if (nb_case mod 10) > 5 then
                for i := 1 to 4 do
                    case i of
                        1 : if (plateau[nb_case - 5] <> 0) and ((plateau[nb_case - 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                        2 : if (plateau[nb_case - 4] <> 0) and ((plateau[nb_case - 4] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                        3 : if (plateau[nb_case + 5] <> 0) and ((plateau[nb_case + 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                        4 : if (plateau[nb_case + 6] <> 0) and ((plateau[nb_case + 6] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                    end
            else
                for i := 1 to 4 do
                    case i of
                        1 : if (plateau[nb_case - 6] <> 0) and ((plateau[nb_case - 6] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                        2 : if (plateau[nb_case - 5] <> 0) and ((plateau[nb_case - 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                        3 : if (plateau[nb_case + 4] <> 0) and ((plateau[nb_case + 4] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                        4 : if (plateau[nb_case + 5] <> 0) and ((plateau[nb_case + 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                    end
        else
            if nb_case in [10, 11, 20, 21, 30, 31, 40, 41] then
                for i := 1 to 2 do
                    case i of
                        1 : if (plateau[nb_case - 5] <> 0) and ((plateau[nb_case - 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                        2 : if (plateau[nb_case + 5] <> 0) and ((plateau[nb_case + 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                    end
            else
                if nb_case in [46, 47, 48, 49] then
                    for i := 1 to 2 do
                        case i of
                            1 : if (plateau[nb_case - 5] <> 0) and ((plateau[nb_case - 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                            2 : if (plateau[nb_case - 4] <> 0) and ((plateau[nb_case - 4] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                        end
                else
                    if nb_case in [2, 3, 4, 5] then
                        for i := 1 to 2 do
                            case i of
                                1 : if (plateau[nb_case + 4] <> 0) and ((plateau[nb_case + 4] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                                2 : if (plateau[nb_case + 5] <> 0) and ((plateau[nb_case + 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
                            end
                    else
                        if nb_case = 1 then
                            if (plateau[nb_case + 5] <> 0) and ((plateau[nb_case + 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1
                        else
                            if nb_case = 50 then
                                if (plateau[nb_case - 5] <> 0) and ((plateau[nb_case - 5] mod 2) = (joueur_ref mod 2)) then valeur := valeur + 1;
        nb_cases_autour := valeur;
    end;

//************************************ COUTS ************************************\\

    function cout_v1(plateau : type_plateau; joueur_ref : integer):integer;
    var nb_pions : integer;

    begin
        ensemble_pions(plateau, joueur_ref, nb_pions);
        cout_v1 := 10*nb_pions;
        ensemble_pions(plateau, (joueur_ref mod 2) + 1, nb_pions);
        cout_v1 := cout_v1 - 10*nb_pions;
    end;

    function score_coup(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur : integer):integer;
    var nb_coup : integer;
        liste_coup : type_liste_coup;
    
    begin
        actualisation_plateau(coup_a_jouer, plateau);
        lister_coup((joueur_courant mod 2) + 1, nb_coup, liste_coup, plateau);
        if (profondeur = 0) or (nb_coup = 0) then
            if nb_coup = 0 then
                if joueur_ref = joueur_courant then
                    score_coup := 10000
                else
                    score_coup := -10000
            else
                score_coup := cout_v1(plateau, joueur_ref)
        else
            score_coup := minmax(plateau, liste_coup[1], false, joueur_ref, (joueur_courant mod 2) + 1, profondeur - 1)
    end;


    function cout_temoin(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref : integer):integer;
    var score, nb_pions, nb_cases_sous_control, i : integer;
        mes_pions : enum_cases;

    begin
        score := 0;
        actualisation_plateau(coup_a_jouer, plateau);

        mes_pions := [];
        mes_pions := ensemble_pions(plateau, joueur_ref, nb_pions);

        for i in mes_pions do
        begin
            score := score + param_pion_2;
            if bordure(i) then score := score + param_4;
            if centre(i) then score := score - param_6;
        end;

        mes_pions := [];
        mes_pions := ensemble_pions(plateau, (joueur_ref mod 2) + 1, nb_pions);

        for i in mes_pions do
        begin
            score := score - param_pion_2;
            if bordure(i) then score := score - param_4;
            if centre(i) then score := score + param_6;
        end;
        
        for i := 1 to 50 do
            if plateau[i] = 3 then 
                if joueur_ref = 1 then 
                    score := score + param_2
                else
                    score := score - param_2
            else
                if plateau[i] = 4 then 
                    if joueur_ref = 2 then 
                        score := score + param_2
                    else
                        score := score - param_2;


        cout_temoin := score
    end;


    function cout_v3(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref : integer):integer;
    var score, nb_pions, i : integer;
        // mes_pions : enum_cases;

    begin
        score := 0;
        // actualisation_plateau(coup_a_jouer, plateau);

        // mes_pions := [];
        // ensemble_pions(plateau, joueur_ref, nb_pions);

        // score := score + param_pion_1*nb_pions;

        // for i in mes_pions do
        // begin
        //     score := score + param_pion_1;
        //     if bordure(i) then score := score + param_3;
        //     if centre(i) then score := score - param_5;
        // end;

        // mes_pions := [];
        // ensemble_pions(plateau, (joueur_ref mod 2) + 1, nb_pions);

        // score := score - param_pion_1*nb_pions;

        // for i in mes_pions do
        // begin
        //     score := score - param_pion_1;
        //     if bordure(i) then score := score - param_3;
        //     if centre(i) then score := score + param_5;
        // end;
        
        for i := 1 to 50 do
            if plateau[i] = 1 then 
                if joueur_ref = 1 then 
                    if centre(i) then
                        score := score + param_pion_1 + param_5
                    else
                        score := score + param_pion_1
                else
                    if centre(i) then
                        score := score - param_pion_1 - param_5
                    else
                        score := score - param_pion_1
            else
                if plateau[i] = 2 then 
                    if joueur_ref = 2 then 
                        if centre(i) then
                            score := score + param_pion_1 + param_5
                        else
                            score := score + param_pion_1
                    else
                        if centre(i) then
                            score := score - param_pion_1 - param_5
                        else
                            score := score - param_pion_1
                else
                    if plateau[i] = 3 then 
                        if joueur_ref = 1 then
                            if centre(i) then
                                score := score + param_1 + param_5
                            else
                                score := score + param_1
                        else
                            if centre(i) then
                                score := score - param_1 - param_5
                            else
                                score := score - param_1
                    else
                        if plateau[i] = 4 then 
                            if joueur_ref = 2 then 
                                if centre(i) then
                                    score := score + param_1 + param_5
                                else
                                    score := score + param_1
                            else
                                if centre(i) then
                                    score := score - param_1 - param_5
                                else
                                    score := score - param_1;


        cout_v3 := score
    end;

    function cout_v4(plateau : type_plateau; joueur_ref : integer):integer;
    var i, score, valeur : integer;

    begin
        score := 0;

        for i := 1 to 50 do
        begin
            valeur := plateau[i];
            if (0 < valeur) and (valeur < 5) then 
                if valeur = 1 then 
                    if joueur_ref = 1 then 
                        if centre(i) then
                            score := score + 40 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                        else
                            score := score + 50 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                    else
                        if centre(i) then
                            score := score - 40 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                        else
                            score := score - 50 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                else
                    if valeur = 2 then 
                        if joueur_ref = 2 then 
                            if centre(i) then
                                score := score + 40 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                            else
                                score := score + 50 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                        else
                            if centre(i) then
                                score := score - 40 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                            else
                                score := score - 50 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                    else
                        if valeur = 3 then 
                            if joueur_ref = 1 then
                                if centre(i) then
                                    score := score + 190 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                                else
                                    score := score + 200 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                            else
                                if centre(i) then
                                    score := score - 190 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                                else
                                    score := score - 200 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                        else
                            if valeur = 4 then 
                                if joueur_ref = 2 then 
                                    if centre(i) then
                                        score := score + 190 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                                    else
                                        score := score + 200 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                                else
                                    if centre(i) then
                                        score := score - 190 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
                                    else
                                        score := score - 200 + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*1
        end;
        cout_v4 := score;
    end;

    function cout_v4_temoin(plateau : type_plateau; joueur_ref : integer):integer;
    var i, score, valeur : integer;

    begin
        score := 0;

        for i := 1 to 50 do
        begin
            valeur := plateau[i];
            if (0 < valeur) and (valeur < 5) then 
                if valeur = 1 then 
                    if joueur_ref = 1 then 
                        if centre(i) then
                            score := score + param_pion_2_2
                        else
                            score := score + param_pion_2
                    else
                        if centre(i) then
                            score := score - param_pion_2_2
                        else
                            score := score - param_pion_2
                else
                    if valeur = 2 then 
                        if joueur_ref = 2 then 
                            if centre(i) then
                                score := score + param_pion_2_2
                            else
                                score := score + param_pion_2
                        else
                            if centre(i) then
                                score := score - param_pion_2_2
                            else
                                score := score - param_pion_2 
                    else
                        if valeur = 3 then 
                            if joueur_ref = 1 then
                                if centre(i) then
                                    score := score + param_2_2 
                                else
                                    score := score + param_2 
                            else
                                if centre(i) then
                                    score := score - param_2_2
                                else
                                    score := score - param_2
                        else
                            if valeur = 4 then 
                                if joueur_ref = 2 then 
                                    if centre(i) then
                                        score := score + param_2_2
                                    else
                                        score := score + param_2
                                else
                                    if centre(i) then
                                        score := score - param_2_2
                                    else
                                        score := score - param_2
        end;
        cout_v4_temoin := score;
    end;

    function cout_v4_tri(plateau : type_plateau; var coup_a_jouer : type_coup; joueur_ref : integer):integer;
    var i, score, valeur : integer;

    begin
        score := 0;
        actualisation_plateau(coup_a_jouer, plateau);

        for i := 1 to 50 do
        begin
            valeur := plateau[i];
            if 0 < valeur then 
                case valeur of 
                    1 : if joueur_ref = 1 then 
                            if centre(i) then
                                score := score + param_pion_1_2// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                            else
                                score := score + param_pion_1// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                        else
                            if centre(i) then
                                score := score - param_pion_1_2// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                            else
                                score := score - param_pion_1;// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour;

                    2 : if joueur_ref = 2 then 
                            if centre(i) then
                                score := score + param_pion_1_2// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                            else
                                score := score + param_pion_1// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                        else
                            if centre(i) then
                                score := score - param_pion_1_2// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                            else
                                score := score - param_pion_1;// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour;

                    3 : if joueur_ref = 1 then
                            if centre(i) then
                                score := score + param_1_2// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                            else
                                score := score + param_1// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                        else
                            if centre(i) then
                                score := score - param_1_2// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                            else
                                score := score - param_1;// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour;

                    4 : if joueur_ref = 2 then
                            if centre(i) then
                                score := score + param_1_2// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                            else
                                score := score + param_1// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                        else
                            if centre(i) then
                                score := score - param_1_2// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour
                            else
                                score := score - param_1;// + (2 - abs(nb_cases_autour(plateau, i, joueur_ref) - 2))*param_case_autour;
                end;

        end;
        cout_v4_tri := score;
    end;

    function cout_v5(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref : integer):integer;
    var score, nb_pions, nb_cases_sous_control, i : integer;
        mes_pions : enum_cases;

    begin
        score := 0;
        actualisation_plateau(coup_a_jouer, plateau);

        mes_pions := [];
        mes_pions := ensemble_pions(plateau, joueur_ref, nb_pions);

        for i in mes_pions do
        begin
            score := score + 100;
            if bordure(i) then score := score + 0;
            if centre(i) then score := score + 0;
        end;

        mes_pions := [];
        mes_pions := ensemble_pions(plateau, (joueur_ref mod 2) + 1, nb_pions);

        for i in mes_pions do
        begin
            score := score - 100;
            if bordure(i) then score := score - 0;
            if centre(i) then score := score - 0;
        end;
        
        for i := 1 to 50 do
            if plateau[i] = 3 then 
                if joueur_ref = 1 then 
                    score := score + 2000
                else
                    score := score - 2000
            else
                if plateau[i] = 4 then 
                    if joueur_ref = 2 then 
                        score := score + 2000
                    else
                        score := score - 2000;


        cout_v5 := score
    end;

//************************************ IA V1 ************************************\\

    function minmax(plateau : type_plateau; coup_a_jouer : type_coup; etage : boolean; joueur_ref, joueur_courant, profondeur : integer):integer;
    var nb_coup, score, resultat, i : integer;
        liste_coup : type_liste_coup;
    
    begin
        if etage then actualisation_plateau(coup_a_jouer, plateau);
        lister_coup(joueur_courant, nb_coup, liste_coup, plateau);
        if nb_coup = 2 then
            minmax := 1
        else if nb_coup > 2 then
        begin
            resultat := score_coup(plateau, liste_coup[1], joueur_ref, joueur_courant, profondeur);
            for i := 1 to nb_coup do
            begin
                score := score_coup(plateau, liste_coup[i], joueur_ref, joueur_courant, profondeur);

                if joueur_courant = joueur_ref then
                    resultat := max(score, resultat)
                else 
                    resultat := min(score, resultat)
            end;
            minmax := resultat
        end
    end;

    function ia_raphael_v1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var  score, resultat, i, indice_meilleur_coup : integer;
    
    begin
        if nb_coup > 0 then
        begin
            resultat := minmax(plateau, liste_coup[1], true, joueur_ref, joueur_ref, 3);
            indice_meilleur_coup := 1;
            for i := 2 to nb_coup do
            begin
                score := minmax(plateau, liste_coup[i], true, joueur_ref, joueur_ref, 3);
                if score > resultat then
                    indice_meilleur_coup := i
                else
                    if score = resultat then
                        if random(2) = 0 then
                            indice_meilleur_coup := i;
            end;
            ia_raphael_v1 := indice_meilleur_coup
        end
        else
            ia_raphael_v1 := 0;    
    end;




//************************************ IA V2 ************************************\\

    function minmax_v2(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur : integer):integer;
    const Max_Branches = 5;
    var meilleurs_scores, indices_meilleurs_scores : array[1..Max_Branches] of integer;
        i, j, k, nb_coup, score, resultat : integer;
        liste_coup : type_liste_coup;
        insertion : boolean;

    begin
        actualisation_plateau(coup_a_jouer, plateau);
        lister_coup((joueur_courant mod 2) + 1, nb_coup, liste_coup, plateau);
        if nb_coup = 0 then
            if joueur_ref = joueur_courant then
                minmax_v2 := 24000
            else
                minmax_v2 := -24000
        else
        begin
            for i := 2 to Max_Branches do
            begin
                meilleurs_scores[i] := 0;
                indices_meilleurs_scores[i] := -1
            end;
            meilleurs_scores[1] := cout_v3(plateau, liste_coup[1], joueur_ref);
            indices_meilleurs_scores[1] := 1;
            for i := 2 to nb_coup do
            begin
                score := cout_v3(plateau, liste_coup[1], joueur_ref);
                insertion := false;
                for k := 1 to Max_Branches do
                begin
                    if joueur_ref = joueur_courant then
                        if (score < meilleurs_scores[k]) and (not insertion) then
                        begin
                            for j := Max_Branches+1-k downto 2 do
                            begin
                                meilleurs_scores[j] := meilleurs_scores[j-1];
                                indices_meilleurs_scores[j] := indices_meilleurs_scores[j-1]
                            end;
                            meilleurs_scores[k] := score;
                            indices_meilleurs_scores[k] := i;
                            insertion := true
                        end
                        else 
                            if (score = meilleurs_scores[Max_Branches]) and (not insertion) and (random(2) = 0) then
                            begin
                                meilleurs_scores[Max_Branches] := score;
                                indices_meilleurs_scores[Max_Branches] := i;
                            end
                    else
                        if (score > meilleurs_scores[k]) and (not insertion) then
                        begin
                            for j := Max_Branches+1-k downto 2 do
                            begin
                                meilleurs_scores[j] := meilleurs_scores[j-1];
                                indices_meilleurs_scores[j] := indices_meilleurs_scores[j-1]
                            end;
                            meilleurs_scores[k] := score;
                            indices_meilleurs_scores[k] := i;
                            insertion := true
                        end
                        else 
                            if (score = meilleurs_scores[Max_Branches]) and (not insertion) and (random(2) = 0) then
                            begin
                                meilleurs_scores[Max_Branches] := score;
                                indices_meilleurs_scores[Max_Branches] := i;
                            end
                end
            end;
            if profondeur > 0 then
            begin
                if nb_coup > (Max_Branches) then
                    nb_coup := Max_Branches;
                resultat := minmax_v2(plateau, liste_coup[indices_meilleurs_scores[1]], joueur_ref, (joueur_courant mod 2) + 1, profondeur - 1);
                for i := 2 to nb_coup  do
                begin
                    if indices_meilleurs_scores[i] > 0 then
                    begin
                        score := minmax_v2(plateau, liste_coup[indices_meilleurs_scores[i]], joueur_ref, (joueur_courant mod 2) + 1,  profondeur - 1);
                        if score > resultat then
                            resultat := score
                        else 
                            if (score = resultat) and (random(2) = 0) then 
                                resultat := score
                    end
                end;
                minmax_v2 := resultat
            end
            else
            begin
                minmax_v2 := meilleurs_scores[1]
            end
        end
    end;

    function ia_raphael_v2(joueur_ref, nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, indice_coup : integer;
    
    begin
        if nb_coup > 1 then
        begin
            resultat := minmax_v2(plateau, liste_coup[1], joueur_ref, joueur_ref, 9);
            indice_coup := 1;
            for i := 2 to nb_coup do
            begin
                score := minmax_v2(plateau, liste_coup[i], joueur_ref, joueur_ref, 9);
                if score > resultat then
                begin
                    resultat := score;
                    indice_coup := i
                end
                else 
                    if (score = resultat) and (random(2) = 0) then
                        indice_coup := i
            end;
            ia_raphael_v2 := indice_coup;
        end
        else
            ia_raphael_v2 := 1    
    end;



//************************************ IA V2 TEMOIN ************************************\\

    function minmax_v2_temoin(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur : integer):integer;
    const Max_Branches = 3;
    var meilleurs_scores, indices_meilleurs_scores : array[1..Max_Branches] of integer;
        i, j, k, nb_coup, score, resultat : integer;
        liste_coup : type_liste_coup;
        insertion : boolean;

    begin
        actualisation_plateau(coup_a_jouer, plateau);
        lister_coup((joueur_courant mod 2) + 1, nb_coup, liste_coup, plateau);
        if nb_coup = 0 then
            if joueur_ref = joueur_courant then
                minmax_v2_temoin := 24000
            else
                minmax_v2_temoin := -24000
        else
        begin
            for i := 2 to Max_Branches do
            begin
                meilleurs_scores[i] := 0;
                indices_meilleurs_scores[i] := -1
            end;
            meilleurs_scores[1] := cout_temoin(plateau, liste_coup[1], joueur_ref);
            indices_meilleurs_scores[1] := 1;
            for i := 2 to nb_coup do
            begin
                score := cout_temoin(plateau, liste_coup[1], joueur_ref);
                insertion := false;
                for k := 1 to Max_Branches do
                begin
                    if joueur_ref = joueur_courant then
                        if (score < meilleurs_scores[k]) and (not insertion) then
                        begin
                            for j := Max_Branches+1-k downto 2 do
                            begin
                                meilleurs_scores[j] := meilleurs_scores[j-1];
                                indices_meilleurs_scores[j] := indices_meilleurs_scores[j-1]
                            end;
                            meilleurs_scores[k] := score;
                            indices_meilleurs_scores[k] := i;
                            insertion := true
                        end
                        else 
                            if (score = meilleurs_scores[Max_Branches]) and (not insertion) and (random(2) = 0) then
                            begin
                                meilleurs_scores[Max_Branches] := score;
                                indices_meilleurs_scores[Max_Branches] := i;
                            end
                    else
                        if (score > meilleurs_scores[k]) and (not insertion) then
                        begin
                            for j := Max_Branches+1-k downto 2 do
                            begin
                                meilleurs_scores[j] := meilleurs_scores[j-1];
                                indices_meilleurs_scores[j] := indices_meilleurs_scores[j-1]
                            end;
                            meilleurs_scores[k] := score;
                            indices_meilleurs_scores[k] := i;
                            insertion := true
                        end
                        else 
                            if (score = meilleurs_scores[Max_Branches]) and (not insertion) and (random(2) = 0) then
                            begin
                                meilleurs_scores[Max_Branches] := score;
                                indices_meilleurs_scores[Max_Branches] := i;
                            end
                end
            end;
            if profondeur > 0 then
            begin
                if nb_coup > (Max_Branches) then
                    nb_coup := Max_Branches;
                resultat := minmax_v2_temoin(plateau, liste_coup[indices_meilleurs_scores[1]], joueur_ref, (joueur_courant mod 2) + 1, profondeur - 1);
                for i := 2 to nb_coup  do
                begin
                    if indices_meilleurs_scores[i] > 0 then
                    begin
                        score := minmax_v2_temoin(plateau, liste_coup[indices_meilleurs_scores[i]], joueur_ref, (joueur_courant mod 2) + 1,  profondeur - 1);
                        if score > resultat then
                            resultat := score
                        else 
                            if (score = resultat) and (random(2) = 0) then 
                                resultat := score
                    end
                end;
                minmax_v2_temoin := resultat
            end
            else
            begin
                minmax_v2_temoin := meilleurs_scores[1]
            end
        end
    end;

    function ia_raphael_v2_temoin(joueur_ref, nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, indice_coup : integer;
    
    begin
        if nb_coup > 1 then
        begin
            resultat := minmax_v2_temoin(plateau, liste_coup[1], joueur_ref, joueur_ref, 7);
            indice_coup := 1;
            for i := 2 to nb_coup do
            begin
                score := minmax_v2_temoin(plateau, liste_coup[i], joueur_ref, joueur_ref, 7);
                if score > resultat then
                begin
                    resultat := score;
                    indice_coup := i
                end
                else 
                    if (score = resultat) and (random(2) = 0) then
                        indice_coup := i
            end;
            ia_raphael_v2_temoin := indice_coup;
        end
        else
            ia_raphael_v2_temoin := 1    
    end;



//************************************ IA V3 ************************************\\

    // function minmax_v3(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur, parametre, alpha, beta : integer):integer;
    // const Max_Branches = 1;
    // var meilleurs_scores, indices_meilleurs_scores : array[1..Max_Branches] of integer;
    //     i, j, k, nb_coup, score, resultat : integer;
    //     liste_coup : type_liste_coup;
    //     insertion : boolean;

    // begin
    //     // writeln('Minmax : ', 1, ', profondeur : ', profondeur, ', joueur_ref : ', joueur_ref, ', joueur_courant : ', joueur_courant);
    //     actualisation_plateau(coup_a_jouer, plateau);
    //     // writeln('Minmax : ', 2);
    //     lister_coup((joueur_courant mod 2) + 1, nb_coup, liste_coup, plateau);
    //     // writeln('Minmax : 3, nb_coup : ', nb_coup);
    //     if nb_coup = 0 then
    //         if joueur_ref = joueur_courant then
    //         begin
    //             minmax_v3 := 30000;
    //             // writeln('Minmax : ', 4.1);
    //         end
    //         else
    //         begin
    //             minmax_v3 := -30000;
    //             // writeln('Minmax : ', 4.2);
    //         end
    //     else
    //     begin
    //         // writeln('Minmax : ', 4.3);
    //         for i := 2 to Max_Branches do
    //         begin
    //             // writeln('Minmax : 5, i :', i, ' Max_Branches : ', Max_Branches);
    //             meilleurs_scores[i] := 0;
    //             indices_meilleurs_scores[i] := -1
    //         end;
    //         if (profondeur = 0) or ((profondeur = 0) and (parametre = 0)) then meilleurs_scores[1] := cout_v3(plateau, liste_coup[1], joueur_ref)
    //         else meilleurs_scores[1] := alpha_beta_v6(plateau, liste_coup[1], joueur_ref, (joueur_courant mod 2) + 1, parametre, alpha, beta);
    //         indices_meilleurs_scores[1] := 1;
    //         // writeln('Minmax : 6, score_1 : ', meilleurs_scores[1], ', indice : ', indices_meilleurs_scores[1]);
    //         for i := 2 to nb_coup do
    //         begin
    //             if (profondeur = 0) or ((profondeur = 0) and (parametre = 0)) then score := cout_v3(plateau, liste_coup[1], joueur_ref)
    //             else score := alpha_beta_v6(plateau, liste_coup[1], joueur_ref, (joueur_courant mod 2) + 1, parametre, alpha, beta);
    //             // writeln('Minmax : 7, score_1 : ', score, ', indice : ', i);
    //             insertion := false;
    //             for k := 1 to Max_Branches do
    //             begin
    //                 if joueur_ref = joueur_courant then
    //                     if (score < meilleurs_scores[k]) and (not insertion) then
    //                     begin
    //                         for j := Max_Branches+1-k downto 2 do
    //                         begin
    //                             meilleurs_scores[j] := meilleurs_scores[j-1];
    //                             indices_meilleurs_scores[j] := indices_meilleurs_scores[j-1]
    //                         end;
    //                         meilleurs_scores[k] := score;
    //                         indices_meilleurs_scores[k] := i;
    //                         insertion := true
    //                     end
    //                     else 
    //                         if (score = meilleurs_scores[Max_Branches]) and (not insertion) and (random(2) = 0) then
    //                         begin
    //                             meilleurs_scores[Max_Branches] := score;
    //                             indices_meilleurs_scores[Max_Branches] := i;
    //                         end
    //                 else
    //                     if (score > meilleurs_scores[k]) and (not insertion) then
    //                     begin
    //                         for j := Max_Branches+1-k downto 2 do
    //                         begin
    //                             meilleurs_scores[j] := meilleurs_scores[j-1];
    //                             indices_meilleurs_scores[j] := indices_meilleurs_scores[j-1]
    //                         end;
    //                         meilleurs_scores[k] := score;
    //                         indices_meilleurs_scores[k] := i;
    //                         insertion := true
    //                     end
    //                     else 
    //                         if (score = meilleurs_scores[Max_Branches]) and (not insertion) and (random(4) = 0) then
    //                         begin
    //                             meilleurs_scores[Max_Branches] := score;
    //                             indices_meilleurs_scores[Max_Branches] := i;
    //                         end
    //             end
    //         end;
    //         if (profondeur > 0) and (parametre > 0) then
    //         begin
    //             if nb_coup > Max_Branches then
    //                 nb_coup := Max_Branches;
    //             resultat := minmax_v3(plateau, liste_coup[indices_meilleurs_scores[1]], joueur_ref, (joueur_courant mod 2) + 1, profondeur - 1, parametre, alpha, beta);
    //             for i := 2 to nb_coup  do
    //             begin
    //                 if indices_meilleurs_scores[i] > 0 then
    //                 begin
    //                     score := minmax_v3(plateau, liste_coup[indices_meilleurs_scores[i]], joueur_ref, (joueur_courant mod 2) + 1, profondeur - 1, parametre, alpha, beta);
    //                     if score > resultat then
    //                         resultat := score
    //                     else 
    //                         if (score = resultat) and (random(4) = 0) then 
    //                             resultat := score
    //                 end
    //             end;
    //             minmax_v3 := resultat
    //         end
    //         else
    //         begin
    //             minmax_v3 := meilleurs_scores[1]
    //         end
    //     end
    // end;


    // function ia_raphael_v3(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    // var i, resultat, score, indice_coup, alpha, beta : integer;
    
    // begin
    //     alpha := -30000;
    //     beta := 30000;
    //     // writeln('IA : ', 1);
    //     if nb_coup > 1 then
    //     begin
    //         // writeln('IA : ', 2.1);
    //         resultat := minmax_v3(plateau, liste_coup[1], joueur_ref, joueur_ref, 5, 2, alpha, beta);
    //         // writeln('IA : resultat_1 :', resultat);
    //         indice_coup := 1;
    //         // writeln('IA : ', 3.1);
    //         for i := 2 to nb_coup do
    //         begin
    //             // writeln('IA : ', 3.1 + 0.01*i, ', i :', i, ', nb_coup : ', nb_coup);
    //             score := minmax_v3(plateau, liste_coup[i], joueur_ref, joueur_ref, 5, 2, alpha, beta);
    //             // writeln('IA : ', 3.1 + 0.01*i, ', score :', score);
    //             if score > resultat then
    //             begin
    //                 // writeln('IA : ', 3.2 + 0.01*i);
    //                 resultat := score;
    //                 indice_coup := i
    //             end
    //             else 
    //                 if (score = resultat) and (random(2) = 0) then
    //                 begin
    //                     // writeln('IA : resultat : ', resultat, ', score : ', score);
    //                     indice_coup := i;
    //                 end;
    //         end;
    //         ia_raphael_v3 := indice_coup;
    //         // writeln('IA : ', 4);
    //     end
    //     else
    //     begin
    //         ia_raphael_v3 := 1;
    //         // writeln('IA : ', 2.2);
    //     end;
    //     if not((1 <= ia_raphael_v3) and (ia_raphael_v3 <=nb_coup)) then
    //     begin
    //         ia_raphael_v3 := 1;
    //         // writeln('IA : ', 5);
    //     end;
    // end;


//************************************ IA V4 ************************************\\

    function alpha_beta_v1(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, alpha, profondeur : integer):integer;
    var nb_coup, v, i : integer;
        liste_coup : type_liste_coup;
    
    begin
        actualisation_plateau(coup_a_jouer, plateau);
        lister_coup(joueur_courant, nb_coup, liste_coup, plateau);

        if nb_coup > 0 then
        begin
            if profondeur = 0 then
                alpha_beta_v1 := cout_v3(plateau, liste_coup[1], joueur_ref)
            else
                begin
                    v := -20000;
                    for i := 1 to nb_coup do
                    begin
                        v := max(v, alpha_beta_v1(plateau, liste_coup[i], joueur_ref, joueur_courant, alpha, profondeur - 1));
                        alpha_beta_v1 := -v;
                        if -v <= alpha then
                            exit;
                    end;
                    
                end;
        end
        else
            if joueur_ref = joueur_courant then
            begin
                alpha_beta_v1 := -20000;
            end
            else
            begin
                alpha_beta_v1 := 20000;
            end;
    end;

    function ia_raphael_v4(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, indice_coup, alpha, beta : integer;
        indices_retour : set of 1..255;

    begin
        // writeln('IA : ', 1);
        if nb_coup > 1 then
        begin
            // writeln('IA : ', 2.1);
            resultat := alpha_beta_v1(plateau, liste_coup[1], joueur_ref, (joueur_ref mod 2) + 1, -20000, 3);
            // writeln('IA : resultat_1 :', resultat);
            indice_coup := 1;
            // writeln('IA : ', 3.1);
            for i := 2 to nb_coup do
            begin
                // writeln('IA : ', 3.1 + 0.01*i, ', i :', i, ', nb_coup : ', nb_coup);
                score := alpha_beta_v1(plateau, liste_coup[i], joueur_ref, (joueur_ref mod 2) + 1, -20000, 3);
                // writeln('IA : ', 3.1 + 0.01*i, ', score :', score);
                if score > resultat then
                begin
                    // writeln('IA : ', 3.2 + 0.01*i);
                    resultat := score;
                    indice_coup := i
                end
                else 
                    if (score = resultat) and (random(2) = 0) then
                    begin
                        // writeln('IA : resultat : ', resultat, ', score : ', score);
                        indice_coup := i;
                    end;
            end;
            ia_raphael_v4 := indice_coup;
            // writeln('IA : ', 4);
        end
        else
        begin
            ia_raphael_v4 := 1;
            // writeln('IA : ', 2.2);
        end;
        if not((1 <= ia_raphael_v4) and (ia_raphael_v4 <= nb_coup)) then
        begin
            ia_raphael_v4 := 1;
            // writeln('IA : ', 5);
        end;
    end;


//************************************ IA V5 ************************************\\

    function alpha_beta_v5(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur, parametre, alpha, beta : integer):integer;
    const Max_Branches = 3;

    var meilleurs_scores, indices_meilleurs_scores : array[1..Max_Branches] of integer;
        i, j, k, nb_coup, score, resultat : integer;
        liste_coup : type_liste_coup;
        insertion : boolean;

    begin
        actualisation_plateau(coup_a_jouer, plateau);
        lister_coup((joueur_courant mod 2) + 1, nb_coup, liste_coup, plateau);
        if nb_coup = 0 then
            if joueur_ref = joueur_courant then
                alpha_beta_v5 := 30000
            else
                alpha_beta_v5 := -30000
        else
        begin
            for i := 2 to Max_Branches do
            begin
                meilleurs_scores[i] := 0;
                indices_meilleurs_scores[i] := -1
            end;
            if (profondeur = 0) or ((profondeur = 0) and (parametre = 0)) then meilleurs_scores[1] := cout_v3(plateau, liste_coup[1], joueur_ref)
            else meilleurs_scores[1] := alpha_beta_v5(plateau, liste_coup[1], joueur_ref, (joueur_courant mod 2) + 1, 0, parametre - 1, alpha, beta);
            indices_meilleurs_scores[1] := 1;
            for i := 2 to nb_coup do
            begin
                if (profondeur = 0) or ((profondeur = 0) and (parametre = 0)) then score := cout_v3(plateau, liste_coup[1], joueur_ref)
                else score := alpha_beta_v5(plateau, liste_coup[i], joueur_ref, (joueur_courant mod 2) + 1, 0, parametre - 1, alpha, beta);
                insertion := false;
                for k := 1 to Max_Branches do
                begin
                    if joueur_ref = joueur_courant then
                        if (score < meilleurs_scores[k]) and (not insertion) then
                        begin
                            for j := Max_Branches+1-k downto 2 do
                            begin
                                meilleurs_scores[j] := meilleurs_scores[j-1];
                                indices_meilleurs_scores[j] := indices_meilleurs_scores[j-1]
                            end;
                            meilleurs_scores[k] := score;
                            indices_meilleurs_scores[k] := i;
                            insertion := true
                        end
                        else 
                            if (score = meilleurs_scores[Max_Branches]) and (not insertion) and (random(2) = 0) then
                            begin
                                meilleurs_scores[Max_Branches] := score;
                                indices_meilleurs_scores[Max_Branches] := i;
                            end
                    else
                        if (score > meilleurs_scores[k]) and (not insertion) then
                        begin
                            for j := Max_Branches+1-k downto 2 do
                            begin
                                meilleurs_scores[j] := meilleurs_scores[j-1];
                                indices_meilleurs_scores[j] := indices_meilleurs_scores[j-1]
                            end;
                            meilleurs_scores[k] := score;
                            indices_meilleurs_scores[k] := i;
                            insertion := true
                        end
                        else 
                            if (score = meilleurs_scores[Max_Branches]) and (not insertion) and (random(4) = 0) then
                            begin
                                meilleurs_scores[Max_Branches] := score;
                                indices_meilleurs_scores[Max_Branches] := i;
                            end
                end
            end;
            if (profondeur > 0) and (parametre > 0) then
            begin
                if nb_coup > Max_Branches then
                    nb_coup := Max_Branches;
                resultat := alpha_beta_v5(plateau, liste_coup[indices_meilleurs_scores[1]], joueur_ref, (joueur_courant mod 2) + 1, profondeur - 1, parametre, alpha, beta);
                for i := 2 to nb_coup  do
                begin
                    if indices_meilleurs_scores[i] > 0 then
                    begin
                        score := alpha_beta_v5(plateau, liste_coup[indices_meilleurs_scores[i]], joueur_ref, (joueur_courant mod 2) + 1, profondeur - 1, parametre, alpha, beta);
                        if score > resultat then
                            resultat := score
                        else 
                            if (score = resultat) and (random(4) = 0) then 
                                resultat := score
                    end
                end;
                alpha_beta_v5 := resultat
            end
            else
            begin
                alpha_beta_v5 := meilleurs_scores[1]
            end
        end
    end;


    function ia_raphael_v5(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, indice_coup : integer;
    
    begin
        if nb_coup > 1 then
        begin
            resultat := alpha_beta_v5(plateau, liste_coup[1], joueur_ref, joueur_ref, 8, 1, -30000, 30000);
            indice_coup := 1;
            for i := 2 to nb_coup do
            begin
                score := alpha_beta_v5(plateau, liste_coup[i], joueur_ref, joueur_ref, 8, 1, -30000, 30000);
                if score > resultat then
                begin
                    resultat := score;
                    indice_coup := i
                end
                else 
                    if (score = resultat) and (random(2) = 0) then
                    begin
                        indice_coup := i;
                    end;
            end;
            ia_raphael_v5 := indice_coup;
        end
        else
        begin
            ia_raphael_v5 := 1;
        end;
        if not((1 <= ia_raphael_v5) and (ia_raphael_v5 <=nb_coup)) then
        begin
            ia_raphael_v5 := 1;
        end;
    end;


//************************************ IA V6 ************************************\\

    function alpha_beta_v6(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur, alpha, beta : integer; var data_poids : type_data_poids):integer;
    var score, i, nb_coup : integer;
        liste_coup : type_liste_coup;
        indices_liste_coup : type_indices_liste_coup;

    begin
        // writeln('alphabeta ',1);
        actualisation_plateau(coup_a_jouer, plateau);

        if profondeur < 1 then
        begin
            // writeln('alphabeta ',2);
            alpha_beta_v6 := cout_vcr1(plateau, joueur_ref, data_poids);
            // writeln('alphabeta ',3);
        end
        else
        begin
            // writeln('alphabeta ',4);
            joueur_courant := (joueur_courant mod 2) + 1;
            lister_coup(joueur_courant, nb_coup, liste_coup, plateau);
            // writeln('alphabeta ',5);
            if nb_coup = 0 then
                if joueur_ref = joueur_courant then
                    alpha_beta_v6 := -30000
                else
                    alpha_beta_v6 := 30000
            else
            begin
                if joueur_ref <> joueur_courant then
                begin
                    // writeln('alphabeta ',6);
                    score := 30000;
                    // writeln('alphabeta ',6.1:1:1);
                    indices_liste_coup := tri_croissant_indices_liste_coup_vcr1(plateau, liste_coup, nb_coup, joueur_ref, data_poids);
                    // writeln('alphabeta ',6.2:1:1);
                    for i := 1 to nb_coup do
                    begin
                        score := min(score, alpha_beta_v6(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, data_poids));
                        if alpha >= score then  //Coupure alpha
                        begin
                            alpha_beta_v6 := score;
                            exit;
                        end;
                        beta := min(score, beta);
                    end;
                    // writeln('alphabeta ',7);
                end
                else
                begin
                    // writeln('alphabeta ',8);
                    score := -30000;
                    indices_liste_coup := tri_decroissant_indices_liste_coup_vcr1(plateau, liste_coup, nb_coup, joueur_ref, data_poids);
                    for i := 1 to nb_coup do
                    begin
                        score := max(score, alpha_beta_v6(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, data_poids));
                        if score >= beta then  //Coupure beta
                        begin
                            alpha_beta_v6 := score;
                            exit;
                        end;
                        alpha := max(score, alpha)
                    end;
                    // writeln('alphabeta ',9);
                end;
                alpha_beta_v6 := score;
            end
        end
    end;

    function ia_raphael_v6(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau; numero_data, nom_dossier : string):integer;
    var i, resultat, score, indice_coup, alpha, beta : integer;
        data_poids : type_data_poids;
        fichier_data : file of type_data_poids;

    begin
        // writeln('ia v6 ', 1);
        assign(fichier_data, 'Ressources/ressources_raphael/darwin/' + nom_dossier + '/dataset_' + numero_data + '.poi');
        reset(fichier_data);
        read(fichier_data, data_poids);
        close(fichier_data);
        
        // writeln('ia v6 ', 2);
        if nb_coup > 1 then
        begin
            alpha := data_poids.debut_alpha;
            beta := data_poids.debut_beta;
            score := -32000;

            for i := 1 to nb_coup do
            begin
                resultat := alpha_beta_v6(plateau, liste_coup[i], joueur_ref, joueur_ref, 2, alpha, beta, data_poids);
                // writeln('ia v6 ', 4);
                if resultat > score then
                begin
                    score := resultat;
                    ia_raphael_v6 := i
                end
                else
                    if (resultat >= score) and (random(2) = 1) then
                    begin
                        score := resultat;
                        ia_raphael_v6 := i
                    end;
                
                if score >= beta then  //Coupure beta
                    break;

                alpha := max(score, alpha)
            end

        end
        else
            ia_raphael_v6 := 1;
        if (ia_raphael_v6 <= 0) or (ia_raphael_v6 > nb_coup) then writeln('Soucis !!! IA V6 renvoie ', ia_raphael_v6);
        // writeln('ia v6 renvoie ', ia_raphael_v6);
    end;

    function ia_raphael_v6_1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau; numero_data, nom_dossier : string):integer;
    var i, resultat, score, indice_coup, alpha, beta : integer;
        data_poids : type_data_poids;
        fichier_data : file of type_data_poids;

    begin
        // writeln('ia v6 ', 1);
        assign(fichier_data, 'Ressources/ressources_raphael/darwin/' + nom_dossier + '/dataset_' + numero_data + '.poi');
        reset(fichier_data);
        read(fichier_data, data_poids);
        close(fichier_data);
        
        // writeln('ia v6 ', 2);
        if nb_coup > 1 then
        begin
            alpha := data_poids.debut_alpha;
            beta := data_poids.debut_beta;
            score := -32000;

            for i := 1 to nb_coup do
            begin
                resultat := alpha_beta_v6(plateau, liste_coup[i], joueur_ref, joueur_ref, 5, alpha, beta, data_poids);
                // writeln('ia v6 ', 4);
                if resultat > score then
                begin
                    score := resultat;
                    ia_raphael_v6_1 := i
                end
                else
                    if (resultat >= score) and (random(2) = 1) then
                    begin
                        score := resultat;
                        ia_raphael_v6_1 := i
                    end;
                
                if score >= beta then  //Coupure beta
                    break;

                alpha := max(score, alpha)
            end

        end
        else
            ia_raphael_v6_1 := 1;
        if (ia_raphael_v6_1 <= 0) or (ia_raphael_v6_1 > nb_coup) then writeln('Soucis !!! IA V6 renvoie ', ia_raphael_v6_1);
        // writeln('ia v6 renvoie ', ia_raphael_v6_1);
    end;


//************************************ IA V6 TEMOIN ************************************\\


    function alpha_beta_v6_temoin(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, alpha, beta, profondeur : integer):integer;
    var score, i, nb_coup : integer;
        liste_coup : type_liste_coup;
        indices_liste_coup : type_indices_liste_coup;

    begin
        actualisation_plateau(coup_a_jouer, plateau);

        if profondeur < 1 then
            alpha_beta_v6_temoin := cout_v4_temoin(plateau, joueur_ref)
        else
        begin
            joueur_courant := (joueur_courant mod 2) + 1;
            lister_coup(joueur_courant, nb_coup, liste_coup, plateau);

            if nb_coup = 0 then
                if joueur_ref = joueur_courant then
                    alpha_beta_v6_temoin := -30000
                else
                    alpha_beta_v6_temoin := 30000
            else
            begin
                if joueur_ref <> joueur_courant then
                begin
                    score := 30000;
                    indices_liste_coup := tri_croissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                    for i := 1 to nb_coup do
                    begin
                        // score := min(score, alpha_beta_v6_temoin(plateau, liste_coup[i], joueur_ref, joueur_courant, alpha, beta, profondeur - 1));
                        score := min(score, alpha_beta_v6_temoin(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, alpha, beta, profondeur - 1));
                        if alpha >= score then  //Coupure alpha
                        begin
                            alpha_beta_v6_temoin := score;
                            exit;
                        end;
                        beta := min(score, beta);
                    end;
                end
                else
                begin
                    score := -30000;
                    indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                    for i := 1 to nb_coup do
                    begin
                        // score := max(score, alpha_beta_v6_temoin(plateau, liste_coup[i], joueur_ref, joueur_courant, alpha, beta, profondeur - 1));
                        score := max(score, alpha_beta_v6_temoin(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, alpha, beta, profondeur - 1));
                        if score >= beta then  //Coupure beta
                        begin
                            alpha_beta_v6_temoin := score;
                            exit;
                        end;
                        alpha := max(score, alpha)
                    end
                end;
                alpha_beta_v6_temoin := score;
            end
        end
    end;

    function ia_raphael_v6_temoin(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, indice_coup, alpha, beta : integer;
    
    begin
        randomize;
        if nb_coup > 1 then
        begin
            alpha := -6;
            beta := 10;

            score := -30000;
            for i := 1 to nb_coup do
            begin
                resultat := alpha_beta_v6_temoin(plateau, liste_coup[i], joueur_ref, joueur_ref, alpha, beta, 2);
                if resultat > score then
                begin
                    score := resultat;
                    ia_raphael_v6_temoin := i
                end;
                
                if score >= beta then  //Coupure beta
                    break;

                alpha := max(score, alpha)
            end

        end
        else
            ia_raphael_v6_temoin := 1;
        if not((1 <= ia_raphael_v6_temoin) and (ia_raphael_v6_temoin <=nb_coup)) then
            ia_raphael_v6_temoin := 1;
    end;


//************************************ IA V7 ************************************\\


    function alpha_beta_v7(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, alpha, beta, profondeur : integer):integer;
    var score, meilleur_score, i, nb_coup : integer;
        liste_coup : type_liste_coup;
        indices_liste_coup : type_indices_liste_coup;

    begin
        actualisation_plateau(coup_a_jouer, plateau);

        if profondeur < 1 then
            // if stable(plateau, joueur_courant) or (profondeur < -2) then
                alpha_beta_v7 := - cout_v4(plateau, joueur_ref)
        //     else
        //     begin
        //         joueur_courant := (joueur_courant mod 2) + 1;
        //         lister_coup(joueur_courant, nb_coup, liste_coup, plateau);

        //         if nb_coup = 0 then
        //             if joueur_ref = joueur_courant then
        //                 alpha_beta_v7 := -30000
        //             else
        //                 alpha_beta_v7 := 30000
        //         else
        //         begin
        //             meilleur_score := -30000;
        //             indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
        //             for i := 1 to nb_coup do
        //             begin
        //                 // score := max(score, alpha_beta_v7(plateau, liste_coup[i], joueur_ref, joueur_courant, alpha, beta, profondeur - 1));
        //                 score := alpha_beta_v7(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, -beta, -alpha, profondeur - 1);
        //                 if score >= meilleur_score then  //Coupure beta
        //                 begin
        //                     meilleur_score := score;
        //                     if meilleur_score >= alpha then
        //                     begin
        //                         alpha := meilleur_score;
        //                         if alpha >= beta then
        //                             exit;
        //                     end
        //                 end
        //             end;
        //             alpha_beta_v7 := meilleur_score;
        //         end
            // end
        else
        begin
            joueur_courant := (joueur_courant mod 2) + 1;
            lister_coup(joueur_courant, nb_coup, liste_coup, plateau);

            if nb_coup = 0 then
                if joueur_ref = joueur_courant then
                    alpha_beta_v7 := -30000
                else
                    alpha_beta_v7 := 30000
            else
            begin
                meilleur_score := -30000;
                indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                for i := 1 to nb_coup do
                begin
                    // score := max(score, alpha_beta_v7(plateau, liste_coup[i], joueur_ref, joueur_courant, alpha, beta, profondeur - 1));
                    score := alpha_beta_v7(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, -beta, -alpha, profondeur - 1);
                    if score >= meilleur_score then  //Coupure beta
                    begin
                        meilleur_score := score;
                        if meilleur_score >= alpha then
                        begin
                            alpha := meilleur_score;
                            if alpha >= beta then
                                exit;
                        end
                    end
                end;
                alpha_beta_v7 := meilleur_score;
            end
        end
    end;

    function ia_raphael_v7(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, meilleur_score, score, indice_coup, alpha, beta : integer;
    
    begin
        randomize;
        if nb_coup > 1 then
        begin
            alpha := -10;
            beta := 20;

            score := -30000;
            for i := 1 to nb_coup do
            begin
                meilleur_score := - alpha_beta_v7(plateau, liste_coup[i], joueur_ref, joueur_ref, alpha, beta, profondeur_ia_7);
                if meilleur_score > score then
                begin
                    score := meilleur_score;
                    ia_raphael_v7 := i
                end;
                
                if score >= beta then  //Coupure beta
                    break;

                alpha := max(score, alpha)
            end

        end
        else
            ia_raphael_v7 := 1;
        if not((1 <= ia_raphael_v7) and (ia_raphael_v7 <=nb_coup)) then
            ia_raphael_v7 := 1;
    end;



//************************************ IA ALPHA-BETA MEMO V1 ************************************\\

    function alpha_beta_memo_v1(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur, alpha, beta : integer; var table_hash : type_table_hash; var tableau_table_transposition : type_tableau_table_transposition):integer;
    var score, i, nb_coup, mon_hash, score_precedent : integer;
        liste_coup : type_liste_coup;
        indices_liste_coup : type_indices_liste_coup;
        table_transposition : type_table_transposition;

    begin
        actualisation_plateau(coup_a_jouer, plateau);

        mon_hash := hash(plateau, table_hash);
        table_transposition := tableau_table_transposition[mon_hash, 1];

        if table_transposition.profondeur >= profondeur then
        begin
            if table_transposition.alpha >= beta then 
                alpha_beta_memo_v1 := table_transposition.alpha;

            if table_transposition.beta <= alpha then 
                alpha_beta_memo_v1 := table_transposition.beta;

            alpha := max(alpha, table_transposition.alpha);
            beta := min(beta, table_transposition.beta);

            exit;
        end
        else
        begin
            if profondeur < 1 then
                score := cout_v4(plateau, joueur_ref)
            else
            begin
                joueur_courant := (joueur_courant mod 2) + 1;
                lister_coup(joueur_courant, nb_coup, liste_coup, plateau);

                if nb_coup = 0 then
                    if joueur_ref = joueur_courant then
                        alpha_beta_memo_v1 := -30000
                    else
                        alpha_beta_memo_v1 := 30000
                else
                begin
                    if joueur_ref = joueur_courant then
                    begin
                        score := 30000;
                        indices_liste_coup := tri_croissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                        i := 1;
                        while (i <= nb_coup) and (score > alpha) do
                        begin
                            score_precedent := score;

                            // score := min(score, alpha_beta_memo_v1(plateau, liste_coup[i], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, tableau_table_transposition));
                            score := min(score, alpha_beta_memo_v1(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, tableau_table_transposition));

                            // if score_precedent <> score then
                            //     table_transposition.indice_coup := indices_liste_coup[i];
                            // alpha := max(score, alpha);

                            beta := min(score, beta);

                            i := i + 1;
                        end;
                    end
                    else
                    begin
                        score := -30000;
                        indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                        i := 1;
                        while (i <= nb_coup) and (score < beta) do
                        begin
                            score_precedent := score;

                            // score := max(score, alpha_beta_memo_v1(plateau, liste_coup[i], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, tableau_table_transposition));
                            score := max(score, alpha_beta_memo_v1(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, tableau_table_transposition));

                            // if score_precedent <> score then
                            //     table_transposition.indice_coup := indices_liste_coup[i];
                            alpha := max(score, alpha);

                            i := i + 1;
                        end
                    end
                end
            end;

            if score <= alpha then 
                table_transposition.alpha := score
            else
                if score >= beta then 
                    table_transposition.beta := score
                else
                begin
                    table_transposition.alpha := score;
                    table_transposition.beta := score
                end;

            alpha_beta_memo_v1 := score
        end;
        tableau_table_transposition[mon_hash, 1] := table_transposition;
    end;

    function ia_raphael_memo_v1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, indice_coup, alpha, beta, mon_hash : integer;
	    table_hash : type_table_hash;
        tableau_table_transposition : type_tableau_table_transposition;

    begin
        init_table_hash(table_hash);
        init_tableau_table_transposition(tableau_table_transposition, 'memo_v1');

        mon_hash := hash(plateau, table_hash);

        if nb_coup > 1 then
        begin
            alpha := debut_alpha;
            beta := debut_beta;

            score := -31000;
            for i := 1 to nb_coup do
            begin
                resultat := alpha_beta_memo_v1(plateau, liste_coup[i], joueur_ref, joueur_ref, 10, alpha, beta, table_hash, tableau_table_transposition);
                if resultat > score then
                begin
                    score := resultat;
                    ia_raphael_memo_v1 := i
                end;

                alpha := max(score, alpha)
            end

        end
        else
            ia_raphael_memo_v1 := 1;
        enregistrement_tableau_table_transposition(tableau_table_transposition, 'memo_v1')
    end;


    function ia_raphael_memo_mtd_v1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, indice_coup, beta, mon_hash, valeur_de_depart,max,min : integer;
	    table_hash : type_table_hash;
        tableau_table_transposition : type_tableau_table_transposition;
        fichier : file of integer;

    begin
        assign(fichier, 'Ressources/ressources_raphael/valeur_de_depart.int');

        init_table_hash(table_hash);
        init_tableau_table_transposition(tableau_table_transposition, 'memo_mtd_v1');
        
        mon_hash := hash(plateau, table_hash);
        if (mon_hash = -6920) or (mon_hash = 29865) then
            valeur_de_depart := 30000
        else
        begin
            reset(fichier);
            read(fichier, valeur_de_depart);
            close(fichier);
        end;

        if nb_coup > 1 then
        begin
            max := 30000;
            min := -30000; 
            score := valeur_de_depart;
            while max > min do
            begin
                if score = min then
                    beta := score + 1
                else
                    beta := score;

                score := -30000;
                for i := 1 to nb_coup do
                begin
                    resultat := alpha_beta_memo_v1(plateau, liste_coup[i], joueur_ref, joueur_ref, profondeur_ia_6, beta-1, beta, table_hash, tableau_table_transposition);
                    if resultat > score then
                    begin
                        score := resultat;
                        ia_raphael_memo_mtd_v1 := i
                    end;
                end;

                if score < beta then
                    max := score 
                else
                    min := score;
            end;
        end
        else
            ia_raphael_memo_mtd_v1 := 1;
        enregistrement_tableau_table_transposition(tableau_table_transposition,'memo_mtd_v1');

        rewrite(fichier);
        write(fichier, valeur_de_depart+10);
        close(fichier);
    end;


//************************************ IA ALPHA-BETA V8 ************************************\\

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

    function stable(plateau : type_plateau; joueur_courant : integer):boolean;
    var i, j : integer;

    begin
        joueur_courant := (joueur_courant mod 2) + 1;
        stable := true;
        for i := 1 to 50 do
            if plateau[i] = joueur_courant then
            begin
                j := 0;
                while (j < 4) and stable do
                begin
                    j := j + 1;
                    case j of
                        1 : stable := not((parite(haut_gauche(i)) <> parite(i)) and (parite(i) = parite(haut_gauche(haut_gauche(i)))) and (haut_gauche(haut_gauche(i)) <= 50) and (plateau[haut_gauche(i)] = (joueur_courant mod 2) + 1) and (plateau[haut_gauche(haut_gauche(i))] = 0));
                        2 : stable := not((parite(haut_droite(i)) <> parite(i)) and (parite(i) = parite(haut_droite(haut_droite(i)))) and (haut_droite(haut_droite(i)) <= 50) and (plateau[haut_droite(i)] = (joueur_courant mod 2) + 1) and (plateau[haut_droite(haut_droite(i))] = 0));
                        3 : stable := not((parite(bas_gauche(i)) <> parite(i)) and (parite(i) = parite(bas_gauche(bas_gauche(i)))) and (bas_gauche(bas_gauche(i)) > 0) and (plateau[bas_gauche(i)] = (joueur_courant mod 2) + 1) and (plateau[bas_gauche(bas_gauche(i))] = 0));
                        4 : stable := not((parite(bas_droite(i)) <> parite(i)) and (parite(i) = parite(bas_droite(bas_droite(i)))) and (bas_droite(bas_droite(i)) > 0) and (plateau[bas_droite(i)] = (joueur_courant mod 2) + 1) and (plateau[bas_droite(bas_droite(i))] = 0));
                    end;
                end;
                if not stable then break;
            end
            // else
            //     if plateau[i] = joueur_courant + 2 then
            //     begin
                    
            //     end; 
        // stable := true;
    end;

    function alphabeta_v8(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur, alpha, beta : integer; var table_hash : type_table_hash; var tableau_table_transposition : type_tableau_table_transposition):integer;
    var score, i, nb_coup, mon_hash, score_precedent : integer;
        liste_coup : type_liste_coup;
        indices_liste_coup : type_indices_liste_coup;
        table_transposition : type_table_transposition;

    begin
        actualisation_plateau(coup_a_jouer, plateau);

        mon_hash := hash(plateau, table_hash);
        table_transposition := tableau_table_transposition[mon_hash, 1];

        if table_transposition.profondeur >= profondeur then
        begin
            if table_transposition.alpha >= beta then 
                alphabeta_v8 := table_transposition.alpha;

            if table_transposition.beta <= alpha then 
                alphabeta_v8 := table_transposition.beta;

            alpha := max(alpha, table_transposition.alpha);
            beta := min(beta, table_transposition.beta);

            exit;
        end
        else
        begin
            if (profondeur < 1) then
                if stable(plateau, joueur_courant) or (profondeur < -1) then
                    score := cout_v4(plateau, joueur_ref)
                else
                begin
                    joueur_courant := (joueur_courant mod 2) + 1;
                    lister_coup(joueur_courant, nb_coup, liste_coup, plateau);
                    if nb_coup = 0 then
                        if joueur_ref = joueur_courant then
                            alphabeta_v8 := -30000
                        else
                            alphabeta_v8 := 30000
                    else
                        if joueur_ref = joueur_courant then
                        begin
                            score := 30000;
                            indices_liste_coup := tri_croissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                            i := 1;
                            while (i <= nb_coup) and (score > alpha) do
                                begin
                                    score_precedent := score;

                                    score := min(score, alphabeta_v8(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, tableau_table_transposition));

                                    // if score_precedent <> score then
                                    //     table_transposition.indice_coup := indices_liste_coup[i];
                                    alpha := max(score, alpha);

                                    beta := min(score, beta);

                                    i := i + 1;
                                end;
                        end
                        else
                        begin
                            score := -30000;
                            indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                            i := 1;
                            while (i <= nb_coup) and (score < beta) do
                                begin
                                    score_precedent := score;

                                    score := max(score, alphabeta_v8(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, tableau_table_transposition));

                                    // if score_precedent <> score then
                                    //     table_transposition.indice_coup := indices_liste_coup[i];
                                    alpha := max(score, alpha);

                                    i := i + 1;
                                end;
                        end
                end
            else
            begin
                joueur_courant := (joueur_courant mod 2) + 1;
                lister_coup(joueur_courant, nb_coup, liste_coup, plateau);

                if nb_coup = 0 then
                    if joueur_ref = joueur_courant then
                        alphabeta_v8 := -30000
                    else
                        alphabeta_v8 := 30000
                else
                begin
                    if joueur_ref <> joueur_courant then
                    begin
                        score := 30000;
                        indices_liste_coup := tri_croissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                        i := 1;
                        while (i <= nb_coup) and (score > alpha) do
                            begin
                                score_precedent := score;
                                score := min(score, alphabeta_v8(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, tableau_table_transposition));

                                // if score_precedent <> score then
                                //     table_transposition.indice_coup := indices_liste_coup[i];
                                // alpha := max(score, alpha);

                                beta := min(score, beta);

                                i := i + 1;
                            end;
                    end
                    else
                    begin
                        score := -30000;
                        indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                        i := 1;
                        while (i <= nb_coup) and (score < beta) do
                            begin
                                score_precedent := score;
                                score := max(score, alphabeta_v8(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, tableau_table_transposition));

                                // if score_precedent <> score then
                                //     table_transposition.indice_coup := indices_liste_coup[i];
                                alpha := max(score, alpha);

                                i := i + 1;
                            end;
                    end
                end;
            end;

            if score <= alpha then 
                table_transposition.alpha := score
            else
                if score >= beta then 
                    table_transposition.beta := score
                else
                begin
                    table_transposition.alpha := score;
                    table_transposition.beta := score
                end;

            alphabeta_v8 := score
        end;
        tableau_table_transposition[mon_hash, 1] := table_transposition;
    end;

    
    function ia_raphael_v8(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, indice_coup, beta, mon_hash, valeur_de_depart,max,min : integer;
	    table_hash : type_table_hash;
        tableau_table_transposition : type_tableau_table_transposition;
        fichier : file of integer;

    begin
        assign(fichier, 'Ressources/ressources_raphael/valeur_de_depart.int');

        init_table_hash(table_hash);
        init_tableau_table_transposition(tableau_table_transposition, 'v8');
        
        mon_hash := hash(plateau, table_hash);
        if (mon_hash = -6920) or (mon_hash = 29865) then
            valeur_de_depart := 200
        else
        begin
            reset(fichier);
            read(fichier, valeur_de_depart);
            close(fichier);
        end;

        if nb_coup > 1 then
        begin
            max := 30000;
            min := -30000; 
            score := valeur_de_depart;
            while max > min do
            begin
                if score = min then
                    beta := score + 1
                else
                    beta := score;

                score := -30000;
                for i := 1 to nb_coup do
                begin
                    resultat := alphabeta_v8(plateau, liste_coup[i], joueur_ref, joueur_ref, profondeur_ia_6, beta-1, beta, table_hash, tableau_table_transposition);
                    if resultat > score then
                    begin
                        score := resultat;
                        ia_raphael_v8 := i
                    end;
                end;

                if score < beta then
                    max := score 
                else
                    min := score;
            end;
        end
        else
            ia_raphael_v8 := 1;
        enregistrement_tableau_table_transposition(tableau_table_transposition, 'v8');

        rewrite(fichier);
        write(fichier, valeur_de_depart);
        close(fichier);
    end;


//************************************ IA ALPHA-BETA VR1 ************************************\\

    function alphabeta_vr1(plateau : type_plateau; joueur_ref, joueur_courant, max_coup, alpha, beta, profondeur : integer; var indice_coup : integer):integer;//; var table_hash : type_table_hash; var tableau_table_transposition : type_tableau_table_transposition):integer;
    var liste_coup : type_liste_coup;
        coup_a_jouer : type_coup;
        nb_coup, score_precedent, i, indice_coup_suivants, mon_hash : integer;
        plateau_essai : type_plateau;
        indices_liste_coup : type_indices_liste_coup;
        // table_transposition : type_table_transposition;
    
    begin
        // mon_hash := hash(plateau, table_hash);
        // table_transposition := tableau_table_transposition[mon_hash, 1];
        // if (table_transposition.profondeur >= profondeur) and (max_coup = table_transposition.max_coup) then
        // begin
        //     // alpha := max(alpha, table_transposition.beta);
        //     // beta := min(beta, table_transposition.alpha);
        //     indice_coup := table_transposition.indice_coup;
        //     alphabeta_vr1 := table_transposition.score;
        //     // if (alphabeta_vr1 > alpha) and (joueur_ref = joueur_courant) then 
        //     //     alpha := alphabeta_vr1;
        //     // if (alphabeta_vr1 < beta) and (joueur_ref <> joueur_courant) then 
        //     //     beta := alphabeta_vr1;
        //     compteur_global := compteur_global + 1;
        // end;
        // else
        begin
            lister_coup(joueur_courant, nb_coup, liste_coup, plateau);
            if nb_coup = 0 then
                if joueur_ref = joueur_courant then 
                begin
                    alphabeta_vr1 := -30000;
                    indice_coup := 0;
                end
                else
                begin
                    alphabeta_vr1 := 30000;
                    indice_coup := 0;
                end
            else
                if ((profondeur < 1) and stable(plateau, joueur_courant)) then//or (profondeur < -2) then
                begin
                    alphabeta_vr1 := cout_v4(plateau, joueur_ref);
                    indice_coup := 0;
                end
                else                
                begin
                    i := 0;
                    if joueur_ref = joueur_courant then
                    begin
                        indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                        indice_coup := indices_liste_coup[1];
                        while (i < nb_coup) and (alpha < beta) do
                        begin
                            i := i + 1;
                            plateau_essai := plateau;
                            score_precedent := alpha;
                            indice_coup_suivants := indice_coup;
                            actualisation_plateau(liste_coup[indices_liste_coup[i]], plateau_essai);
                            // actualisation_plateau(liste_coup[i], plateau_essai);
                            alpha := max(alpha, alphabeta_vr1(plateau_essai, joueur_ref, (joueur_courant mod 2) + 1, nb_coup, alpha, beta, profondeur - 1, indice_coup_suivants));//, table_hash, tableau_table_transposition));
                            if alpha <> score_precedent then 
                                indice_coup := indices_liste_coup[i];
                                // indice_coup := i;
                        end;
                        alphabeta_vr1 := alpha;
                    end
                    else
                    begin
                        indices_liste_coup := tri_croissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                        indice_coup := indices_liste_coup[1];
                        while (i < nb_coup) and (alpha < beta) do
                        begin
                            i := i + 1;
                            plateau_essai := plateau;
                            score_precedent := beta;
                            indice_coup_suivants := indice_coup;
                            actualisation_plateau(liste_coup[indices_liste_coup[i]], plateau_essai);
                            // actualisation_plateau(liste_coup[i], plateau_essai);
                            beta := min(beta, alphabeta_vr1(plateau_essai, joueur_ref, (joueur_courant mod 2) + 1, nb_coup, alpha, beta, profondeur - 1, indice_coup_suivants));//, table_hash, tableau_table_transposition));
                            if beta <> score_precedent then 
                                indice_coup := indices_liste_coup[i];
                                // indice_coup := i;
                        end;
                        alphabeta_vr1 := beta;
                    end;
                end;
        end;
        // tableau_table_transposition[mon_hash, 1].indice_coup := indice_coup;
        // tableau_table_transposition[mon_hash, 1].max_coup := nb_coup;
        // tableau_table_transposition[mon_hash, 1].profondeur := profondeur;
        // tableau_table_transposition[mon_hash, 1].score := alphabeta_vr1;
        // tableau_table_transposition[mon_hash, 1].alpha := alpha;
        // tableau_table_transposition[mon_hash, 1].beta := beta;
    end;

    function ia_raphael_vr1(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var indice_coup{, mon_hash, valeur_de_depart} : integer;
        // table_hash : type_table_hash;
        // tableau_table_transposition : type_tableau_table_transposition;
        // fichier : file of integer;

    begin
        // writeln('debut tour');

        // assign(fichier, 'Ressources/ressources_raphael/valeur_de_depart.int');
        // init_table_hash(table_hash);
        // init_tableau_table_transposition(tableau_table_transposition, 'vr1');
        // mon_hash := hash(plateau, table_hash, joueur_ref);
        // if (mon_hash = -6920) or (mon_hash = 29865) then
        //     valeur_de_depart := 200
        // else
        // begin
        //     reset(fichier);
        //     read(fichier, valeur_de_depart);
        //     close(fichier);
        // end;

        if nb_coup > 1 then
        begin
            alphabeta_vr1(plateau, joueur_ref, joueur_ref, nb_coup, -30000, 30000, 5, indice_coup);//, table_hash, tableau_table_transposition);
            ia_raphael_vr1 := indice_coup;
        end
        else
            ia_raphael_vr1 := 1;

        // enregistrement_tableau_table_transposition(tableau_table_transposition, 'vr1');
        // rewrite(fichier);
        // write(fichier, valeur_de_depart);
        // close(fichier);

        if (0 >= ia_raphael_vr1) or (nb_coup < ia_raphael_vr1) then
            writeln('erreur fin tour renvoie ', ia_raphael_vr1, ', nb_coup = ', nb_coup);
        // writeln('fin tour');
    end;


//vr2//

    function alphabeta_vr2(plateau : type_plateau; joueur_ref, joueur_courant, max_coup, alpha, beta, profondeur : integer; var indice_coup : integer):integer;//; var table_hash : type_table_hash; var tableau_table_transposition : type_tableau_table_transposition):integer;
    var liste_coup : type_liste_coup;
        coup_a_jouer : type_coup;
        nb_coup, score_precedent, i, indice_coup_suivants, mon_hash : integer;
        plateau_essai : type_plateau;
        indices_liste_coup : type_indices_liste_coup;
    
    begin
        begin
            lister_coup(joueur_courant, nb_coup, liste_coup, plateau);
            if nb_coup = 0 then
                if joueur_ref = joueur_courant then 
                begin
                    alphabeta_vr2 := -30000;
                    indice_coup := 0;
                end
                else
                begin
                    alphabeta_vr2 := 30000;
                    indice_coup := 0;
                end
            else
                if ((profondeur < 1) and stable(plateau, joueur_courant)) then
                begin
                    alphabeta_vr2 := cout_v4(plateau, joueur_ref);
                    indice_coup := 0;
                end
                else                
                begin
                    i := 0;
                    if joueur_ref = joueur_courant then
                    begin
                        indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                        indice_coup := indices_liste_coup[1];
                        while (i < nb_coup) and (alpha < beta) do
                        begin
                            i := i + 1;
                            plateau_essai := plateau;
                            score_precedent := alpha;
                            indice_coup_suivants := indice_coup;
                            actualisation_plateau(liste_coup[indices_liste_coup[i]], plateau_essai);
                            alpha := max(alpha, alphabeta_vr2(plateau_essai, joueur_ref, (joueur_courant mod 2) + 1, nb_coup, alpha, beta, profondeur - 1, indice_coup_suivants));//, table_hash, tableau_table_transposition));
                            if alpha <> score_precedent then 
                                indice_coup := indices_liste_coup[i];
                        end;
                        alphabeta_vr2 := alpha;
                    end
                    else
                    begin
                        indices_liste_coup := tri_croissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                        indice_coup := indices_liste_coup[1];
                        while (i < nb_coup) and (alpha < beta) do
                        begin
                            i := i + 1;
                            plateau_essai := plateau;
                            score_precedent := beta;
                            indice_coup_suivants := indice_coup;
                            actualisation_plateau(liste_coup[indices_liste_coup[i]], plateau_essai);
                            beta := min(beta, alphabeta_vr2(plateau_essai, joueur_ref, (joueur_courant mod 2) + 1, nb_coup, alpha, beta, profondeur - 1, indice_coup_suivants));//, table_hash, tableau_table_transposition));
                            if beta <> score_precedent then 
                                indice_coup := indices_liste_coup[i];
                        end;
                        alphabeta_vr2 := beta;
                    end;
                end;
        end;
    end;

    function ia_raphael_vr2(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var indice_coup : integer;
        
    begin
        // writeln('debut tour vr2');

        if nb_coup > 1 then
        begin
            alphabeta_vr2(plateau, joueur_ref, joueur_ref, nb_coup, -100, 200, 7, indice_coup);//, table_hash, tableau_table_transposition);
            ia_raphael_vr2 := indice_coup;
        end
        else
            ia_raphael_vr2 := 1;

        if (0 >= ia_raphael_vr2) or (nb_coup < ia_raphael_vr2) then
            writeln('erreur fin tour renvoie ', ia_raphael_vr2, ', nb_coup = ', nb_coup);
        // writeln('fin tour vr2');
    end;

//vr3//

    function alphabeta_vr3(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur, alpha, beta : integer; var table_hash, table_verif : type_table_hash; var tableau_table_transposition : type_tableau_table_transposition):integer;
    var score, i, j, nb_coup, mon_hash, mon_hash_verif : integer;
        liste_coup : type_liste_coup;
        indices_liste_coup : type_indices_liste_coup;
        table_transposition : type_table_transposition;
        table_exists : boolean;

    begin
        actualisation_plateau(coup_a_jouer, plateau);

        if ((profondeur < 1) and stable(plateau, joueur_courant)) or (profondeur < -2) then
        begin
            alphabeta_vr3 := cout_v4(plateau, joueur_ref);
            exit;
        end
        else
        begin
            table_exists := false;
            mon_hash := hash(plateau, table_hash);
            mon_hash_verif := hash_verif(plateau, table_verif);
            j := 1;
            table_transposition := tableau_table_transposition[mon_hash, 1];
            while (table_transposition.profondeur >= profondeur) and (not table_exists) and (j <= max_dim) do
            begin
                if (table_transposition.hash_verif = mon_hash_verif) then
                begin
                    if table_transposition.alpha >= beta then 
                    begin
                        alphabeta_vr3 := table_transposition.alpha;
                        exit;
                    end;
                    if table_transposition.beta <= alpha then 
                    begin
                        alphabeta_vr3 := table_transposition.beta;
                        exit;
                    end;
                    alpha := max(alpha, table_transposition.beta);
                    beta := min(beta, table_transposition.alpha);
                    table_exists := true;
                end;

                if not table_exists then
                begin
                    j := j + 1;
                    table_transposition := tableau_table_transposition[mon_hash, j];
                end;
            end;

            if (not table_exists) and (j > max_dim) then
                compteur_global := compteur_global + 1;

            joueur_courant := (joueur_courant mod 2) + 1;
            lister_coup(joueur_courant, nb_coup, liste_coup, plateau);

            if nb_coup = 0 then
                if joueur_ref = joueur_courant then
                begin
                    alphabeta_vr3 := -30000;
                    exit;
                end
                else
                begin
                    alphabeta_vr3 := 30000;
                    exit;
                end
            else
            begin
                if joueur_ref <> joueur_courant then
                begin
                    score := 31000;
                    indices_liste_coup := tri_croissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                    for i := 1 to nb_coup do
                    begin
                        score := min(score, alphabeta_vr3(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, table_verif, tableau_table_transposition));
                        if alpha >= score then  //Coupure alpha
                        begin
                            alphabeta_vr3 := score;
                            exit;
                        end;
                        beta := min(score, beta);
                    end;
                end
                else
                begin
                    score := -31000;
                    indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                    for i := 1 to nb_coup do
                    begin
                        score := max(score, alphabeta_vr3(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, table_verif, tableau_table_transposition));
                        if score >= beta then  //Coupure beta
                        begin
                            alphabeta_vr3 := score;
                            exit;
                        end;
                        alpha := max(score, alpha)
                    end
                end;
                alphabeta_vr3 := score;
            end;
        end;

        if (j <= max_dim) and (table_transposition.profondeur < profondeur) then
        begin
            if score <= alpha then
                tableau_table_transposition[mon_hash, j].alpha := score;
            if score >= beta then
                tableau_table_transposition[mon_hash, j].beta := score;
            if (alpha < score) and (score < beta) then
            begin
                tableau_table_transposition[mon_hash, j].alpha := score;
                tableau_table_transposition[mon_hash, j].beta := score;
            end;
            tableau_table_transposition[mon_hash, j].profondeur := profondeur;
            tableau_table_transposition[mon_hash, j].hash_verif := mon_hash_verif;
        end;
    end;

    function ia_raphael_vr3(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, alpha, beta : integer;
        mon_hash_verif : longint;
        table_hash, table_verif : type_table_hash;
        tableau_table_transposition : type_tableau_table_transposition;

    begin
        // writeln('debut tour vr3');

        init_table_hash(table_hash);
        init_table_verif(table_verif);
        init_tableau_table_transposition(tableau_table_transposition, 'vr3++');

        if nb_coup > 1 then
        begin
            alpha := -30000;
            beta := 30000;

            score := -31000;
            for i := 1 to nb_coup do
            begin
                resultat := alphabeta_vr3(plateau, liste_coup[i], joueur_ref, joueur_ref, profondeur_ia_6_temoin-1, alpha, beta, table_hash, table_verif, tableau_table_transposition);
                if resultat > score then
                begin
                    score := resultat;
                    ia_raphael_vr3 := i
                end
                else
                    if (resultat = score) and (random(2) = 1) then
                    begin
                        score := resultat;
                        ia_raphael_vr3 := i
                    end;

                if score >= beta then  //Coupure beta
                    break;

                alpha := max(score, alpha)
            end;
        end
        else
            ia_raphael_vr3 := 1;

        enregistrement_tableau_table_transposition(tableau_table_transposition, 'vr3++');

        // writeln('fin tour vr3');
        if (0 >= ia_raphael_vr3) or (nb_coup < ia_raphael_vr3) then
            writeln('erreur fin tour renvoie ', ia_raphael_vr3, ' ', i, ', nb_coup = ', nb_coup);
    end;

//vr3t//

    function ia_raphael_vr3t(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, alpha, beta : integer;
        mon_hash_verif : longint;
        table_hash, table_verif : type_table_hash;
        tableau_table_transposition : type_tableau_table_transposition;

    begin
        // writeln('debut tour vr3t');

        init_table_hash(table_hash);
        init_table_verif(table_verif);
        init_tableau_table_transposition(tableau_table_transposition, 'vr3t');

        if nb_coup > 1 then
        begin
            alpha := -30000;
            beta := 30000;

            score := -31000;
            for i := 1 to nb_coup do
            begin
                resultat := alphabeta_vr3(plateau, liste_coup[i], joueur_ref, joueur_ref, profondeur_ia_6-1, alpha, beta, table_hash, table_verif, tableau_table_transposition);
                if resultat > score then
                begin
                    score := resultat;
                    ia_raphael_vr3t := i
                end;
                
                if score >= beta then  //Coupure beta
                    break;

                alpha := max(score, alpha)
            end;
        end
        else
            ia_raphael_vr3t := 1;

        enregistrement_tableau_table_transposition(tableau_table_transposition, 'vr3t');

        // writeln('fin tour vr3t');
        if (0 >= ia_raphael_vr3t) or (nb_coup < ia_raphael_vr3t) then
            writeln('erreur fin tour renvoie ', ia_raphael_vr3t, ' ', i, ', nb_coup = ', nb_coup);
    end;

//vr4//

    function ia_raphael_vr4(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, alpha, beta, valeur_de_depart, mini, maxi : integer;
        mon_hash_verif : longint;
        table_hash, table_verif : type_table_hash;
        tableau_table_transposition : type_tableau_table_transposition;
        fichier : file of integer;

    begin
        // writeln('debut tour vr4');

        init_table_hash(table_hash);
        init_table_verif(table_verif);
        init_tableau_table_transposition(tableau_table_transposition, 'vr4');

        assign(fichier, 'Ressources/ressources_raphael/valeur_de_depart.int');
        mon_hash_verif := hash_verif(plateau, table_verif);
        if mon_hash_verif = 70828258 then
            valeur_de_depart := 10
        else
        begin
            reset(fichier);
            read(fichier, valeur_de_depart);
            close(fichier);
        end;

        if nb_coup > 1 then
        begin
            maxi := 30000;
            mini := -30000; 
            score := valeur_de_depart;
            while maxi > mini do
            begin
                if score = mini then
                    beta := score + 1
                else
                    beta := score;

                score := -31000;
                for i := 1 to nb_coup do
                begin
                    resultat := alphabeta_vr3(plateau, liste_coup[i], joueur_ref, joueur_ref, profondeur_ia_6-1, alpha, beta, table_hash, table_verif, tableau_table_transposition);
                    if resultat > score then
                    begin
                        score := resultat;
                        ia_raphael_vr4 := i
                    end;
                end;

                if score < beta then
                    maxi := score 
                else
                    mini := score;
            end;
        end
        else
            ia_raphael_vr4 := 1;

        enregistrement_tableau_table_transposition(tableau_table_transposition, 'vr4');

        rewrite(fichier);
        write(fichier, valeur_de_depart);
        close(fichier);

        // writeln('fin tour vr4');
        if (0 >= ia_raphael_vr4) or (nb_coup < ia_raphael_vr4) then
            writeln('erreur fin tour renvoie ', ia_raphael_vr4, ' ', i, ', nb_coup = ', nb_coup);
    end;

//vr5//

    function alphabeta_vr5(plateau : type_plateau; coup_a_jouer : type_coup; joueur_ref, joueur_courant, profondeur, alpha, beta : integer; var table_hash, table_verif : type_table_hash; var tableau_table_transposition : type_tableau_table_transposition):integer;
    var score, i, j, nb_coup, mon_hash, mon_hash_verif : integer;
        liste_coup : type_liste_coup;
        indices_liste_coup : type_indices_liste_coup;
        table_transposition : type_table_transposition;
        table_exists : boolean;

    begin
        actualisation_plateau(coup_a_jouer, plateau);

        if ((profondeur < 1) and stable(plateau, joueur_courant)) or (profondeur < -2) then
        begin
            alphabeta_vr5 := cout_v4(plateau, joueur_ref);
            exit;
        end
        else
        begin
            table_exists := false;
            mon_hash := hash(plateau, table_hash);
            mon_hash_verif := hash_verif(plateau, table_verif);
            j := 1;
            table_transposition := tableau_table_transposition[mon_hash, 1];
            while (table_transposition.profondeur >= profondeur) and (not table_exists) and (j <= max_dim) do
            begin
                if (table_transposition.hash_verif = mon_hash_verif) then
                begin
                    if table_transposition.alpha >= beta then 
                    begin
                        alphabeta_vr5 := table_transposition.alpha;
                        exit;
                    end;
                    if table_transposition.beta <= alpha then 
                    begin
                        alphabeta_vr5 := table_transposition.beta;
                        exit;
                    end;
                    alpha := max(alpha, table_transposition.beta);
                    beta := min(beta, table_transposition.alpha);
                    table_exists := true;
                end;

                if not table_exists then
                begin
                    j := j + 1;
                    table_transposition := tableau_table_transposition[mon_hash, j];
                end;
            end;

            if (not table_exists) and (j > max_dim) then
                compteur_global := compteur_global + 1;

            joueur_courant := (joueur_courant mod 2) + 1;
            lister_coup(joueur_courant, nb_coup, liste_coup, plateau);

            if nb_coup = 0 then
                if joueur_ref = joueur_courant then
                begin
                    alphabeta_vr5 := -30000;
                    exit;
                end
                else
                begin
                    alphabeta_vr5 := 30000;
                    exit;
                end
            else
            begin
                if joueur_ref <> joueur_courant then
                begin
                    score := 31000;
                    indices_liste_coup := tri_croissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                    for i := 1 to nb_coup do
                    begin
                        score := min(score, alphabeta_vr5(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, table_verif, tableau_table_transposition));
                        if alpha >= score then  //Coupure alpha
                        begin
                            alphabeta_vr5 := score;
                            exit;
                        end;
                        beta := min(score, beta);
                    end;
                end
                else
                begin
                    score := -31000;
                    indices_liste_coup := tri_decroissant_indices_liste_coup(plateau, liste_coup, nb_coup, joueur_ref);
                    for i := 1 to nb_coup do
                    begin
                        score := max(score, alphabeta_vr5(plateau, liste_coup[indices_liste_coup[i]], joueur_ref, joueur_courant, profondeur - 1, alpha, beta, table_hash, table_verif, tableau_table_transposition));
                        if score >= beta then  //Coupure beta
                        begin
                            alphabeta_vr5 := score;
                            exit;
                        end;
                        alpha := max(score, alpha)
                    end
                end;
                alphabeta_vr5 := score;
            end;
        end;

        if (j <= max_dim) and (table_transposition.profondeur < profondeur) then
        begin
            if score <= alpha then
                tableau_table_transposition[mon_hash, j].alpha := score;
            if score >= beta then
                tableau_table_transposition[mon_hash, j].beta := score;
            if (alpha < score) and (score < beta) then
            begin
                tableau_table_transposition[mon_hash, j].alpha := score;
                tableau_table_transposition[mon_hash, j].beta := score;
            end;
            tableau_table_transposition[mon_hash, j].profondeur := profondeur;
            tableau_table_transposition[mon_hash, j].hash_verif := mon_hash_verif;
        end;
    end;

    function ia_raphael_vr5(joueur_ref,nb_coup : integer; liste_coup : type_liste_coup; plateau : type_plateau):integer;
    var i, resultat, score, alpha, beta : integer;
        mon_hash_verif : longint;
        table_hash, table_verif : type_table_hash;
        tableau_table_transposition : type_tableau_table_transposition;

    begin
        // writeln('debut tour vr5');

        init_table_hash(table_hash);
        init_table_verif(table_verif);
        init_tableau_table_transposition(tableau_table_transposition, 'vr5++');

        if nb_coup > 1 then
        begin
            alpha := -30000;
            beta := 30000;

            score := -31000;
            for i := 1 to nb_coup do
            begin
                resultat := alphabeta_vr5(plateau, liste_coup[i], joueur_ref, joueur_ref, profondeur_ia_6_temoin-1, alpha, beta, table_hash, table_verif, tableau_table_transposition);
                if resultat > score then
                begin
                    score := resultat;
                    ia_raphael_vr5 := i
                end
                else
                    if (resultat = score) and (random(2) = 1) then
                    begin
                        score := resultat;
                        ia_raphael_vr5 := i
                    end;

                if score >= beta then  //Coupure beta
                    break;

                alpha := max(score, alpha)
            end;
        end
        else
            ia_raphael_vr5 := 1;

        enregistrement_tableau_table_transposition(tableau_table_transposition, 'vr5++');

        // writeln('fin tour vr3');
        if (0 >= ia_raphael_vr5) or (nb_coup < ia_raphael_vr5) then
            writeln('erreur fin tour ia 5 renvoie ', ia_raphael_vr5, ' ', i, ', nb_coup = ', nb_coup);
    end;

//************************************ COUT VCR ************************************\\
//pion_au_centre//
    function pion_au_centre(position : integer):boolean;
    begin
        if (position in [22..24]) or (position in [27..29]) then
            pion_au_centre := true
        else
            pion_au_centre := false;
    end;

//bords//
    function bord_bas(position : integer):boolean;
    begin
        if position in [1..5] then
            bord_bas := true
        else
            bord_bas := false;
    end;

    function bord_haut(position : integer):boolean;
    begin
        if position in [46..50] then
            bord_haut := true
        else
            bord_haut := false;
    end;

    function bord_droit(position : integer):boolean;
    begin
        if position in [10,20,30,40,50] then
            bord_droit := true
        else
            bord_droit := false;
    end;

    function bord_gauche(position : integer):boolean;
    begin
        if position in [1,11,21,31,41] then
            bord_gauche := true
        else
            bord_gauche := false;
    end;

    function bord_vertical(position : integer):boolean;
    begin
        if position in [1,11,21,31,41,10,20,30,40,50] then
            bord_vertical := true
        else
            bord_vertical := false;
    end;

//etude_autour//
    function etude_avant_droite(var plateau : type_plateau; position, joueur_courant : integer):shortint;
    begin
        if position in [10,20,30,40,50] then
            etude_avant_droite := 1
        else
            if ((position > 5) and (joueur_courant = 2)) or ((position < 46) and (joueur_courant = 1)) then
                if joueur_courant = 1 then
                    if plateau[haut_droite(position)] in [2,4] then
                        etude_avant_droite := -1
                    else 
                        if plateau[haut_droite(position)] = 0 then
                            etude_avant_droite := 0
                        else
                            etude_avant_droite := 1
                else
                    if plateau[bas_droite(position)] in [1,3] then
                        etude_avant_droite := -1
                    else    
                        if plateau[bas_droite(position)] = 0 then
                            etude_avant_droite := 0
                        else
                            etude_avant_droite := 1
    end;

    function etude_avant_gauche(var plateau : type_plateau; position, joueur_courant : integer):shortint;
    begin
        if position in [1,11,21,31,41] then
            etude_avant_gauche := 1
        else
            if ((position > 5) and (joueur_courant = 2)) or ((position < 46) and (joueur_courant = 1)) then
                if joueur_courant = 1 then
                    if plateau[haut_gauche(position)] in [2,4] then
                        etude_avant_gauche := -1
                    else    
                        if plateau[haut_gauche(position)] = 0 then
                            etude_avant_gauche := 0
                        else
                            etude_avant_gauche := 1
                else
                    if plateau[bas_gauche(position)] in [1,3] then
                        etude_avant_gauche := -1
                    else    
                        if plateau[bas_gauche(position)] = 0 then
                            etude_avant_gauche := 0
                        else
                            etude_avant_gauche := 1
    end;
    
    function etude_arriere_droite(var plateau : type_plateau; position, joueur_courant : integer):shortint;
    begin
        if position in [10,20,30,40,50] then
            etude_arriere_droite := 1
        else
            if ((position > 5) and (joueur_courant = 1)) or ((position < 46) and (joueur_courant = 2)) then
                if joueur_courant = 2 then
                    if plateau[haut_droite(position)] in [2,4] then
                        etude_arriere_droite := -1
                    else    
                        if plateau[haut_droite(position)] = 0 then
                            etude_arriere_droite := 0
                        else
                            etude_arriere_droite := 1
                else
                    if plateau[bas_droite(position)] in [1,3] then
                        etude_arriere_droite := -1
                    else    
                        if plateau[bas_droite(position)] = 0 then
                            etude_arriere_droite := 0
                        else
                            etude_arriere_droite := 1
    end;

    function etude_arriere_gauche(var plateau : type_plateau; position, joueur_courant : integer):shortint;
    begin
        if position in [1,11,21,31,41] then
            etude_arriere_gauche := 1
        else
            if ((position > 5) and (joueur_courant = 1)) or ((position < 46) and (joueur_courant = 2)) then
                if joueur_courant = 2 then
                    if plateau[haut_gauche(position)] in [2,4] then
                        etude_arriere_gauche := -1
                    else    
                        if plateau[haut_gauche(position)] = 0 then
                            etude_arriere_gauche := 0
                        else
                            etude_arriere_gauche := 1
                else
                    if plateau[bas_gauche(position)] in [1,3] then
                        etude_arriere_gauche := -1
                    else    
                        if plateau[bas_gauche(position)] = 0 then
                            etude_arriere_gauche := 0
                        else
                            etude_arriere_gauche := 1
    end;


//diagonales//
    function diagonales(var plateau : type_plateau; position, joueur_courant : integer):byte;
    var arriere_droite, arriere_gauche, avant_droite, avant_gauche : byte;

    begin
        // writeln(1);
        arriere_droite := etude_arriere_droite(plateau, position, joueur_courant);
        // writeln(2);
        arriere_gauche := etude_arriere_gauche(plateau, position, joueur_courant);
        // writeln(3);
        avant_droite := etude_avant_droite(plateau, position, joueur_courant);
        // writeln(4);
        avant_gauche := etude_avant_gauche(plateau, position, joueur_courant);
        // writeln(5);
        // writeln(2);
        if ((arriere_droite = 0) and (avant_gauche = -1)) or ((arriere_droite = -1) and (avant_gauche = 0)) or ((arriere_gauche = 0) and (avant_droite = -1)) or ((arriere_gauche = -1) and (avant_droite = 0)) then
        begin
            // writeln(3);
            diagonales := 0;
        end
        else
            if (arriere_droite = -avant_gauche) or (arriere_gauche = -avant_droite) then
            begin
                // writeln(4);
                diagonales := 3;
            end
            else
                if ((arriere_droite = avant_gauche) and (avant_gauche = 1)) or ((arriere_gauche = avant_droite) and (avant_droite = 1)) then 
                begin
                    // writeln(5);
                    diagonales := 4;
                end
                else
                    if ((arriere_droite = avant_gauche) and (avant_gauche = -1)) or ((arriere_gauche = avant_droite) and (avant_droite = -1)) then 
                    begin
                        // writeln(6);
                        diagonales := 5;
                    end
                    else
                        if ((arriere_droite = 0) and (avant_gauche = 1)) or ((arriere_droite = 1) and (avant_gauche = 0)) or ((arriere_gauche = 0) and (avant_droite = 1)) or ((arriere_gauche = 1) and (avant_droite = 0)) then
                        begin
                            // writeln(7);
                            diagonales := 2;
                        end
                        else
                        begin
                            // writeln(8);
                            diagonales := 1;
                        end;
        // writeln('renvoie ', diagonales);
    end;

//VCR1//
    function cout_vcr1(plateau : type_plateau; joueur_ref : integer; var data_poids : type_data_poids):integer;
    var i, score : integer;

    begin
        score := 0;
        // writeln(1);
        with data_poids do
            for i := 1 to 50 do
            begin
                // writeln(2);
                case plateau[i] of 
                    1 : if joueur_ref = 1 then 
                        begin
                            // writeln(3);
                            if bord_bas(i) then 
                                score := score + tab[1]
                            else 
                                if bord_haut(i) then
                                    score := score + tab[2]
                                else
                                    if bord_vertical(i) then
                                        score := score + tab[3];
                            // writeln(4);
                            score := score + tab[3+((i + 4) div 5)];
                            // writeln(5);
                            score := score + tab[14 + diagonales(plateau, i, 1)];
                            // writeln(6);
                            if pion_au_centre(i) then
                                score := score + tab[22] + tab[20]
                            else
                                score := score + tab[22];
                            // writeln(7);
                        end
                        else
                        begin
                            if bord_bas(i) then 
                                score := score - tab[1]
                            else 
                                if bord_haut(i) then
                                    score := score - tab[2]
                                else
                                    if bord_vertical(i) then
                                        score := score - tab[3];

                            score := score - tab[3+((i + 4) div 5)];

                            score := score - tab[14 + diagonales(plateau, i, 1)];

                            if pion_au_centre(i) then
                                score := score - tab[22] - tab[20]
                            else
                                score := score - tab[22]
                        end;

                    2 : if joueur_ref = 2 then 
                        begin
                            if bord_haut(i) then 
                                score := score + tab[1]
                            else 
                                if bord_bas(i) then
                                    score := score + tab[2]
                                else
                                    if bord_vertical(i) then
                                        score := score + tab[3];

                            score := score + tab[3+((i + 4) div 5)];

                            score := score + tab[14 + diagonales(plateau, i, 2)];

                            if pion_au_centre(i) then
                                score := score + tab[22] + tab[20]
                            else
                                score := score + tab[22]
                        end
                        else
                        begin
                            if bord_haut(i) then 
                                score := score - tab[1]
                            else 
                                if bord_bas(i) then
                                    score := score - tab[2]
                                else
                                    if bord_vertical(i) then
                                        score := score - tab[3];
                            
                            score := score - tab[3+((i + 4) div 5)];

                            score := score - tab[14 + diagonales(plateau, i, 2)];
                            
                            if pion_au_centre(i) then
                                score := score - tab[22] - tab[20]
                            else
                                score := score - tab[22]
                        end;

                    3 : if joueur_ref = 1 then
                        begin
                            if bord_bas(i) then 
                                score := score + tab[1]
                            else 
                                if bord_haut(i) then
                                    score := score + tab[2]
                                else
                                    if bord_vertical(i) then
                                        score := score + tab[3];
                            // writeln(4);
                            
                            score := score + tab[3+((i + 4) div 5)];

                            // writeln(5);
                            score := score + tab[14 + diagonales(plateau, i, 1)];

                            if pion_au_centre(i) then
                                score := score + tab[21] + tab[20]
                            else
                                score := score + tab[21]
                        end
                        else
                        begin
                            if bord_bas(i) then 
                                score := score - tab[1]
                            else 
                                if bord_haut(i) then
                                    score := score - tab[2]
                                else
                                    if bord_vertical(i) then
                                        score := score - tab[3];
                            
                            score := score - tab[3+((i + 4) div 5)];

                            score := score - tab[14 + diagonales(plateau, i, 1)];

                            if pion_au_centre(i) then
                                score := score - tab[21] - tab[20]
                            else
                                score := score - tab[21]
                        end;

                    4 : if joueur_ref = 2 then 
                        begin
                            if bord_haut(i) then 
                                score := score + tab[1]
                            else 
                                if bord_bas(i) then
                                    score := score + tab[2]
                                else
                                    if bord_vertical(i) then
                                        score := score + tab[3];
                            
                            score := score + tab[3+((i + 4) div 5)];

                            score := score + tab[14 + diagonales(plateau, i, 2)];

                            if pion_au_centre(i) then
                                score := score + tab[21] + tab[20]
                            else
                                score := score + tab[21]
                        end
                        else
                        begin
                            if bord_haut(i) then 
                                score := score - tab[1]
                            else 
                                if bord_bas(i) then
                                    score := score - tab[2]
                                else
                                    if bord_vertical(i) then
                                        score := score - tab[3];
                            
                            score := score - tab[3+((i + 4) div 5)];

                            score := score - tab[14 + diagonales(plateau, i, 2)];

                            if pion_au_centre(i) then
                                score := score - tab[21] - tab[20]
                            else
                                score := score - tab[21]
                        end;
                end;
            end;
        // writeln(2, ' ', score);
        cout_vcr1 := score;
        // writeln(cout_vcr1);
    end;
end.