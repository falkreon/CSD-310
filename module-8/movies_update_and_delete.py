# CSD310: Database Development and Use
# Module 8.2: Movies: Update and Deletes
# Isaac Ellingson
# 11/22/2025

import mysql.connector
from mysql.connector import errorcode

import dotenv
from dotenv import dotenv_values


def show_films(cursor, title):
    print('\n -- {} --'.format(title))

    cursor.execute("""
        SELECT
            film.film_name AS Name,
            film.film_director AS Director,
            genre.genre_name AS Genre,
            studio.studio_name AS Studio
        FROM film
          LEFT JOIN genre ON film.genre_id = genre.genre_id
          LEFT JOIN studio ON film.studio_id = studio.studio_id
        """)
    films = cursor.fetchall()

    for film in films:
        print("Film Name: " + film['Name'])
        print("Director: " + film['Director'])
        print("Genre: " + film['Genre'])
        print("Studio: " + film['Studio'])
        print()


secrets = dotenv_values(".env")

db_config = {
    "user": secrets["USER"],
    "password": secrets["PASSWORD"],
    "host": secrets["HOST"],
    "database": secrets["DATABASE"],
    "raise_on_warnings": True
}

db = None

try:

    db = mysql.connector.connect(**db_config) # ** is kwargs / variadic

    # These cursor args let us use dictionary keys instead of positional arguments,
    # which is clearer and more durable. The tradeoff is that the dictionaries are
    # mutable. Can't have everything I guess.
    cursor = db.cursor( buffered=True, dictionary=True )
    show_films(cursor, "DISPLAYING FILMS")

    cursor.execute("""
        INSERT INTO film (
            film_name, film_releaseDate, film_runtime,
            film_director, studio_id, genre_id
        )
        VALUES('The Mummy', 1932, 73, 'Karl Freund', 3, 1 );
        """)

    show_films(cursor, "NOW WITH MORE FILMS")

    cursor.execute("""
        UPDATE film
            SET genre_id = 1
            WHERE film_name = 'Alien';
        """)

    show_films(cursor, "NOW WITH LESS SCI-FI")

    cursor.execute("""
        DELETE FROM film
            WHERE film_name = 'Gladiator';
        """)

    show_films(cursor, "NOW WITH LESS GLADIATOR")


    # Restore everything to how it was so that multiple runs can produce the expected output
    cursor.execute("""
        DELETE FROM film
            WHERE film_name = 'The Mummy';
        """)

    cursor.execute("""
        INSERT IGNORE INTO film (
            film_id,
            film_name, film_releaseDate, film_runtime,
            film_director, studio_id, genre_id
        )
        VALUES(1, 'Gladiator', 2000, 155, 'Ridley Scott', 3, 3 );
        """)

    cursor.execute("""
        UPDATE film
            SET genre_id = 2
            WHERE film_name = 'Alien';
        """)


except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("  The supplied username or password are invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("  The specified database does not exist")

    else:
        print(err)

finally:
    if (db is not None): db.close()
