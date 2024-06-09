require "open-uri"

puts "---------- Deleting previous data----------"
puts " Deleting ..."
DaysOfWeek.delete_all
Day.delete_all
GiteHoliday.delete_all
Holiday.delete_all
Gite.delete_all
HomePage.delete_all

puts "---------- Generating new gites ----------"

lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In rhoncus lectus ut quam pharetra suscipit. Fusce venenatis vehicula tortor, et hendrerit ante tempor eget. Vestibulum et ultrices lacus. Nullam sit amet sem sit amet nibh mattis congue. Suspendisse aliquet in nunc eget tempor. Nullam lobortis, nibh ut molestie mattis, nunc augue lobortis lectus, et malesuada diam lectus a felis. In ultricies lobortis ex non egestas. Aliquam rutrum est lorem, ac mattis ipsum placerat non.

Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer in arcu lectus. Mauris turpis tellus, pharetra et sollicitudin eget, condimentum id ex. Suspendisse potenti. Pellentesque sollicitudin ultrices lacus eu placerat. Aliquam euismod bibendum lorem. Pellentesque maximus luctus ex in sodales. Curabitur tincidunt eget elit sed blandit. Aenean ac risus ipsum. Praesent id magna maximus, malesuada libero porta, ultricies nibh."

hirondelles = Gite.new
hirondelles.name = "Le Nid aux Hirondelles"
hirondelles.description = lorem_ipsum
hirondelles.capacity = 13
hirondelles.sanitary = 4
hirondelles.rooms = 5
hirondelles.commun = "BBQ, sauna, piscine etc ..."
hirondelles.save!
puts " #{hirondelles.name} created"

chouette = Gite.new
chouette.name = "Le Perchoir de la Chouette"
chouette.description = lorem_ipsum
chouette.capacity = 8
chouette.sanitary = 4
chouette.rooms = 4
chouette.commun = "BBQ, sauna, piscine etc ..."
chouette.save!
puts " #{chouette.name} created"

pmr = Gite.new
pmr.name = "L'Arbre de Vie"
pmr.description = lorem_ipsum
pmr.capacity = 8
pmr.sanitary = 4
pmr.rooms = 4
pmr.commun = "BBQ, sauna, piscine etc ..."
pmr.save!
puts " #{pmr.name} created"

puts "---------- Generating HomePage ----------"

home = HomePage.new
home.introduction_title = "La ferme d'Auwez"
home.introduction_text = lorem_ipsum
home.gites_title = "Nos Gites"
home.mariages_title = "Les Mariages"
home.mariages_text = lorem_ipsum
home.entreprises_title = "Services aux entreprises"
home.decouvrir_title = "Découvrez plus"
home.save!
puts " Homepage created"

puts "---------- Adding photos ----------"
seeds_photos = [
  "https://res.cloudinary.com/dlyq7dzjx/image/upload/v1696006219/Ciney/yz20jc18uddrixli7g8jve96hlrz.jpg",
  "https://res.cloudinary.com/dlyq7dzjx/image/upload/v1695987849/Ciney/kp4izd0bzoe23rnocvscsp179ytc.jpg",
  "https://res.cloudinary.com/dlyq7dzjx/image/upload/v1695987855/Ciney/f1qunlp7cdsn8uuitomeuc5nzo0c.jpg",
  "https://res.cloudinary.com/dlyq7dzjx/image/upload/v1695987852/Ciney/n3pjn17awbwnlacpyohioetiybwg.jpg",
  "https://res.cloudinary.com/dlyq7dzjx/image/upload/v1711753045/Ciney/8xmjcrnr1dgzgx40ihgqv06j3n1g.jpg",
  "https://res.cloudinary.com/dlyq7dzjx/image/upload/v1695987849/Ciney/kp4izd0bzoe23rnocvscsp179ytc.jpg"
]

puts " Attach main photos ..."
hirondelles.photo_principale.attach(io: URI.open(seeds_photos[0]), filename: "Main image 1", content_type: "image/jpg")
chouette.photo_principale.attach(io: URI.open(seeds_photos[1]), filename: "Main image 2", content_type: "image/jpg")
pmr.photo_principale.attach(io: URI.open(seeds_photos[2]), filename: "Main image 3", content_type: "image/jpg")
home.main_photos.attach(io: URI.open(seeds_photos[0]), filename: "Main image 1", content_type: "image/jpg")
home.main_photos.attach(io: URI.open(seeds_photos[1]), filename: "Main image 2", content_type: "image/jpg")
home.main_photos.attach(io: URI.open(seeds_photos[2]), filename: "Main image 3", content_type: "image/jpg")



hirondelles.save!
chouette.save!
pmr.save!

puts " Attach all photos ..."
seeds_photos.each_with_index do |photo_url, index|
    hirondelles.photos.attach(io: URI.open(seeds_photos[index]), filename: "Photo_#{index + 1}", content_type: "image/jpg")
    chouette.photos.attach(io: URI.open(seeds_photos[index]), filename: "Photo_#{index + 1}", content_type: "image/jpg")
    pmr.photos.attach(io: URI.open(seeds_photos[index]), filename: "Photo_#{index + 1}", content_type: "image/jpeg")
    
    home.entreprises_photos.attach(io: URI.open(seeds_photos[index]), filename: "Photo_#{index + 1}", content_type: "image/jpeg") # Will have other photos later
    home.decouvrir_photos.attach(io: URI.open(seeds_photos[index]), filename: "Photo_#{index + 1}", content_type: "image/jpeg") # Will have other photos later
    puts " Photo #{index + 1} added"
end

puts " Photos added"
