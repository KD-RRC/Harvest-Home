# Clear existing data
ProductCategory.destroy_all
Price.destroy_all
Product.destroy_all
Category.destroy_all

# Create categories
honey     = Category.create!(name: "Honey & Bee Products", description: "Raw honey, beeswax candles, and other hive products from Manitoba beekeepers.")
baked     = Category.create!(name: "Baked Goods", description: "Artisan breads, pastries, and treats baked fresh by local Manitoba makers.")
preserves = Category.create!(name: "Jams & Preserves", description: "Handcrafted jams, jellies, pickles, and fermented goods made from prairie produce.")
meat      = Category.create!(name: "Meat & Charcuterie", description: "Locally raised bison, heritage pork, and house-made charcuterie from Manitoba farms.")
pantry    = Category.create!(name: "Pantry & Condiments", description: "Hot sauces, mustards, infused oils, and spice blends crafted in small batches.")
grains    = Category.create!(name: "Flour & Grains", description: "Stone-ground flours, oats, wild rice, and heritage grains grown on the Prairies.")
dairy     = Category.create!(name: "Dairy & Eggs", description: "Farmstead cheeses, free-range eggs, and fresh butter from Manitoba producers.")
produce   = Category.create!(name: "Fresh & Preserved Produce", description: "Seasonal vegetables, dried herbs, and preserved fruits from Manitoba market gardens.")

# Create products with prices
products = [
  {
    name: "Wildflower Raw Honey",
    description: "Unpasteurized wildflower honey harvested from hives set among Manitoba's native prairie flowers. Rich amber colour with a complex floral finish. 500g jar.",
    sku: "HNY-001",
    stock_quantity: 48,
    active: true,
    category: honey,
    price: 16.99
  },
  {
    name: "Creamed Buckwheat Honey",
    description: "Smooth, spreadable creamed honey made from pure Manitoba buckwheat. Deep, robust flavour with a hint of molasses. Perfect on toast or stirred into tea. 250g jar.",
    sku: "HNY-002",
    stock_quantity: 30,
    active: true,
    category: honey,
    price: 12.99
  },
  {
    name: "Sourdough Country Loaf",
    description: "Long-fermented sourdough loaf made with a blend of stone-ground whole wheat and bread flour. Crisp crust, open crumb, mild tang. Baked fresh every Friday.",
    sku: "BKD-001",
    stock_quantity: 12,
    active: true,
    category: baked,
    price: 11.00
  },
  {
    name: "Cinnamon Cardamom Buns (6-pack)",
    description: "Soft, pillowy buns filled with Manitoba butter, cinnamon, and freshly ground cardamom, finished with a cream cheese glaze. Baked to order.",
    sku: "BKD-002",
    stock_quantity: 20,
    active: true,
    category: baked,
    price: 18.00
  },
  {
    name: "Saskatoon Berry Jam",
    description: "Classic prairie jam made from hand-picked Saskatoon berries grown near Portage la Prairie. No pectin added — just berries, sugar, and lemon. 250ml jar.",
    sku: "PRE-001",
    stock_quantity: 60,
    active: true,
    category: preserves,
    price: 9.99
  },
  {
    name: "Dill Pickle Relish",
    description: "Tangy, crunchy dill relish made from garden cucumbers, fresh dill, and garlic. A Manitoba summer staple. No artificial preservatives. 250ml jar.",
    sku: "PRE-002",
    stock_quantity: 45,
    active: true,
    category: preserves,
    price: 8.50
  },
  {
    name: "Bison Jerky – Cracked Pepper",
    description: "Tender strips of Manitoba bison seasoned with coarse black pepper and slow-dried. High protein, low fat, and 100% locally raised bison. 100g bag.",
    sku: "MET-001",
    stock_quantity: 35,
    active: true,
    category: meat,
    price: 14.99
  },
  {
    name: "Prairie Fire Hot Sauce",
    description: "A bold, vinegar-forward hot sauce made from Manitoba-grown cayenne and habanero peppers. Medium-high heat with a bright, fruity finish. 150ml bottle.",
    sku: "PAN-001",
    stock_quantity: 50,
    active: true,
    category: pantry,
    price: 10.00
  },
  {
    name: "Stone-Ground Whole Wheat Flour",
    description: "100% whole wheat flour stone-ground from Red Fife wheat grown in the Interlake region. Nutty, rich flavour ideal for bread, muffins, and pancakes. 1kg bag.",
    sku: "GRN-001",
    stock_quantity: 40,
    active: true,
    category: grains,
    price: 7.99
  },
  {
    name: "Manitoba Wild Rice",
    description: "Hand-harvested wild rice from northern Manitoba lakes. Earthy, nutty flavour with a satisfying chew. A genuine prairie staple. 400g bag.",
    sku: "GRN-002",
    stock_quantity: 25,
    active: true,
    category: grains,
    price: 13.50
  }
]

products.each do |attrs|
  product = Product.create!(
    name:          attrs[:name],
    description:   attrs[:description],
    sku:           attrs[:sku],
    stock_quantity: attrs[:stock_quantity],
    active:        attrs[:active]
  )
  product.categories << attrs[:category]
  Price.create!(
    product:        product,
    amount:         attrs[:price],
    effective_date: Time.now
  )
end

puts "Seeded #{Category.count} categories and #{Product.count} products."