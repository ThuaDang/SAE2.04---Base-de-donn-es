set schema 'parcoursup2';

drop view if exists _etude_statistique;
create view _etude_statistique as
select
    a.cod_aff_form               as code_formation,
    a.capacite                   as x1_capacite,
    a.effectif_total_candidats   as x2_candidats,
    a.effectif_total_candidates  as x3_candidates,
    coalesce(m.total_admis, 0)   as y_total_admis                       -- coalesce pour gérer les valeurs nulles, on mets à 0 si aucune valeur.
from _admissions_generalites a              
left join (                                                             -- left join pour inclure toutes les formations même si elles n'ont pas d'admis.    
    select cod_aff_form, session_annee, 
           sum(effectif_admis_neo_bac_selon_mention) as total_admis
    from _effectif_selon_mention
    group by cod_aff_form, session_annee
) m on  m.cod_aff_form  = a.cod_aff_form
    and m.session_annee = a.session_annee
    limit 20;

select * from _etude_statistique;


-- Export de la vue en csv 
WbExport -file=etude_statistique.csv
         -outputDir=.
         -type=text
         -sourceTable=_etude_statistique
         -schema=parcoursup2
         -delimiter=';'
         -header=true
         -keyColumns=No_Dossier,formation
         -dateFormat='d/M/y'
         -timestampFormat='d/M/y H:m:s'
         ;
