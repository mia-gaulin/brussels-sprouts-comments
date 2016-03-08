DROP TABLE IF EXISTS recipes CASCADE;

CREATE TABLE recipes(
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

DROP TABLE IF EXISTS comments CASCADE;

CREATE TABLE comments(
  id SERIAL PRIMARY KEY,
  comment VARCHAR(255),
  recipe_id INT REFERENCES recipes(id)
);

-- recipe can have many reviews, but review belongs to a single recipe
