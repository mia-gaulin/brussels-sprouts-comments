require 'pg'
require 'faker'

TITLES = ["Roasted Brussels Sprouts",
  "Fresh Brussels Sprouts Soup",
  "Brussels Sprouts with Toasted Breadcrumbs, Parmesan, and Lemon",
  "Cheesy Maple Roasted Brussels Sprouts and Broccoli with Dried Cherries",
  "Hot Cheesy Roasted Brussels Sprout Dip",
  "Pomegranate Roasted Brussels Sprouts with Red Grapes and Farro",
  "Roasted Brussels Sprout and Red Potato Salad",
  "Smoky Buttered Brussels Sprouts",
  "Sweet and Spicy Roasted Brussels Sprouts",
  "Smoky Buttered Brussels Sprouts",
  "Brussels Sprouts and Egg Salad with Hazelnuts"]

system "psql brussels_sprouts_recipes < schema.sql"

def db_connection
  begin
    connection = PG.connect(dbname: "brussels_sprouts_recipes")
    yield(connection)
  ensure
    connection.close
  end
end


TITLES.each do |title|
  db_connection do |conn|
    conn.exec("INSERT INTO recipes (name) VALUES ($1);", [title])
  end
end

30.times do
  db_connection { |conn| conn.exec("INSERT INTO comments (comment) VALUES ($1);", [Faker::Lorem.paragraph]) }
end

# How many recipes in total?

total_recipes = []

db_connection do |conn|
  total_recipes = conn.exec("SELECT * FROM recipes;")
end

puts "There are #{total_recipes.count} recipes."

# How many comments in total?

total_comments = []

db_connection do |conn|
  total_comments = conn.exec("SELECT * FROM comments;")
end

puts "There are #{total_comments.count} comments."

# How many comments per recipe?

SELECT comment FROM comments WHERE recipe_id = 1

# What is the name of the recipe associated with a specific comment?

SELECT * FROM recipes JOIN comments ON recipes.id = comments.recipe_id

# Add new recipe

INSERT INTO recipes (name) VALUES ('Brussels Sprouts with Goat Cheese');

INSERT INTO comments (comment, recipe_id) VALUES ('ew brussels sprouts'), ('ew goat cheese');
