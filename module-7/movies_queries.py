import mysql.connector
from mysql.connector import errorcode

import dotenv
from dotenv import dotenv_values

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

    cursor = db.cursor()

    # # This will dump the entire db in a pretty table
    #cursor.execute("""
    #    SELECT
    #        film.film_id AS Id,
    #        film.film_name AS Name,
    #        film.film_releaseDate AS ReleaseDate,
    #        film.film_runtime AS Runtime,
    #        film.film_director AS Director,
    #        studio.studio_name AS Studio,
    #        genre.genre_name AS Genre
    #    FROM film
    #      LEFT JOIN genre ON film.genre_id = genre.genre_id
    #      LEFT JOIN studio ON film.studio_id = studio.studio_id
    #    """)
    #movies = cursor.fetchall()
    #print(movies)


    print("-- DISPLAYING studio RECORDS --")
    cursor.execute("""
        SELECT
            studio_id AS Id,
            studio_name AS Name
        FROM studio;
        """)
    studios = cursor.fetchall()

    for studio in studios:
        print("Studio ID: " + str(studio[0]))
        print("Studio Name: " + studio[1])
        print()

    print("-- DISPLAYING genre RECORDS --")
    cursor.execute("""
        SELECT
            genre_id AS Id,
            genre_name AS Name
        FROM genre;
        """)
    genres = cursor.fetchall()

    for genre in genres:
        print("Genre ID: " + str(genre[0]))
        print("Genre Name: " + genre[1])
        print()

    print("-- DISPLAYING Short Film RECORDS --")
    cursor.execute("""
        SELECT
            film_name AS Name,
            film_runtime AS Runtime
        FROM film
        WHERE film_runtime < 120;
        """)
    short_films = cursor.fetchall()

    for short_film in short_films:
        print("Film name: " + short_film[0])
        print("Runtime: " + str(short_film[1]) + " minutes")
        print()

    print("-- DISPLAYING director RECORDS IN ORDER --")
    cursor.execute("""
        SELECT
            film_name AS Name,
            film_director AS Director
        FROM film
        ORDER BY Director ASC;
        """)
    directors = cursor.fetchall()

    for director in directors:
        print("Film Name: " + director[0])
        print("Director: " + director[1])
        print()


except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("  The supplied username or password are invalid")

    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("  The specified database does not exist")

    else:
        print(err)

finally:
    if (db is not None): db.close()
