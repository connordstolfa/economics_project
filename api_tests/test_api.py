import requests
import pandas as pd

def test_api_fetch(table_name):
    print(f"⛷️Fetching econ data from {table_name} with FastAPI...")

    endpoint = f"http://127.0.0.1:8000/api/v1/{table_name}"

    response = requests.get(endpoint)

    if response.status_code == 200:
        json_data = response.json()
        print(f"✅Received {len(response.json()['data'])} rows from {table_name}")

        df = pd.DataFrame(json_data['data'])
        return df
    else:
        print(f"❌Error fetching data from {table_name}: {response.status_code}: {response.text}")

test_api_fetch("fct_economic_indicators")
