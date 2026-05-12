
drop schema if exists parcoursup cascade;
create schema parcoursup;
set schema 'parcoursup';

create type type_bac as enum (
	'Bac général',
	'Bac technologique',
	'Bac professionnel',
	'Autres'
);

create type libelle_mention as enum(
	'Sans information',
	'Sans mention',
	'Assez bien',
	'Bien',
	'Très bien',
	'Très bien avec félicitations du jury'
);

drop table if exists _academie;
create table _academie(
	academie_nom varchar(30) primary key
);

drop table if exists _region;
create table _region(
	region_nom varchar(30) primary key
);

drop table if exists _etablissement;
create table _etablissement(
	etablissement_code_uai varchar(30) primary key,
	etablissement_nom varchar(30),
	etablissement_statut varchar(30)
);

drop table if exists _filiere;
create table _filiere(
	filiere_id int primary key,
	filiere_libelle varchar(30),
	filiere_libelle_tres_abrege varchar(30),
	filiere_libelle_abrege varchar(30),
	filiere_libelle_detaille_bis varchar(30)
);

drop table if exists _session;
create table _session(
	session_annee int primary key
);

drop table if exists _regroupement;
create table _regroupement(
	libelle_regroupement varchar(30) primary key
);

drop table if exists _type_bac;
create table _type_bac(
	type_bac type_bac primary key
);

drop table if exists _mention_bac;
create table _mention_bac(
	libelle_mention libelle_mention primary key
);

drop table if exists _departement;
create table _departement(
	departement_code varchar(30) primary key,
	departement_nom varchar(30),
	region_nom varchar(30) references _region(region_nom)
);

drop table if exists _commune;
create table _commune(
	commune_nom varchar(30) primary key,
	departement_code varchar(30) references _departement(departement_code) 	
);

drop table if exists _formation;
create table _formation(
	cod_aff_form varchar(30) primary key,
	filiere_libelle_detaille varchar(30),
	coordonnes_gps varchar(30),
	list_com varchar(30),
	concours_communs_banque_epreuvre varchar(30),
	url_formation varchar(30),
	tri varchar(30),
	academie_nom varchar(30) references _academie(academie_nom),
	filiere_id int references _filiere(filiere_id),
	etablissement_code_uai varchar(30) references _etablissement(etablissement_code_uai),
	commune_nom varchar(30) references _commune(commune_nom)
);

drop table if exists _admissions_selon_type_neo_bac;
create table _admissions_selon_type_neo_bac(
	effectif_candidat_neo_bac_classes int,
	cod_aff_form varchar(30) references _formation(cod_aff_form),
	type_bac type_bac references _type_bac(type_bac),
	session_annee int references _session(session_annee),
	constraint admissions_selon_type_neo_bac_PK primary key (cod_aff_form, type_bac, session_annee)
);

drop table if exists _effectif_selon_mention;
create table _effectif_selon_mention(
	effectif_admis_neo_bac_selon_mention int,
	libelle_mention libelle_mention references _mention_bac(libelle_mention),
	cod_aff_form varchar(30) references _formation(cod_aff_form),
	session_annee int references _session(session_annee),
	constraint effectif_selon_mention_PK primary key (libelle_mention, cod_aff_form, session_annee)
);

drop table if exists _admissions_generalites;
create table _admissions_generalites(
	selectivite varchar(30),
	capacite int,
	effectif_total_candidats int,
	effectif_total_candidates int,
	session_annee int references _session(session_annee),
	cod_aff_form varchar(30) references _formation(cod_aff_form),
	constraint admissions_generalites_PK primary key (session_annee, cod_aff_form)
);

drop table if exists _rang_dernier_appele_selon_regroupement;
create table _rang_dernier_appele_selon_regroupement(
	rang_dernier_appele int,
	libelle_regroupement varchar(30) references _regroupement(libelle_regroupement),
	session_annee int references _session(session_annee),
	cod_aff_form varchar(30) references _formation(cod_aff_form),
	constraint rang_dernier_appele_selon_regroupement_PK primary key (libelle_regroupement, session_annee, cod_aff_form)
)