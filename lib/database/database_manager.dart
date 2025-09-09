import '../modeles/redacteur.dart';

class DatabaseManager {
  // Simulation d'une base de données en mémoire pour Windows/Web
  static List<Redacteur> _redacteurs = [];
  static int _nextId = 1;
  static bool _initialized = false;

  Future<void> testDatabase() async {
    if (!_initialized) {
      _redacteurs.addAll([
        Redacteur(id: 1, nom: 'Dubois', prenom: 'Jean', email: 'jean.dubois@email.com'),
        Redacteur(id: 2, nom: 'Martin', prenom: 'Marie', email: 'marie.martin@email.com'),
      ]);
      _nextId = 3;
      _initialized = true;
      print('Base de données en mémoire initialisée avec ${_redacteurs.length} rédacteurs');
    }
  }

  Future<List<Redacteur>> getAllRedacteurs() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_redacteurs);
  }

  Future<int> insertRedacteur(Redacteur redacteur) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (_redacteurs.any((r) => r.email == redacteur.email)) {
      throw Exception('Un rédacteur avec cet email existe déjà');
    }
    
    final nouveauRedacteur = Redacteur(
      id: _nextId,
      nom: redacteur.nom,
      prenom: redacteur.prenom,
      email: redacteur.email,
    );
    
    _redacteurs.add(nouveauRedacteur);
    print('Rédacteur ajouté : ${nouveauRedacteur.nom} ${nouveauRedacteur.prenom}');
    return _nextId++;
  }

  Future<int> updateRedacteur(Redacteur redacteur) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final index = _redacteurs.indexWhere((r) => r.id == redacteur.id);
    if (index != -1) {
      if (_redacteurs.any((r) => r.email == redacteur.email && r.id != redacteur.id)) {
        throw Exception('Un autre rédacteur avec cet email existe déjà');
      }
      
      _redacteurs[index] = redacteur;
      print('Rédacteur mis à jour : ${redacteur.nom} ${redacteur.prenom}');
      return 1;
    }
    return 0;
  }

  Future<int> deleteRedacteur(int id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    
    final initialLength = _redacteurs.length;
    _redacteurs.removeWhere((redacteur) => redacteur.id == id);
    final deleted = initialLength - _redacteurs.length;
    
    if (deleted > 0) {
      print('Rédacteur supprimé (ID: $id)');
    }
    
    return deleted;
  }
}