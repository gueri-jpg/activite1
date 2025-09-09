import 'package:flutter/material.dart';
import 'modeles/redacteur.dart';
import 'database/database_manager.dart';

void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  const MonApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Rédacteurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        useMaterial3: true,
      ),
      home: const RedacteurInterface(),
    );
  }
}

class RedacteurInterface extends StatefulWidget {
  const RedacteurInterface({super.key});

  @override
  State<RedacteurInterface> createState() => _RedacteurInterfaceState();
}

class _RedacteurInterfaceState extends State<RedacteurInterface> {
  final DatabaseManager _databaseManager = DatabaseManager();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  List<Redacteur> _redacteurs = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chargerRedacteurs();
  }

  // Charger tous les rédacteurs depuis la base de données
  Future<void> _chargerRedacteurs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final redacteurs = await _databaseManager.getAllRedacteurs();
      if (mounted) {
        setState(() {
          _redacteurs = redacteurs;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Ajouter un nouveau rédacteur
  Future<void> _ajouterRedacteur() async {
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();
    final email = _emailController.text.trim();

    if (nom.isNotEmpty && prenom.isNotEmpty && email.isNotEmpty) {
      try {
        final nouveauRedacteur = Redacteur.nouveau(
          nom: nom,
          prenom: prenom,
          email: email,
        );

        await _databaseManager.insertRedacteur(nouveauRedacteur);
        _viderChamps();
        await _chargerRedacteurs();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rédacteur ajouté avec succès!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur: $e')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
    }
  }

  // Vider les champs de saisie
  void _viderChamps() {
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
  }

  // Modifier un rédacteur
  Future<void> _modifierRedacteur(Redacteur redacteur) async {
    final TextEditingController nomController =
        TextEditingController(text: redacteur.nom);
    final TextEditingController prenomController =
        TextEditingController(text: redacteur.prenom);
    final TextEditingController emailController =
        TextEditingController(text: redacteur.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le rédacteur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomController,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            TextField(
              controller: prenomController,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nom = nomController.text.trim();
              final prenom = prenomController.text.trim();
              final email = emailController.text.trim();

              if (nom.isNotEmpty && prenom.isNotEmpty && email.isNotEmpty) {
                try {
                  final redacteurModifie = Redacteur(
                    id: redacteur.id,
                    nom: nom,
                    prenom: prenom,
                    email: email,
                  );

                  await _databaseManager.updateRedacteur(redacteurModifie);
                  Navigator.pop(context);
                  await _chargerRedacteurs();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Rédacteur modifié avec succès!')),
                    );
                  }
                } catch (e) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: $e')),
                  );
                }
              }
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  // Supprimer un rédacteur
  Future<void> _supprimerRedacteur(Redacteur redacteur) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
            'Êtes-vous sûr de vouloir supprimer ${redacteur.prenom} ${redacteur.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await _databaseManager.deleteRedacteur(redacteur.id!);
                Navigator.pop(context);
                await _chargerRedacteurs();

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Rédacteur supprimé avec succès!')),
                  );
                }
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: $e')),
                );
              }
            },
            child:
                const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Rédacteurs'),
        backgroundColor: Colors.pink[400],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section d'ajout
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _nomController,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _prenomController,
                      decoration: const InputDecoration(
                        labelText: 'Prénom',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _ajouterRedacteur,
                        icon: const Icon(Icons.add),
                        label: const Text('Ajouter un Rédacteur'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[400],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Titre de la section liste
            Text(
              'Liste des Rédacteurs (${_redacteurs.length})',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[700],
                  ),
            ),

            const SizedBox(height: 10),

            // Liste des rédacteurs
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _redacteurs.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.people_outline,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'Aucun rédacteur enregistré',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _redacteurs.length,
                          itemBuilder: (context, index) {
                            final redacteur = _redacteurs[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.pink[400],
                                  child: Text(
                                    redacteur.prenom.isNotEmpty
                                        ? redacteur.prenom[0].toUpperCase()
                                        : 'R',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(
                                  '${redacteur.prenom} ${redacteur.nom}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(redacteur.email),
                                    Text(
                                      'ID: ${redacteur.id}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () =>
                                          _modifierRedacteur(redacteur),
                                      tooltip: 'Modifier',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _supprimerRedacteur(redacteur),
                                      tooltip: 'Supprimer',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
