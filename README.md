# Multi-Crop Database System for Variety Recommendation in Sub-Saharan Africa

## 1. Overview

This project is a relational database and analytics platform designed to support evidence-based crop variety selection across Sub-Saharan Africa (SSA). The system integrates multi-year, multi-location trial data from five countries (Nigeria, Kenya, Ethiopia, Tanzania, and Ghana) for four major crops: Maize, Rice, Sorghum, and Cowpea.

The goal is to help researchers, breeders, agronomists, and farmers make data-driven decisions by providing a centralized, structured, and queryable source of agricultural data.

## 2. Key Features

*   **Centralized Data**: Consolidates multi-environment trial (MET) data into a single, consistent database.
*   **Standardized Schema**: Implements a star schema to normalize heterogeneous data from different sources.
*   **Rich Datasets**: Includes phenotypic, environmental, and agronomic metadata.
*   **Analytical Support**: Enables complex queries to analyze variety performance, stability, and environmental response.
*   **Data Provenance**: Retains the original, unprocessed data in a staging table for lineage and auditing.

## 3. Project Structure

The project is organized into the following directories:

```
.
├── Project/
│   ├── data_use_scripts/      # SQL scripts with example analytical queries.
│   ├── database_dump/         # Full database dump for backup and restoration.
│   ├── documentation/         # Detailed project documentation, including data dictionary and setup guides.
│   ├── processed_data/        # Cleaned, consolidated CSV data used for populating the database.
│   ├── raw_data/              # Original, unmodified data files from various sources.
│   └── sql_scripts/           # Scripts for creating and populating the database schema.
├── Report/                    # Project report.
└── README.md                  # This file.
```

## 4. Database Schema

The database follows a star schema with a central fact table (`phenotype_measurement`) and five dimension tables (`crop`, `location`, `variety`, `trial`, `trait`).

For a complete and detailed description of each table, column, data type, and relationship, please refer to the **[Crops_MET Data Dictionary](./Project/documentation/Crops_MET%20Data%20Dictionary.md)**.

## 5. Getting Started

Follow these steps to set up and populate the database on your local machine.

### Prerequisites

*   **Database System**: MariaDB 10.3+ or MySQL 8.0+
*   **Operating System**: macOS, Linux, or Windows.
*   **Permissions**: Administrative (root) access to your database system.

### Installation

The setup process involves running a series of SQL scripts that create the database, load the data from the `processed_data` directory, and normalize it into the schema's tables.

For detailed, step-by-step instructions, please follow the **[Crops_MET Database Setup Guide](./Project/documentation/Crops_MET_Database_Setup_Guide.md)**.

A quick overview of the steps is:
1.  Navigate to the `Project/sql_scripts` directory.
2.  Make the setup script executable: `chmod +x setup_db_script.sh`.
3.  Run the script: `./setup_db_script.sh` and provide your database credentials when prompted.

## 6. Example Queries

The `Project/data_use_scripts/` directory contains a collection of SQL files that demonstrate how to query the database to answer key agricultural questions, such as:

*   Ranking variety performance by trait.
*   Summarizing trait statistics by country or region.
*   Identifying the best locations for a specific trait.
*   Analyzing year-to-year trends in crop performance.

## 7. Documentation

All project documentation is located in the `Project/documentation/` and `Report/` directories.

*   **[Crops_MET Data Dictionary.md](./Project/documentation/Crops_MET%20Data%20Dictionary.md)**: Provides a detailed description of the database schema.
*   **[Crops_MET_Database_Setup_Guide.md](./Project/documentation/Crops_MET_Database_Setup_Guide.md)**: Contains comprehensive setup and installation instructions.
*   **[DMSProject.pdf](./Report/DMSProject.pdf)**: The full project report detailing the design, implementation, and use of the database.

## 8. Ethics and Usage Guidelines

### Intended Use
This decision-support system and the underlying data are intended to be used by farmers, researchers, agronomists, and breeders for educational and decision-making purposes. The recommendations generated are designed to supplement, not replace, professional agronomic advice and local expertise.

### Data Licensing and Attribution
*   **Data**: The processed data contained in this database is shared under the [Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) license](https://creativecommons.org/licenses/by-sa/4.0/). You must give appropriate credit to the original data sources, provide a link to the license, and indicate if changes were made.
*   **Code**: All original code and scripts used to process and create the database are released under the [MIT License](https://opensource.org/licenses/MIT).
*   **Attribution**: When using this data, please cite the original research institutions that provided the raw data, as detailed in the project documentation.

### Data Integrity and Generation
To ensure dataset completeness and structural consistency for analysis, some missing data points for environmental or trait records were filled using simulation or AI-based generation. While this enables more robust querying, users should be aware that not all data points originate from direct field measurements.

### Limitations and Disclaimer
*   The data in this system originates from specific multi-environment trials conducted between 2018 and 2023. The findings may not be generalizable to all geographic locations, environmental conditions, or agricultural practices.
*   The creators and contributors of this database are not liable for any decisions, financial losses, or crop failures resulting from the use of this system.
*   While significant effort was made to clean and standardize the data, errors may still exist. Users are encouraged to perform their own quality checks and validation.