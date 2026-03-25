# Fast API setup.

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .database_calls import get_indicator_data

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

# Establish a get request to the API.
@app.get("/api/v1/{table_name}")
def get_data(table_name: str):
    data = get_indicator_data(table_name)
    return {
        "selected_table": table_name,
        "data": data,
    }

# Use this for testing: uvicorn app.backend.main:app --reload
