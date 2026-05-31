-- 1 BASELINE PLATFORM FRAUD METRICS

SELECT 
  COUNT(*) AS total_transactions,
  SUM(CASE WHEN is_fraud = 1 THEN 1 ELSE 0 END) AS fraud_transaction_count,
  ROUND(COUNT(CASE WHEN is_fraud = 1 THEN 1 END) * 100.0 / COUNT(*), 2) AS volume_of_fraud_percent,
  SUM(amount) AS total_processed_amount,
  SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END) AS total_fraud_amount_lost,
  ROUND(SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END) * 100.0 / SUM(amount), 2) AS value_of_fraud_percent
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`;


-- 2 TEMPORAL PEAK ANALYSIS
SELECT 
  transaction_hour,
  COUNT(*) AS total_transactions,
  SUM(is_fraud) AS fraud_count,
  ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`
GROUP BY transaction_hour
ORDER BY fraud_rate_percentage DESC;


-- 3 GEOGRAPHIC RISK VARIATION
SELECT 
  CASE WHEN location <> home_city THEN 'Out of Town' ELSE 'Home City' END AS travel_status,
  COUNT(*) AS total_transactions,
  SUM(is_fraud) AS fraud_cases,
  ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`
GROUP BY travel_status;


-- 4 HARDWARE PROFILING
SELECT 
  device_type,
  COUNT(*) AS total_transactions,
  SUM(is_fraud) AS fraud_count,
  ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS device_fraud_rate_percentage
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`
GROUP BY device_type
ORDER BY device_fraud_rate_percentage DESC;

--5 HIGH-RISK VENDOR EXPLORATION (TOP 10)

SELECT 
  merchant_name,
  COUNT(*) AS total_transactions,
  SUM(is_fraud) AS fraud_count,
  ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS merchant_fraud_rate_percentage,
  SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END) AS total_fraud_loss
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`
GROUP BY merchant_name
HAVING total_transactions >= 10 
ORDER BY merchant_fraud_rate_percentage DESC, fraud_count DESC
LIMIT 10;


--6 VALUE ORDER BUCKETING
SELECT 
  CASE 
    WHEN amount < 10 THEN '1. Under $10 (Micro)'
    WHEN amount BETWEEN 10 AND 50 THEN '2. $10 - $50 (Low)'
    WHEN amount BETWEEN 51 AND 250 THEN '3. $51 - $250 (Medium)'
    WHEN amount BETWEEN 251 AND 1000 THEN '4. $251 - $1000 (High)'
    ELSE '5. Over $1000 (Macro)'
  END AS amount_bucket,
  COUNT(*) AS total_transactions,
  SUM(is_fraud) AS fraud_count,
  ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`
GROUP BY amount_bucket
ORDER BY amount_bucket;


-- 7 PAYMENT METHOD VULNERABILITY

SELECT 
  payment_method,
  COUNT(*) AS total_transactions,
  SUM(is_fraud) AS fraud_count,
  ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage,
  SUM(CASE WHEN is_fraud = 1 THEN amount ELSE 0 END) AS total_financial_loss
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`
GROUP BY payment_method
ORDER BY fraud_rate_percentage DESC;


-- 8 OPERATIONAL EFFICIENCY & FALSE POSITIVE RATIO (FPR)
SELECT 
  COUNT(CASE WHEN transaction_status IN ('Failed') AND is_fraud = 0 THEN 1 END) AS false_positives_count,
  COUNT(CASE WHEN transaction_status IN ('Failed') AND is_fraud = 1 THEN 1 END) AS true_positives_count,
  ROUND(
    COUNT(CASE WHEN transaction_status IN ('Failed') AND is_fraud = 0 THEN 1 END) * 1.0 / 
    NULLIF(COUNT(CASE WHEN transaction_status IN ('Failed') AND is_fraud = 1 THEN 1 END), 0), 
    2
  ) AS false_positive_ratio
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`;


-- 9 LOGICAL RULE COMPOSITE MATRIX
SELECT 
  device_type,
  payment_method,
  CASE WHEN location <> home_city THEN 'Out of Town' ELSE 'Home City' END AS travel_status,
  COUNT(*) AS total_transactions,
  SUM(is_fraud) AS fraud_count,
  ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS combined_fraud_rate
FROM `fraud-analytics-project-497906.Fraud_analysis_data.Fraud_Table`
GROUP BY device_type, payment_method, travel_status
HAVING total_transactions >= 50 
ORDER BY combined_fraud_rate DESC
LIMIT 5;


