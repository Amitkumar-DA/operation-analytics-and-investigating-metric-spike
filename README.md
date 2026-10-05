# 📊 Operation Analytics & Investigating Metric Spike

<p align="center">

**A SQL-driven operational analytics project focused on productivity, throughput, user engagement, retention, and business performance.**

</p>

<p align="center">

![SQL](https://img.shields.io/badge/SQL-MySQL-blue?style=for-the-badge\&logo=mysql\&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?style=for-the-badge\&logo=mysql\&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-Data%20Validation-green?style=for-the-badge\&logo=microsoftexcel\&logoColor=white)
![Analytics](https://img.shields.io/badge/Data%20Analytics-Business%20Insights-purple?style=for-the-badge)
![Status](https://img.shields.io/badge/Project-Completed-success?style=for-the-badge)

</p>

---

## 🧭 Project Overview

**Operation Analytics & Investigating Metric Spike** is an end-to-end SQL analytics project designed to transform operational and user activity data into actionable business insights.

The project investigates two key business areas:

| Case Study          | Focus                                  |
| ------------------- | -------------------------------------- |
| 🔎 **Case Study 1** | Job Review Operations                  |
| 📈 **Case Study 2** | User Engagement & Metric Investigation |

The analysis uses SQL to evaluate operational productivity, throughput, language distribution, user growth, retention, device engagement, and email performance.

> **Business Goal:** Use data to understand operational performance, identify meaningful trends, investigate metric fluctuations, and support data-driven decision-making.

---

# 🎯 Business Questions

### Operational Analytics

* How efficiently are jobs being reviewed?
* How does reviewer productivity change over time?
* What is the daily and weekly throughput?
* Which languages represent the largest share of reviewed content?
* Are there duplicate records affecting data quality?

### User & Product Analytics

* How many users are actively engaging each week?
* Is the user base continuing to grow?
* How well are users retained over time?
* Which devices generate the most engagement?
* How effective are email campaigns at driving engagement?

---

# 🗂️ Dataset Architecture

The project works with multiple operational and user activity datasets.

```text
                         ┌──────────────────┐
                         │    JOB_DATA      │
                         ├──────────────────┤
                         │ job_id           │
                         │ actor_id         │
                         │ event            │
                         │ language         │
                         │ time_spent       │
                         │ org              │
                         │ ds               │
                         └────────┬─────────┘
                                  │
                                  ▼
                       ┌─────────────────────┐
                       │ Operational         │
                       │ Analytics           │
                       └─────────────────────┘


┌──────────────┐       ┌──────────────┐       ┌────────────────┐
│    USERS     │       │    EVENTS    │       │ EMAIL_EVENTS   │
├──────────────┤       ├──────────────┤       ├────────────────┤
│ user_id      │       │ user_id      │       │ user_id        │
│ created_at   │       │ occured_at   │       │ occured_at     │
│ company_id   │       │ event_type   │       │ action         │
│ language     │       │ event_name   │       │ user_type      │
│ activated_at │       │ location     │       └────────────────┘
│ state        │       │ device       │
└──────────────┘       │ user_type    │
                       └──────────────┘
```

---

# 🧰 Tech Stack

<p align="center">

| Tool                       | Purpose                                    |
| -------------------------- | ------------------------------------------ |
| 🐬 **MySQL Workbench 8.0** | Database creation & SQL analysis           |
| 🧮 **SQL**                 | Data extraction, transformation & analysis |
| 📄 **CSV**                 | Raw data source                            |
| 📊 **Microsoft Excel**     | Data validation & review                   |
| 📑 **PowerPoint**          | Presentation of findings                   |
| 📘 **PDF**                 | Project documentation                      |

</p>

The original project workflow involved importing CSV datasets into MySQL Workbench, validating the data, performing cleaning checks, and then applying SQL-based analysis.

---

# 🔬 Case Study 1 — Job Data Analysis

The first case study focuses on operational performance within a job-review workflow.

### Key Metrics

**Reviewer Productivity**
Measures how efficiently reviewers process jobs relative to time spent.

**Throughput**
Measures completed review events relative to total review time.

**Language Distribution**
Identifies which languages represent the largest share of operational workload.

**Data Quality**
Checks for potential duplicate records.

The `job_data` table contains job IDs, actor IDs, event types, languages, time spent, organization, and review dates.

---

## 📈 Finding #1 — Reviewer Productivity

The analysis showed significant variation in reviewer productivity across days.

### Key Finding

> 🚀 **28-Nov-2020 recorded the highest reviewer productivity, exceeding 218 jobs per hour.**

The lowest productivity occurred on 27-Nov-2020, suggesting that workload complexity or operational conditions may have varied significantly between days.

### SQL Highlight

```sql
SELECT 
    AVG(t) AS avg_jobs_reviewed_per_hour,
    AVG(p) AS avg_jobs_reviewed_per_second
FROM (
    SELECT 
        ds,
        ((COUNT(job_id) * 3600) / SUM(time_spent)) AS t,
        (COUNT(job_id) / SUM(time_spent)) AS p
    FROM job_data
    WHERE MONTH(ds) = 11
    GROUP BY ds
) a;
```

---

## ⚡ Finding #2 — Throughput

Daily throughput showed substantial fluctuations.

### Key Findings

* 📈 Throughput increased significantly after **27-Nov**.
* 🏆 Throughput peaked on **28-Nov**.
* 📊 Daily performance was highly variable.
* 📉 Rolling averages provide a smoother operational trend.

### SQL Highlight

```sql
SELECT
    ds AS date,
    ROUND(COUNT(event) / SUM(time_spent), 2) AS daily_throughput
FROM job_data
GROUP BY ds
ORDER BY ds;
```

---

## 🌍 Finding #3 — Language Distribution

Language analysis identified a significant concentration of workload.

### Key Finding

> 🗣️ **Persian represented nearly 38% of reviewed jobs.**

This indicates that reviewer allocation should consider language-specific workload demand.

### SQL Highlight

```sql
SELECT
    language,
    ROUND(100 * COUNT(*) / total, 2) AS percentage
FROM job_data
CROSS JOIN (
    SELECT COUNT(*) AS total
    FROM job_data
) sub
GROUP BY language, total;
```

---

# 🧪 Case Study 2 — Investigating Metric Spike

The second case study investigates product usage and user engagement patterns using:

* `users`
* `events`
* `email_events`

---

## 👥 Finding #4 — Weekly User Engagement

Weekly engagement remained relatively stable.

### Key Findings

> **1,100+ active users** were recorded weekly.

A slight decline was observed toward the end of August, suggesting stabilization rather than rapid growth in weekly engagement.

### SQL Highlight

```sql
SELECT
    EXTRACT(WEEK FROM occured_at) AS week_number,
    COUNT(DISTINCT user_id) AS active_users
FROM events
WHERE event_type = 'engagement'
GROUP BY week_number
ORDER BY week_number;
```

---

# 📈 Finding #5 — User Growth

The user acquisition analysis showed a consistent upward trend.

### KPI

## **9,381 Total Registered Users**

### Key Findings

* 📈 Continuous user acquisition
* 🚀 Healthy growth trend
* 📊 Consistent weekly registration
* ⚠️ No evidence of acquisition slowdown

### SQL Highlight

```sql
SELECT
    year,
    week_num,
    num_users,
    SUM(num_users) OVER (
        ORDER BY year, week_num
    ) AS cumulative_users
FROM (
    SELECT
        EXTRACT(YEAR FROM created_at) AS year,
        EXTRACT(WEEK FROM created_at) AS week_num,
        COUNT(DISTINCT user_id) AS num_users
    FROM users
    GROUP BY year, week_num
) sub;
```

---

# 🔄 Finding #6 — User Retention

Cohort analysis was used to evaluate long-term user retention.

### Analysis Framework

```text
Signup Cohort
     │
     ▼
User Activation
     │
     ▼
Weekly Engagement
     │
     ▼
Retention Period
     │
     ▼
Long-Term User Loyalty
```

The analysis provides a framework for identifying weak signup cohorts and potential onboarding issues.

### SQL Concepts Used

* CTEs
* Cohort analysis
* Date calculations
* Conditional aggregation
* Joins

---

# 📱 Finding #7 — Device Engagement

User engagement was also segmented by device.

```sql
SELECT
    EXTRACT(YEAR FROM occured_at) AS year,
    EXTRACT(WEEK FROM occured_at) AS week_num,
    device,
    COUNT(DISTINCT user_id) AS engaged_users
FROM events
WHERE event_type = 'engagement'
  AND event_name = 'login'
GROUP BY
    EXTRACT(YEAR FROM occured_at),
    EXTRACT(WEEK FROM occured_at),
    device
ORDER BY
    year,
    week_num,
    device;
```

This analysis can help organizations understand platform usage and prioritize future product investments.

---

# 📧 Finding #8 — Email Engagement

Email interaction was analyzed by action type.

### Key Findings

* 📩 Weekly digest emails dominated communication.
* 👀 Open activity indicates active email interaction.
* 🖱️ Click-through events demonstrate engagement.
* 🔄 Re-engagement campaigns can target inactive users.
* 📈 Email remains an important retention channel.

### SQL Highlight

```sql
SELECT
    action,
    COUNT(*) AS total_events,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER(),
        2
    ) AS percentage
FROM email_events
GROUP BY action;
```

---

# 📸 Project Screenshots

Add screenshots from your PowerPoint or SQL analysis to make the repository visually stronger.

### 📊 Operational Analytics

```markdown
![Operational Analytics](screenshots/operational-analysis.png)
```

### 📈 User Growth & Engagement

```markdown
![User Growth](screenshots/user-growth.png)
```

### 🔄 Retention Analysis

```markdown
![Retention Analysis](screenshots/retention-analysis.png)
```

### 📧 Email Engagement

```markdown
![Email Engagement](screenshots/email-engagement.png)
```

> **Recommended GitHub structure:**

```text
screenshots/
├── operational-analysis.png
├── throughput.png
├── language-distribution.png
├── user-growth.png
├── retention-analysis.png
├── device-engagement.png
└── email-engagement.png
```

---

# 🧠 Business Insights

| Area            | Insight                     | Business Implication                       |
| --------------- | --------------------------- | ------------------------------------------ |
| ⚙️ Productivity | Large day-to-day variation  | Investigate workload complexity            |
| 🚀 Throughput   | Peak observed on 28-Nov     | Identify drivers of high efficiency        |
| 🌍 Language     | Persian ≈ 38% of jobs       | Allocate appropriate language resources    |
| 👥 Engagement   | 1,100+ weekly active users  | Engagement remains relatively stable       |
| 📈 Growth       | 9,381 registered users      | Healthy acquisition trend                  |
| 🔄 Retention    | Cohort analysis available   | Identify weak onboarding periods           |
| 📱 Devices      | Engagement varies by device | Inform platform investment                 |
| 📧 Email        | Digest emails dominate      | Email remains a valuable retention channel |

---

# 💼 Business Value

This project demonstrates how raw operational data can be converted into insights that support:

```text
Raw Data
   │
   ▼
Data Validation
   │
   ▼
SQL Analysis
   │
   ▼
KPI Measurement
   │
   ▼
Trend Investigation
   │
   ▼
Business Insights
   │
   ▼
Data-Driven Decisions
```

### Potential Business Applications

✅ Workforce planning
✅ Operational efficiency monitoring
✅ Reviewer resource allocation
✅ User growth monitoring
✅ Retention analysis
✅ Product optimization
✅ Email campaign evaluation
✅ Data quality monitoring

---

# 📂 Repository Structure

```text
📦 Operation-Analytics
│
├── 📁 Data
│   ├── job_data.csv
│   ├── users.csv
│   ├── events.csv
│   └── email_events.csv
│
├── 📁 SQL
│   ├── job_data_analysis.sql
│   └── metric_spike_analysis.sql
│
├── 📁 Screenshots
│   ├── operational-analysis.png
│   ├── throughput.png
│   ├── language-distribution.png
│   ├── user-growth.png
│   ├── retention-analysis.png
│   ├── device-engagement.png
│   └── email-engagement.png
│
├── 📁 Documentation
│   └── Project_Report.pdf
│
├── 📁 Presentation
│   └── Operation_Analytics.pptx
│
└── 📄 README.md
```

---

# 🏆 Skills Demonstrated

### Technical Skills

`SQL` `MySQL` `CTEs` `Window Functions` `Aggregations` `Joins` `Cohort Analysis` `Data Cleaning` `Data Validation`

### Analytical Skills

`KPI Analysis` `Trend Analysis` `Operational Analytics` `User Analytics` `Retention Analysis` `Data Quality` `Business Intelligence`

### Business Skills

`Problem Solving` `Insight Generation` `Decision Support` `Performance Monitoring` `Resource Planning`

---

# 📌 Key Takeaways

> **Operational performance is not static.** Daily productivity and throughput can vary significantly, making trend analysis and rolling averages important for performance monitoring.

> **User growth and engagement tell different stories.** The user base continued to grow while weekly engagement remained relatively stable.

> **Segmentation creates actionable insights.** Language, device, cohort, and email-action analysis help identify specific opportunities for optimization.

These findings demonstrate the practical application of SQL for solving real-world business analytics problems.

---

# 👨‍💻 Author

### **Amit Kumar**

**Data Analyst | SQL | MySQL | Business Analytics**

---

<p align="center">

⭐ **If you found this project interesting, consider starring the repository!**

</p>

