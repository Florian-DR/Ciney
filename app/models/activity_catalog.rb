class ActivityCatalog
  # CONTENU À PERSONNALISER :
  # Remplacer les titres, distances et dénivelés lorsque les six parcours
  # définitifs sont connus. Les noms de fichiers sont documentés dans
  # public/gpx/README.md.
  GPX_TRACE_GROUPS = [
    {
      category: "À vélo",
      icon: "fa-bicycle",
      traces: [
        { title: "Mise en selle", distance: "32km", elevation: "574m", file: "Ciney-Frandeux-32km.gpx" },
        { title: "À vos clips !", distance: "42km", elevation: "672m", file: "Ciney-Chevetogne-42km.gpx" },
        { title: "Parcourir le Condroz", distance: "70km", elevation: "785m", file: "Ciney-Croisette_Promenade-70km.gpx" },
      ],
    },
    {
      category: "En courant",
      icon: "fa-person-running",
      traces: [
        { title: "Running du matin", distance: "5km", elevation: "108m", file: "Ciney-5km.gpx" },
        { title: "Découverte des environs", distance: "10km", elevation: "245m", file: "Ciney-10km.gpx" },
        { title: "Exploration poussée", distance: "15km", elevation: "338m", file: "Ciney-15km.gpx" },
      ],
    },
  ].freeze
end
