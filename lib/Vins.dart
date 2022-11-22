class Vins {
  final String nom;
  final String descriptif;
  final String couleur;
  final String embouteillage;
  final String cepage;
  final String chateau_domaine_propriete_clos;
  final String annee;
  final String prix;
  final String image_bouteille;
  final String url_producteur;

  const Vins({
    required this.nom,
    required this.descriptif,
    required this.couleur,
    required this.embouteillage,
    required this.cepage,
    required this.chateau_domaine_propriete_clos,
    required this.annee,
    required this.prix,
    required this.image_bouteille,
    required this.url_producteur,
  });

  static Vins fromJson(json) => Vins(
      nom: json['nom'],
      descriptif: json['descriptif'],
      couleur: json['couleur'],
      embouteillage: json['embouteillage'],
      cepage: json['cepage'],
      chateau_domaine_propriete_clos: json['chateau_domaine_propriete_clos'],
      annee: json['annee'],
      prix: json['prix'],
      image_bouteille: json['image_bouteille'],
      url_producteur: json['url_producteur'],
  );
}
