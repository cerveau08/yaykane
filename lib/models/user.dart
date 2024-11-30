class AppUser {
  final String uid;
  final String prenom;
  final String nom;
  final String email;
  final String adresse;
  final String? photoUrl;

  AppUser({
    required this.uid,
    required this.prenom,
    required this.nom,
    required this.email,
    required this.adresse,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'prenom': prenom,
      'nom': nom,
      'email': email,
      'adresse': adresse,
      'photoUrl': photoUrl,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      prenom: map['prenom'],
      nom: map['nom'],
      email: map['email'],
      adresse: map['adresse'],
      photoUrl: map['photoUrl'],
    );
  }
}
