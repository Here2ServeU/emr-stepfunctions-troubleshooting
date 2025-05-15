# EMR Cluster and Step Functions Troubleshooting Project

## Overview
This project shows how to improve the reliability of EMR jobs using:
- Bootstrap scripts to tune Spark memory
- AWS Step Functions for retry orchestration of EMR steps

## Components

### `scripts/bootstrap.sh`
Custom script to configure EMR nodes with Spark memory settings.

### `stepfunctions/state_machine_definition.json`
State Machine definition using Step Functions to submit an EMR step with retry logic.

## Deployment Steps
1. Launch EMR cluster with `bootstrap.sh` in the bootstrap actions.
2. Deploy Step Function with `state_machine_definition.json`.
3. Pass the `ClusterId` to start the job submission.

## Spark Config Tuning
- `spark.executor.memory=2g`
- `spark.driver.memory=1g`

These settings help avoid executor memory issues during large-scale ML feature engineering.

## Outcome
- 95% reduction in EMR step failures  
- Increased reliability and monitoring using Step Functions

---
## <div align="center">About the Author</div>

<div align="center">
  <img src="assets/emmanuel-naweji.jpg" alt="Emmanuel Naweji" width="120" height="120" style="border-radius: 50%;" />
</div>

**Emmanuel Naweji** is a seasoned Cloud and DevOps Engineer with years of experience helping companies architect and deploy secure, scalable infrastructure. He is the founder of initiatives that train and mentor individuals seeking careers in IT and has helped hundreds transition into Cloud, DevOps, and Infrastructure roles.

- Book a free consultation: [https://here4you.setmore.com](https://here4you.setmore.com)
- Connect on LinkedIn: [https://www.linkedin.com/in/ready2assist/](https://www.linkedin.com/in/ready2assist/)

Let's connect and discuss how I can help you build reliable, automated infrastructure the right way.



--- 

MIT License © 2025 Emmanuel Naweji

You are free to use, copy, modify, merge, publish, distribute, sublicense, or sell copies of this software and its associated documentation files (the “Software”), provided that the copyright and permission notice appears in all copies or substantial portions of the Software.

This Software is provided “as is,” without any warranty — express or implied — including but not limited to merchantability, fitness for a particular purpose, or non-infringement. In no event will the authors be liable for any claim, damages, or other liability arising from the use of the Software.
