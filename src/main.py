import os
from dataclasses import dataclass

import psycopg
from prettytable import from_db_cursor
from psycopg import sql

DBNAME = os.environ["DBNAME"]


@dataclass
class User:
    name: str


def create_user(connection: psycopg.Connection, user: User):
    create_user_query = """INSERT INTO public."users" (name) VALUES ({name})"""
    with connection.cursor() as cur:
        cur.execute(sql.SQL(create_user_query).format(name=user.name))


if __name__ == "__main__":
    users = [
        User(name="Saruman the White"),
        User(name="Gandalf the Gray"),
        User(name="Frodo Baggins"),
        User(name="Samwise Gamgee"),
    ]
    with psycopg.connect(f"dbname={DBNAME} user=postgres") as connection:
        for user in users:
            create_user(connection, user)

        with connection.cursor() as cur:
            cur.execute("SELECT * FROM Users")
            print(from_db_cursor(cur))
