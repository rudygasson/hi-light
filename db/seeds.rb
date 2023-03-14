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
  "A dreadful quiet hung everywhere – except where a horde of flies had been zooming for days in obsessive parabolas.",
  "This movement and change has been called Tao by the Chinese, yet in fact there is no movement, for the moment is the only reality and there is nothing beside it in relation to which it can be said to move. Thus it can be called at once the eternally moving and eternally resting",
  "It is like trying to trace someone with whom you fell in love at first sight, and then lost touch; and you go back to the original place of meeting again and again, trying in vain to pick up the threads.",
  "Importance is not measured by time, and change is a symptom of the presence of life",
  "The message of the Eastern wisdom is that the forms of life are maya and therefore profoundly lacking in seriousness from the viewpoint of reality. For the world of form and illusion which the majority take to be the real world is none other than the play of the Spirit, or, as the Hindus have called it, the Dance of Shiva. He is enlightened who joins in this play knowing it as play, for man suffers only because he takes seriously what the gods made for fun.",
  "So far as words, thoughts, ideas, and images are concerned, the doctrines of Buddhism and most forms of Hinduism are so negative and hopeless that they seem to be a sort of glorying in nihilism. They do not merely insist that human life is impermanent, that man has no immortal soul, and that in time every trace of our existence must vanish. They go on to indicate, as the wise man’s goal, a release from this transient life which seems to be no release at all—a state called nirvana, which may be translated “despair,” and the attainment of a metaphysical condition called shunyata, which is a voidness so void as to be neither existent nor nonexistent!",
  "The unenlightened man keeps a tight hold on himself because he is afraid of losing himself; he can trust neither circumstances nor his own human nature; he is terrified of being genuine, of accepting himself as he is and tries to deceive himself into the belief that he is as he wishes to be. But these are the wishes, the desires that bind him, and it was such desires as these that the Buddha described as the cause of human misery.",
  "Felix was large, as nursery bears go, and a rich golden-brown, to begin with, and he had an expression of thoughtful determination. He had been made in France, and that was how he came to be named Felix",
  "To its critics, Canada is not a real country. It’s too large and too diverse and its history is too complicated. Even scholars concede that it’s a difficult country to know. At nearly 10 million square kilometres, it stretches across six time zones, east to west, from the Atlantic Ocean to the Pacific Ocean, and south to north, from its border with the United States to the High Arctic. (See Map 1) Only Russia is bigger.",
  "North America was neither outside of history nor empty when Europe ‘discovered’ it in the late 15th century. It was home to some 500,000 people, belonging to numerous distinct cultures and speaking over fifty languages, but who were connected by elaborate trade routes criss-crossing the continent and who shared a similar cosmology. Despite different rituals, festivals, feasts, and rites of passage, Indigenous peoples believed that humans, animals, and plants enjoyed equal positions and interacted on equal terms, that everything had a spirit, including trees, rocks, and waterways, that the spirit world was as real as the material world, and that it was owed respect, even reverence, through prayers, offerings, and small daily practices.",
  "The primitive Tarahumara Indians in Mexico’s remote Copper Canyon perform remarkable multi-day ultra-endurance running feats wearing nothing more than strips of rubber strapped to their feet."
]
dates = ["Tuesday, 3 May 2022 19:24:53", "Saturday, 7 May 2022 19:48:03", "Monday, 9 May 2022 23:05:13"]
quotes.each do |quote|
  location = (1..3000).to_a.sample
  book = Book.all.sample

  Highlight.create(
    user: book.user,
    book: book,
    quote: quote,
    page: (1..100).to_a.sample,
    location_start: location,
    location_end: location + (0..30).to_a.sample,
    highlight_date: dates.sample,
    public: [true, false].sample,
    comment: [nil, "A comment", "Another comment"].sample
  )
end
puts "---> #{Highlight.count} highlights in database."

puts "Creating tags and hitags …"
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
  user.highlights.each do |highlight|
    num = rand(0..3)
    if num > 0
      user.tags.sample(num).each do |tag|
        HiTag.create(tag: tag, highlight: highlight)
      end
    end
  end
end
puts "---> #{Tag.count} tags in database."
puts "---> #{HiTag.count} hitags in database."

# puts "Creating hi_tags…"
# User.all.each do |user|
#   user.highlights.each do |highlight|
#     num = rand(0..3)
#     if num > 0
#       Tag.all.sample(num).each do |tag|
#         HiTag.create!(tag: tag, highlight: highlight)
#       end
#     end
#   end
# end
# puts "---> #{HiTag.count} hi_tags in database."
