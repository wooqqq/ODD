# app/cassandra_database.py
from cassandra.cluster import Cluster
from cassandra.auth import PlainTextAuthProvider
import os
from dotenv import load_dotenv

load_dotenv()

CASSANDRA_HOST = os.getenv("CASSANDRA_HOST")
CASSANDRA_KEYSPACE = os.getenv("CASSANDRA_KEYSPACE")
CASSANDRA_USER = os.getenv("CASSANDRA_USER")
CASSANDRA_PASSWORD = os.getenv("CASSANDRA_PASSWORD")

auth_provider = PlainTextAuthProvider(username=CASSANDRA_USER, password=CASSANDRA_PASSWORD)
cluster = Cluster([CASSANDRA_HOST], auth_provider=auth_provider)
session = cluster.connect(CASSANDRA_KEYSPACE)

def get_cassandra_session():
    return session
