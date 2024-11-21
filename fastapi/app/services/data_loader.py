import pandas as pd
from app.cassandra_database import get_cassandra_session

session = get_cassandra_session()

def load_data(table_name: str):
    query = f"SELECT * FROM {table_name}"
    rows = session.execute(query)

    # 빈 결과 처리
    if not rows:
        raise ValueError(f"No data found in table: {table_name}")

    return pd.DataFrame(list(rows))


def load_data_by_user(table_name: str, user_id: str):
    query = f"SELECT * FROM {table_name} WHERE user_id=%s ALLOW FILTERING"
    rows = session.execute(query, (user_id,))

    # 빈 결과 처리
    if not rows:
        raise ValueError(f"No data found for user: {user_id} in table: {table_name}")

    data = pd.DataFrame(list(rows))
    data['event_time'] = pd.to_datetime(data['event_time'], errors='coerce')
    return data


def load_logs_data():
    query = "SELECT * FROM logs"
    rows = session.execute(query)
    logs_data = pd.DataFrame(list(rows))
    if not logs_data.empty:
        print("Initial logs data columns:", logs_data.columns)
        if 'event_time' in logs_data.columns:
            logs_data['event_time'] = pd.to_datetime(logs_data['event_time'], errors='coerce')
        else:
            print("Error: 'event_time' column not found in logs data.")
            raise ValueError("'event_time' column is missing from logs data.")
        logs_data['date'] = pd.to_datetime(logs_data['date'], errors='coerce')
    return logs_data


def load_item_data():
    query = "SELECT * FROM item"
    rows = session.execute(query)
    item_data = pd.DataFrame(list(rows))
    return item_data

