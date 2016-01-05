import java.sql.*;
/**
 * 
 * @authors Groupe TP3D2 Yiqing Chen, Jingyi Gao, Sourithi Kichenaradjou, Robin Paxion
 *
 */
public class Application {
	private static Connection co;

	public Application() {

	}

	/* Insertions */
	
	/** 
	 * insérer étudiant
	 * @param num
	 * @param nom
	 * @param prenom
	 * @param mdp
	 * @param mail
	 * @param tp
	 * @param stage
	 * @return boolean
	 * @throws SQLException
	 */
	public static boolean InsererEtudiant(int num, String nom, String prenom, String mdp, String mail, String tp,
			String stage) throws SQLException {
		CallableStatement cst = co.prepareCall("{call InsertEtudiant (? , ? , ? , ? , ? , ? , ?)}");
		cst.setInt(1, num);
		cst.setString(2, nom);
		cst.setString(3, prenom);
		cst.setString(4, mdp);
		cst.setString(5, mail);
		cst.setString(6, tp);
		cst.setString(7, stage);
		boolean succes = cst.execute();
		cst.close();
		return succes;
	}
	/** 
	 * insérer stagiaire
	 * @param numetudiant
	 * @param numentreprise
	 * @param annee
	 * @return boolean
	 * @throws SQLException
	 */
	public static boolean InsererStagiaire(int numetudiant, int numentreprise, int annee) throws SQLException {
		CallableStatement cst = co.prepareCall("{call InsertStagiaire (? , ? , ?)}");
		cst.setInt(1, numetudiant);
		cst.setInt(2, numentreprise);
		cst.setInt(3, annee);
		boolean succes = cst.execute();
		cst.close();
		return succes;
	}

	/**
	 * insérer entreprise
	 * @param num
	 * @param nom
	 * @param CPE
	 * @param ville
	 * @return boolean
	 * @throws SQLException
	 */
	public static boolean InsererEntreprise(int num, String nom, String CPE, String ville) throws SQLException {
		CallableStatement cst = co.prepareCall("{call InsertEntreprise (? , ? , ? , ?)}");
		cst.setInt(1, num);
		cst.setString(2, nom);
		cst.setString(3, CPE);
		cst.setString(4, ville);
		boolean succes = cst.execute();
		cst.close();
		return succes;
	}

	/**
	 * insérer Stage
	 * @param anneestage
	 * @param nbstages
	 * @param numentreprise
	 * @return boolean
	 * @throws SQLException
	 */
	public static boolean InsererStageEntreprise(int anneestage, int nbstages, int numentreprise) throws SQLException {
		CallableStatement cst = co.prepareCall("{call InsertStageEntreprise (? , ? , ?)}");
		cst.setInt(1, anneestage);
		cst.setInt(2, nbstages);
		cst.setInt(3, numentreprise);
		boolean succes = cst.execute();
		cst.close();
		return succes;
	}

	/**
	 * nb étudiants avec stage de l'année en cours
	 * @throws SQLException
	 */
	public static void nbEtudiantsAvecStage() throws SQLException {
		CallableStatement cst = co.prepareCall("{call NbAvecStage ( ? )}");
		cst.setInt(1, 2015);
		cst.execute();
		cst.close();
	}

	/**
	 * nb étudiants sans stage de l'année en cours
	 * @throws SQLException
	 */
	public static void nbEtudiantsSansStage() throws SQLException {
		CallableStatement cst = co.prepareCall("{call NbSansStage ( ? )}");
		cst.setInt(1, 2015);
		cst.execute();
		cst.close();
	}

	/**
	 * nb étudiants sans stage de l'année passée en paramètre
	 * @param annee
	 * @throws SQLException
	 */
	public static void nbEtudiantsSansStage(int annee) throws SQLException {
		CallableStatement cst = co.prepareCall("{call NbSansStageAnnee ( ? )}");
		cst.setInt(1, annee);
		cst.execute();
		cst.close();
	}

	/**
	 * nb de stage dans la ville passée en paramètre
	 * @param ville
	 * @throws SQLException
	 */
	public static void nbStageVille(String ville) throws SQLException {
		CallableStatement cst = co.prepareCall("{call NombreStageVille ( ? )}");
		cst.setString(1, ville);
		cst.execute();
		cst.close();

	}

	/**
	 * nb de stage dans le département passé en paramètre
	 * @param departement
	 * @throws SQLException
	 */
	public static void nbStageDepartement(String departement) throws SQLException {
		CallableStatement cst = co.prepareCall("{call NombreStageDepartement ( ? )}");
		cst.setString(1, departement);
		cst.execute();
		cst.close();
	}

	/**
	 * nb stagiaires les N années précédentes
	 * @param annees
	 * @throws SQLException
	 */
	public static void nbStagiairesAnnéesPrécédentes(int annees) throws SQLException {
		CallableStatement cst = co.prepareCall("{call NombreStagiaireAnnee ( ? )}");
		cst.setInt(1, annees);
		cst.execute();
		cst.close();
	}

	/**
	 * nb stagiaires dans toutes les régions
	 * @throws SQLException
	 */
	public static void nbStagiairesRégions() throws SQLException {
		CallableStatement cst = co.prepareCall("{call NombreStagiaireMonde ( ? )}");
		cst.setInt(1, 1);
		cst.execute();
		cst.close();
	}

	/**
	 * nb moyen de stagiaires encadrés par les entreprises dans les n dernières années (NON FONCTIONNEL)
	 * @throws SQLException
	 */
	public static void nbStagiairesAnnéeMoyenne() throws SQLException {
		CallableStatement cst = co.prepareCall("{call NombreStagiaireAnneeMoyenne ( ? )}");
		cst.execute();
		cst.close();
	}
	
	/*procédures d'affichage des stats*/
	/**
	 * 
	 * @throws SQLException
	 */
	public static void afficherNbEtudiantAvecStage() throws SQLException {
		CallableStatement cst = co.prepareCall("{? = call afficherNbEtudiantAvecStage ( )}");
		cst.registerOutParameter(1,java.sql.Types.INTEGER);
		cst.execute();
		System.out.println("afficherNbEtudiantAvecStage");
		System.out.println(cst.getInt(1));
		cst.close();
	}
	/**
	 * 
	 * @throws SQLException
	 */
	public static void afficherNbEtudiantSansStage() throws SQLException {
		CallableStatement cst = co.prepareCall("{? = call afficherNbEtudiantSansStage ( )}");
		cst.registerOutParameter(1,java.sql.Types.INTEGER);
		cst.execute();
		System.out.println("afficherNbEtudiantSansStage");
		System.out.println(cst.getInt(1));
		cst.close();
	}
	/**
	 * 
	 * @throws SQLException
	 */
	public static void afficherNbEtudiantSansStageADate() throws SQLException {
		CallableStatement cst = co.prepareCall("{? = call afficherEtudiantSsStageADate ( )}");
		cst.registerOutParameter(1,java.sql.Types.INTEGER);
		cst.execute();
		System.out.println("afficherNbEtudiantSansStageADateVoulue");
		System.out.println(cst.getInt(1));
		cst.close();
	}
	/**
	 * 
	 * @throws SQLException
	 */
	public static void afficherNbEtudiantPrisParEntreprise() throws SQLException {
		CallableStatement cst = co.prepareCall("{? = call afficherEtudiantPsPEntreprise ( )}");
		cst.registerOutParameter(1,java.sql.Types.INTEGER);
		cst.execute();
		System.out.println("afficherNbEtudiantPrisParEntreprise");
		System.out.println(cst.getInt(1));
		cst.close();
	}
	/**
	 * 
	 * @throws SQLException
	 */
	public static void afficherNbStageParZoneGeographique() throws SQLException {
		CallableStatement cst = co.prepareCall("{? = call afficherStageZoneGeographique ( )}");
		cst.registerOutParameter(1,java.sql.Types.INTEGER);
		cst.execute();
		System.out.println("afficherNbStageParZoneGeographique");
		System.out.println(cst.getInt(1));
		cst.close();
	}
	/**
	 * 
	 * @throws SQLException
	 */
	public static void afficherNbStageToutesZonesGeographique() throws SQLException {
		CallableStatement cst = co.prepareCall("{? = call afficherStageTtesZsGeog ( )}");
		cst.registerOutParameter(1,java.sql.Types.INTEGER);
		cst.execute();
		System.out.println("afficherNbStageToutesZonesGeographique");
		System.out.println(cst.getInt(1));
		cst.close();
	}
	
	
	/**
	 * Main Function
	 * @param args
	 */
	public static void main(String[] args) {
		co = OutilsJDBC.openConnection("jdbc:oracle:thin:rpaxion/r2d2@oracle.iut-orsay.fr:1521:etudom");

		try {
			/*InsererEtudiant(1, "titi", "toto", "r2d2", "toto@gmail.com", "tp3D2", "1");
			InsererEtudiant(2, "tutu", "tata", "r4d5", "tata@gmail.com", "tp3D1", "0");
			InsererEtudiant(3, "tic", "tac", "pez", "tac@gmail.com", "tp3A2", "0");
			InsererEtudiant(4, "rico", "cora", "mdp", "rico@gmail.com", "tp3A1", "1");
			InsererEtudiant(5, "bidul", "sam", "pass", "sam@gmail.com", "tp3E1", "1");
			InsererEntreprise(1, "footlocker", "75003", "Paris");
			InsererStagiaire(1, 1, 2015);
			InsererStageEntreprise(2015, 3, 1);*/
			
			
			
			nbEtudiantsAvecStage();
			nbEtudiantsSansStage();
			nbEtudiantsSansStage(2015);
			nbStageVille("starlab");
			nbStageDepartement("94240");
			nbStagiairesRégions();
			//afficherNbEtudiantAvecStage();
			//afficherNbEtudiantSansStage();
			//afficherNbEtudiantSansStageADate();
			//afficherNbEtudiantPrisParEntreprise();
			//afficherNbStageParZoneGeographique();
			//afficherNbStageToutesZonesGeographique();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}
}
