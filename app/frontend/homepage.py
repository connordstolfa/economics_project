import streamlit as st
import requests
import pandas as pd
import plotly.express as px

# Use for launching streamlit: streamlit run app/frontend/homepage.py

st.set_page_config(page_title="econ_dash", layout="wide")

# 1. Sidebar Setup
st.sidebar.title("Headlines")
API_BASE_URL = "http://127.0.0.1:8000/api/v1"

# Choose which dbt model to view
target_table = st.sidebar.selectbox(
    "Select Data Source",
    options=["fct_economic_indicators", "int_inflation_measures", "stg_gdp"],
    index=0
)

st.title(f"Your Economic Indicators")

# Populate with data from DBT.
try:
    response = requests.get(f"{API_BASE_URL}/{target_table}")
    response.raise_for_status()
    df = pd.DataFrame(response.json()["data"])
    df['date'] = pd.to_datetime(df['date']).dt.date
    df = df.sort_values('date')

    # --- NEW: HEADLINE METRIC ---
    # We grab the most recent numeric value to show as a 'Headline'
    numeric_cols = df.select_dtypes(include=['number']).columns.tolist()
    if numeric_cols:
        primary_col = numeric_cols[0] 
        latest_val = df[primary_col].iloc[-1]
        prev_val = df[primary_col].iloc[-2] if len(df) > 1 else latest_val
        delta = round(latest_val - prev_val, 2)
        
        st.sidebar.metric(
            label=f"Latest {primary_col.replace('_', ' ').title()}", 
            value=f"{latest_val:,.2f}", 
            delta=f"{delta}"
        )

    st.sidebar.markdown("---") # Visual divider

    st.sidebar.markdown ("### Date Range")
    col_1, col_2 = st.sidebar.columns(2) # Creating 2 side by side columns.

    # --- NEW: DATE FILTER ---
    min_date = df['date'].min()
    max_date = df['date'].max()

    with col_1:
        start_date = st.date_input(
            "Start Date",
            value=min_date,
            min_value=min_date,
            max_value=max_date
        )
    
    with col_2:
        end_date = st.date_input(
            "End Date",
            value=max_date,
            min_value=min_date,
            max_value=max_date,
        )

    # Apply the Filter
    mask = (df['date'] >= start_date) & (df['date'] <= end_date)
    filtered_df = df.loc[mask]

    # 4. Main Display
    st.title(f"📊 {target_table.replace('_', ' ').title()}")
    
    if not filtered_df.empty:
        selected_metric = st.selectbox("Select Metric to Visualize", options=numeric_cols)
        fig = px.line(filtered_df, x='date', y=selected_metric, template="plotly_dark")
        st.plotly_chart(fig, use_container_width=True)
    else:
        st.warning("No data found for the selected date range.")

except Exception as e:
    st.error(f"Connection Error: {e}")

# Populate with data from headlines API.

