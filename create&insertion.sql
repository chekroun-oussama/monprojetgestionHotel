

-- Création des tables
CREATE TABLE Hotel (
    id_Hotel INT PRIMARY KEY,
    Ville VARCHAR(100),
    Pays VARCHAR(100),
    Code_postal INT
);

CREATE TABLE Presentation (
    id_Presentation INT PRIMARY KEY,
    Prix DECIMAL(10,2),
    Description TEXT
);

CREATE TABLE Client (
    id_Client INT PRIMARY KEY,
    Adresse VARCHAR(255),
    Ville VARCHAR(100),
    Code_postal INT,
    E_mail VARCHAR(100),
    Numero_de_telephone VARCHAR(20),
    Nom_complet VARCHAR(100)
);

CREATE TABLE Type_Chambre (
    id_Type INT PRIMARY KEY,
    Type VARCHAR(50),
    Tarif INT
);

CREATE TABLE Reservation (
    id_Reservation INT PRIMARY KEY,
    Date_arrivee DATE,
    Date_depart DATE,
    id_Client INT,
    FOREIGN KEY (id_Client) REFERENCES Client(id_Client)
);

CREATE TABLE Chambre (
    id_Chambre INT PRIMARY KEY,
    Numero INT,
    Etage INT,
    Fumeurs BOOLEAN,
    id_Type INT,
    id_Hotel INT,
    FOREIGN KEY (id_Type) REFERENCES Type_Chambre(id_Type),
    FOREIGN KEY (id_Hotel) REFERENCES Hotel(id_Hotel)
);

CREATE TABLE Evaluation (
    id_Evaluation INT PRIMARY KEY,
    Date_arrivee DATE,
    La_note INT,
    Texte_descriptif TEXT,
    id_Hotel INT,
    id_Client INT,
    FOREIGN KEY (id_Hotel) REFERENCES Hotel(id_Hotel),
    FOREIGN KEY (id_Client) REFERENCES Client(id_Client)
);

CREATE TABLE Offre (
    id_Hotel INT,
    id_Presentation INT,
    PRIMARY KEY (id_Hotel, id_Presentation),
    FOREIGN KEY (id_Hotel) REFERENCES Hotel(id_Hotel),
    FOREIGN KEY (id_Presentation) REFERENCES Presentation(id_Presentation)
);

CREATE TABLE Concerner (
    id_Chambre INT,
    id_Reservation INT,
    PRIMARY KEY (id_Chambre, id_Reservation),
    FOREIGN KEY (id_Chambre) REFERENCES Chambre(id_Chambre),
    FOREIGN KEY (id_Reservation) REFERENCES Reservation(id_Reservation)
);

-- Insertions
INSERT INTO Hotel VALUES
(1, 'Paris', 'France', 75001),
(2, 'Lyon', 'France', 69002);

INSERT INTO Client VALUES
(1, '12 Rue de Paris', 'Paris', 75001, 'jean.dupont@email.fr','0612345678', 'Jean Dupont'),
(2, '5 Avenue Victor Hugo', 'Lyon', 69002, 'marie.leroy@email.fr','0623456789', 'Marie Leroy'),
(3, '8 Boulevard Saint-Michel', 'Marseille', 13005,'paul.moreau@email.fr', '0634567890', 'Paul Moreau'),
(4, '27 Rue Nationale', 'Lille', 59800, 'lucie.martin@email.fr','0645678901', 'Lucie Martin'),
(5, '3 Rue des Fleurs', 'Nice', 6000, 'emma.giraud@email.fr','0656789012', 'Emma Giraud');

INSERT INTO Presentation VALUES
(1, 15.00, 'Petit-déjeuner'),
(2, 30.00, 'Navette aéroport'),
(3, 0.00, 'Wi-Fi gratuit'),
(4, 50.00, 'Spa et bien-être'),
(5, 20.00, 'Parking sécurisé');

INSERT INTO Type_Chambre VALUES
(1, 'Simple', 80),
(2, 'Double', 120);

INSERT INTO Chambre VALUES
(1, 201, 2, 0, 1, 1),
(2, 502, 5, 1, 1, 2),
(3, 305, 3, 0, 2, 1),
(4, 410, 4, 0, 2, 2),
(5, 104, 1, 1, 2, 2),
(6, 202, 2, 0, 1, 1),
(7, 307, 3, 1, 1, 2),
(8, 101, 1, 0, 1, 1);

INSERT INTO Reservation VALUES
(1, '2025-06-15', '2025-06-18', 1),
(2, '2025-07-01', '2025-07-05', 2),
(3, '2025-08-10', '2025-08-14', 3),
(4, '2025-09-05', '2025-09-07', 4),
(5, '2025-09-20', '2025-09-25', 5),
(7, '2025-11-12', '2025-11-14', 2),
(9, '2026-01-15', '2026-01-18', 4),
(10, '2026-02-01', '2026-02-05', 2);


INSERT INTO Evaluation VALUES
(1, '2025-06-15', 5, 'Excellent séjour, personnel très accueillant.', 1, 1),
(2, '2025-07-01', 4, 'Chambre propre, bon rapport qualité/prix.', 2, 2),
(3, '2025-08-10', 3, 'Séjour correct mais bruyant la nuit.', 1, 3),
(4, '2025-09-05', 5, 'Service impeccable, je recommande.', 2, 4),
(5, '2025-09-20', 4, 'Très bon petit-déjeuner, hôtel bien situé.', 1, 5);


--Ecrire les requêtes SQL ET en algèbre relationnelle qui permettent de:
--a. Afficher la liste des réservations avec le nom du client et la ville de l’hôtel réservé.
SELECT R.id_Reservation, R.Date_arrivee, R.Date_depart, C.Nom_complet, H.Ville
FROM Reservation R
JOIN Client C ON R.id_Client = C.id_Client
JOIN Concerner Co ON R.id_Reservation = Co.id_Reservation
JOIN Chambre Ch ON Co.id_Type = Ch.id_Type
JOIN Hotel H ON Ch.id_Hotel = H.id_Hotel;


--b. Afficher les clients qui habitent à Paris.
SELECT * 
FROM Client 
WHERE Ville = 'Paris';
--c. Calculer le nombre de réservations faites par chaque client.
SELECT C.id_Client, C.Nom_complet, COUNT(R.id_Reservation) AS Nb_Reservations
FROM Client C
LEFT JOIN Reservation R ON C.id_Client = R.id_Client
GROUP BY C.id_Client, C.Nom_complet;
--d. Donner le nombre de chambres pour chaque type de chambre.
SELECT TC.Type, COUNT(C.id_Chambre) AS Nb_Chambres
FROM Type_Chambre TC
LEFT JOIN Chambre C ON TC.id_Type = C.id_Type
GROUP BY TC.id_Type, TC.Type;
-- e. Afficher la liste des chambres qui ne sont pas réservées pour une période donnée (entre deux dates saisies par l’utilisateur)
SELECT * 
FROM Chambre 
WHERE id_Chambre NOT IN (
  SELECT Ch.id_Chambre
  FROM Chambre Ch
  JOIN Concerner Co ON Ch.id_Type = Co.id_Type
  JOIN Reservation R ON Co.id_Reservation = R.id_Reservation
  WHERE R.Date_arrivee <= '2025-07-10'
    AND R.Date_depart >= '2025-07-01'
);
-- f.Qu’est ce que SQLite, quelle différence avec MySQL?
--f.1. SQLite est un moteur de base de données relationnelle léger, sans serveur, qui stocke les données dans un fichier unique
--f.2. SQLite est parfait pour des bases légères et autonomes et MySQL est adapté aux applications critiques et multi-utilisateurs donc Si vous développez une app mobile ou un petit projet, SQLite est idéal. Pour un site web avec beaucoup d’utilisateurs, MySQL (ou PostgreSQL) est préférable.

