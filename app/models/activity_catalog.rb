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
        { title: "Mise en selle", distance: "32 km", elevation: "574", file: "Ciney-Frandeux-32km.gpx" },
        { title: "À vos clips !", distance: "42 km", elevation: "672", file: "Ciney-Chevetogne-42km.gpx" },
        { title: "Parcourir le Condroz", distance: "70 km", elevation: "785", file: "Ciney-Croisette_Promenade-70km.gpx" },
      ],
    },
    {
      category: "En courant",
      icon: "fa-person-running",
      traces: [
        { title: "Running du matin", distance: "5 km", elevation: "108", file: "Ciney-5km.gpx" },
        { title: "Découverte des environs", distance: "10 km", elevation: "245", file: "Ciney-10km.gpx" },
        { title: "Exploration poussée", distance: "15 km", elevation: "338", file: "Ciney-15km.gpx" },
      ],
    },
  ].freeze
end
