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
        { title: "Boucle vélo n° 1", distance: "Distance à préciser", elevation: "Dénivelé à préciser", file: "velo-1.gpx" },
        { title: "Boucle vélo n° 2", distance: "Distance à préciser", elevation: "Dénivelé à préciser", file: "velo-2.gpx" },
        { title: "Boucle vélo n° 3", distance: "Distance à préciser", elevation: "Dénivelé à préciser", file: "velo-3.gpx" },
      ],
    },
    {
      category: "En courant",
      icon: "fa-person-running",
      traces: [
        { title: "Parcours running n° 1", distance: "Distance à préciser", elevation: "Dénivelé à préciser", file: "course-1.gpx" },
        { title: "Parcours running n° 2", distance: "Distance à préciser", elevation: "Dénivelé à préciser", file: "course-2.gpx" },
        { title: "Parcours running n° 3", distance: "Distance à préciser", elevation: "Dénivelé à préciser", file: "course-3.gpx" },
      ],
    },
  ].freeze
end
