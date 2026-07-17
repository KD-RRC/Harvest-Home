require 'net/http'
require 'json'

puts "Clearing existing data..."
ProductCategory.destroy_all
Price.destroy_all
Product.destroy_all
Category.destroy_all

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

puts "\n\nSeeding complete!"
puts "  Manitoba hand-crafted products : #{manitoba_products.count}"
puts "  API-sourced products           : #{api_count}"
puts "  Total products                 : #{Product.count}"
puts "  Total categories               : #{Category.count}"