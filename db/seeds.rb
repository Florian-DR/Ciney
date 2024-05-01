puts "---------- Deleting previous data----------"
DaysOfWeek.delete_all
Day.delete_all
Holiday.delete_all
Gite.delete_all


puts "---------- Generating new gites ----------"

lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In rhoncus lectus ut quam pharetra suscipit. Fusce venenatis vehicula tortor, et hendrerit ante tempor eget. Vestibulum et ultrices lacus. Nullam sit amet sem sit amet nibh mattis congue. Suspendisse aliquet in nunc eget tempor. Nullam lobortis, nibh ut molestie mattis, nunc augue lobortis lectus, et malesuada diam lectus a felis. In ultricies lobortis ex non egestas. Aliquam rutrum est lorem, ac mattis ipsum placerat non.

Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer in arcu lectus. Mauris turpis tellus, pharetra et sollicitudin eget, condimentum id ex. Suspendisse potenti. Pellentesque sollicitudin ultrices lacus eu placerat. Aliquam euismod bibendum lorem. Pellentesque maximus luctus ex in sodales. Curabitur tincidunt eget elit sed blandit. Aenean ac risus ipsum. Praesent id magna maximus, malesuada libero porta, ultricies nibh."

hirondelles = Gite.new
hirondelles.name = "Le nid aux Hirondelles"
hirondelles.description = lorem_ipsum
hirondelles.capacity = 13
hirondelles.sanitary = 4
hirondelles.rooms = 5
hirondelles.save!
puts " #{hirondelles.name} created"

chouette = Gite.new
chouette.name = "Le perchoir des Chouettes"
chouette.description = lorem_ipsum
chouette.capacity = 8
chouette.sanitary = 4
chouette.rooms = 4
chouette.save!
puts " #{chouette.name} created"

pmr = Gite.new
pmr.name = "L'Arbre de vie"
pmr.description = lorem_ipsum
pmr.capacity = 8
pmr.sanitary = 4
pmr.rooms = 4
pmr.save!
puts " #{pmr.name} created"

home = HomePage.new
home.introduction_title
home.introduction_text
home.gites_title
home.mariages_title
home.mariages_text
home.entreprises_title
home.decouvrir_title
home.save!
puts "Homepage created"
