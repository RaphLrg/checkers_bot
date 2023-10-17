{$R evo_4.res}
{$mode ObjFPC}

program evolution_4;

uses init, manger, TypeSdl, ia_raphael, sysutils, strutils, math, crt;

const   MAX_GENERATION = 10000;
        NOMBRE_IA_ALEA = 1;
        NOMBRE_IA_FILLE = 10;
        

var tab_data, new_tab_data : type_tab_data;
    fichier_data, fichier_retour : file of type_data_poids;
    fichier_generation : file of integer;
    nom_monde : string;
    i, j, k, nb_fichier, nb_generation, numero_ia_1, numero_ia_2, nb_victoire_1, nb_victoire_2, nb_egalite : integer;
    ia : type_ia_evo;
    tab_victoire : array[1..NOMBRE_IA_ALEA+NOMBRE_IA_FILLE,1..2] of integer;
    survivant : type_selection;
    fin : boolean;

begin
    randomize;
    // write('Veuillez entrer le nom de l''univers d''evolution : ');
    nom_monde := 'mesozoique';
    // readln(nom_monde);
    if not directoryExists('Ressources/ressources_raphael/darwin/'+ nom_monde) then
    begin
        createdir('Ressources/ressources_raphael/darwin/'+ nom_monde);
        createdir('Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/');
        tab_data := init_tab_data(NOMBRE_IA_ALEA + NOMBRE_IA_FILLE, nom_monde, true);
    end
    else
    begin
        for i := 1 to NOMBRE_IA_ALEA + NOMBRE_IA_FILLE do 
        begin
            if fileExists('Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi') then
            begin
                assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi');
                reset(fichier_data);
                read(fichier_data, tab_data[i]);
                close(fichier_data);
            end
            else
            begin
                tab_data[i] := init_data_poids;
                assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/dataset_'+ inttostr(i) +'.poi');
                rewrite(fichier_data);
                write(fichier_data, tab_data[i]);
                close(fichier_data);
            end;

            if not fileExists('Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/dataset_'+ inttostr(i) +'.poi') then
            begin
                assign(fichier_data, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/dataset_'+ inttostr(i) +'.poi');
                rewrite(fichier_data);
                write(fichier_data, tab_data[i]);
                close(fichier_data);
            end;
        end;
    end;
    
    ia := @ia_raphael_v6;

    survivant[1] := 0;
    survivant[2] := 0;
    fin := false;
    while (nb_generation <= MAX_GENERATION) and (not fin) do
    begin
        assign(fichier_generation, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/nb_generation.int');
        if not fileExists('Ressources/ressources_raphael/darwin/'+ nom_monde +'/nb_generation.int') then
        begin
            nb_generation := 1;
            rewrite(fichier_generation);
            write(fichier_generation, nb_generation);
            close(fichier_generation); 
        end
        else
            if (survivant[1] = 0) or (survivant[2] = 0) then
            begin
                reset(fichier_generation);
                read(fichier_generation, nb_generation);
                close(fichier_generation); 
            end
            else
            begin
                rewrite(fichier_generation);
                write(fichier_generation, nb_generation);
                close(fichier_generation); 
            end;

        assign(fichier_generation, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/rapport/nb_generation.int');
        rewrite(fichier_generation);
        write(fichier_generation, nb_generation);
        close(fichier_generation);

        clrscr;
        writeln('Generation ',nb_generation, ', survivant : ', survivant[1], ' et ', survivant[2]);

        survivant := selection(@ia_raphael_v6, nom_monde);

        tab_data := heredite_v2(survivant, tab_data, 10, 1, nom_monde);

        // writeln(4);
        nb_generation := nb_generation + 1;

        // fin := true;
        // for i := 1 to 2 do
        //     with tab_data[survivant[i]] do
        //         for j := 1 to 24 do
        //             if tab_mutation[j] <> 0 then
        //                 fin := false;
        // fin := false;
        // try
        //     clrscr;
        //     affichage_data('cretace');
        // except
        // end;
        // delay(1000);
    end;

    createdir('Ressources/ressources_raphael/darwin/'+ nom_monde +'/Resultats');
    for i := 1 to 2 do
    begin
        assign(fichier_retour, 'Ressources/ressources_raphael/darwin/'+ nom_monde +'/Resultats/survivant_'+ inttostr(i) +'.poi');
        rewrite(fichier_retour);
        write(fichier_retour, tab_data[survivant[i]]);
        close(fichier_retour);
    end;
end.