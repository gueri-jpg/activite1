class Redacteur {
  int? id;
  String nom;
  String prenom;
  String email;

  // Constructeur avec tous les attributs (pour les objets existants)
  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur sans l'attribut id (pour les nouveaux objets)
  Redacteur.nouveau({
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Méthode pour convertir un objet rédacteur en Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  // Méthode pour créer un objet Redacteur à partir d'un Map
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id']?.toInt(),
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      email: map['email'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Redacteur{id: $id, nom: $nom, prenom: $prenom, email: $email}';
  }
}