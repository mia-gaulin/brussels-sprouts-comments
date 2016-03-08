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

COMMENTS = Faker::Lorem.paragraph(6)

system "psql brussels_sprouts_recipes < schema.sql"

def db_connection
  begin
    connection = PG.connect(dbname: "brussels_sprouts_recipes")
    yield(connection)
  ensure
    connection.close
  end
end

def post_recipes
  db_connection do |conn|
    TITLES.each do |recipe|
      result = conn.exec_params("INSERT INTO recipes (name) VALUES ($1);" [recipe])
    end
  end
end

def post_comments
  db_connection do |conn|
    COMMENTS.each do |comment|
      result = conn.exec_params("INSERT INTO comments (comment) VALUES ($1);" [comment])
    end
  end
end

post_recipes
post_comments

# How many recipes in total?

def recipe_count
  db_connection do |conn|
    conn.exec("SELECT * FROM recipes;").to_a
  end
end

puts "There are #{recipe_count.length} recipes."

# How many comments in total?

def comment_count
  db_connection do |conn|
    conn.exec("SELECT * FROM comments;").to_a
  end
end

puts "There are #{comment_count.length} comments."

# How many comments per recipe?

def comments_per_recipe
  db_connection do |conn|
    conn.exec("SELECT recipe_id, COUNT(*) FROM comments GROUP BY recipe_id").to_a
  end
end

comments_per_recipe

# What is the name of the recipe associated with a specific comment?

def identify_recipe
  db_connection do |conn|
    conn.exec("SELECT recipes.id, comments.comment FROM recipes INNER JOIN comments ON comments.recipe_id=recipes.id").to_a
  end
end

# Add new recipe
