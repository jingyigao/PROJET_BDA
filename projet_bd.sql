/*table Entreprise*/  
CREATE TABLE Entreprise(
  NumEntreprise INTEGER CONSTRAINT PK_Entreprise PRIMARY KEY,
  NomEntreprise VARCHAR2(30),
  VilleEntreprise VARCHAR2(30),
  CPEntreprise VARCHAR2(6));
  
/*table Etudiant*/
CREATE TABLE Etudiant(
  NumEtudiant INTEGER CONSTRAINT PK_Etudiant PRIMARY KEY,
  NomEtudiant VARCHAR2(30),
  PrenomEtudiant VARCHAR2(30),
  MdpEtudiant VARCHAR2(30)NOT NULL,
  EmailEtudiant VARCHAR2(30),
  TP VARCHAR2(5),
  EnStage INT CHECK(EnStage IN ('1','0'))
);  

CREATE TABLE Stagiaire(
      NumEtudiant INTEGER CONSTRAINT CIR_Etudiant REFERENCES ETUDIANT,
       NumEntreprise INTEGER CONSTRAINT CIR_Entreprise REFERENCES ENTREPRISE, 
       AnneeStage INTEGER NOT NULL
);

/*table des Stages en fonction des entreprises*/
CREATE TABLE TriStages_Entreprises(
    AnneeStage INTEGER,
    NbrStage INTEGER,
    NumEntreprise INTEGER CONSTRAINT CIR_ENTR REFERENCES ENTREPRISE 
    );
    
    
    /*Table Statistiques qui comporte une seule ligne */
CREATE TABLE Statistiques(
    Identifiant INTEGER CONSTRAINT pk_stats PRIMARY KEY, 
    NbEtudiantAvecStage INTEGER,
    NbEtudiantSansStage INTEGER,
    NbEtudiantSansStageADateVoulue INTEGER,
    NbEtudiantPrisParEntreprise INTEGER,
    NbEtudiantMoyenParEntreprise INTEGER,
    NbStageParZoneGeographique INTEGER,
    NbStageToutesZonesGeographique INTEGER
    );

/* insert des données*/

/*Inserer Etudiant*/
CREATE PROCEDURE InsertEtudiant(nb INTEGER,nom VARCHAR, prenom VARCHAR, MDP VARCHAR,email VARCHAR, TP VARCHAR, enStage VARCHAR)
AS
BEGIN
    INSERT INTO Etudiant
    VALUES(nb,nom,prenom,MDP,email,TP,enStage);
END;

/*Inserer Stagiaire*/
CREATE PROCEDURE InsertStagiaire(numEtudiant INTEGER,NumEntreprise INTEGER, Anneestage INTEGER)
AS
BEGIN
    INSERT INTO Stagiaire
    VALUES (numEtudiant,NumEntreprise,Anneestage);
END;

/*Inserer Entreprise*/
CREATE PROCEDURE InsertEntreprise(num INTEGER,nom VARCHAR,CPE VARCHAR,ville VARCHAR)
AS
BEGIN
    INSERT INTO   Entreprise
    VALUES(num,nom,CPE,ville);
END;

/*Inserer Stage_Entreprise*/
CREATE PROCEDURE InsertStageEntreprise(AnneeStage  INTEGER,NbrStage INTEGER,NumEntreprise INTEGER)
AS
BEGIN
    INSERT INTO TRISTAGES_ENTREPRISES
    VALUES(AnneeStage,NbrStage,NumEntreprise);
END;    

/*création des procédures*/

/*calcule du nombre d'étudiants avec stage cette année*/
CREATE PROCEDURE NbAvecStage(Annee INTEGER)
IS
Nombre INTEGER;
BEGIN
  SELECT COUNT(*) INTO Nombre
  FROM Etudiant e, Stagiaire s 
  WHERE e.numEtudiant = s.numEtudiant
	AND s.Anneestage = Annee
	AND e.EnStage = '1';
  UPDATE Statistiques SET NbEtudiantAvecStage = Nombre;
END;

/*calcule du nombre d'étudiants sans stage cette année*/
CREATE PROCEDURE NbSansStage(Annee INTEGER) 
IS
Nombre INTEGER;
BEGIN

    SELECT COUNT(*) INTO Nombre
    FROM Etudiant e, Stagiaire s 
    WHERE e.numEtudiant = s.numEtudiant
	  AND s.Anneestage = Annee
	  AND e.EnStage = '0';
    UPDATE Statistiques SET NbEtudiantSansStage = Nombre;
END;

/*calcule du nombre d'étudiants sans stage pour l'année voulue*/
CREATE PROCEDURE NbSansStageAnnee(Annee INTEGER)
IS
Nombre INTEGER;
BEGIN
    SELECT COUNT(*) INTO Nombre
    FROM Etudiant e, Stagiaire s 
    WHERE e.numEtudiant = s.numEtudiant
	  AND s.Anneestage = Annee
	  AND e.EnStage = '0';
    UPDATE Statistiques SET NbEtudiantSansStageADateVoulue = Nombre;
END;

/*NombreTotal de stage pour une ville passée en paramètres*/
CREATE PROCEDURE NombreStageVille(Ville VARCHAR)
IS
Nombre_Stage INTEGER;
BEGIN
    SELECT COUNT(*) INTO Nombre_Stage 
    FROM TriStages_Entreprises se, Entreprise e
    WHERE se.NumEntreprise = e.NumEntreprise
    AND e.VilleEntreprise = Ville;
    UPDATE STATISTIQUES SET NbStageParZoneGeographique = Nombre_Stage;
END;

/*NombreTotal de stage pour un département(code postal) passée en paramètres*/
CREATE PROCEDURE NombreStageDepartement(Departement VARCHAR)
IS
Nombre_Stage INTEGER;
BEGIN
    SELECT COUNT(*) INTO Nombre_Stage 
    FROM TriStages_Entreprises se, Entreprise e
    WHERE se.NumEntreprise = e.NumEntreprise
    AND e.CPEntreprise = Departement;
    UPDATE STATISTIQUES SET NbStageParZoneGeographique = Nombre_Stage;
END;


/*NE FONCTIONNE PAS
NombreTotal de stagiaire sur N années
CREATE PROCEDURE NombreStagiaireAnnee(duree INTEGER) 
IS
    Nb_stage INTEGER;
    Nb_stage_Total INTEGER;
    Annee_precedente INTEGER:=2015; 
    Annee_derniere INTEGER:=duree;
BEGIN
    LOOP
        SELECT COUNT(se.NombreStage) INTO Nb_stage
        FROM Stage_Entreprise se
        WHERE se.AnneeStage = Annee_precedente;
        SET Annee_precedente = Annee_precedente - 1;
        SET Annee_derniere = Annee_derniere - 1;
        SET Nb_stage_Total = Nb_stage_Total + Nb_stage;
        EXIT WHEN Annee_derniere = 0;
    END LOOP;
    UPDATE STATISTIQUES SET NbEtudiantPrisParEntreprise = Nb_stage_Total;
END;*/

/*Nombre dans toutes les régions*/
CREATE PROCEDURE NombreStagiaireMonde(nb INTEGER)
IS
    Total INTEGER;
BEGIN
    SELECT COUNT(*) INTO Total
    FROM TriStages_Entreprises;
    UPDATE Statistiques SET NbStageToutesZonesGeographique = Total;
END;
  
/* NE FONCTIONNE PAS
Nombre par N années en moyenne
CREATE PROCEDURE NombreStagiaireAnneeMoyenne(period INTEGER)
AS
    DECLARE Nombre_Stage INTEGER;
    DECLARE Period I;
BEGIN
    SELECT * FROM NombreStagiaire_Annee(period) INTO Nombre_Stage;
    SELECT CONVERT(DOUBLE,Nombre_Stage) INTO Nombre_Stage;
    SELECT CONVERT(DOUBLE,period) INTO Period;
     UPDATE Statistiques SET NbEtudiantMoyenParEntreprise = Nombre_Stage/Period;
END;*/

/*procédure d'affichage des statistiques*/
CREATE FUNCTION afficherNbEtudiantAvecStage RETURN INTEGER
IS 
  nb INTEGER;
BEGIN
	SELECT NbEtudiantAvecStage INTO nb
	FROM Statistiques;
	RETURN nb;
END;

CREATE FUNCTION afficherNbEtudiantSansStage RETURN INTEGER
IS nb INTEGER;
BEGIN
	SELECT NbEtudiantSansStage INTO nb
	FROM Statistiques;
	RETURN nb;
END;

CREATE FUNCTION afficherEtudiantSsStageADate RETURN INTEGER
IS 
nb INTEGER;
BEGIN
	SELECT NbEtudiantSansStageADateVoulue INTO nb
	FROM Statistiques;
	RETURN nb;
END;

CREATE FUNCTION afficherEtudiantPsPEntreprise RETURN INTEGER
IS nb INTEGER;
BEGIN
	SELECT NbEtudiantPrisParEntreprise INTO nb
	FROM Statistiques;
	RETURN nb;
END;

CREATE FUNCTION afficherStageZoneGeographique RETURN INTEGER
IS nb INTEGER;
BEGIN
	SELECT NbStageParZoneGeographique INTO nb
	FROM Statistiques;
	RETURN nb;
END;

CREATE FUNCTION afficherStageTtesZsGeog RETURN INTEGER
IS nb INTEGER;
BEGIN
	SELECT NbStageToutesZonesGeographique INTO nb
	FROM Statistiques;
	RETURN nb;
END;



/*NE FONCTIONNE PAS
CREATE TRIGGER after_update_Etudiant AFTER UPDATE 
ON ETUDIANT FOR EACH ROW
  DECLARE NbSansStage INTEGER;
  DECLARE NbAvecStage INTEGER;
  BEGIN 
    SELECT COUNT(e.NumEtudiant) INTO NbAvecStage
      FROM etudiant e
      WHERE e.EnStage = '1';
    UPDATE STATISTIQUES SET NbEtudiantAvecStage = NbAvecStage
      WHERE identifiant = 1;
    SELECT COUNT(e.NumEtudiant) INTO NbSansStage
      FROM etudiant e
      WHERE e.EnStage = '0';
    UPDATE STATISTIQUES SET NbEtudiantSansStage = NbSansStage
      WHERE identifiant = 1;
END;*/

/* Les DROPS */
DROP TABLE TRISTAGES_ENTREPRISES;
DROP TABLE STATISTIQUES;
DROP TABLE STAGIAIRE;
DROP TABLE ETUDIANT;
DROP TABLE ENTREPRISE;