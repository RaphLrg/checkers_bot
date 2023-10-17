program entrainement;

uses ia_raphael, init, typesdl, sysutils, math;

{$Q+}
{$S+}

function recherche_meilleur_parametre(ia_temoin, ia_eleve : type_ia; parametre : pinteger; borne_mini, borne_maxi, nb_parties : integer):integer;
const   pas_maxi = 30;
        Dilution = 4;

var ecart_bornes, ecart_essai, nb_essai, essai_effectues, nb_victoire_temoin, nb_victoire_eleve, nb_boucle, max_boucle : integer;
    tableau_victoires, valeurs_essai : array[1..pas_maxi] of integer;
    indices_retenus, valeurs_maxi : array[1..2] of integer;
    nb_tours_total : longint;

begin
    if borne_maxi > borne_mini then
    begin
        nb_boucle := 0;
        max_boucle := borne_maxi - borne_mini;
        ecart_bornes := borne_maxi - borne_mini;
        repeat
            nb_boucle := nb_boucle + 1;

            if ecart_bornes >= (pas_maxi - 1) then
                nb_essai := pas_maxi - 1
            else
                nb_essai := ecart_bornes;
            
            ecart_essai := ecart_bornes div nb_essai;
            
            if ecart_bornes mod nb_essai <> 0 then
                nb_essai := nb_essai + 1;

            for essai_effectues := 1 to pas_maxi do 
            begin
                tableau_victoires[essai_effectues] := - nb_parties;
                valeurs_essai[essai_effectues] := 0;
            end;
            
            valeurs_essai[1] := borne_mini;

            for essai_effectues := 2 to nb_essai do
                valeurs_essai[essai_effectues] := valeurs_essai[essai_effectues - 1] + ecart_essai;

            if valeurs_essai[nb_essai] > borne_maxi then
                valeurs_essai[nb_essai] := borne_maxi;
            
            essai_effectues := 0;

            while (nb_essai - essai_effectues) > 0 do
            begin
                essai_effectues := essai_effectues + 1;

                parametre^ := valeurs_essai[essai_effectues];

                writeln('Match ', essai_effectues, ', Boucle ', nb_boucle, ' param_test = ', parametre^);

                match_ia(ia_temoin, ia_eleve, nb_parties, 0, false, false, false, nb_victoire_temoin, nb_victoire_eleve, nb_tours_total);

                writeln('Difference de victoire (test - temoin) = ', nb_victoire_eleve - nb_victoire_temoin);

                tableau_victoires[essai_effectues] := nb_victoire_eleve - nb_victoire_temoin;

            end;

            for essai_effectues := 1 to 2 do
            begin
                valeurs_maxi[essai_effectues] := - nb_parties;
                indices_retenus[essai_effectues] := 1;
            end;

            for essai_effectues := 1 to nb_essai do
                if tableau_victoires[essai_effectues] >= valeurs_maxi[1] then
                begin
                    valeurs_maxi[1] := tableau_victoires[essai_effectues];
                    indices_retenus[1] := essai_effectues;
                end
                else
                    if tableau_victoires[essai_effectues] > valeurs_maxi[2] then
                    begin
                        valeurs_maxi[2] := tableau_victoires[essai_effectues];
                        indices_retenus[2] := essai_effectues;
                    end;

            borne_mini := round(((Dilution - 1)*min(valeurs_essai[indices_retenus[1]], valeurs_essai[indices_retenus[2]]) + borne_mini) / Dilution);
            borne_maxi := round(((Dilution - 1)*max(valeurs_essai[indices_retenus[1]], valeurs_essai[indices_retenus[2]]) + borne_maxi) / Dilution);

            ecart_bornes := borne_maxi - borne_mini;
        until (ecart_bornes < 3) or (nb_boucle >= max_boucle);

        recherche_meilleur_parametre := borne_mini;
    end
    else
        recherche_meilleur_parametre := -30000;
end;

var meilleure_valeur : integer;

begin
    param_pion_1 := 50;
	param_pion_2 := 100;//100;
	param_1 := 200;
    param_2 := 5570;//5570;
    param_3 := 0;
    param_4 := 0;
    param_5 := 1;
    param_6 := -20;//-20;
	param_1_2 := 190;
	param_pion_1_2 := 40;
	max_tri := 2;
	profondeur_ia_6 := 3;
    debut_alpha := 11;
    debut_beta := 136;
    param_case_autour := 1;

    meilleure_valeur := recherche_meilleur_parametre(@ia_raphael_vr3t, @ia_raphael_vr3, @debut_alpha, -1000, 200, 100);
    writeln('La meilleure valeur semble etre : ', meilleure_valeur);

end.