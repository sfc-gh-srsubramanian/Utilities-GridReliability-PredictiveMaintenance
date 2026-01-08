# Google Slides Generation Guide

This directory contains tools to create a professional Google Slides presentation for the Grid Reliability & Predictive Maintenance solution using Snowflake brand colors.

## 📋 Quick Start (Recommended Method)

### Method 1: PowerPoint Generation → Upload to Google Slides

**✅ Easiest and fastest method - no OAuth setup required!**

#### Step 1: Install Dependencies

```bash
cd solution_presentation
pip install python-pptx
```

#### Step 2: Generate PowerPoint

```bash
python create_powerpoint.py
```

This creates `Grid_Reliability_Snowflake_Presentation.pptx` with:
- Snowflake brand colors (#29B5E8 blue, #24323D winter, etc.)
- Professional layouts
- First 5 slides created (title + 4 content slides)

#### Step 3: Upload to Google Slides

1. Go to [Google Drive](https://drive.google.com/)
2. Click "New" → "File upload"
3. Select `Grid_Reliability_Snowflake_Presentation.pptx`
4. Once uploaded, right-click the file
5. Select "Open with" → "Google Slides"
6. Done! 🎉

---

## 🎨 Snowflake Brand Colors Used

The presentation uses the official Snowflake color palette from `SNOWFLAKE_COLOR_SCHEME.md`:

### Primary Colors
- **Snowflake Blue** (#29B5E8) - Used 80% of the time (headers, accents)
- **Mid Blue** (#11567F) - Contrasting blue for depth (subtitles)
- **Midnight** (#000000) - Text and serious business

### Secondary Colors (Accents)
- **Star Blue** (#71D3DC) - Accent highlights
- **Valencia Orange** (#FF9F36) - Call-to-action elements
- **Purple Moon** (#7D44CF) - Accent purple
- **First Light** (#D45B90) - Accent rose
- **Windy City** (#8A999E) - Neutral elements

### Tertiary Colors (Backgrounds)
- **Winter** (#24323D) - Dark backgrounds (title slide)
- **Iceberg** (#003545) - Serious blue backgrounds
- **White** (#FFFFFF) - Content slides
- **Light Gray** (#F2F2F2) - Impact slides

---

## 📊 Presentation Structure

Based on `Grid_Reliability_Presentation_Slides.md`:

### Main Slides (26 total)
1. **Title Slide** - Dark background with Snowflake Blue title
2. **The Utility Challenge** - Problem statement
3. **Regulatory & Climate Pressures** - Industry context
4. **The Business Opportunity** - ROI & impact stats
5. **Our Solution - Platform Overview** - Solution capabilities
6. **Architecture** - Medallion approach
7. **Data Integration** - IT/OT convergence
8. **Machine Learning Models** - ML ensemble
9. **Unstructured Intelligence** - Document & CV processing
10. **Snowflake Intelligence Agent** - Natural language queries
11. **Interactive Dashboard** - Streamlit dashboard features
12. **Business Impact - Reliability** - SAIDI/SAIFI improvements
13. **Business Impact - Cost** - Financial returns
14. **Use Case #1** - Predictive maintenance
15. **Use Case #2** - Root cause analysis
16. **Use Case #3** - Technician support
17. **Technical Specifications** - Enterprise requirements
18. **Deployment Model** - Implementation phases
19. **Success Metrics** - KPIs to track
20. **What Makes This Different?** - Snowflake advantages
21. **Customer Success Story** - Anonymized case study
22. **Live Demo** - Dashboard walkthrough
23. **Getting Started** - Next steps
24. **Why Act Now?** - Urgency drivers
25. **Q&A** - Contact information
26. **Thank You** - Closing slide

### Appendix Slides (4 total)
- **A:** ML Model Details - Technical architecture
- **B:** Data Model - Database schema
- **C:** Integration Patterns - System connections
- **D:** Cost Model - Consumption estimates

---

## 🛠️ Customization

### Extending the PowerPoint Script

The `create_powerpoint.py` script includes three slide templates:

1. **Title Slide** - `create_title_slide()`
2. **Content Slide** - `create_content_slide()` 
3. **Impact Slide** - `create_impact_slide()`

To add more slides, follow the pattern in `main()`:

```python
# Add a new content slide
create_content_slide(
    prs,
    "Slide Title",
    "Subtitle (optional)",
    [
        {
            'heading': 'Section Heading',
            'bullets': [
                'Bullet point 1',
                'Bullet point 2',
                'Bullet point 3'
            ]
        },
        {
            'heading': 'Another Section',
            'bullets': [
                'More bullets here'
            ]
        }
    ]
)
```

### Adding Images

After uploading to Google Slides:

1. Insert images from `solution_presentation/images/`:
   - `architecture_overview.png`
   - `medallion_architecture.png`
   - `data_pipeline.png`
   - `ml_models.png`
   - `unstructured_integration.png`

2. Take screenshots of:
   - Streamlit dashboard pages
   - Intelligence Agent queries
   - Asset maps

3. Add to relevant slides:
   - Slide 6: Architecture diagram
   - Slide 8: ML models diagram
   - Slide 11: Dashboard screenshots
   - Slide 22: Demo screenshots

---

## 🔧 Alternative Method: Direct Google Slides API

**⚠️ More complex - requires OAuth setup**

### Step 1: Google Cloud Setup

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or select existing)
3. Enable APIs:
   - Google Slides API
   - Google Drive API
4. Create credentials:
   - "Create Credentials" → "OAuth client ID"
   - Application type: "Desktop app"
   - Download JSON file
5. Save as `solution_presentation/credentials.json`

### Step 2: Install Dependencies

```bash
pip install google-api-python-client google-auth-httplib2 google-auth-oauthlib
```

### Step 3: Run Generator

```bash
python generate_all_slides.py
```

This will:
1. Open browser for Google authentication
2. Create presentation directly in Google Slides
3. Output link to your new presentation

---

## 📝 Presentation Tips

### For Executive Audience
- Focus on slides: 1-6, 12-13, 19-21, 23-24
- Emphasize ROI and business impact
- Skip technical appendix

### For Technical Audience
- Include all 26 slides + appendix
- Deep dive on ML models (Slide 8, Appendix A)
- Show architecture details (Slide 6, Appendix B)
- Demo live queries

### For Sales/Business Dev
- Focus on: 1-5, 12-16, 19-21, 23-24
- Emphasize customer success (Slide 21)
- Strong call-to-action (Slide 23)
- Include competitive differentiators (Slide 20)

---

## 📚 Reference Files

- **Content Source:** `Grid_Reliability_Presentation_Slides.md`
- **Color Scheme:** `SNOWFLAKE_COLOR_SCHEME.md` (in ~/Downloads)
- **Solution Overview:** `Grid_Reliability_Solution_Overview.md`
- **Business Case:** `../docs/business/BUSINESS_CASE.md`
- **Demo Script:** `../docs/business/DEMO_SCRIPT.md`

---

## 🎯 Next Steps After Generation

1. ✅ Review all slides for accuracy
2. ✅ Add company logo to title slide
3. ✅ Add Snowflake logo to footer
4. ✅ Insert diagrams from `images/` folder
5. ✅ Add dashboard screenshots
6. ✅ Customize contact information (Slide 25)
7. ✅ Add speaker notes for each slide
8. ✅ Practice demo flow (Slide 22)
9. ✅ Share with stakeholders for review

---

## 🐛 Troubleshooting

### PowerPoint Method

**Issue:** `ModuleNotFoundError: No module named 'pptx'`
```bash
pip install python-pptx
```

**Issue:** "Font not found" errors
- The script uses Arial (universally available)
- If issues persist, change `font.name = 'Arial'` to another font

**Issue:** Colors look different in Google Slides
- Google Slides may render RGB colors slightly differently
- Adjust in Google Slides after upload if needed

### Google Slides API Method

**Issue:** `credentials.json not found`
- Follow Step 1 of Alternative Method above
- Ensure file is in `solution_presentation/` directory

**Issue:** "Access denied" or "Invalid credentials"
- Delete `token.pickle`
- Run script again to re-authenticate

**Issue:** Slides API quota exceeded
- Wait 24 hours or request quota increase
- Use PowerPoint method instead

---

## 📄 License & Attribution

This presentation generation tool is part of the Grid Reliability & Predictive Maintenance solution.

**Snowflake Brand Colors:** Used in accordance with Snowflake branding guidelines.

---

## 🤝 Support

For questions or issues:
1. Check the markdown source: `Grid_Reliability_Presentation_Slides.md`
2. Review color scheme: `SNOWFLAKE_COLOR_SCHEME.md`
3. Refer to main README: `../README.md`

---

**Happy Presenting! 🎉**
