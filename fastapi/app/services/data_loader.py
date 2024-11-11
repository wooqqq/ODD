import pandas as pd
from app.cassandra_database import get_cassandra_session, session

session = get_cassandra_session()

def load_data(table_name):
    query = f"SELECT * FROM {table_name}"
    rows = session.execute(query)
    return pd.DataFrame(list(rows))