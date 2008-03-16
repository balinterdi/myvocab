-- Two words mean the same (and thus form a vocab pair)
-- if they have the same meaning

CREATE TABLE words (
  id serial PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  lang CHAR(2) NOT NULL,
  meaning_id REFERENCES meanings.id
)

CREATE TABLE meanings (
  id serial PRIMARY KEY,
)

CREATE OR REPLACE VIEW words_en AS
SELECT * FROM words
WHERE lang='en';

CREATE OR REPLACE VIEW words_hu AS
SELECT * FROM words
WHERE lang='hu';