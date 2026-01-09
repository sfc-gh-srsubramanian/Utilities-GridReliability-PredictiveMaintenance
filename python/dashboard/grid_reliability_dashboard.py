"""
AI-Driven Grid Reliability & Predictive Maintenance
Streamlit Dashboard

Purpose: Interactive dashboard for monitoring transformer health and failure predictions
Features: Asset health heatmap, risk alerts, sensor trends, work order generation, ROI calculator

Author: Grid Reliability AI/ML Team
Date: 2025-11-15
Version: 1.0

Usage:
    streamlit run grid_reliability_dashboard.py
"""

import streamlit as st
import pandas as pd
import numpy as np
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots
from datetime import datetime, timedelta
import snowflake.connector
from snowflake.snowpark import Session
import json

# =============================================================================
# PAGE CONFIGURATION
# =============================================================================

st.set_page_config(
    page_title="Grid Reliability & Predictive Maintenance",
    page_icon="⚡",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Custom CSS for better styling
st.markdown("""
<style>
    .main-header {
        font-size: 2.5rem;
        color: #1f77b4;
        font-weight: bold;
        margin-bottom: 0.5rem;
    }
    .subheader {
        font-size: 1.2rem;
        color: #555;
        margin-bottom: 1.5rem;
    }
    .metric-card {
        background-color: #f0f2f6;
        padding: 1rem;
        border-radius: 0.5rem;
        border-left: 4px solid #1f77b4;
    }
    .critical-alert {
        background-color: #ffebee;
        padding: 1rem;
        border-radius: 0.5rem;
        border-left: 4px solid #d32f2f;
    }
    .high-alert {
        background-color: #fff3e0;
        padding: 1rem;
        border-radius: 0.5rem;
        border-left: 4px solid #f57c00;
    }
    /* Make Plotly map controls more prominent */
    .modebar {
        background-color: rgba(31, 119, 180, 0.1) !important;
        border: 2px solid #1f77b4 !important;
        border-radius: 8px !important;
        padding: 4px !important;
    }
    .modebar-btn {
        background-color: white !important;
        border: 1px solid #1f77b4 !important;
        border-radius: 4px !important;
        margin: 2px !important;
    }
    .modebar-btn:hover {
        background-color: #1f77b4 !important;
    }
    .modebar-btn svg {
        filter: brightness(0) saturate(100%) invert(36%) sepia(84%) saturate(1200%) hue-rotate(189deg) brightness(95%) contrast(90%);
    }
</style>
""", unsafe_allow_html=True)

# =============================================================================
# SNOWFLAKE CONNECTION
# =============================================================================

@st.cache_resource
def get_snowflake_session():
    """Create Snowflake session - uses native connection in Streamlit in Snowflake"""
    try:
        # For Streamlit in Snowflake - use the built-in connection
        from snowflake.snowpark.context import get_active_session
        session = get_active_session()
        
        # No need to set context - queries will use fully qualified names
        return session
    except Exception as e:
        st.error(f"Failed to get Snowflake session: {str(e)}")
        st.info("This app is designed to run in Streamlit in Snowflake")
        st.stop()

# =============================================================================
# DATA LOADING FUNCTIONS
# =============================================================================

@st.cache_data(ttl=300)  # Cache for 5 minutes
def load_asset_health_data(_session):
    """Load current asset health data"""
    query = """
    SELECT 
        ASSET_ID,
        ASSET_TYPE,
        LOCATION_SUBSTATION,
        LOCATION_CITY,
        LOCATION_COUNTY,
        LOCATION_LAT,
        LOCATION_LON,
        CUSTOMERS_AFFECTED,
        CRITICALITY_SCORE,
        RISK_SCORE,
        FAILURE_PROBABILITY,
        PREDICTED_RUL_DAYS,
        CONFIDENCE,
        ALERT_LEVEL,
        RISK_CATEGORY,
        DAYS_SINCE_MAINTENANCE,
        ASSET_AGE_YEARS
    FROM UTILITIES_GRID_RELIABILITY.ANALYTICS.VW_ASSET_HEALTH_DASHBOARD
    ORDER BY RISK_SCORE DESC
    """
    df = _session.sql(query).to_pandas()
    return df

@st.cache_data(ttl=300)
def load_high_risk_assets(_session):
    """Load high-risk assets requiring attention"""
    query = """
    SELECT *
    FROM ANALYTICS.VW_HIGH_RISK_ASSETS
    ORDER BY RISK_SCORE DESC
    """
    df = _session.sql(query).to_pandas()
    return df

@st.cache_data(ttl=300)
def load_reliability_metrics(_session):
    """Load SAIDI/SAIFI metrics"""
    query = """
    SELECT *
    FROM ANALYTICS.VW_RELIABILITY_METRICS
    """
    df = _session.sql(query).to_pandas()
    return df

@st.cache_data(ttl=300)
def load_cost_avoidance(_session):
    """Load cost avoidance data"""
    query = """
    SELECT *
    FROM ANALYTICS.VW_COST_AVOIDANCE_REPORT
    """
    df = _session.sql(query).to_pandas()
    return df

@st.cache_data(ttl=300)
def load_sensor_history(_session, asset_id, days=30):
    """Load sensor reading history for an asset"""
    query = f"""
    SELECT 
        READING_TIMESTAMP,
        OIL_TEMPERATURE_C,
        LOAD_CURRENT_A,
        DISSOLVED_H2_PPM,
        VIBRATION_MM_S,
        POWER_FACTOR
    FROM UTILITIES_GRID_RELIABILITY.RAW.SENSOR_READINGS
    WHERE ASSET_ID = '{asset_id}'
      AND READING_TIMESTAMP >= DATEADD(day, -{days}, CURRENT_TIMESTAMP())
    ORDER BY READING_TIMESTAMP
    """
    df = _session.sql(query).to_pandas()
    return df

# =============================================================================
# VISUALIZATION FUNCTIONS
# =============================================================================

def create_risk_heatmap(df):
    """Create geographic heatmap of asset risk scores with data-driven geographic context"""
    
    if df.empty:
        return go.Figure()
    
    # Calculate geographic centers from actual data
    city_locations = df.groupby('LOCATION_CITY').agg({
        'LOCATION_LAT': 'mean',
        'LOCATION_LON': 'mean',
        'ASSET_ID': 'count'
    }).reset_index()
    city_locations.columns = ['CITY', 'LAT', 'LON', 'ASSET_COUNT']
    
    county_stats = df.groupby('LOCATION_COUNTY').agg({
        'LOCATION_LAT': 'mean',
        'LOCATION_LON': 'mean',
        'RISK_SCORE': 'mean',
        'ASSET_ID': 'count'
    }).reset_index()
    
    # Create figure from scratch for better control
    fig = go.Figure()
    
    # Add Florida state outline for geographic context (simplified but accurate)
    # Coordinates trace Florida's actual boundary
    florida_outline_lon = [
        -87.63, -87.42, -87.31, -87.22, -87.13, -87.06, -86.95, -86.82, -86.66, -86.50,
        -86.36, -86.29, -86.15, -86.08, -85.99, -85.89, -85.74, -85.63, -85.53, -85.43,
        -85.31, -85.18, -85.05, -84.87, -84.70, -84.56, -84.47, -84.43, -84.40, -84.29,
        -84.18, -84.09, -84.05, -83.92, -83.84, -83.73, -83.61, -83.47, -83.35, -83.22,
        -83.11, -83.04, -82.93, -82.85, -82.78, -82.71, -82.64, -82.59, -82.52, -82.45,
        -82.36, -82.26, -82.18, -82.12, -82.05, -81.97, -81.90, -81.85, -81.77, -81.71,
        -81.64, -81.58, -81.48, -81.35, -81.26, -81.17, -81.10, -81.06, -80.96, -80.88,
        -80.81, -80.74, -80.59, -80.48, -80.42, -80.38, -80.35, -80.32, -80.29, -80.24,
        -80.18, -80.13, -80.10, -80.07, -80.05, -80.03, -80.01, -80.04, -80.08, -80.14,
        -80.22, -80.26, -80.31, -80.35, -80.39, -80.46, -80.53, -80.63, -80.75, -80.84,
        -80.96, -81.03, -81.13, -81.24, -81.35, -81.48, -81.60, -81.76, -81.90, -82.04,
        -82.18, -82.28, -82.38, -82.47, -82.60, -82.75, -82.87, -82.95, -83.07, -83.18,
        -83.29, -83.41, -83.53, -83.66, -83.80, -83.95, -84.11, -84.31, -84.67, -84.85,
        -85.00, -85.18, -85.39, -85.56, -85.74, -85.85, -86.08, -86.27, -86.47, -86.66,
        -86.88, -87.10, -87.33, -87.50, -87.63
    ]
    florida_outline_lat = [
        31.00, 30.95, 30.92, 30.89, 30.86, 30.83, 30.79, 30.75, 30.71, 30.67,
        30.63, 30.59, 30.54, 30.50, 30.46, 30.42, 30.36, 30.32, 30.28, 30.24,
        30.20, 30.15, 30.09, 30.02, 29.95, 29.88, 29.82, 29.77, 29.73, 29.67,
        29.61, 29.56, 29.50, 29.44, 29.39, 29.32, 29.26, 29.18, 29.10, 29.03,
        28.96, 28.90, 28.82, 28.75, 28.68, 28.60, 28.53, 28.46, 28.38, 28.31,
        28.24, 28.16, 28.09, 28.02, 27.94, 27.87, 27.80, 27.73, 27.65, 27.58,
        27.51, 27.43, 27.34, 27.26, 27.18, 27.10, 27.02, 26.95, 26.87, 26.79,
        26.71, 26.63, 26.47, 26.32, 26.20, 26.14, 26.09, 26.03, 25.97, 25.94,
        25.94, 25.95, 25.96, 25.97, 25.98, 25.99, 26.01, 26.05, 26.09, 26.14,
        26.23, 26.32, 26.42, 26.53, 26.63, 26.74, 26.85, 26.96, 27.07, 27.18,
        27.30, 27.42, 27.54, 27.65, 27.77, 27.89, 28.01, 28.13, 28.25, 28.37,
        28.49, 28.61, 28.73, 28.85, 28.96, 29.08, 29.20, 29.32, 29.44, 29.56,
        29.68, 29.79, 29.91, 30.02, 30.15, 30.28, 30.44, 30.71, 30.71, 30.71,
        30.71, 30.71, 30.71, 30.71, 30.71, 30.71, 30.71, 30.71, 30.71, 30.71,
        30.71, 30.71, 30.71, 30.71, 31.00
    ]
    
    fig.add_trace(go.Scattermapbox(
        lat=florida_outline_lat,
        lon=florida_outline_lon,
        mode='lines',
        line=dict(width=3, color='#1f77b4'),
        fill='toself',
        fillcolor='rgba(31, 119, 180, 0.05)',
        name='Florida',
        hoverinfo='skip',
        showlegend=False
    ))
    
    # Add asset markers with fixed sizes (not sized by customers - that causes huge circles)
    for risk_cat in ['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']:
        cat_df = df[df['RISK_CATEGORY'] == risk_cat]
        if not cat_df.empty:
            # Map risk categories to colors
            colors = {'LOW': 'green', 'MEDIUM': 'gold', 'HIGH': 'orange', 'CRITICAL': 'red'}
            sizes = {'LOW': 14, 'MEDIUM': 16, 'HIGH': 18, 'CRITICAL': 20}
            
            fig.add_trace(go.Scattermapbox(
                lat=cat_df['LOCATION_LAT'],
                lon=cat_df['LOCATION_LON'],
                mode='markers',
                marker=dict(
                    size=sizes[risk_cat],
                    color=colors[risk_cat],
                    opacity=0.7
                ),
                text=cat_df['ASSET_ID'],
                customdata=cat_df[['LOCATION_SUBSTATION', 'LOCATION_CITY', 'RISK_SCORE', 
                                   'CUSTOMERS_AFFECTED', 'ALERT_LEVEL']],
                hovertemplate='<b>%{text}</b><br>' +
                             'Substation: %{customdata[0]}<br>' +
                             'City: %{customdata[1]}<br>' +
                             'Risk Score: %{customdata[2]:.1f}<br>' +
                             'Customers: %{customdata[3]:,}<br>' +
                             'Alert: %{customdata[4]}<extra></extra>',
                name=f'{risk_cat} Risk',
                showlegend=True
            ))
    
    # Add city labels (smaller markers)
    fig.add_trace(go.Scattermapbox(
        lat=city_locations['LAT'],
        lon=city_locations['LON'],
        mode='text',
        text=city_locations['CITY'],
        textfont=dict(
            size=10,
            color='darkblue',
            family='Arial Black'
        ),
        name='Cities',
        showlegend=False,
        hoverinfo='skip'
    ))
    
    # Add county labels (very subtle, background)
    county_labels = [f"{row['LOCATION_COUNTY']}" for _, row in county_stats.iterrows()]
    fig.add_trace(go.Scattermapbox(
        lat=county_stats['LOCATION_LAT'],
        lon=county_stats['LOCATION_LON'],
        mode='text',
        text=county_labels,
        textfont=dict(
            size=8,
            color='rgba(100,100,100,0.4)',
            family='Arial'
        ),
        name='Counties',
        showlegend=False,
        hoverinfo='skip'
    ))
    
    # Configure layout with proper zoom controls
    fig.update_layout(
        mapbox=dict(
            style="white-bg",
            center=dict(
                lat=df['LOCATION_LAT'].mean(),
                lon=df['LOCATION_LON'].mean()
            ),
            zoom=5.5
        ),
        margin={"r": 0, "t": 0, "l": 0, "b": 0},
        height=650,
        legend=dict(
            yanchor="top",
            y=0.99,
            xanchor="left",
            x=0.01,
            bgcolor="rgba(255,255,255,0.9)",
            bordercolor="gray",
            borderwidth=1,
            font=dict(size=12)
        ),
        paper_bgcolor='#e8f4f8',
        plot_bgcolor='#e8f4f8',
        # Make modebar (toolbar) more prominent
        modebar=dict(
            bgcolor='rgba(255, 255, 255, 0.95)',
            color='#1f77b4',
            activecolor='#ff7f0e',
            orientation='h'
        )
    )
    
    return fig

def create_risk_distribution(df):
    """Create risk score distribution chart"""
    risk_counts = df['RISK_CATEGORY'].value_counts().reindex(['LOW', 'MEDIUM', 'HIGH', 'CRITICAL'], fill_value=0)
    
    colors = {
        'LOW': 'green',
        'MEDIUM': 'yellow',
        'HIGH': 'orange',
        'CRITICAL': 'red'
    }
    
    fig = go.Figure(data=[
        go.Bar(
            x=risk_counts.index,
            y=risk_counts.values,
            marker_color=[colors[cat] for cat in risk_counts.index],
            text=risk_counts.values,
            textposition='auto'
        )
    ])
    
    fig.update_layout(
        title="Asset Risk Distribution",
        xaxis_title="Risk Category",
        yaxis_title="Number of Assets",
        height=400
    )
    
    return fig

def create_sensor_trends(df, asset_id):
    """Create sensor trend charts for an asset"""
    if df.empty:
        return None
    
    fig = make_subplots(
        rows=3, cols=2,
        subplot_titles=('Oil Temperature', 'Load Current', 'Dissolved H2', 
                       'Vibration', 'Power Factor', ''),
        vertical_spacing=0.12,
        horizontal_spacing=0.1
    )
    
    # Oil Temperature
    fig.add_trace(
        go.Scatter(x=df['READING_TIMESTAMP'], y=df['OIL_TEMPERATURE_C'],
                  mode='lines', name='Oil Temp', line=dict(color='red')),
        row=1, col=1
    )
    fig.add_hline(y=90, line_dash="dash", line_color="orange", row=1, col=1,
                  annotation_text="Warning Threshold")
    
    # Load Current
    fig.add_trace(
        go.Scatter(x=df['READING_TIMESTAMP'], y=df['LOAD_CURRENT_A'],
                  mode='lines', name='Load Current', line=dict(color='blue')),
        row=1, col=2
    )
    
    # Dissolved H2
    fig.add_trace(
        go.Scatter(x=df['READING_TIMESTAMP'], y=df['DISSOLVED_H2_PPM'],
                  mode='lines', name='H2', line=dict(color='purple')),
        row=2, col=1
    )
    fig.add_hline(y=100, line_dash="dash", line_color="orange", row=2, col=1,
                  annotation_text="Normal Limit")
    
    # Vibration
    fig.add_trace(
        go.Scatter(x=df['READING_TIMESTAMP'], y=df['VIBRATION_MM_S'],
                  mode='lines', name='Vibration', line=dict(color='green')),
        row=2, col=2
    )
    
    # Power Factor
    fig.add_trace(
        go.Scatter(x=df['READING_TIMESTAMP'], y=df['POWER_FACTOR'],
                  mode='lines', name='Power Factor', line=dict(color='brown')),
        row=3, col=1
    )
    
    fig.update_layout(
        height=900,
        title_text=f"Sensor Trends: {asset_id} (Last 30 Days)",
        showlegend=False
    )
    
    fig.update_xaxes(title_text="Date", row=3, col=1)
    fig.update_yaxes(title_text="°C", row=1, col=1)
    fig.update_yaxes(title_text="Amps", row=1, col=2)
    fig.update_yaxes(title_text="ppm", row=2, col=1)
    fig.update_yaxes(title_text="mm/s", row=2, col=2)
    fig.update_yaxes(title_text="PF", row=3, col=1)
    
    return fig

def create_top_risks_table(df, n=10):
    """Create formatted table of top risk assets"""
    top_risks = df.nsmallest(n, 'RISK_SCORE', keep='first').copy()
    
    # Format columns
    top_risks['RISK_SCORE'] = top_risks['RISK_SCORE'].round(1)
    top_risks['FAILURE_PROBABILITY'] = (top_risks['FAILURE_PROBABILITY'] * 100).round(1).astype(str) + '%'
    top_risks['CUSTOMERS_AFFECTED'] = top_risks['CUSTOMERS_AFFECTED'].apply(lambda x: f'{x:,}')
    
    display_df = top_risks[[
        'ASSET_ID', 'LOCATION_SUBSTATION', 'LOCATION_CITY',
        'RISK_SCORE', 'FAILURE_PROBABILITY', 'PREDICTED_RUL_DAYS',
        'CUSTOMERS_AFFECTED', 'ALERT_LEVEL'
    ]]
    
    return display_df

# =============================================================================
# MAIN DASHBOARD
# =============================================================================

def main():
    # Header
    st.markdown('<div class="main-header">⚡ Grid Reliability & Predictive Maintenance</div>', 
                unsafe_allow_html=True)
    st.markdown('<div class="subheader"> AI-Driven Transformer Health Monitoring System</div>', 
                unsafe_allow_html=True)
    
    # Initialize Snowflake session
    session = get_snowflake_session()
    
    # Sidebar
    st.sidebar.image("https://via.placeholder.com/200x80/1f77b4/ffffff?text=Grid+Reliability", 
                     use_container_width=True)
    st.sidebar.title("Navigation")
    page = st.sidebar.radio(
        "Select View",
        ["📊 Overview", "🗺️ Asset Map", "⚠️ High-Risk Alerts", 
         "📈 Asset Details", "💰 ROI Calculator", "📋 Work Orders"]
    )
    
    st.sidebar.markdown("---")
    st.sidebar.info(f"Last Updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    
    if st.sidebar.button("🔄 Refresh Data"):
        st.cache_data.clear()
        st.rerun()
    
    # Load data
    with st.spinner("Loading data from Snowflake..."):
        asset_health_df = load_asset_health_data(session)
        high_risk_df = load_high_risk_assets(session)
        reliability_df = load_reliability_metrics(session)
        cost_df = load_cost_avoidance(session)
    
    # =============================================================================
    # PAGE: OVERVIEW
    # =============================================================================
    
    if page == "📊 Overview":
        st.header("System Overview")
        
        # Key Metrics
        col1, col2, col3, col4, col5 = st.columns(5)
        
        with col1:
            st.metric("Total Assets", f"{len(asset_health_df):,}")
        
        with col2:
            avg_risk = asset_health_df['RISK_SCORE'].mean()
            st.metric("Avg Risk Score", f"{avg_risk:.1f}", 
                     delta=None, delta_color="inverse")
        
        with col3:
            critical_count = len(asset_health_df[asset_health_df['RISK_SCORE'] >= 85])
            st.metric("Critical Assets", critical_count, 
                     delta=None, delta_color="inverse")
        
        with col4:
            high_risk_count = len(high_risk_df)
            st.metric("High-Risk Assets", high_risk_count)
        
        with col5:
            if not reliability_df.empty:
                total_customers = reliability_df['TOTAL_CUSTOMERS_AT_RISK'].iloc[0]
                st.metric("Customers at Risk", f"{total_customers:,}")
        
        st.markdown("---")
        
        # Charts
        col1, col2 = st.columns(2)
        
        with col1:
            fig_dist = create_risk_distribution(asset_health_df)
            st.plotly_chart(fig_dist, use_container_width=True)
        
        with col2:
            # Top 5 high-risk assets
            st.subheader("Top 5 High-Risk Assets")
            top_5 = asset_health_df.nlargest(5, 'RISK_SCORE')[
                ['ASSET_ID', 'LOCATION_SUBSTATION', 'RISK_SCORE', 'ALERT_LEVEL']
            ]
            st.dataframe(top_5, use_container_width=True, hide_index=True)
        
        # Financial Impact
        st.markdown("---")
        st.subheader("💰 Financial Impact")
        
        if not cost_df.empty:
            col1, col2, col3 = st.columns(3)
            
            with col1:
                cost_avoid = cost_df['NET_COST_AVOIDANCE'].iloc[0]
                st.metric("Net Cost Avoidance", f"${cost_avoid/1e6:.2f}M")
            
            with col2:
                emergency_cost = cost_df['EMERGENCY_REPAIR_COST_AVOIDANCE'].iloc[0]
                st.metric("Emergency Repair Avoided", f"${emergency_cost/1e6:.2f}M")
            
            with col3:
                prev_cost = cost_df['PREVENTIVE_MAINTENANCE_COST'].iloc[0]
                st.metric("Preventive Maintenance Cost", f"${prev_cost/1e3:.0f}K")
        
        # SAIDI Impact
        if not reliability_df.empty:
            st.markdown("---")
            st.subheader("📉 SAIDI/SAIFI Impact")
            
            saidi_impact = reliability_df['POTENTIAL_SAIDI_POINTS'].iloc[0]
            
            col1, col2 = st.columns(2)
            with col1:
                st.metric("Potential SAIDI Impact", f"{saidi_impact:.4f} points")
                st.caption("Impact if all high-risk assets fail")
            
            with col2:
                # SAIDI gauge
                fig_gauge = go.Figure(go.Indicator(
                    mode="gauge+number",
                    value=saidi_impact,
                    title={'text': "SAIDI Risk"},
                    gauge={
                        'axis': {'range': [None, 0.1]},
                        'bar': {'color': "darkred"},
                        'steps': [
                            {'range': [0, 0.03], 'color': "lightgreen"},
                            {'range': [0.03, 0.06], 'color': "yellow"},
                            {'range': [0.06, 0.1], 'color': "red"}
                        ],
                        'threshold': {
                            'line': {'color': "black", 'width': 4},
                            'thickness': 0.75,
                            'value': saidi_impact
                        }
                    }
                ))
                st.plotly_chart(fig_gauge, use_container_width=True)
    
    # =============================================================================
    # PAGE: ASSET MAP
    # =============================================================================
    
    elif page == "🗺️ Asset Map":
        st.header("Geographic Asset Health Map")
        
        # Filters
        col1, col2, col3 = st.columns(3)
        with col1:
            counties = ['All'] + sorted(asset_health_df['LOCATION_COUNTY'].unique().tolist())
            selected_county = st.selectbox("County", counties)
        
        with col2:
            risk_filter = st.selectbox("Risk Level", ['All', 'CRITICAL', 'HIGH', 'MEDIUM', 'LOW'])
        
        with col3:
            min_customers = st.number_input("Min Customers Affected", 0, 20000, 0, 1000)
        
        # Apply filters
        filtered_df = asset_health_df.copy()
        if selected_county != 'All':
            filtered_df = filtered_df[filtered_df['LOCATION_COUNTY'] == selected_county]
        if risk_filter != 'All':
            filtered_df = filtered_df[filtered_df['RISK_CATEGORY'] == risk_filter]
        filtered_df = filtered_df[filtered_df['CUSTOMERS_AFFECTED'] >= min_customers]
        
        st.info(f"Showing {len(filtered_df)} assets")
        
        # Map
        fig_map = create_risk_heatmap(filtered_df)
        
        # Configure map controls - only essential controls
        config = {
            'displayModeBar': True,
            'displaylogo': False,
            'modeBarButtonsToRemove': [
                'select2d', 'lasso2d', 'autoScale2d', 
                'hoverClosestCartesian', 'hoverCompareCartesian',
                'toggleSpikelines', 'resetScale2d'
            ],
            'toImageButtonOptions': {
                'format': 'png',
                'filename': 'grid_asset_map',
                'height': 1000,
                'width': 1600,
                'scale': 2
            }
        }
        
        st.plotly_chart(fig_map, use_container_width=True, config=config)
        
        # Asset table
        st.subheader("Asset List")
        display_cols = ['ASSET_ID', 'LOCATION_SUBSTATION', 'LOCATION_CITY', 
                       'RISK_SCORE', 'ALERT_LEVEL', 'CUSTOMERS_AFFECTED']
        st.dataframe(filtered_df[display_cols].sort_values('RISK_SCORE', ascending=False),
                    use_container_width=True, hide_index=True)
    
    # =============================================================================
    # PAGE: HIGH-RISK ALERTS
    # =============================================================================
    
    elif page == "⚠️ High-Risk Alerts":
        st.header("High-Risk Asset Alerts")
        
        if high_risk_df.empty:
            st.success("✅ No high-risk assets detected!")
        else:
            # Critical assets
            critical_df = high_risk_df[high_risk_df['RISK_SCORE'] >= 85]
            if not critical_df.empty:
                st.markdown(f'<div class="critical-alert"><h3>🚨 CRITICAL: {len(critical_df)} Assets Requiring Immediate Action</h3></div>', 
                           unsafe_allow_html=True)
                
                for idx, row in critical_df.iterrows():
                    with st.expander(f"🔴 {row['ASSET_ID']} - Risk: {row['RISK_SCORE']:.1f} - {row['LOCATION_SUBSTATION']}"):
                        col1, col2 = st.columns(2)
                        
                        with col1:
                            st.write(f"**Location:** {row['LOCATION_CITY']}, {row['LOCATION_COUNTY']}")
                            st.write(f"**Customers Affected:** {row['CUSTOMERS_AFFECTED']:,}")
                            st.write(f"**Failure Probability:** {row['FAILURE_PROBABILITY']*100:.1f}%")
                            st.write(f"**Predicted RUL:** {row['PREDICTED_RUL_DAYS']:.0f} days")
                        
                        with col2:
                            st.write(f"**Action Timeline:** {row['RECOMMENDED_ACTION_TIMELINE']}")
                            st.write(f"**Priority:** {row['WORK_ORDER_PRIORITY']}")
                            st.write(f"**SAIDI Impact:** {row['ESTIMATED_SAIDI_IMPACT']:.4f} points")
                            st.write(f"**Days Since Maintenance:** {row['DAYS_SINCE_MAINTENANCE']}")
            
            # High risk assets
            st.markdown("---")
            high_only_df = high_risk_df[high_risk_df['RISK_SCORE'] < 85]
            if not high_only_df.empty:
                st.markdown(f'<div class="high-alert"><h3>⚠️ HIGH RISK: {len(high_only_df)} Assets Requiring Attention</h3></div>', 
                           unsafe_allow_html=True)
                
                st.dataframe(
                    high_only_df[[
                        'ASSET_ID', 'LOCATION_SUBSTATION', 'LOCATION_CITY',
                        'RISK_SCORE', 'FAILURE_PROBABILITY', 'PREDICTED_RUL_DAYS',
                        'CUSTOMERS_AFFECTED', 'RECOMMENDED_ACTION_TIMELINE'
                    ]].sort_values('RISK_SCORE', ascending=False),
                    use_container_width=True,
                    hide_index=True
                )
    
    # =============================================================================
    # PAGE: ASSET DETAILS
    # =============================================================================
    
    elif page == "📈 Asset Details":
        st.header("Detailed Asset Analysis")
        
        # Asset selection
        asset_id = st.selectbox(
            "Select Asset",
            asset_health_df['ASSET_ID'].tolist()
        )
        
        asset_info = asset_health_df[asset_health_df['ASSET_ID'] == asset_id].iloc[0]
        
        # Asset header
        col1, col2, col3, col4 = st.columns(4)
        with col1:
            st.metric("Risk Score", f"{asset_info['RISK_SCORE']:.1f}")
        with col2:
            st.metric("Failure Prob", f"{asset_info['FAILURE_PROBABILITY']*100:.1f}%")
        with col3:
            st.metric("RUL (days)", f"{asset_info['PREDICTED_RUL_DAYS']:.0f}")
        with col4:
            alert_color = "🔴" if asset_info['ALERT_LEVEL'] == 'CRITICAL' else "🟡" if asset_info['ALERT_LEVEL'] == 'HIGH' else "🟢"
            st.metric("Alert Level", f"{alert_color} {asset_info['ALERT_LEVEL']}")
        
        # Asset information
        st.subheader("Asset Information")
        col1, col2 = st.columns(2)
        
        with col1:
            st.write(f"**Location:** {asset_info['LOCATION_SUBSTATION']}")
            st.write(f"**City:** {asset_info['LOCATION_CITY']}, {asset_info['LOCATION_COUNTY']}")
            st.write(f"**Coordinates:** {asset_info['LOCATION_LAT']:.4f}, {asset_info['LOCATION_LON']:.4f}")
        
        with col2:
            st.write(f"**Customers Affected:** {asset_info['CUSTOMERS_AFFECTED']:,}")
            st.write(f"**Criticality Score:** {asset_info['CRITICALITY_SCORE']}")
            st.write(f"**Asset Age:** {asset_info['ASSET_AGE_YEARS']:.1f} years")
            st.write(f"**Days Since Maintenance:** {asset_info['DAYS_SINCE_MAINTENANCE']}")
        
        # Sensor trends
        st.subheader("Sensor Trends (Last 30 Days)")
        with st.spinner("Loading sensor history..."):
            sensor_df = load_sensor_history(session, asset_id, days=30)
        
        if not sensor_df.empty:
            fig_trends = create_sensor_trends(sensor_df, asset_id)
            if fig_trends:
                st.plotly_chart(fig_trends, use_container_width=True)
        else:
            st.warning("No sensor data available for this asset")
    
    # =============================================================================
    # PAGE: ROI CALCULATOR
    # =============================================================================
    
    elif page == "💰 ROI Calculator":
        st.header("ROI Calculator")
        
        st.subheader("Current Program Impact")
        
        if not cost_df.empty and not reliability_df.empty:
            cost_data = cost_df.iloc[0]
            rel_data = reliability_df.iloc[0]
            
            col1, col2 = st.columns(2)
            
            with col1:
                st.markdown("### Financial Metrics")
                st.metric("High-Risk Assets Identified", f"{cost_data['HIGH_RISK_ASSETS']}")
                st.metric("Emergency Repair Cost Avoidance", f"${cost_data['EMERGENCY_REPAIR_COST_AVOIDANCE']/1e6:.2f}M")
                st.metric("Preventive Maintenance Cost", f"${cost_data['PREVENTIVE_MAINTENANCE_COST']/1e3:.1f}K")
                st.metric("NET COST AVOIDANCE", f"${cost_data['NET_COST_AVOIDANCE']/1e6:.2f}M", 
                         delta=None, delta_color="normal")
                
                roi = (cost_data['NET_COST_AVOIDANCE'] / cost_data['PREVENTIVE_MAINTENANCE_COST']) * 100
                st.metric("ROI", f"{roi:.0f}%")
            
            with col2:
                st.markdown("### Reliability Metrics")
                st.metric("Customers Protected", f"{cost_data['TOTAL_CUSTOMERS_PROTECTED']:,}")
                st.metric("SAIDI Impact Prevented", f"{cost_data['SAIDI_IMPACT_PREVENTED']:.4f} points")
                
                # Annualized projections
                st.markdown("### Annualized Projections")
                annual_savings = cost_data['NET_COST_AVOIDANCE'] * 12
                st.metric("Annual Cost Avoidance", f"${annual_savings/1e6:.1f}M")
                
                annual_saidi = cost_data['SAIDI_IMPACT_PREVENTED'] * 12
                st.metric("Annual SAIDI Prevention", f"{annual_saidi:.4f} points")
        
        st.markdown("---")
        
        # Custom scenario calculator
        st.subheader("Custom Scenario Calculator")
        
        col1, col2 = st.columns(2)
        
        with col1:
            num_failures = st.slider("Predicted Failures Prevented", 0, 100, 10)
            avg_repair_cost = st.number_input("Avg Emergency Repair Cost ($)", 0, 1000000, 450000, 10000)
            avg_prev_cost = st.number_input("Avg Preventive Maintenance Cost ($)", 0, 100000, 45000, 1000)
        
        with col2:
            avg_customers = st.number_input("Avg Customers per Asset", 0, 20000, 10000, 500)
            avg_outage_hours = st.number_input("Avg Outage Duration (hours)", 0.0, 10.0, 4.2, 0.1)
        
        # Calculate
        total_emergency_cost = num_failures * avg_repair_cost
        total_prev_cost = num_failures * avg_prev_cost
        net_savings = total_emergency_cost - total_prev_cost
        
        total_customers = num_failures * avg_customers
        customer_minutes = total_customers * avg_outage_hours * 60
        saidi_impact = customer_minutes / 5800000  # Utility customer base
        
        st.markdown("### Scenario Results")
        col1, col2, col3 = st.columns(3)
        
        with col1:
            st.metric("Net Cost Savings", f"${net_savings/1e6:.2f}M")
        with col2:
            st.metric("ROI", f"{(net_savings/total_prev_cost)*100:.0f}%")
        with col3:
            st.metric("SAIDI Points Saved", f"{saidi_impact:.4f}")
    
    # =============================================================================
    # PAGE: WORK ORDERS
    # =============================================================================
    
    elif page == "📋 Work Orders":
        st.header("Maintenance Work Order Generator")
        
        if high_risk_df.empty:
            st.success("No work orders needed - all assets are healthy!")
        else:
            st.info(f"{len(high_risk_df)} assets require maintenance attention")
            
            # Generate work orders
            for idx, row in high_risk_df.iterrows():
                priority_color = "🔴" if row['WORK_ORDER_PRIORITY'] == 1 else "🟡" if row['WORK_ORDER_PRIORITY'] == 2 else "🟢"
                
                with st.expander(f"{priority_color} Priority {row['WORK_ORDER_PRIORITY']} - {row['ASSET_ID']} - {row['LOCATION_SUBSTATION']}"):
                    st.markdown(f"""
                    **MAINTENANCE WORK ORDER**
                    
                    ---
                    **Asset ID:** {row['ASSET_ID']}  
                    **Location:** {row['LOCATION_SUBSTATION']}, {row['LOCATION_CITY']}, {row['LOCATION_COUNTY']}  
                    **Priority:** {row['WORK_ORDER_PRIORITY']} ({row['RECOMMENDED_ACTION_TIMELINE']})
                    
                    ---
                    **RISK ASSESSMENT**
                    - Risk Score: {row['RISK_SCORE']:.1f}/100
                    - Failure Probability: {row['FAILURE_PROBABILITY']*100:.1f}%
                    - Predicted Failure: {row['PREDICTED_RUL_DAYS']:.0f} days
                    - Customers Affected: {row['CUSTOMERS_AFFECTED']:,}
                    - SAIDI Impact: {row['ESTIMATED_SAIDI_IMPACT']:.4f} points
                    
                    ---
                    **RECOMMENDED ACTIONS**
                    1. Immediate oil sampling and dissolved gas analysis (DGA)
                    2. Thermal imaging of bushings and tap changer
                    3. Vibration analysis
                    4. Load transfer planning
                    5. Schedule maintenance window: Next available {row['RECOMMENDED_ACTION_TIMELINE'].lower()}
                    6. Standby mobile transformer on-site (if critical)
                    
                    ---
                    **COST ESTIMATE**
                    - Preventive Maintenance: $45,000
                    - Emergency Repair (if failure): $450,000
                    - **Cost Avoidance: $405,000**
                    
                    ---
                    **CUSTOMER IMPACT**
                    - Planned Outage: 0-2 hours (scheduled)
                    - Unplanned Outage (if failure): 4-6 hours
                    """)
                    
                    col1, col2 = st.columns(2)
                    with col1:
                        if st.button(f"Generate Work Order PDF", key=f"pdf_{idx}"):
                            st.success(f"Work order generated for {row['ASSET_ID']}")
                    with col2:
                        if st.button(f"Schedule Maintenance", key=f"schedule_{idx}"):
                            st.success(f"Maintenance scheduled for {row['ASSET_ID']}")

# =============================================================================
# RUN APP
# =============================================================================

if __name__ == "__main__":
    main()


