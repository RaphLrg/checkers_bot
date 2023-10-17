program synthese;
{$S-}
{$R res_synthese.res}
{$mode ObjFPC}
uses TypeSdl, init, crt, sysutils, ia_raphael, math;
var data_poids : type_data_poids;
    i, j, nb_total_ia, numero_ia_1, numero_ia_2 : integer;
    nb_victoire_1, nb_victoire_2, nb_egalite : longint;
    tab_victoire : array[1..100,1..2] of integer;
    tab_survivant : array[1..2,1..2] of integer;
    fichier_data : file of type_data_poids;
    tab_data : array[1..10] of type_data_poids;
    tab_nom : array[1..5] of string;
    sortie : boolean;
    ia : type_ia_evo;
    tab_indice_nom : array[1..10] of integer;
    indice_selection : array[1..2] of integer;

begin
    nb_total_ia := 10;

    ia := @ia_raphael_v6_1;

    nb_victoire_1 := 0;
    nb_victoire_2 := 0;
    nb_egalite := 0;

    tab_nom[1] := 'jurassic';
    tab_nom[2] := 'cretace';
    tab_nom[3] := 'trias';
    tab_nom[4] := 'mesozoique';
    tab_nom[5] := 'paleozoique';

    for i := 1 to 5 do
    begin
        tab_indice_nom[(i*2)-1] := i;
        tab_indice_nom[i*2] := i;
    end;
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

    for numero_ia_1 := 1 to nb_total_ia - 1 do
        for numero_ia_2 := numero_ia_1 + 1 to nb_total_ia do
        begin
            // writeln(0.1:1:1);
            match_ia_synthese(ia, ia, 100, inttostr(((numero_ia_1 + 1) mod 2)*5 + 1), inttostr(((numero_ia_2 + 1) mod 2)*5 + 1), tab_nom[tab_indice_nom[numero_ia_1]], tab_nom[tab_indice_nom[numero_ia_2]], nb_victoire_1, nb_victoire_2, nb_egalite);
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
    indice_selection[1] := 1;
    indice_selection[2] := 2;

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
                    indice_selection[2] := indice_selection[1];
                end;
                tab_survivant[j,1] := tab_victoire[i,1];
                tab_survivant[j,2] := tab_victoire[i,2];
                indice_selection[j] := i;
                sortie := true;
            end
            else
                if (tab_survivant[j,1] = tab_victoire[i,1]) and (tab_survivant[j,2] < tab_victoire[i,2]) then
                begin
                    if j = 1 then
                    begin
                        tab_survivant[2,1] := tab_survivant[1,1];
                        tab_survivant[2,2] := tab_survivant[1,2];
                        indice_selection[2] := indice_selection[1];
                    end;
                    tab_survivant[j,1] := tab_victoire[i,1];
                    tab_survivant[j,2] := tab_victoire[i,2];
                    indice_selection[j] := i;
                    sortie := true;
                end
                else
                    if (tab_survivant[j,1] = tab_victoire[i,1]) and (tab_survivant[j,2] = tab_victoire[i,2]) and (random(2) = 1) then
                    begin
                        if j = 1 then
                        begin
                            tab_survivant[2,1] := tab_survivant[1,1];
                            tab_survivant[2,2] := tab_survivant[1,2];
                            indice_selection[2] := indice_selection[1];
                        end;
                        tab_survivant[j,1] := tab_victoire[i,1];
                        tab_survivant[j,2] := tab_victoire[i,2];
                        indice_selection[j] := i;
                        sortie := true;
                    end;
            j := j + 1;
        until sortie or (j > 2);
    end;

    writeln('Vainqueur : ',indice_selection[1]);
        for j := 1 to 24 do
        begin
            if j < 23 then
            begin
                if abs(tab_data[indice_selection[1]].tab[j]) = tab_data[indice_selection[1]].tab[j] then 
                    write(' ');
                if abs(tab_data[indice_selection[1]].tab[j]) < 10 then 
                    write('  ') 
                else
                    if abs(tab_data[indice_selection[1]].tab[j]) < 100 then 
                        write(' ');
                write(tab_data[indice_selection[1]].tab[j],'  ');
            end
            else
                if j = 23 then
                begin
                    if abs(tab_data[indice_selection[1]].debut_alpha) = tab_data[indice_selection[1]].debut_alpha then 
                        write(' ');
                    if abs(tab_data[indice_selection[1]].debut_alpha) < 10 then 
                        write('    ')
                    else
                        if abs(tab_data[indice_selection[1]].debut_alpha) < 100 then 
                            write('   ')
                        else
                            if abs(tab_data[indice_selection[1]].debut_alpha) < 1000 then 
                                write('  ')
                            else
                                if abs(tab_data[indice_selection[1]].debut_alpha) < 10000 then 
                                    write(' ');
                    write(tab_data[indice_selection[1]].debut_alpha,'  ');
                end
                else
                begin
                    if abs(tab_data[indice_selection[1]].debut_beta) = tab_data[indice_selection[1]].debut_beta then 
                        write(' ');
                    if abs(tab_data[indice_selection[1]].debut_beta) < 10 then 
                        write('    ')
                    else
                        if abs(tab_data[indice_selection[1]].debut_beta) < 100 then 
                            write('   ')
                        else
                            if abs(tab_data[indice_selection[1]].debut_beta) < 1000 then 
                                write('  ')
                            else
                                if abs(tab_data[indice_selection[1]].debut_beta) < 10000 then 
                                    write(' ');
                    write(tab_data[indice_selection[1]].debut_beta,'  ');
                end;
        end;
    read(tab_nom[1]);
end.