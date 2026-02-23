# db/seeds.rb

require "faker"

puts "Clearing old data..."
Insight.delete_all
Listing.delete_all

STREETS = [
  "Sveavägen", "Hornsgatan", "Götgatan", "Birger Jarlsgatan",
  "Vasagatan", "Kungsgatan", "Sankt Eriksgatan", "Odengatan",
  "Nybrogatan", "Drottninggatan"
]

AREAS = [
  "Södermalm", "Östermalm", "Kungsholmen", "Vasastan",
  "Gamla Stan", "Norrmalm", "Sundbyberg", "Solna"
]

EVENT_TYPES = ["view", "save", "inquiry"]

puts "Creating listings..."

30.times do
  created_at = Faker::Date.between(from: 90.days.ago, to: Date.today)

  sold = [true, false].sample
  date_sold = sold ? Faker::Date.between(from: created_at, to: Date.today) : nil

  listing = Listing.create!(
    title: "#{Faker::Address.community} in #{AREAS.sample}",
    address: "#{STREETS.sample} #{rand(1..120)}, #{AREAS.sample}",
    price: rand(1_500_000..12_000_000),
    rooms: rand(1.0..6.0).round(1),
    bathrooms: rand(1.0..3.0).round(1),
    measurement: rand(25.0..180.0).round(1),
    floors: rand(1..3),
    description: Faker::Lorem.paragraph(sentence_count: 4),
    date_sold: date_sold,
    created_at: created_at,
    updated_at: created_at
  )

  # Generate insights for each listing
  rand(20..80).times do
    Insight.create!(
      listing_id: listing.id,
      event_type: EVENT_TYPES.sample,
      occurred_at: Faker::Time.between(from: created_at, to: Date.today)
    )
  end
end

puts "Done! Created #{Listing.count} listings and #{Insight.count} insights."
