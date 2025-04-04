CREATE TABLE shows (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      category TEXT CHECK( category IN ( 'movie', 'anime', 'serie')) NOT NULL,
      image TEXT
    )