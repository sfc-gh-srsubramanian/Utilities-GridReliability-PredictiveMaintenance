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
    # Extract unique cities with their coordinates
    city_locations = df.groupby('LOCATION_CITY').agg({
        'LOCATION_LAT': 'mean',
        'LOCATION_LON': 'mean',
        'ASSET_ID': 'count'
    }).reset_index()
    city_locations.columns = ['CITY', 'LAT', 'LON', 'ASSET_COUNT']
    
    # Extract county statistics
    county_stats = df.groupby('LOCATION_COUNTY').agg({
        'LOCATION_LAT': 'mean',
        'LOCATION_LON': 'mean',
        'RISK_SCORE': 'mean',
        'ASSET_ID': 'count',
        'CUSTOMERS_AFFECTED': 'sum'
    }).reset_index()
    
    # Create base scatter mapbox with enhanced styling
    fig = px.scatter_mapbox(
        df,
        lat='LOCATION_LAT',
        lon='LOCATION_LON',
        color='RISK_SCORE',
        size='CUSTOMERS_AFFECTED',
        hover_name='ASSET_ID',
        hover_data={
            'LOCATION_SUBSTATION': True,
            'LOCATION_CITY': True,
            'LOCATION_COUNTY': True,
            'RISK_SCORE': ':.1f',
            'CUSTOMERS_AFFECTED': ':,',
            'ALERT_LEVEL': True,
            'LOCATION_LAT': False,
            'LOCATION_LON': False
        },
        color_continuous_scale=[
            [0, 'green'],
            [0.40, 'yellow'],
            [0.70, 'orange'],
            [0.85, 'red']
        ],
        range_color=[0, 100],
        zoom=6,
        height=600,
        title="Florida Grid Assets - Risk Score Heatmap"
    )
    
    # Enhance asset markers for better visibility
    fig.update_traces(
        marker=dict(
            sizemode='diameter',
            sizemin=4,
            opacity=0.8,
            line=dict(width=1, color='white')
        )
    )
    
    # Add city markers layer (data-driven)
    fig.add_trace(go.Scattermapbox(
        lat=city_locations['LAT'],
        lon=city_locations['LON'],
        mode='markers+text',
        marker=dict(
            size=12,
            color='navy',
            symbol='circle',
            opacity=0.9
        ),
        text=city_locations['CITY'],
        textposition='top center',
        textfont=dict(
            size=11,
            color='darkblue',
            family='Arial Black'
        ),
        name='Cities',
        hovertemplate='<b>%{text}</b><br>Assets: %{customdata}<extra></extra>',
        customdata=city_locations['ASSET_COUNT'],
        showlegend=True
    ))
    
    # Add county labels layer (background, larger text)
    county_labels = [
        f"{row['LOCATION_COUNTY']}<br>({row['ASSET_ID']} assets, Avg Risk: {row['RISK_SCORE']:.1f})"
        for _, row in county_stats.iterrows()
    ]
    
    fig.add_trace(go.Scattermapbox(
        lat=county_stats['LOCATION_LAT'],
        lon=county_stats['LOCATION_LON'],
        mode='text',
        text=county_labels,
        textfont=dict(
            size=9,
            color='rgba(60,60,60,0.5)',
            family='Arial'
        ),
        name='Counties',
        showlegend=True,
        hovertemplate='<b>%{text}</b><extra></extra>'
    ))
    
    # Try stamen-terrain for better geographic context, fallback to carto-positron
    fig.update_layout(
        mapbox_style="stamen-terrain",
        mapbox_center={
            "lat": df['LOCATION_LAT'].mean(),
            "lon": df['LOCATION_LON'].mean()
        },
        margin={"r": 0, "t": 40, "l": 0, "b": 0},
        legend=dict(
            yanchor="top",
            y=0.99,
            xanchor="left",
            x=0.01,
            bgcolor="rgba(255,255,255,0.8)"
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
        st.plotly_chart(fig_map, use_container_width=True)
        
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


