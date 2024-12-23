program show_pi1;
{
Auteur: Patrick Premartin.
Date: 30/11/1991. (1.0)
      24/06/1992. (1.1)
      25/06/1992.
Langage: Turbo Pascal 6.0

But: Slide permettant de consulter les images au format .PI1
     On passe le nom du fichier (r‚pertoire, et masques DOS accept‚s).
}
uses
    crt,
    dos,
    olf_software,
    u_code_clavier,
    u_m_util,
    u_parametre,
    u_picture;

const
     num_vers : string [3] = '1.1';
     dat_vers : string [10] = '06/25/1992';

var
   dir1 : dirstr;
   name : namestr;
   ext : extstr;
   dir0,
   nom : string;
   fich_type : searchrec;

procedure mode_texte;
begin
     directvideo := true;
     asm
        push ax
        mov ah, 0
        mov al, 3
        int 10h
        pop ax
     end;
end; { Mode_Texte }

procedure mode_graphique;
begin
     directvideo := false;
     asm
        push ax
        mov ah, 0
        mov al, 13h
        int 10h
        pop ax
     end;
end; { Mode_Graphique }

procedure lit_image (nom : string);
var
   fichier : file of t_pi1;
   image : p_pi1;
   mask,
   coul,
   i,
   j,
   k,
   l,
   x,
   y : integer;
begin
     coul_min := 48-coul_min;
     new (image);
     assign (fichier, nom);
     reset (fichier);
     read (fichier, image^);
     close (fichier);
     palette_adapte (image^.palette);
     affiche_image (image^.image);

{ Transformation de la palette. }
     dispose (image);
end; { lit_image }

begin
     init_licence ('show');
     init_olf_message (mess_careware);
     init_ligne_olf_software ('Show PI1 files '+num_vers, '(c) Patrick Premartin '+dat_vers);
     coul_min := 16;
     if ((param_del ('/H')) or (paramcount = 0) or (param_del ('/?')))
     then
         begin
              writeln ('Syntax:');
              writeln ('       SHOWPI1 [[path]file_name[.PI1]] [/H|/?]');
              writeln;
              writeln ('This program display .PI1 picture from Atari Computer.');
              writeln;
              writeln ('Only use VGA or upper card...');
         end
     else
         if (paramcount > 0)
         then
             begin
                  fsplit (fexpand (paramstr (1)), dir1, name, ext);
                  nom := dir1+name+'.PI1';
                  getdir (0, dir0);
                  chdir (copy (dir1, 1, pred (length (dir1))));
                  findfirst (nom, archive, fich_type);
                  if (doserror = 0)
                  then
                      mode_graphique
                  else
                      alert ('No PI1 files on this directory...', al_error);
                  {endif}
                  while (doserror = 0) do
                        begin
                             if confirm ('Show you: '+fich_type.name+' ?')
                             then
                                 begin
                                      lit_image (fich_type.name);
                                      alert (fich_type.name, al_nothing);
                                 end;
                             {endif}
                             findnext (fich_type);
                        end;
                  {endwhile}
                  chdir (dir0);
                  mode_texte;
             end;
         {endif}
     {endif}
end.
