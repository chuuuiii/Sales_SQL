# SQL Data Cleaning & Sales Analysis Project

---

## Tools Used

* MySQL Workbench
---

## Dataset Information

### Table: `sales_dirty`

The original dataset contains:

* 180 Records
* 10 Columns

### Columns

| Column Name   | Description             |
| ------------- | ----------------------- |
| Order_ID      | Unique order identifier |
| Customer_Name | Customer name           |
| Region        | Sales region            |
| Country       | Customer country        |
| Product       | Product sold            |
| Category      | Product category        |
| Order_Date    | Date of order           |
| Revenue       | Revenue generated       |
| Profit        | Profit generated        |
| Sales_Rep     | Sales representative    |

---

## Data Quality Issues Identified

The dataset intentionally contained:

* Missing values
* NULL values
* "Null" and "N/A" text values
* Leading and trailing spaces
* Mixed capitalization
* Inconsistent country names
* Inconsistent product names
* Invalid date formats
* Currency symbols in numeric fields
* Duplicate-like records

Examples:

```text
APAC
apac

Philippines
philippines

Monitor
monitor

NULL
Null
N/A
```

---

## Data Cleaning Process

### 1. Created a Working Copy

### 2. Standardized Text Fields

* Removed extra spaces using TRIM()
* Standardized capitalization
* Corrected inconsistent values

Examples:

```text
apac → APAC
philippines → Philippines
monitor → Monitor
```

### 3. Handled Missing Values

Replaced:

```text
NULL
Null
N/A
```

with proper missing values for analysis.

### 4. Cleaned Numeric Fields

Removed:

```text
$
,
```

from Revenue and Profit columns.

Converted numeric fields into appropriate data types.

### 5. Standardized Dates

Converted multiple date formats into a consistent format suitable for analysis.

### 6. Validated Data Quality

Checked for:

* Missing values
* Duplicate Order IDs
* Invalid dates
* Negative values
* Inconsistent categories

## Exploratory Data Analysis (EDA)

## Project Workflow

```text
Raw Data
    ↓
SQL Data Cleaning
    ↓
Clean Dataset
    ↓
Exploratory Data Analysis
```
---

## Skills Demonstrated

### SQL

* SELECT
* WHERE
* GROUP BY
* HAVING
* ORDER BY
* CTE
* WINDOW FUNCTONS
* Aggregate Functions
* Data Cleaning
* Data Validation

---

## Author
Rajahmuden Dalaten
