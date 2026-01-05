#!/usr/bin/env python3
"""
Generate architecture diagram images for the Grid Reliability Solution

This script creates professional architecture diagrams using the diagrams library.
"""

import os
from pathlib import Path

try:
    from diagrams import Diagram, Cluster, Edge
    from diagrams.custom import Custom
    from diagrams.onprem.database import PostgreSQL
    from diagrams.onprem.analytics import Snowflake
    from diagrams.programming.language import Python
    from diagrams.generic.storage import Storage
    from diagrams.generic.compute import Rack
    from diagrams.generic.blank import Blank
    DIAGRAMS_AVAILABLE = True
except ImportError:
    DIAGRAMS_AVAILABLE = False
    print("⚠️  'diagrams' library not available. Installing...")
    print("   Run: pip install diagrams")

# For fallback - create text-based diagrams using matplotlib
try:
    import matplotlib.pyplot as plt
    import matplotlib.patches as mpatches
    from matplotlib.patches import FancyBboxPatch, Rectangle, FancyArrowPatch
    MATPLOTLIB_AVAILABLE = True
except ImportError:
    MATPLOTLIB_AVAILABLE = False
    print("⚠️  'matplotlib' library not available.")

# Snowflake colors
SNOWFLAKE_BLUE = '#29B5E8'
SUCCESS_GREEN = '#47D147'
WARNING_YELLOW = '#FFA500'
ALERT_RED = '#FF4444'
LIGHT_GRAY = '#F5F7FA'
DARK_GRAY = '#4A4A4A'

# Create images directory
images_dir = Path(__file__).parent / "images"
images_dir.mkdir(exist_ok=True)


def create_architecture_overview_matplotlib():
    """Create architecture overview diagram using matplotlib"""
    fig, ax = plt.subplots(figsize=(16, 10))
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Title
    ax.text(8, 9.5, 'Grid Reliability Platform Architecture', 
            ha='center', va='top', fontsize=20, fontweight='bold', color=DARK_GRAY)
    
    # Data Sources (Left)
    sources_x, sources_y = 1.5, 5
    sources = [
        ('SCADA\nSensors', 7.5),
        ('Asset\nSystems', 6),
        ('Maintenance\nLogs', 4.5),
        ('Technical\nManuals', 3),
        ('Visual\nInspections', 1.5)
    ]
    
    for i, (label, y_offset) in enumerate(sources):
        box = FancyBboxPatch((0.5, y_offset - 0.4), 2, 0.8, 
                             boxstyle="round,pad=0.1", 
                             facecolor=LIGHT_GRAY, edgecolor=DARK_GRAY, linewidth=2)
        ax.add_patch(box)
        ax.text(1.5, y_offset, label, ha='center', va='center', 
                fontsize=10, fontweight='bold')
    
    # Snowflake Platform (Center)
    platform_box = FancyBboxPatch((3.5, 1), 9, 7.5, 
                                  boxstyle="round,pad=0.2", 
                                  facecolor='white', edgecolor=SNOWFLAKE_BLUE, linewidth=3)
    ax.add_patch(platform_box)
    ax.text(8, 8.2, 'SNOWFLAKE AI DATA CLOUD', 
            ha='center', va='center', fontsize=14, fontweight='bold', color=SNOWFLAKE_BLUE)
    
    # Layers inside Snowflake
    layers = [
        ('RAW (Bronze)\nAssets • Sensors • Maintenance', 6.8, '#E8F4F8'),
        ('FEATURES (Silver)\nEngineering • Degradation', 5.6, '#D4EBF7'),
        ('ML\nXGBoost • Isolation Forest • RUL', 4.4, '#B8DDF0'),
        ('ANALYTICS (Gold)\nScorecard • Metrics • Cost Avoid', 3.2, '#9DCFE8'),
        ('UNSTRUCTURED\nDocs • Images • CV Detections', 2.0, '#E8F4F8')
    ]
    
    for label, y_pos, color in layers:
        box = FancyBboxPatch((4, y_pos - 0.35), 8, 0.7, 
                             boxstyle="round,pad=0.05", 
                             facecolor=color, edgecolor=SNOWFLAKE_BLUE, linewidth=1.5)
        ax.add_patch(box)
        ax.text(8, y_pos, label, ha='center', va='center', 
                fontsize=9, fontweight='bold')
    
    # Outputs (Right)
    outputs = [
        ('Intelligence\nAgent', 7),
        ('Cortex\nSearch', 5.5),
        ('Dashboards\n& Reports', 4),
        ('API\nIntegrations', 2.5)
    ]
    
    for label, y_offset in outputs:
        box = FancyBboxPatch((13, y_offset - 0.4), 2.5, 0.8, 
                             boxstyle="round,pad=0.1", 
                             facecolor=SUCCESS_GREEN, edgecolor=DARK_GRAY, 
                             linewidth=2, alpha=0.7)
        ax.add_patch(box)
        ax.text(14.25, y_offset, label, ha='center', va='center', 
                fontsize=10, fontweight='bold', color='white')
    
    # Arrows from sources to platform
    for _, y_offset in sources:
        arrow = FancyArrowPatch((2.5, y_offset), (3.5, 5), 
                               arrowstyle='->', mutation_scale=20, 
                               linewidth=2, color=DARK_GRAY, alpha=0.6)
        ax.add_patch(arrow)
    
    # Arrows from platform to outputs
    for _, y_offset in outputs:
        arrow = FancyArrowPatch((12.5, 5), (13, y_offset), 
                               arrowstyle='->', mutation_scale=20, 
                               linewidth=2, color=DARK_GRAY, alpha=0.6)
        ax.add_patch(arrow)
    
    plt.savefig(images_dir / 'architecture_overview.png', dpi=300, bbox_inches='tight', 
                facecolor='white', edgecolor='none')
    plt.close()
    print("✅ Created architecture_overview.png")


def create_data_pipeline_matplotlib():
    """Create data pipeline diagram using matplotlib"""
    fig, ax = plt.subplots(figsize=(16, 8))
    ax.set_xlim(0, 16)
    ax.set_ylim(0, 8)
    ax.axis('off')
    
    # Title
    ax.text(8, 7.5, 'Data Pipeline: Medallion Architecture', 
            ha='center', va='top', fontsize=20, fontweight='bold', color=DARK_GRAY)
    
    # Bronze Layer
    bronze_box = FancyBboxPatch((0.5, 4), 4, 2.5, 
                                boxstyle="round,pad=0.1", 
                                facecolor='#CD7F32', edgecolor=DARK_GRAY, 
                                linewidth=2, alpha=0.3)
    ax.add_patch(bronze_box)
    ax.text(2.5, 6.2, 'BRONZE (RAW)', ha='center', va='center', 
            fontsize=12, fontweight='bold', color='#8B4513')
    
    bronze_items = [
        'Asset Master',
        'Sensor Readings',
        'Maintenance History',
        'Failure Events',
        'Documents'
    ]
    for i, item in enumerate(bronze_items):
        ax.text(2.5, 5.6 - i*0.3, f'• {item}', ha='center', va='center', 
                fontsize=9)
    
    # Silver Layer
    silver_box = FancyBboxPatch((5.5, 4), 4, 2.5, 
                                boxstyle="round,pad=0.1", 
                                facecolor='#C0C0C0', edgecolor=DARK_GRAY, 
                                linewidth=2, alpha=0.3)
    ax.add_patch(silver_box)
    ax.text(7.5, 6.2, 'SILVER (FEATURES)', ha='center', va='center', 
            fontsize=12, fontweight='bold', color='#696969')
    
    silver_items = [
        'Rolling Statistics',
        'Degradation Indicators',
        'Thermal Rise Calc',
        'Load Utilization',
        'NLP Processing'
    ]
    for i, item in enumerate(silver_items):
        ax.text(7.5, 5.6 - i*0.3, f'• {item}', ha='center', va='center', 
                fontsize=9)
    
    # Gold Layer
    gold_box = FancyBboxPatch((10.5, 4), 4, 2.5, 
                              boxstyle="round,pad=0.1", 
                              facecolor='#FFD700', edgecolor=DARK_GRAY, 
                              linewidth=2, alpha=0.3)
    ax.add_patch(gold_box)
    ax.text(12.5, 6.2, 'GOLD (ML + ANALYTICS)', ha='center', va='center', 
            fontsize=12, fontweight='bold', color='#B8860B')
    
    gold_items = [
        'ML Predictions',
        'Asset Scorecards',
        'Cost Avoidance',
        'Reliability Metrics',
        'Semantic Views'
    ]
    for i, item in enumerate(gold_items):
        ax.text(12.5, 5.6 - i*0.3, f'• {item}', ha='center', va='center', 
                fontsize=9)
    
    # Data Quality bars
    dq_y = 2.5
    ax.text(2.5, dq_y + 0.3, 'Data Quality:', ha='center', va='center', 
            fontsize=10, fontweight='bold')
    ax.text(2.5, dq_y, 'Ingestion', ha='center', va='center', fontsize=9)
    
    ax.text(7.5, dq_y + 0.3, 'Data Quality:', ha='center', va='center', 
            fontsize=10, fontweight='bold')
    ax.text(7.5, dq_y, 'Transformation', ha='center', va='center', fontsize=9)
    
    ax.text(12.5, dq_y + 0.3, 'Data Quality:', ha='center', va='center', 
            fontsize=10, fontweight='bold')
    ax.text(12.5, dq_y, 'Enrichment', ha='center', va='center', fontsize=9)
    
    # Arrows between layers
    arrow1 = FancyArrowPatch((4.5, 5.2), (5.5, 5.2), 
                            arrowstyle='->', mutation_scale=30, 
                            linewidth=3, color=SNOWFLAKE_BLUE)
    ax.add_patch(arrow1)
    
    arrow2 = FancyArrowPatch((9.5, 5.2), (10.5, 5.2), 
                            arrowstyle='->', mutation_scale=30, 
                            linewidth=3, color=SNOWFLAKE_BLUE)
    ax.add_patch(arrow2)
    
    # Bottom legend
    ax.text(8, 0.8, 'Structured + Unstructured Data → Feature Engineering → AI/ML Models → Business Insights', 
            ha='center', va='center', fontsize=11, style='italic', color=DARK_GRAY)
    
    plt.savefig(images_dir / 'data_pipeline.png', dpi=300, bbox_inches='tight', 
                facecolor='white', edgecolor='none')
    plt.close()
    print("✅ Created data_pipeline.png")


def create_ml_models_matplotlib():
    """Create ML models diagram using matplotlib"""
    fig, ax = plt.subplots(figsize=(14, 10))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Title
    ax.text(7, 9.5, 'Machine Learning Pipeline', 
            ha='center', va='top', fontsize=20, fontweight='bold', color=DARK_GRAY)
    
    # Feature Engineering
    feature_box = FancyBboxPatch((1, 7), 3.5, 1.5, 
                                 boxstyle="round,pad=0.1", 
                                 facecolor='#E8F4F8', edgecolor=SNOWFLAKE_BLUE, linewidth=2)
    ax.add_patch(feature_box)
    ax.text(2.75, 8.3, 'Feature Engineering', ha='center', va='center', 
            fontsize=11, fontweight='bold')
    ax.text(2.75, 7.8, '• Rolling statistics', ha='center', va='center', fontsize=8)
    ax.text(2.75, 7.5, '• Degradation indicators', ha='center', va='center', fontsize=8)
    ax.text(2.75, 7.2, '• Thermal calculations', ha='center', va='center', fontsize=8)
    
    # Three ML Models
    models = [
        ('XGBoost Classifier', 'Failure Prediction', '• Probability: 0-100%\n• Alert: LOW/HIGH/CRITICAL', 5.5),
        ('Isolation Forest', 'Anomaly Detection', '• Anomaly Score\n• Anomaly Flag', 4),
        ('Linear Regression', 'RUL Estimation', '• Predicted RUL (days)\n• Confidence Interval', 2.5)
    ]
    
    for title, subtitle, features, y_pos in models:
        model_box = FancyBboxPatch((5.5, y_pos - 0.5), 3.5, 1.2, 
                                   boxstyle="round,pad=0.1", 
                                   facecolor='#B8DDF0', edgecolor=SNOWFLAKE_BLUE, linewidth=2)
        ax.add_patch(model_box)
        ax.text(7.25, y_pos + 0.5, title, ha='center', va='center', 
                fontsize=10, fontweight='bold')
        ax.text(7.25, y_pos + 0.2, subtitle, ha='center', va='center', 
                fontsize=9, style='italic')
        ax.text(7.25, y_pos - 0.2, features, ha='center', va='center', fontsize=7)
        
        # Arrow from features to model
        arrow = FancyArrowPatch((4.5, 7.5), (5.5, y_pos + 0.1), 
                               arrowstyle='->', mutation_scale=20, 
                               linewidth=2, color=DARK_GRAY, alpha=0.6)
        ax.add_patch(arrow)
    
    # Scoring & Predictions
    scoring_box = FancyBboxPatch((10, 5.5), 3, 2.5, 
                                 boxstyle="round,pad=0.1", 
                                 facecolor='#9DCFE8', edgecolor=SNOWFLAKE_BLUE, linewidth=2)
    ax.add_patch(scoring_box)
    ax.text(11.5, 7.6, 'Model Predictions', ha='center', va='center', 
            fontsize=11, fontweight='bold')
    ax.text(11.5, 7.2, '• High-risk assets', ha='left', va='center', fontsize=8)
    ax.text(11.5, 6.9, '• Alert levels', ha='left', va='center', fontsize=8)
    ax.text(11.5, 6.6, '• Anomaly detection', ha='left', va='center', fontsize=8)
    ax.text(11.5, 6.3, '• Maintenance schedule', ha='left', va='center', fontsize=8)
    ax.text(11.5, 6.0, '• Cost avoidance', ha='left', va='center', fontsize=8)
    ax.text(11.5, 5.7, '• Reliability metrics', ha='left', va='center', fontsize=8)
    
    # Arrows from models to scoring
    for _, _, _, y_pos in models:
        arrow = FancyArrowPatch((9, y_pos + 0.1), (10, 6.5), 
                               arrowstyle='->', mutation_scale=20, 
                               linewidth=2, color=DARK_GRAY, alpha=0.6)
        ax.add_patch(arrow)
    
    # Model Training Info
    training_box = FancyBboxPatch((1, 1), 12, 1, 
                                  boxstyle="round,pad=0.1", 
                                  facecolor=LIGHT_GRAY, edgecolor=DARK_GRAY, linewidth=1)
    ax.add_patch(training_box)
    ax.text(7, 1.7, 'Model Training & Validation', ha='center', va='center', 
            fontsize=10, fontweight='bold')
    ax.text(7, 1.3, 'Historical Data: 432K+ sensor readings • 192 maintenance records • 10 failure events | '
                    'Validation: 80/20 train-test split • Cross-validation', 
            ha='center', va='center', fontsize=8)
    
    plt.savefig(images_dir / 'ml_models.png', dpi=300, bbox_inches='tight', 
                facecolor='white', edgecolor='none')
    plt.close()
    print("✅ Created ml_models.png")


def create_medallion_architecture_matplotlib():
    """Create medallion architecture diagram"""
    fig, ax = plt.subplots(figsize=(14, 10))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Title
    ax.text(7, 9.5, 'Snowflake Medallion Architecture', 
            ha='center', va='top', fontsize=20, fontweight='bold', color=DARK_GRAY)
    
    schemas = [
        ('RAW', 8, '#CD7F32', ['ASSET_MASTER', 'SENSOR_READINGS', 'MAINTENANCE_HISTORY', 'FAILURE_EVENTS']),
        ('FEATURES', 6.5, '#C0C0C0', ['ASSET_FEATURES', 'SENSOR_FEATURES', 'DEGRADATION_INDICATORS']),
        ('ML', 5, SNOWFLAKE_BLUE, ['TRAINING_DATA', 'MODEL_PREDICTIONS', 'ANOMALY_SCORES']),
        ('ANALYTICS', 3.5, '#FFD700', ['VW_ASSET_HEALTH_SCORECARD', 'VW_MAINTENANCE_OPTIMIZATION', 'VW_COST_AVOIDANCE']),
        ('UNSTRUCTURED', 2, SUCCESS_GREEN, ['MAINTENANCE_LOG_DOCUMENTS', 'TECHNICAL_MANUALS', 'VISUAL_INSPECTIONS', 'CV_DETECTIONS']),
        ('STAGING', 0.5, LIGHT_GRAY, ['FILE_FORMATS', 'STAGES', 'TEMPORARY_TABLES'])
    ]
    
    for schema_name, y_pos, color, tables in schemas:
        # Schema box
        box_height = 0.8
        schema_box = FancyBboxPatch((1, y_pos - box_height/2), 12, box_height, 
                                    boxstyle="round,pad=0.05", 
                                    facecolor=color, edgecolor=DARK_GRAY, 
                                    linewidth=2, alpha=0.3)
        ax.add_patch(schema_box)
        
        # Schema name
        text_color = 'white' if schema_name in ['ML'] else DARK_GRAY
        ax.text(1.5, y_pos, schema_name, ha='left', va='center', 
                fontsize=12, fontweight='bold', color=text_color)
        
        # Tables
        table_text = ' • '.join(tables[:3])
        if len(tables) > 3:
            table_text += f' • +{len(tables)-3} more'
        ax.text(7, y_pos, table_text, ha='center', va='center', 
                fontsize=8, style='italic', color=DARK_GRAY)
    
    # Data flow arrows
    arrow_x = 13.5
    for i in range(len(schemas) - 2):
        y1 = schemas[i][1]
        y2 = schemas[i+1][1]
        arrow = FancyArrowPatch((arrow_x, y1 - 0.3), (arrow_x, y2 + 0.3), 
                               arrowstyle='->', mutation_scale=20, 
                               linewidth=2, color=SNOWFLAKE_BLUE)
        ax.add_patch(arrow)
    
    plt.savefig(images_dir / 'medallion_architecture.png', dpi=300, bbox_inches='tight', 
                facecolor='white', edgecolor='none')
    plt.close()
    print("✅ Created medallion_architecture.png")


def create_unstructured_integration_matplotlib():
    """Create unstructured data integration diagram"""
    fig, ax = plt.subplots(figsize=(14, 10))
    ax.set_xlim(0, 14)
    ax.set_ylim(0, 10)
    ax.axis('off')
    
    # Title
    ax.text(7, 9.5, 'Unstructured Data Integration', 
            ha='center', va='top', fontsize=20, fontweight='bold', color=DARK_GRAY)
    
    # Data Sources
    sources = [
        ('Maintenance\nLogs', 8, '80 PDFs'),
        ('Technical\nManuals', 6.5, '15 Documents'),
        ('Visual\nInspections', 5, '150 Records'),
        ('CV\nDetections', 3.5, '281 Findings')
    ]
    
    for label, y_pos, count in sources:
        box = FancyBboxPatch((0.5, y_pos - 0.4), 2, 0.8, 
                             boxstyle="round,pad=0.1", 
                             facecolor=LIGHT_GRAY, edgecolor=DARK_GRAY, linewidth=2)
        ax.add_patch(box)
        ax.text(1.5, y_pos + 0.1, label, ha='center', va='center', 
                fontsize=9, fontweight='bold')
        ax.text(1.5, y_pos - 0.2, count, ha='center', va='center', 
                fontsize=7, style='italic')
    
    # Processing Layer
    process_box = FancyBboxPatch((3.5, 2.5), 3, 5, 
                                 boxstyle="round,pad=0.1", 
                                 facecolor='#E8F4F8', edgecolor=SNOWFLAKE_BLUE, linewidth=2)
    ax.add_patch(process_box)
    ax.text(5, 7.2, 'Processing', ha='center', va='center', 
            fontsize=11, fontweight='bold', color=SNOWFLAKE_BLUE)
    
    processes = [
        'Text Extraction',
        'NLP Analysis',
        'Image Processing',
        'Metadata Tagging',
        'Quality Checks'
    ]
    for i, proc in enumerate(processes):
        ax.text(5, 6.6 - i*0.6, f'• {proc}', ha='center', va='center', fontsize=8)
    
    # Cortex Search
    search_box = FancyBboxPatch((7.5, 4), 2.5, 2, 
                                boxstyle="round,pad=0.1", 
                                facecolor='#B8DDF0', edgecolor=SNOWFLAKE_BLUE, linewidth=2)
    ax.add_patch(search_box)
    ax.text(8.75, 5.7, 'Cortex Search', ha='center', va='center', 
            fontsize=10, fontweight='bold')
    ax.text(8.75, 5.3, 'Semantic Search', ha='center', va='center', fontsize=8)
    ax.text(8.75, 4.9, 'Vector Embeddings', ha='center', va='center', fontsize=8)
    ax.text(8.75, 4.5, 'Relevance Ranking', ha='center', va='center', fontsize=8)
    ax.text(8.75, 4.1, 'Context Retrieval', ha='center', va='center', fontsize=8)
    
    # Intelligence Agent
    agent_box = FancyBboxPatch((11, 4), 2.5, 2, 
                               boxstyle="round,pad=0.1", 
                               facecolor=SUCCESS_GREEN, edgecolor=DARK_GRAY, 
                               linewidth=2, alpha=0.7)
    ax.add_patch(agent_box)
    ax.text(12.25, 5.7, 'Intelligence', ha='center', va='center', 
            fontsize=10, fontweight='bold', color='white')
    ax.text(12.25, 5.4, 'Agent', ha='center', va='center', 
            fontsize=10, fontweight='bold', color='white')
    ax.text(12.25, 4.8, 'Natural Language', ha='center', va='center', 
            fontsize=8, color='white')
    ax.text(12.25, 4.4, 'Queries', ha='center', va='center', 
            fontsize=8, color='white')
    
    # Arrows
    for _, y_pos, _ in sources:
        arrow = FancyArrowPatch((2.5, y_pos), (3.5, 5), 
                               arrowstyle='->', mutation_scale=15, 
                               linewidth=1.5, color=DARK_GRAY, alpha=0.6)
        ax.add_patch(arrow)
    
    arrow1 = FancyArrowPatch((6.5, 5), (7.5, 5), 
                            arrowstyle='->', mutation_scale=20, 
                            linewidth=2, color=SNOWFLAKE_BLUE)
    ax.add_patch(arrow1)
    
    arrow2 = FancyArrowPatch((10, 5), (11, 5), 
                            arrowstyle='->', mutation_scale=20, 
                            linewidth=2, color=SNOWFLAKE_BLUE)
    ax.add_patch(arrow2)
    
    # Use Cases
    ax.text(7, 1.5, 'Example Queries:', ha='center', va='center', 
            fontsize=10, fontweight='bold')
    queries = [
        '"Find maintenance logs mentioning oil degradation"',
        '"Show technical manuals for GE transformers with high vibration"',
        '"Which assets have thermal inspection images showing hotspots?"'
    ]
    for i, query in enumerate(queries):
        ax.text(7, 1 - i*0.3, query, ha='center', va='center', 
                fontsize=7, style='italic')
    
    plt.savefig(images_dir / 'unstructured_integration.png', dpi=300, bbox_inches='tight', 
                facecolor='white', edgecolor='none')
    plt.close()
    print("✅ Created unstructured_integration.png")


def main():
    """Generate all architecture diagrams"""
    print("🎨 Generating Grid Reliability Architecture Diagrams...")
    print()
    
    if not MATPLOTLIB_AVAILABLE:
        print("❌ matplotlib is required to generate diagrams")
        print("   Run: pip install matplotlib")
        return
    
    # Generate all diagrams
    create_architecture_overview_matplotlib()
    create_data_pipeline_matplotlib()
    create_ml_models_matplotlib()
    create_medallion_architecture_matplotlib()
    create_unstructured_integration_matplotlib()
    
    print()
    print("✨ All diagrams generated successfully!")
    print(f"📁 Location: {images_dir}")
    print()
    print("Generated files:")
    for img_file in sorted(images_dir.glob("*.png")):
        print(f"  ✓ {img_file.name}")


if __name__ == "__main__":
    main()
