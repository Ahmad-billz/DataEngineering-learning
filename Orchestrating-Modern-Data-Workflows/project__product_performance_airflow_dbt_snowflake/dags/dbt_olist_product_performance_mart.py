from __future__ import annotations

from datetime import datetime
from airflow.decorators import dag
from airflow.operators.bash import BashOperator

PROJECT_DIR = "/opt/airflow/dbt/olist_dbt"  # must contain dbt_project.yml

default_args = {
    "owner": "analytics",
    "retries": 0,
}

@dag(
    dag_id="dbt_olist_product_performance_mart",
    description="Run dbt models for Olist dataset in Snowflake",
    schedule=None,
    start_date=datetime(2025, 1, 1),
    catchup=False,
    default_args=default_args,
    tags=["dbt", "snowflake", "olist"],
)
def dbt_olist_product_performance_mart():

    dbt_deps = BashOperator(
        task_id="dbt_deps",
        bash_command=f"cd {PROJECT_DIR} && rm -rf dbt_packages && dbt deps",
        do_xcom_push=False,
    )

    dbt_clean = BashOperator(
        task_id="dbt_clean",
        bash_command=f"cd {PROJECT_DIR} && dbt clean",
        do_xcom_push=False,
    )

    dbt_compile = BashOperator(
        task_id="dbt_compile",
        bash_command=f"cd {PROJECT_DIR} && dbt compile",
        do_xcom_push=False,
    )

    # optional (only if your assignment requires it each run)
    dbt_debug = BashOperator(
        task_id="dbt_debug",
        bash_command=f"cd {PROJECT_DIR} && dbt debug",
        do_xcom_push=False,
    )

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=f"cd {PROJECT_DIR} && dbt run --select +fact_product_performance",
        do_xcom_push=False,
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=f"cd {PROJECT_DIR} && dbt test --select +fact_product_performance",
        do_xcom_push=False,
    )

    dbt_deps >> dbt_clean >> dbt_compile >> dbt_debug >> dbt_run >> dbt_test


dag = dbt_olist_product_performance_mart()
