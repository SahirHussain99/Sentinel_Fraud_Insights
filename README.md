# Sentinel-Fraud-Insights: End-to-End Financial Risk & Operational Optimization

##  Project Overview
This project delivers a deep-dive quantitative risk assessment of a financial transaction system processing **$233.3M across 18,000 transactions**. Operating entirely within **Google Cloud BigQuery**, the analysis shifts focus from basic fraud counts to high-impact financial risk vectors, temporal attack windows, and operational bottlenecks—specifically identifying a critical friction threshold in user decline patterns.

---

##  Key Business Insights (Executive Summary)

### 1. The Financial Leverage Discrepancy (Macro Exposure)
* **The Data:** Fraudulent transactions account for only **0.67% of total volume**, yet command **2.74% ($6.38M) of total revenue loss**. 
* **Strategic Takeaway:** Fraud patterns are heavily leveraged toward high-ticket transactions. Analysis of transaction buckets reveals that **100% of realized fraud occurred in amounts exceeding $251**, proving that bad actors systematically bypass lower-value micro-transaction channels.

### 2. Operational Emergency: The False Positive Crisis
* **The Data:** The system generated a **106.8:1 False Positive Ratio** (1,602 legitimate transactions erroneously blocked/failed vs. only 15 true fraud cases caught).
* **Strategic Takeaway:** The current automated decline rules are unsustainably aggressive. The platform is severely disrupting customer experience and hemorrhaging lifetime value by over-blocking valid users to catch minimal fraud. Immediate migration from hard-blocks to dynamic step-up verification (SMS/MFA) is recommended.

### 3. Geographic and Temporal Target Profiles
* **The Data:** Transactions flagged as **"Out of Town"** see their inherent fraud risk more than double, escalating from **0.57% to 1.21%**. Concurrently, an early-morning attack window peaks at **4:00 AM (1.67% fraud rate)**, followed by a sustained evening surge at **6:00 PM (1.39%)**.
* **Strategic Takeaway:** Fraud automation networks selectively exploit thin customer service oversight windows (early morning) and geographic anomalies. 

### 4. High-Risk Multi-Attribute Vector (Composite Profiling)
* **The Data:** Isolation of combined data features reveals that **Out-of-Town Net Banking transactions executed via POS Terminals or Tablets** yield a catastrophic risk peak between **2.00% and 2.70%**.
* **Strategic Takeaway:** Traditional banking settlement rails (Debit, Net Banking, NEFT) remain heavily compromised compared to modernized protocols like UPI (0.44% risk), pinpointing exactly where backend validation rule updates must be targeted.

---

##  Tech Stack & Methodology
* **Engine:** Google Cloud BigQuery (SQL)
* **Modeling & Verification:** Excel (Descriptive statistics matrix and validation verification)
* **Framework:** Multi-conditional logical scanning (`CASE WHEN`), Data Segment Aggregations (`GROUP BY`), and Defensive System Ratio Calculations (`NULLIF`).


## Strategic Recommendations
Calibrate Gateway Restrictions: Immediately deprecate strict block parameters for transactions under $250 to mitigate the current 106.8:1 false alarm impact.

Implement Temporal Scaling: Integrate a backend modifier that escalates step-up identity validation routing for vectors executed between 2:00 AM and 5:00 AM.

Target Isolated Multi-Vectors: Hardcode rules triggering real-time multi-factor handshakes specifically for high-risk channels matching location <> home_city combined with standard Net Banking methods on handheld hardware.
