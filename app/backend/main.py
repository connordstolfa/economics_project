# Fast API setup.

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.backend.database_calls import get_indicator_data
from app.backend.scrape_the_business_page import get_latest_econ_articles as articles

app = FastAPI(title="EconDash API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {
        "status": "online",
        "message": "✅Economics Data API is live!🥳",
    }

@app.get("/api/v1/headlines")
def read_headlines():
    news = articles()
    relevant_news = [{"headline": article["headline"], "summary": article["abstract"]} for article in news]
    return relevant_news

# Establish a get request to the API.
@app.get("/api/v1/{table_name}")
def get_data(table_name: str):
    data = get_indicator_data(table_name)
    return {
        "selected_table": table_name,
        "data": data,
    }



# Use this for testing: uvicorn app.backend.main:app --reload

# print(read_headlines())
# print(get_data('fct_economic_indicators'))