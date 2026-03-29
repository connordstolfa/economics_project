import os
import requests
from dotenv import load_dotenv
from .pre_loaded_headlines import STATIC_TIMES_HEADLINES

load_dotenv()

times_api_key = os.getenv("TIMES_API_KEY")

def get_latest_econ_articles(api_key=times_api_key):
    # Times endpoint for the business section.
    # Hitting the Times News Wire API.
    endpoint = f"https://api.nytimes.com/svc/news/v3/content/nyt/business.json"

    params = {
        # "api-key": api_key,
        "api-key": '123',
        "sort": "newest",
        "limit": 5 # I'm grabbing the 5 latest articles
    }

    try:
        response = requests.get(endpoint, params=params)
        response.raise_for_status()
        data = response.json()
        # Instantiate a list to store article results.
        articles = []
        for item in data.get("results", []):
            articles.append({
                "headline": item.get("title"),
                "abstract": item.get("abstract"), # This is the "Gold" for your AI summary
                "url": item.get("url"),
                "published_date": item.get("published_date")
            })
        return articles
    except Exception as e:
        print(f"Error fetching latest news: {e}. Printing Pre-Loaded headlines.")
        return STATIC_TIMES_HEADLINES

if __name__ == "__main__":
    print(get_latest_econ_articles(times_api_key))
