# Simple seeding with random string
puts "Deleting previous records"

HiTag.destroy_all
Tag.destroy_all
Highlight.destroy_all
Book.destroy_all
User.destroy_all
Author.destroy_all

puts "Seeding database…"

puts "Creating users…"
User.create!(
  email: "leo@leo.com",
  password: "123456",
  first_name: "Leo",
  last_name: "Campagnaro"
)
User.create!(
  email: "soline@soline.com",
  password: "123456",
  first_name: "Soline",
  last_name: "Dziadzio"
)
User.create!(
  email: "lucas@lucas.com",
  password: "123456",
  first_name: "Lucas",
  last_name: "Grüner"
)
puts "---> #{User.count} users in database."

puts "Creating authors…"
authors = [
  "Victor Hugo", "Hermann Hesse", "Boris Vian", "J.R.R. Tolkien", "Robertson Davies", "Emmanuel Carrère",
  "Delphine de Vigan", "Leila Slimani", "Roald Dahl", "Jesus", "Michael Pollan"
]
authors.each do |author|
  Author.create!(name: author)
end
puts "---> #{Author.count} authors in database."

puts "Creating books…"
books = [
  "Capital", "The Steppenwolf", "L'herbe rouge", "The Lord of the Rings", "The Manticore", "Madame Bovary",
  "Sapiens", "L'adversaire", "Rien ne s'oppose à la nuit", "The Ogre's Garden", "Matilda", "The Bible",
  "How To Change Your Mind", "The Giver", "Peter Pan", "House on Mango Street"
]
books.each do |book|
  Book.create!(
    user: User.all.sample,
    author: Author.all.sample,
    title: book
  )
end
puts "---> #{Book.count} books in database."

puts "Creating highlights…"
quotes = [
  "When you tightly focus your vision, your analytical brain assumes control of your body, but it can’t compute sensations and direct movements fast enough to keep you balanced.",
  "Freedom to move within a relationship requires not only that we sustain our personal ground and sense of space but also that we acknowledge the space between ourselves and the other person.",
  "Your walk is your posture in motion.",
  "It must be remembered that in becoming meat-eaters we had to chew, and therefore to taste, all this rich, unsuitable food. The carnivores - the great cats, the wolves and dogs, the crocodiles - merely tore their meat into pieces and swallowed it, careless of whether it was shoulder, rump steak, liver or tripes. We could not bolt our food.",
  "The best-fed, biggest and most enterprising people were undoubtedly those who followed the big cats",
  "This was all very well, but it did not solve the major problem or settle the host of minor inconveniences which are inevitable when the cat tribe is the ruling class. One of these is undoubtedly housing. Every ape-woman wants a decent place in which to bring up her family, a real home, snug, warm and, above all, dry; nobody, I fancy, will deny that basically this means a cave.",
  "A dreadful quiet hung everywhere – except where a horde of flies had been zooming for days in obsessive parabolas."
]
dates = ["Tuesday, 3 May 2022 19:24:53", "Saturday, 7 May 2022 19:48:03", "Monday, 9 May 2022 23:05:13"]
30.times do
  location = (1..3000).to_a.sample
  book = Book.all.sample

  Highlight.create(
    user: book.user,
    book: book,
    quote: quotes.sample,
    page: (1..100).to_a.sample,
    location_start: location,
    location_end: location + (0..30).to_a.sample,
    highlight_date: dates.sample,
    public: [true, false].sample,
    comment: [nil, "A comment", "Another comment"].sample
  )
end
puts "---> #{Highlight.count} highlights in database."

puts "Creating tags…"
tags = [
  "university", "web dev", "friendship", "online", "work", "private", "school", "gardening", "passions",
  "skiing", "holidays", "online marketing", "mixology", "fashion", "furniture", "woodworking", "interior design",
  "project management", "self-development", "manifesting", "meditation", "agriculture", "homesteading", "best friends",
  "animals", "cooking", "mergers & acquisitions", "best horror", "favourite", "research", "novel", "movie"
]
colors = [
  "purple", #"#B6ACC3", "#67597A"
  "blue", #"#A1F7F7", "#9CF6F6"
  "green", #"#AFD5C7", "#4E937A"
  "yellow", #"#FFD485", "#FFBC42"
  "red", #"#E2A2BC", "#8F2D56"
  "orange", #"#F9B38A" "#F79256"
]
User.all.each do |user|
  tags.sample(rand(1..tags.length)).each do |tag|
    Tag.create!(name: tag, user: user, color: colors.sample)
  end
end
puts "---> #{Tag.count} highlights in database."

puts "Creating hi_tags…"
User.all.each do |user|
  user.highlights.each do |highlight|
    num = rand(0..3)
    if num > 0
      Tag.all.sample(num).each do |tag|
        HiTag.create!(tag: tag, highlight: highlight)
      end
    end
  end
end
puts "---> #{HiTag.count} hi_tags in database."
