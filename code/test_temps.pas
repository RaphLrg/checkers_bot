{$mode ObjFPC}
program test_temps;

uses sysutils, TypeSdl, crt;

type type_table_transposition = record 
    profondeur : shortint;
    alpha, beta : integer;
    hash_verif : longint;
end;     

type type_tableau_table_transposition = array[-32768..32767] of type_table_transposition;

type type_test_tab_p_table = array[-134217728..134217727] of ^type_tableau_table_transposition;

type type_test = array[-134217728..134217727] of integer;
    
type type_tab_p_table = array[-1028..1027] of ^type_tableau_table_transposition;


var i, j : longint;
    t_1, t_2 : TSystemTime;
    tab_p, tab_2 : type_tab_p_table;
    tab_table_t : type_tableau_table_transposition;
    fichier_sortie : file of type_tab_p_table;
    tab_int : array[-32768..32767] of longint;

begin
    DateTimeToSystemTime(Now,t_1);
    for j := 1 to 1000 do
    for i := -32768 to 32767 do
        with tab_table_t[i] do
        begin
            alpha := 1;
            beta := 2;
            profondeur := 7;
            hash_verif := 4;
        end;
    DateTimeToSystemTime(Now,t_2);
    
        // tab_int[i] := i;
    i := - 1028;
    // while i <= 1027 do
    // begin
    //     tab_p[i] := @tab_table_t;
    //     i := i + 1;
    // end;
    assign(fichier_sortie, 'Ressources/ressources_raphael/test/essai_1.tst');
    reset(fichier_sortie);
    read(fichier_sortie, tab_2);
    writeln('ok');
    // for i := -256 to 255 do
    try
        writeln('1 ',tab_2[1]^[-20].profondeur,'.');
    except
        on E : EAccessViolation do
            writeln('EAccessViolation');
    end;
    // writeln('2 ',tab_p[1]^[-20].profondeur,'.');
    // rewrite(fichier_sortie);
    // write(fichier_sortie, tab_p);
    close(fichier_sortie);
    writeln('temps : ',diffTemps(t_2, t_1));
end.