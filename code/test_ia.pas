program test_ia;
{$S-}
{$R projet.res}
{$mode ObjFPC}
uses ia_raphael, sysutils, crt, TypeSdl, sdl, sdl_image, sdl_ttf, sdl_mixer, init, strutils, classes;

    procedure test_bordure();
    var i, nb_bords : integer;
    begin
        nb_bords := 0;
        for i := 1 to 50 do
        begin
            // writeln(i, ' ', bordure(i));
            if bordure(i) then
                nb_bords := nb_bords + 1
        end;
        writeln(#10,'Test bordure : (1)');
        write('Nombre de bords : ');
        if nb_bords <> 18 then
            writeln('KO')
        else
            writeln('OK');
        write(#10)
    end;
//commentaires
    // procedure test_ensemble_pions();
    // var plateau : plateau_jeu;
    //     i, j, nb_pions, nb_aleatoire, nb_aleatoire_2, nb_pions_crees, pions_blancs, pions_noirs : integer;
    //     booleen_verif : boolean;
    //     enum_pions_blancs, enum_pions_noirs : enum_cases;
    // begin
    //     randomize;
    //     for i := 1 to 50 do 
    //         plateau[i] := 0;
    //     writeln(#10,'Tests ensemble_pions ');
    //     writeln('Test nb_pions : (4)');

    //     ensemble_pions(plateau, 1, nb_pions);
    //     write('0 Pions : ');
    //     if nb_pions = 0 then writeln('OK') else writeln('KO');

    //     booleen_verif := true;
    //     for j := 1 to 10000 do
    //     begin
    //         for i := 1 to 50 do 
    //             plateau[i] := 0;
    //         nb_aleatoire := random(50) + 1;
    //         nb_pions_crees := nb_aleatoire;
    //         while nb_aleatoire <> 0 do
    //         begin
    //             nb_aleatoire_2 := random(50) + 1;
    //             if plateau[nb_aleatoire_2] = 0 then 
    //             begin
    //                 plateau[nb_aleatoire_2] := 1;
    //                 nb_aleatoire := nb_aleatoire - 1;
    //             end;
    //         end;
    //         ensemble_pions(plateau, 1, nb_pions);
    //         if nb_pions <> nb_pions_crees then 
    //             booleen_verif := false
    //     end;
    //     write('Nombre aleatoire de pions : ');
    //     if booleen_verif then 
    //     begin 
    //         writeln('OK');
    //     end
    //     else writeln('KO');

    //     for i := 1 to 50 do 
    //             plateau[i] := 1;
    //     ensemble_pions(plateau, 1, nb_pions);
    //     write('50 Pions : ');
    //     if nb_pions = 50 then
    //         writeln('OK')
    //     else
    //         writeln('KO');

    //     booleen_verif := true;
    //     for j := 1 to 10000 do
    //     begin
    //         for i := 1 to 50 do 
    //             plateau[i] := 0;
    //         pions_blancs := 0;
    //         pions_noirs := 0;
    //         nb_aleatoire := random(50) + 1;
    //         while nb_aleatoire <> 0 do
    //         begin
    //             nb_aleatoire_2 := random(50) + 1;
    //             if plateau[nb_aleatoire_2] = 0 then 
    //             begin
    //                 nb_aleatoire := nb_aleatoire - 1;
    //                 if random(2) = 0 then
    //                 begin
    //                     plateau[nb_aleatoire_2] := 1;
    //                     pions_blancs := pions_blancs + 1;
    //                 end
    //                 else
    //                 begin
    //                     plateau[nb_aleatoire_2] := 2;
    //                     pions_noirs := pions_noirs + 1;
    //                 end;
    //             end;
    //         end;
    //         ensemble_pions(plateau, 1, nb_pions);
    //         if nb_pions <> pions_blancs then 
    //             booleen_verif := false;
    //         ensemble_pions(plateau, 2, nb_pions);
    //         if nb_pions <> pions_noirs then 
    //             booleen_verif := false;
    //     end;
    //     write('Nombre aleatoire de pions differents : ');
    //     if booleen_verif then 
    //     begin 
    //         writeln('OK');
    //     end
    //     else writeln('KO');


    //     writeln('Tests position des pions : (1)');

    //     booleen_verif := true;
    //     for j := 1 to 10000 do
    //     begin
    //         for i := 1 to 50 do 
    //             plateau[i] := 0;
    //         enum_pions_blancs := [];
    //         enum_pions_noirs := [];
    //         nb_aleatoire := random(50) + 1;
    //         while nb_aleatoire <> 0 do
    //         begin
    //             nb_aleatoire_2 := random(50) + 1;
    //             if plateau[nb_aleatoire_2] = 0 then 
    //             begin
    //                 nb_aleatoire := nb_aleatoire - 1;
    //                 if random(2) = 0 then
    //                 begin
    //                     plateau[nb_aleatoire_2] := 1;
    //                     enum_pions_blancs := enum_pions_blancs + [nb_aleatoire_2];
    //                 end
    //                 else
    //                 begin
    //                     plateau[nb_aleatoire_2] := 2;
    //                     enum_pions_noirs := enum_pions_noirs + [nb_aleatoire_2];
    //                 end;
    //             end;
    //         end;
    //         if ensemble_pions(plateau, 1, nb_pions) <> enum_pions_blancs then 
    //             booleen_verif := false;
    //         if ensemble_pions(plateau, 2, nb_pions) <> enum_pions_noirs then 
    //             booleen_verif := false;
    //     end;
    //     write('Enumerations aleatoire de pions differents : ');
    //     if booleen_verif then 
    //     begin 
    //         writeln('OK');
    //     end
    //     else writeln('KO');

    //     // for i := 1 to 50 do write(i,':',plateau[i],', ');
    //     // writeln();
    //     // for i in ensemble_pions(plateau, 1, nb_pions) do write(i,', ');
    //     // writeln();
    //     // for i in ensemble_pions(plateau, 2, nb_pions) do write(i,', ');

    //     write(#10)
    // end;

    // procedure affiche_cases_sous_control();
    // var plateau : plateau_jeu;
    //     i, nb_aleatoire, nb_aleatoire_2, nb_pions_1, nb_pions_2, nb_cases_sous_control_1, nb_cases_sous_control_2, x, y : integer;
    // begin
    //     randomize;
    //     for i := 1 to 20 do
    //         writeln();
    //     for i := 1 to 50 do
    //     begin
    //         textbackground(white);
    //         x := ((i-1) mod 5)*4 + 100;
    //         y := 11 - ((i-1) div 5);
    //         if ((x+y) mod 2) = 0 then x := x + 2;
    //         gotoxy(x, y);
    //         write('  ');

    //         textbackground(black);
    //     end;

    //     for i := 1 to 50 do 
    //         plateau[i] := 0;
    //     nb_aleatoire := random(50) + 1;
    //     while nb_aleatoire <> 0 do
    //     begin
    //         nb_aleatoire_2 := random(50) + 1;
    //         if plateau[nb_aleatoire_2] = 0 then 
    //         begin
    //             nb_aleatoire := nb_aleatoire - 1;
    //             if random(2) = 0 then
    //                 plateau[nb_aleatoire_2] := 1
    //             else
    //                 plateau[nb_aleatoire_2] := 2
    //         end
    //     end;

    //     for i in cases_sous_control(plateau, 1, ensemble_pions(plateau, 1, nb_pions_1), nb_cases_sous_control_1)-ensemble_pions(plateau, 1, nb_pions_1)-cases_sous_control(plateau, 2, ensemble_pions(plateau, 2, nb_pions_2), nb_cases_sous_control_2)-ensemble_pions(plateau, 2, nb_pions_2) do 
    //     begin
    //         textbackground(blue);
            
    //         x := ((i-1) mod 5)*4 + 100;
    //         y := 11 - ((i-1) div 5);
    //         if ((x+y) mod 2) = 0 then x := x + 2;
    //         gotoxy(x, y);
    //         write('  ');

    //         textbackground(black);
    //     end;

    //     for i in ensemble_pions(plateau, 1, nb_pions_1) do 
    //     begin
    //         textbackground(yellow);
            
    //         x := ((i-1) mod 5)*4 + 100;
    //         y := 11 - ((i-1) div 5);
    //         if ((x+y) mod 2) = 0 then x := x + 2;
    //         gotoxy(x, y);
    //         write('  ');

    //         textbackground(black);
    //     end;

    //     for i in cases_sous_control(plateau, 2, ensemble_pions(plateau, 2, nb_pions_2), nb_cases_sous_control_2)-ensemble_pions(plateau, 2, nb_pions_2)-cases_sous_control(plateau, 1, ensemble_pions(plateau, 1, nb_pions_1), nb_cases_sous_control_1)-ensemble_pions(plateau, 1, nb_pions_1) do 
    //     begin
    //         textbackground(green);
            
    //         x := ((i-1) mod 5)*4 + 100;
    //         y := 11 - ((i-1) div 5);
    //         if ((x+y) mod 2) = 0 then x := x + 2;
    //         gotoxy(x, y);
    //         write('  ');

    //         textbackground(black);
    //     end;

    //     for i in ensemble_pions(plateau, 2, nb_pions_2) do 
    //     begin
    //         textbackground(red);
            
    //         x := ((i-1) mod 5)*4 + 100;
    //         y := 11 - ((i-1) div 5);
    //         if ((x+y) mod 2) = 0 then x := x + 2;
    //         gotoxy(x, y);
    //         write('  ');

    //         textbackground(black);
    //     end;

    // end;

    

var i, x, y : integer;
    j, k : longint;
    bin : string;

begin
    // j := 2147483647;
    // writeln((j+1));
    // j := j+1;    
    // writeln(j);
    // k := 1;
    // while j < k do 
    // begin 
    //     j := j+1;
    //     k := j+1;
    // end;
    // writeln(j);

    // j := 2139651655;
    // bin := binstr(j, 32);
    // setlength(bin, 16);
    // writeln(strtoint('%'+bin));
    // writeln(%11111111111111111111);
    bin := '';
    while bin = '' do
    begin
        try
            clrscr;
            evaluation_remplissage_tableau_transposition('vr3++', false, false);
        except
            writeln('Erreur tableau de transposition');
        end;
        try
            variance_evo;
        except
            writeln('Erreur variance evo');
        end;
        try
            affichage_data('jurassic');
        except
            writeln('Erreur jurassic');
        end;
        try
            affichage_data('cretace');
        except
            writeln('Erreur cretace');
        end;
        try
            affichage_data('trias');
        except
            writeln('Erreur trias');
        end;
        try
            affichage_data('mesozoique');
        except
            writeln('Erreur mesozoique');
        end;
        try
            affichage_data('paleozoique');
        except
            writeln('Erreur paleozoique');
        end;
        try
            writeln('');
            write('Entrer pour actualiser');
            readln(bin);
        except
        end;
    end;
    
    // j := -99;
    // writeln(j mod 99);

    // test_bordure;
    // test_ensemble_pions;
    // affiche_cases_sous_control;
    // for i := 1 to 3 do
    //     writeln();
    // match_ia(@ia_raphael_v2, @ia_raphael_v2, 1000, false, true);
    // tournoi_ia('essai_tournoi_1', 99, false, false);
    
end.
    
