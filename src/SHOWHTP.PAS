program show_htp;
{
Auteur: Patrick Premartin.
Date: 23/01/1992. (1.0)
Langage: Turbo Pascal 6.0

But: Slide permettant de voir les fichiers de pages ecran .HTP provenant de
     'Hyper Text Maker'. On passe le nom du fichier (r‚pertoire, et masques DOS
     accept‚s).
}
uses
    crt,
    dos,
    olf_software,
    u_code_clavier,
    u_m_util,
    u_parametre,
    u_htp;

const
     num_vers : string [3] = '1.0';
     dat_vers : string [10] = '23/01/1992';

var
   dir1 : dirstr;
   name : namestr;
   ext : extstr;
   dir0,
   nom : string;
   fich_type : searchrec;
   page : p_page;
   i,
   j : word;

begin
     init_licence ('show');
     init_olf_message (mess_careware);
     init_ligne_olf_software ('Show Hyper Text Page '+num_vers, '(c) Patrick Premartin '+dat_vers);
     if ((param_del ('/H')) or (paramcount = 0) or (param_del ('/?')))
     then
         begin
              writeln ('Syntax:');
              writeln ('       SHOWHTP [[path]file_name[.HTP]] [/H]');
              writeln;
              writeln ('Show you HTP files, they come from ''Hyper Text Maker''.');
              writeln ('You can use * and ? as jokers. Contact us...');
         end
     else
         if (paramcount > 0)
         then
             begin
                  fsplit (fexpand (paramstr (1)), dir1, name, ext);
                  nom := dir1+name+'.HTP';
                  getdir (0, dir0);
                  chdir (copy (dir1, 1, pred (length (dir1))));
                  findfirst (nom, archive, fich_type);
                  if (doserror <> 0)
                  then
                      alert ('No HTP files on this directory...', al_error);
                  {endif}
                  while (doserror = 0) do
                        begin
                             if confirm ('Show you: '+fich_type.name+' ?')
                             then
                                 begin
                                      page := htp_load (fich_type.name);
                                      clrscr;
                                      for i := 1 to max_lig do
                                          for j := 1 to max_col do
                                              write (page^.tab [i, j]);
                                          {endfor}
                                      {endfor}
                                      freemem (page, sizeof (page^));
                                      alert ('', al_wait);
                                 end;
                             {endif}
                             findnext (fich_type);
                        end;
                  {endwhile}
                  chdir (dir0);
             end;
         {endif}
     {endif}
end.
