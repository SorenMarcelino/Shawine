class User {
  final String nom;
  final String prenom;
  final String avatar;

  const User({
    required this.nom,
    required this.prenom,
    required this.avatar,
  });

  static User fromJson(json) => User(
    nom: json['nom'],
    prenom: json['prenom'],
    avatar: json['avatar'],
  );
}
