require 'net/http'
require 'json'

puts "Clearing existing data..."
ProductCategory.destroy_all
Price.destroy_all
Product.destroy_all
Category.destroy_all
Province.destroy_all

# ── Provinces with Canadian tax rates ────────────────────────────────────────
[
  { name: 'Alberta',                   code: 'AB', gst: 0.05,   pst: 0.00,    hst: 0.00 },
  { name: 'British Columbia',          code: 'BC', gst: 0.05,   pst: 0.07,    hst: 0.00 },
  { name: 'Manitoba',                  code: 'MB', gst: 0.05,   pst: 0.07,    hst: 0.00 },
  { name: 'New Brunswick',             code: 'NB', gst: 0.00,   pst: 0.00,    hst: 0.15 },
  { name: 'Newfoundland and Labrador', code: 'NL', gst: 0.00,   pst: 0.00,    hst: 0.15 },
  { name: 'Northwest Territories',     code: 'NT', gst: 0.05,   pst: 0.00,    hst: 0.00 },
  { name: 'Nova Scotia',               code: 'NS', gst: 0.00,   pst: 0.00,    hst: 0.15 },
  { name: 'Nunavut',                   code: 'NU', gst: 0.05,   pst: 0.00,    hst: 0.00 },
  { name: 'Ontario',                   code: 'ON', gst: 0.00,   pst: 0.00,    hst: 0.13 },
  { name: 'Prince Edward Island',      code: 'PE', gst: 0.00,   pst: 0.00,    hst: 0.15 },
  { name: 'Quebec',                    code: 'QC', gst: 0.05,   pst: 0.09975, hst: 0.00 },
  { name: 'Saskatchewan',              code: 'SK', gst: 0.05,   pst: 0.06,    hst: 0.00 },
  { name: 'Yukon',                     code: 'YT', gst: 0.05,   pst: 0.00,    hst: 0.00 },
].each { |p| Province.create!(p) }
puts "Created #{Province.count} provinces."

# Create categories
honey     = Category.create!(name: "Honey & Bee Products",      description: "Raw honey, beeswax candles, and other hive products from Manitoba beekeepers.")
baked     = Category.create!(name: "Baked Goods",               description: "Artisan breads, pastries, and treats baked fresh by local Manitoba makers.")
preserves = Category.create!(name: "Jams & Preserves",          description: "Handcrafted jams, jellies, pickles, and fermented goods made from prairie produce.")
meat      = Category.create!(name: "Meat & Charcuterie",        description: "Locally raised bison, heritage pork, and house-made charcuterie from Manitoba farms.")
pantry    = Category.create!(name: "Pantry & Condiments",       description: "Hot sauces, mustards, infused oils, and spice blends crafted in small batches.")
grains    = Category.create!(name: "Flour & Grains",            description: "Stone-ground flours, oats, wild rice, and heritage grains grown on the Prairies.")
dairy     = Category.create!(name: "Dairy & Eggs",              description: "Farmstead cheeses, free-range eggs, and fresh butter from Manitoba producers.")
produce   = Category.create!(name: "Fresh & Preserved Produce", description: "Seasonal vegetables, dried herbs, and preserved fruits from Manitoba market gardens.")

puts "Created #{Category.count} categories."

# ── 10 hand-crafted Manitoba products ────────────────────────────────────────
manitoba_products = [
  { name: "Wildflower Raw Honey",             description: "Unpasteurized wildflower honey harvested from hives set among Manitoba's native prairie flowers. Rich amber colour with a complex floral finish. 500g jar.",                                                                    sku: "HNY-001", stock: 48, category: honey,     price: 16.99 },
  { name: "Creamed Buckwheat Honey",          description: "Smooth, spreadable creamed honey made from pure Manitoba buckwheat. Deep, robust flavour with a hint of molasses. Perfect on toast or stirred into tea. 250g jar.",                                                          sku: "HNY-002", stock: 30, category: honey,     price: 12.99 },
  { name: "Sourdough Country Loaf",           description: "Long-fermented sourdough loaf made with a blend of stone-ground whole wheat and bread flour. Crisp crust, open crumb, mild tang. Baked fresh every Friday.",                                                                 sku: "BKD-001", stock: 12, category: baked,     price: 11.00 },
  { name: "Cinnamon Cardamom Buns (6-pack)",  description: "Soft, pillowy buns filled with Manitoba butter, cinnamon, and freshly ground cardamom, finished with a cream cheese glaze. Baked to order.",                                                                                 sku: "BKD-002", stock: 20, category: baked,     price: 18.00 },
  { name: "Saskatoon Berry Jam",              description: "Classic prairie jam made from hand-picked Saskatoon berries grown near Portage la Prairie. No pectin added — just berries, sugar, and lemon. 250ml jar.",                                                                    sku: "PRE-001", stock: 60, category: preserves, price: 9.99  },
  { name: "Dill Pickle Relish",               description: "Tangy, crunchy dill relish made from garden cucumbers, fresh dill, and garlic. A Manitoba summer staple. No artificial preservatives. 250ml jar.",                                                                          sku: "PRE-002", stock: 45, category: preserves, price: 8.50  },
  { name: "Bison Jerky – Cracked Pepper",     description: "Tender strips of Manitoba bison seasoned with coarse black pepper and slow-dried. High protein, low fat, and 100% locally raised bison. 100g bag.",                                                                          sku: "MET-001", stock: 35, category: meat,      price: 14.99 },
  { name: "Prairie Fire Hot Sauce",           description: "A bold, vinegar-forward hot sauce made from Manitoba-grown cayenne and habanero peppers. Medium-high heat with a bright, fruity finish. 150ml bottle.",                                                                      sku: "PAN-001", stock: 50, category: pantry,    price: 10.00 },
  { name: "Stone-Ground Whole Wheat Flour",   description: "100% whole wheat flour stone-ground from Red Fife wheat grown in the Interlake region. Nutty, rich flavour ideal for bread, muffins, and pancakes. 1kg bag.",                                                               sku: "GRN-001", stock: 40, category: grains,    price: 7.99  },
  { name: "Manitoba Wild Rice",               description: "Hand-harvested wild rice from northern Manitoba lakes. Earthy, nutty flavour with a satisfying chew. A genuine prairie staple. 400g bag.",                                                                                   sku: "GRN-002", stock: 25, category: grains,    price: 13.50 },
]

manitoba_products.each do |attrs|
  product = Product.create!(
    name:           attrs[:name],
    description:    attrs[:description],
    sku:            attrs[:sku],
    stock_quantity: attrs[:stock],
    active:         true
  )
  product.categories << attrs[:category]
  Price.create!(product: product, amount: attrs[:price], effective_date: Time.now)
  print "."
end

puts "\nCreated #{Product.count} hand-crafted Manitoba products."

# ── API products to reach 100 total ──────────────────────────────────────────
def fetch_products(search_term, page = 1)
  url = URI("https://world.openfoodfacts.org/cgi/search.pl?search_terms=#{URI.encode_www_form_component(search_term)}&tagtype_0=countries&tag_contains_0=contains&tag_0=canada&action=process&json=1&page_size=30&page=#{page}&fields=product_name,generic_name_en,ingredients_text_en,quantity,brands")
  response = Net::HTTP.get(url)
  JSON.parse(response)
rescue => e
  puts "Error fetching #{search_term}: #{e.message}"
  { 'products' => [] }
end

categories_map = {
  honey:     honey,
  baked:     baked,
  preserves: preserves,
  meat:      meat,
  pantry:    pantry,
  grains:    grains,
  dairy:     dairy,
  produce:   produce
}

searches = [
  ["honey",       :honey],
  ["maple syrup", :honey],
  ["bread",       :baked],
  ["granola",     :baked],
  ["cookie",      :baked],
  ["jam",         :preserves],
  ["pickle",      :preserves],
  ["jerky",       :meat],
  ["hot sauce",   :pantry],
  ["mustard",     :pantry],
  ["flour",       :grains],
  ["oats",        :grains],
  ["cheese",      :dairy],
  ["butter",      :dairy],
  ["dried fruit", :produce],
  ["herb tea",    :produce],
]

skus_used = Product.pluck(:sku)
api_count = 0
counter   = 100

searches.each do |term, category_key|
  break if Product.count >= 100
  puts "Fetching '#{term}' from API..."

  data     = fetch_products(term)
  products = data['products'] || []

  products.each do |p|
    break if Product.count >= 100

    name = p['product_name'].to_s.strip
    next if name.blank? || name.length < 3 || name.length > 100

    # Build description
    parts = []
    parts << p['generic_name_en'].to_s.strip      if p['generic_name_en'].present?
    parts << "Brand: #{p['brands']}"              if p['brands'].present?
    parts << "Size: #{p['quantity']}"             if p['quantity'].present?
    parts << p['ingredients_text_en'].to_s.truncate(200) if p['ingredients_text_en'].present?
    description = parts.join(". ").presence || "A quality Canadian #{term} product."
    description = description.truncate(500)

    sku = "API-#{counter}"
    next if skus_used.include?(sku)
    skus_used << sku
    counter += 1

    price = case category_key
            when :honey     then rand(8.99..24.99).round(2)
            when :baked     then rand(6.99..18.99).round(2)
            when :preserves then rand(7.99..14.99).round(2)
            when :meat      then rand(12.99..28.99).round(2)
            when :pantry    then rand(6.99..16.99).round(2)
            when :grains    then rand(5.99..14.99).round(2)
            when :dairy     then rand(7.99..22.99).round(2)
            when :produce   then rand(5.99..12.99).round(2)
            else rand(7.99..19.99).round(2)
            end

    product = Product.create!(
      name:           name,
      description:    description,
      sku:            sku,
      stock_quantity: rand(10..100),
      active:         true
    )
    product.categories << categories_map[category_key]
    Price.create!(product: product, amount: price, effective_date: Time.now)
    api_count += 1
    print "."
  end

  sleep(0.5)
end

# ── Fallback: fill to 100 if API failed ──────────────────────────────────────
if Product.count < 100
  puts "\nAPI unavailable - filling remaining products with local data..."
  all_categories = Category.all.to_a
  filler_products = [
    ["Prairie Blueberry Jam", preserves, 8.99],
    ["Manitoba Sunflower Oil", pantry, 12.99],
    ["Red River Cereal", grains, 6.99],
    ["Beeswax Candle", honey, 14.99],
    ["Perogies (dozen)", baked, 9.99],
    ["Smoked Goldeye Fish", meat, 18.99],
    ["Organic Oat Flour", grains, 7.49],
    ["Prairie Berry Granola", baked, 11.99],
    ["Manitoba Canola Oil", pantry, 9.99],
    ["Wild Blueberry Preserve", preserves, 10.99],
    ["Heritage Wheat Berries", grains, 8.99],
    ["Farmhouse Cheddar", dairy, 16.99],
    ["Free Range Eggs (dozen)", dairy, 7.99],
    ["Dried Saskatoon Berries", produce, 12.99],
    ["Prairie Mushroom Mix", produce, 9.99],
    ["Buckwheat Pancake Mix", baked, 8.99],
    ["Manitoba Flaxseed Oil", pantry, 11.99],
    ["Bison Steak Seasoning", meat, 8.99],
    ["Raw Beeswax", honey, 9.99],
    ["Chokecherry Jelly", preserves, 8.49],
    ["Organic Spelt Flour", grains, 9.99],
    ["Prairie Herb Tea Blend", produce, 11.99],
    ["Smoked Cheddar", dairy, 14.99],
    ["Haskap Berry Jam", preserves, 9.99],
    ["Manitoba Hemp Seeds", grains, 13.99],
    ["Garlic Dill Pickles", preserves, 7.99],
    ["Prairie Wildflower Tea", produce, 10.99],
    ["Artisan Rye Bread", baked, 9.99],
    ["Bison Summer Sausage", meat, 16.99],
    ["Sunflower Seed Butter", pantry, 12.99],
    ["Organic Rolled Oats", grains, 5.99],
    ["Manitoba Honey Mustard", pantry, 7.99],
    ["Farmstead Gouda", dairy, 18.99],
    ["Prairie Seed Mix", produce, 8.99],
    ["Crabapple Jelly", preserves, 8.99],
    ["Whole Grain Crackers", baked, 6.99],
    ["Smoked Bison Jerky", meat, 15.99],
    ["Elderflower Cordial", produce, 13.99],
    ["Lavender Honey", honey, 17.99],
    ["Wild Rice Blend", grains, 11.99],
    ["Prairie Fire BBQ Sauce", pantry, 9.99],
    ["Aged White Cheddar", dairy, 15.99],
    ["Carrot Cake Mix", baked, 8.49],
    ["Manitoba Pea Protein", grains, 19.99],
    ["Rosehip Jelly", preserves, 9.49],
    ["Heritage Pork Sausage", meat, 13.99],
    ["Infused Canola Oil", pantry, 10.99],
    ["Clover Honey", honey, 11.99],
    ["Dried Wild Mushrooms", produce, 14.99],
    ["Sourdough Crackers", baked, 7.99],
    ["Saskatoon Berry Syrup", honey, 12.99],
    ["Prairie Chai Blend", produce, 11.49],
    ["Manitoba Sunflower Seeds", grains, 5.99],
    ["Smoked Whitefish Pate", meat, 14.99],
    ["Cranberry Preserve", preserves, 9.49],
    ["Buttermilk Pancake Mix", baked, 7.99],
    ["Cold Pressed Hemp Oil", pantry, 16.99],
    ["Aged Gouda Wheel", dairy, 21.99],
    ["Dried Chokecherries", produce, 11.99],
    ["Artisan Pumpernickel", baked, 8.99],
    ["Heritage Beef Jerky", meat, 13.99],
    ["Manitoba Birch Syrup", honey, 19.99],
    ["Organic Millet Flour", grains, 8.49],
    ["Prairie Kombucha Kit", produce, 14.99],
    ["Smoked Gouda", dairy, 17.99],
    ["Jalapeño Pepper Jelly", preserves, 8.99],
    ["Sunflower Brittle", baked, 9.49],
    ["Bison Pemmican", meat, 16.99],
    ["Garlic Infused Oil", pantry, 11.49],
    ["Raw Wildflower Comb Honey", honey, 22.99],
    ["Organic Amaranth Flour", grains, 9.99],
    ["Prairie Rose Hip Tea", produce, 10.49],
    ["Farmstead Brie", dairy, 19.99],
    ["Plum Preserve", preserves, 8.99],
    ["Seed Bread Loaf", baked, 10.99],
    ["Smoked Bison Salami", meat, 18.99],
    ["Truffle Infused Oil", pantry, 14.99],
    ["Buckwheat Honey", honey, 13.99],
    ["Manitoba Pumpkin Seeds", grains, 6.99],
    ["Nettle Herbal Tea", produce, 9.99],
    ["Old Cheddar Block", dairy, 16.49],
    ["Rhubarb Ginger Jam", preserves, 9.99],
    ["Sourdough Baguette", baked, 7.99],
    ["Duck Confit", meat, 24.99],
    ["Rosemary Infused Oil", pantry, 10.99],
    ["Prairie Acacia Honey", honey, 15.99],
    ["Teff Flour", grains, 10.49],
    ["Dried Lavender", produce, 8.99],
    ["Sheep Milk Feta", dairy, 18.49],
    ["Strawberry Rhubarb Jam", preserves, 9.49],
  ]

  filler_products.each_with_index do |(name, category, price), i|
    break if Product.count >= 100
    sku = "FILL-#{i + 1}"
    next if Product.find_by(sku: sku)
    product = Product.create!(
      name:           name,
      description:    "A quality Manitoba-made product from local producers. Available for province-wide delivery through Harvest & Home.",
      sku:            sku,
      stock_quantity: rand(10..80),
      active:         true
    )
    product.categories << category
    Price.create!(product: product, amount: price, effective_date: Time.now)
    print "."
  end
  puts "\nTotal after filler: #{Product.count}"
end

puts "\n\nSeeding complete!"
puts "  Manitoba hand-crafted products : #{manitoba_products.count}"
puts "  API-sourced products           : #{api_count}"
puts "  Total products                 : #{Product.count}"
puts "  Total categories               : #{Category.count}"