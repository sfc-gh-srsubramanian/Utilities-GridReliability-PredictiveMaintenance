# Architecture Diagram Images

## Placeholder Images

This folder contains placeholder images for the Grid Reliability solution presentation.

## Creating Actual Diagrams

Replace these placeholders with actual architecture diagrams created using:

1. **draw.io (diagrams.net)** - Free, open-source
   - Use the existing Grid_Architecture.drawio file in docs/architecture/
   - Export as PNG with transparent background
   - Recommended size: 1920x1080 or 2560x1440

2. **Lucidchart** - Professional diagramming tool
   - Import Snowflake shapes library
   - Use consistent color scheme (Snowflake blue: #29B5E8)
   - Export as high-res PNG

3. **Figma** - Design tool with diagramming capabilities
   - Use Snowflake design assets
   - Collaborate with team in real-time

## Recommended Diagrams

### 1. architecture_overview.png
- High-level system architecture
- Show: Data sources → Snowflake (layers) → Analytics/AI → Outputs
- Include: SCADA, Asset systems, Documents → RAW/FEATURES/ML/ANALYTICS → Dashboards/Agents

### 2. data_pipeline.png
- Detailed data flow through medallion architecture
- Show: Bronze (RAW) → Silver (FEATURES) → Gold (ML + ANALYTICS)
- Include: Data quality, transformations, enrichment steps

### 3. ml_models.png
- Machine learning pipeline
- Show: Feature engineering → Model training → Scoring → Predictions
- Include: XGBoost, Isolation Forest, Linear Regression models

### 4. medallion_architecture.png
- Snowflake medallion architecture layers
- Show: RAW, FEATURES, ML, ANALYTICS, UNSTRUCTURED schemas
- Include: Data flow and dependencies

### 5. unstructured_integration.png
- Unstructured data integration architecture
- Show: Documents/Images → Extraction → NLP/CV → Cortex Search → Intelligence Agents
- Include: Maintenance logs, manuals, visual inspections, CV detections

## Design Guidelines

**Colors:**
- Snowflake Blue: #29B5E8
- Success Green: #47D147
- Warning Yellow: #FFA500
- Alert Red: #FF4444
- Background: White or light gray (#F5F7FA)

**Fonts:**
- Headings: Montserrat Bold
- Body: Open Sans Regular
- Code: Courier New or Monaco

**Icons:**
- Use Snowflake official icons where possible
- Keep icon style consistent (line vs. solid)
- Size icons proportionally

**Layout:**
- Left-to-right flow for data pipelines
- Top-to-bottom for hierarchies
- Group related components visually
- Use whitespace effectively

## Export Settings

- **Format**: PNG with transparent background
- **Resolution**: 300 DPI or higher
- **Width**: 1920px minimum (2560px for 4K displays)
- **Compression**: Use PNG-24 for best quality

## Quick Start with draw.io

```bash
# 1. Open existing architecture diagram
open ../../docs/architecture/Grid_Architecture.drawio

# 2. Select specific layer/page to export
# File → Export as → PNG

# 3. Settings:
#    - Zoom: 100%
#    - Border Width: 10px
#    - Transparent Background: Yes
#    - Width: 2560px

# 4. Save to this folder with appropriate name
```

## Automation (Optional)

For automated diagram generation from code (advanced):

- **Diagrams as Code**: Use Python `diagrams` library
- **Mermaid**: Text-based diagrams in Markdown
- **PlantUML**: Text-based UML diagrams

Example with Python diagrams library:
```python
from diagrams import Diagram, Cluster
from diagrams.onprem.analytics import Snowflake
from diagrams.generic.storage import Storage

with Diagram("Grid Reliability Architecture", show=False, direction="LR"):
    # Define your architecture here
    pass
```
