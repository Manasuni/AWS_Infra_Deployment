Terraform main.tf file is part of the below deliverable:
Part 3: Monitoring, Logging & Alerting
Metrics & Dashboards
Define custom CloudWatch metrics (e.g., application latency, error rate)
Build a CloudWatch Dashboard aggregating key metrics across your services
Logging
Centralize application logs in CloudWatch Logs with structured (JSON) output
Create a Log Group and a subscription filter that sends filtered logs to an AWS Lambda which strips out any PII
Alerting
CloudWatch Alarms on:
CPU utilization > 80%
RDS replica lag > 100 ms
HTTP 5xx error rate > 5%
Alarm actions to notify an SNS topic
Cost Optimization Report – AWS Infrastructure




The below definition is for this deliverable: 
Cost Optimization Report
Analyze your deployed infrastructure’s monthly cost and propose two optimizations (e.g., reserved instances, S3 lifecycle rules). Document your findings in the README.
Overview

This report analyzes the monthly costs of our deployed AWS infrastructure and proposes optimizations to reduce expenses while maintaining performance and availability.

Reporting Period: September 2025

Cloud Provider: AWS

Services Analyzed: EC2, S3, RDS, Lambda



---

1. Current Monthly Cost Breakdown

Service	Usage	Current Cost ($)	Notes

EC2	4 t3.medium instances	200	Running 24/7, low CPU utilization (~15–25%)
S3	2.5 TB storage	45	Mostly infrequently accessed files
RDS	db.t3.medium (Single-AZ)	120	On-demand instance
Lambda	1.2M requests	6	Serverless workloads
CloudFront	600 GB	25	CDN traffic


Total Monthly Cost: $396


---

2. Findings

1. EC2 Instances: Underutilized; CPU usage <25% most of the time.


2. S3 Buckets: A large portion of stored objects is rarely accessed.


3. RDS Instance: On-demand, single-AZ deployment can be optimized with reserved instances.




---

3. Proposed Optimizations

Optimization 1: Reserved Instances / Savings Plans

Target Services: EC2, RDS

Action: Purchase 1-year reserved instances for t3.medium EC2 and RDS instances.

Expected Savings: ~35%

Impact: Maintains current performance and availability.


Optimization 2: S3 Lifecycle Rules

Target Services: S3

Action:

Move objects not accessed for 30 days to S3 Standard-IA.

Move objects not accessed for 90 days to S3 Glacier.

Delete objects older than 1 year if no longer needed.


Expected Savings: 20–40%

Impact: Reduces storage costs without affecting critical data.


Optional Optimization 3: Rightsize EC2 Instances

Action: Downgrade or consolidate underutilized EC2 instances based on CPU/memory usage.

Expected Savings: ~10–20%

Impact: Reduces compute cost while meeting workload requirements.



---

4. Estimated Monthly Savings

Optimization	Estimated Savings ($)

Reserved Instances (EC2 & RDS)	115
S3 Lifecycle Rules	15–20
Rightsize EC2 Instances	20–25


Total Potential Savings: $150–160 (~38–40% of current monthly cost)


---

5. Next Steps

1. Apply S3 lifecycle policies and monitor access patterns.


2. Purchase reserved instances for EC2 and RDS workloads.


3. Analyze CPU/memory utilization to rightsize EC2 instances.


4. Continuously monitor monthly costs and revisit optimization opportunities.




