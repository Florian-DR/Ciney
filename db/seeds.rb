require "open-uri"

puts "---------- Deleting previous data----------"
puts " Deleting ..."
Photo.delete_all
Gite.delete_all
HomePage.delete_all

def generate_aws_image(key)
  Shrine::UploadedFile.new(
    storage: "store", # must match Shrine.storages key (usually :store)
    id: key,  
    metadata: {
        "filename"  => File.basename(key),
        "mime_type" => "image/jpeg",  # adjust if not jpg
  }
)
end

puts "---------- Generating new gites ----------"

lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In rhoncus lectus ut quam pharetra suscipit. Fusce venenatis vehicula tortor, et hendrerit ante tempor eget. Vestibulum et ultrices lacus. Nullam sit amet sem sit amet nibh mattis congue. Suspendisse aliquet in nunc eget tempor. Nullam lobortis, nibh ut molestie mattis, nunc augue lobortis lectus, et malesuada diam lectus a felis. In ultricies lobortis ex non egestas. Aliquam rutrum est lorem, ac mattis ipsum placerat non.

Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Integer in arcu lectus. Mauris turpis tellus, pharetra et sollicitudin eget, condimentum id ex. Suspendisse potenti. Pellentesque sollicitudin ultrices lacus eu placerat. Aliquam euismod bibendum lorem. Pellentesque maximus luctus ex in sodales. Curabitur tincidunt eget elit sed blandit. Aenean ac risus ipsum. Praesent id magna maximus, malesuada libero porta, ultricies nibh."

hirondelles = Gite.new
hirondelles.name = "Les Hirondelles"
hirondelles.description = lorem_ipsum
hirondelles.capacity = 15
hirondelles.rooms = 6
hirondelles.sanitary = 5
hirondelles.commun = "BBQ, sauna, piscine etc ..."
hirondelles.save!
puts " #{hirondelles.name} created"

horizon = Gite.new
horizon.name = "L'Horizon"
horizon.description = lorem_ipsum
horizon.capacity = 6
horizon.rooms = 2
horizon.sanitary = 2
horizon.commun = "BBQ, sauna, piscine etc ..."
horizon.save!
puts " #{horizon.name} created"

arbre = Gite.new
arbre.name = "L'Arbre de Vie"
arbre.description = lorem_ipsum
arbre.capacity = 4
arbre.rooms = 2
arbre.sanitary = 2
arbre.commun = "BBQ, sauna, piscine etc ..."
arbre.save!
puts " #{arbre.name} created"

puts "---------- Generating HomePage ----------"

home = HomePage.new
home.save!
puts " Homepage created"

puts "---------- Adding photos ----------"
puts " Generate image from key"
key_tree = "gite/54/main_photo/312a7e5d6614ab96057dc2238a0e1b43.jpg"
key_horizon = "gite/53/main_photo/99174155bab83422874880d04d686b2a.jpg"
key_panorama= "gite/52/main_photo/d1b7240f8445963a20dfb83acd7077be.jpg"
key_piscine= "photo/72/image/a463f7c83500f8854526b36fc66581f0.jpg"
key_vaches= "photo/81/image/865be029758dc47d33a73e707f33f0e0.jpg"

image_tree = generate_aws_image(key_tree)
image_horizon = generate_aws_image(key_horizon)
image_panorama = generate_aws_image(key_panorama)

puts " Attach main photos ..."
home.photos.create(image: image_tree, photo_type: PhotoType::MAIN_HOMEPAGE)
home.photos.create(image: image_horizon, photo_type: PhotoType::MAIN_HOMEPAGE) 
hirondelles.main_photo = image_panorama 
horizon.main_photo = image_horizon 
arbre.main_photo =  image_tree


five_first_photos = [
    image_tree, 
    generate_aws_image(key_piscine),
    image_horizon, 
    image_panorama,
    generate_aws_image(key_vaches)
]

five_first_photos.each do |photo|
  hirondelles.photos.create(image: photo, photo_type: PhotoType::GALLERY_GITE)
  horizon.photos.create(image: photo, photo_type: PhotoType::GALLERY_GITE)
  arbre.photos.create(image: photo, photo_type: PhotoType::GALLERY_GITE)
end

hirondelles.save!
horizon.save!
arbre.save!

puts " Photos added"
