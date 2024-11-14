-- Users table
CREATE TABLE IF NOT EXISTS user_info (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_picture TEXT,
    user_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    dietary_preference VARCHAR(100)
);

-- Recipes table
CREATE TABLE IF NOT EXISTS recipes (
    recipe_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES user_info(user_id),
    title VARCHAR(100) NOT NULL,
    cook_time INTEGER,
    description TEXT,
    published_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    latest_updated_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    public_or_private BOOLEAN DEFAULT false
);

-- Recipe template table
CREATE TABLE IF NOT EXISTS recipe_template (
    template_id SERIAL PRIMARY KEY,
    recipe_id INTEGER REFERENCES recipes(recipe_id),
    step_number INTEGER,
    instruction TEXT,
    ingredient_name VARCHAR(100),
    quantity VARCHAR(50)
);

-- Following info table
CREATE TABLE IF NOT EXISTS following_info (
    following_info_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES user_info(user_id),
    followers_info VARCHAR(255),
    no_of_public_posts INTEGER DEFAULT 0,
    following_info VARCHAR(255),
    following_count INTEGER DEFAULT 0,
    followers_count INTEGER DEFAULT 0
);

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_recipes_user_id ON recipes(user_id);
CREATE INDEX IF NOT EXISTS idx_recipe_template_recipe_id ON recipe_template(recipe_id);
CREATE INDEX IF NOT EXISTS idx_following_info_user_id ON following_info(user_id);
