enum Statut {
  enCours,
  annulee,
  terminee,
  enAttente,
}

extension StatutExtension on Statut {
  String get name {
    switch (this) {
      case Statut.enCours:
        return 'En cours';
      case Statut.annulee:
        return 'Annulée';
      case Statut.terminee:
        return 'Terminée';
      case Statut.enAttente:
        return 'En attente';
      default:
        return '';
    }
  }
}
