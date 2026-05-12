DROP SCHEMA IF EXISTS parcoursup CASCADE;
CREATE SCHEMA parcoursup;
SET SCHEMA 'parcoursup';

CREATE TYPE type_bac AS ENUM (
	'Bac général',
	'Bac technologique',
	'Bac professionnel',
	'Autres'
);

CREATE TYPE libelle_mention AS ENUM(
	'Sans information',
	'Sans mention',
	'Assez bien',
	'Bien',
	'Très bien',
	'Très bien avec félicitations du jury'
);

DROP TABLE IF EXISTS _academie;
CREATE TABLE _academie(
	academie_nom VARCHAR(30) PRIMARY KEY
);

DROP TABLE IF EXISTS _region;
CREATE TABLE _region(
	region_nom VARCHAR(30) PRIMARY KEY
);

DROP TABLE IF EXISTS _etablissement;
CREATE TABLE _etablissement(
	etablissement_code_uai VARCHAR(30) PRIMARY KEY,
	etablissement_nom VARCHAR(30),
	etablissement_statut VARCHAR(30)
);

DROP TABLE IF EXISTS _filiere;
CREATE TABLE _filiere(
	filiere_id INT PRIMARY KEY,
	filiere_libelle VARCHAR(30),
	filiere_libelle_tres_abrege VARCHAR(30),
	filiere_libelle_abrege VARCHAR(30),
	filiere_libelle_detaille_bis VARCHAR(30)
);

DROP TABLE IF EXISTS _session;
CREATE TABLE _session(
	session_annee INT PRIMARY KEY
);

DROP TABLE IF EXISTS _regroupement;
CREATE TABLE _regroupement(
	libelle_regroupement VARCHAR(30) PRIMARY KEY
);

DROP TABLE IF EXISTS _type_bac;
CREATE TABLE _type_bac(
	type_bac type_bac PRIMARY KEY
);

DROP TABLE IF EXISTS _mention_bac;
CREATE TABLE _mention_bac(
	libelle_mention libelle_mention PRIMARY KEY
);

DROP TABLE IF EXISTS _departement;
CREATE TABLE _departement(
	departement_code VARCHAR(30) PRIMARY KEY,
	departement_nom VARCHAR(30),
	region_nom VARCHAR(30) REFERENCES _region(region_nom)
);

DROP TABLE IF EXISTS _commune;
CREATE TABLE _commune(
	commune_nom VARCHAR(30) PRIMARY KEY,
	departement_code VARCHAR(30) REFERENCES _departement(departement_code) 	
);

DROP TABLE IF EXISTS _formation;
CREATE TABLE _formation(
	cod_aff_form VARCHAR(30) PRIMARY KEY,
	filiere_libelle_detaille VARCHAR(30),
	coordonnes_gps VARCHAR(30),
	list_com VARCHAR(30),
	concours_communs_banque_epreuvre VARCHAR(30),
	url_formation VARCHAR(30),
	tri VARCHAR(30),
	academie_nom VARCHAR(30) REFERENCES _academie(academie_nom),
	filiere_id INT REFERENCES _filiere(filiere_id),
	etablissement_code_uai VARCHAR(30) REFERENCES _etablissement(etablissement_code_uai),
	commune_nom VARCHAR(30) REFERENCES _commune(commune_nom)
);

DROP TABLE IF EXISTS _admissions_selon_type_neo_bac;
CREATE TABLE _admissions_selon_type_neo_bac(
	effectif_candidat_neo_bac_classes INT,
	cod_aff_form VARCHAR(30) REFERENCES _formation(cod_aff_form),
	type_bac type_bac REFERENCES _type_bac(type_bac),
	session_annee INT REFERENCES _session(session_annee),
	CONSTRAINT admissions_selon_type_neo_bac_PK PRIMARY KEY (cod_aff_form, type_bac, session_annee)
);

DROP TABLE IF EXISTS _effectif_selon_mention;
CREATE TABLE _effectif_selon_mention(
	effectif_admis_neo_bac_selon_mention INT,
	libelle_mention libelle_mention REFERENCES _mention_bac(libelle_mention),
	cod_aff_form VARCHAR(30) REFERENCES _formation(cod_aff_form),
	session_annee INT REFERENCES _session(session_annee),
	CONSTRAINT effectif_selon_mention_PK PRIMARY KEY (libelle_mention, cod_aff_form, session_annee)
);

DROP TABLE IF EXISTS _admissions_generalites;
CREATE TABLE _admissions_generalites(
	selectivite VARCHAR(30),
	capacite INT,
	effectif_total_candidats INT,
	effectif_total_candidates INT,
	session_annee INT REFERENCES _session(session_annee),
	cod_aff_form VARCHAR(30) REFERENCES _formation(cod_aff_form),
	CONSTRAINT admissions_generalites_PK PRIMARY KEY (session_annee, cod_aff_form)
);

DROP TABLE IF EXISTS _rang_dernier_appele_selon_regroupement;
CREATE TABLE _rang_dernier_appele_selon_regroupement(
	rang_dernier_appele INT,
	libelle_regroupement VARCHAR(30) REFERENCES _regroupement(libelle_regroupement),
	session_annee INT REFERENCES _session(session_annee),
	cod_aff_form VARCHAR(30) REFERENCES _formation(cod_aff_form),
	CONSTRAINT rang_dernier_appele_selon_regroupement_PK PRIMARY KEY (libelle_regroupement, session_annee, cod_aff_form)
)