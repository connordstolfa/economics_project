# economics_project
A project pulling data from FRED and other economic data sources for presentation.

In this project, you'll find a pre-loaded Duckdb database, which pulls data from a number of FRED endpoints.

That data is managed in DBT and displayed in a Streamlit dashboard. The entire project includes a live API connection to FRED and to the New York Times, for pulling recent business headlines.

Dagster orchestrates the data pipeline. 

graph LR
A[FRED API] --> D[Dagster]
B[NYT API] --> D
D --> E[(DuckDB)]
E --> F[dbt Models]
F --> G[FastAPI]
G --> H[Streamlit Dashboard]

This program is Dockerized, so it can be run at your convenience.

Dashboard: http://localhost:8501
API: http://localhost:8000/docs
http://localhost:3000
