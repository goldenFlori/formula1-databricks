# Databricks notebook source
# DBTITLE 1,Overview
# MAGIC %md
# MAGIC ###Build Nationality Region Reference
# MAGIC
# MAGIC 1. Create nationality and region reference data
# MAGIC 2. Create a DataFrame with nationality and region columns
# MAGIC 3. Write the reference data to gold ref_nationality_region table

# COMMAND ----------

# DBTITLE 1,Load environment
# MAGIC %run ../00-common/01.environment-config

# COMMAND ----------

# DBTITLE 1,Define target table
target_table = f"{catalog_name}.{gold_schema}.ref_nationality_region"

# COMMAND ----------

# DBTITLE 1,Import helpers
from pyspark.sql import Row

# COMMAND ----------

# DBTITLE 1,Step 1 markdown
# MAGIC %md
# MAGIC ##### Step 1 - Create nationality and region reference data

# COMMAND ----------

# DBTITLE 1,Define reference rows
nationality_region = [
    # Manually curated nationality -> region mapping

    # Europe
    Row(nationality="British", region="Europe"),
    Row(nationality="Austrian", region="Europe"),
    Row(nationality="Belgian", region="Europe"),
    Row(nationality="Czech", region="Europe"),
    Row(nationality="Danish", region="Europe"),
    Row(nationality="Dutch", region="Europe"),
    Row(nationality="East German", region="Europe"),
    Row(nationality="Finnish", region="Europe"),
    Row(nationality="French", region="Europe"),
    Row(nationality="German", region="Europe"),
    Row(nationality="Hungarian", region="Europe"),
    Row(nationality="Irish", region="Europe"),
    Row(nationality="Italian", region="Europe"),
    Row(nationality="Liechtensteiner", region="Europe"),
    Row(nationality="Monegasque", region="Europe"),
    Row(nationality="Polish", region="Europe"),
    Row(nationality="Portuguese", region="Europe"),
    Row(nationality="Russian", region="Europe"),
    Row(nationality="Spanish", region="Europe"),
    Row(nationality="Swedish", region="Europe"),
    Row(nationality="Swiss", region="Europe"),

    # North America
    Row(nationality="American", region="North America"),
    Row(nationality="Canadian", region="North America"),
    Row(nationality="Mexican", region="North America"),

    # South America
    Row(nationality="Argentine", region="South America"),
    Row(nationality="Brazilian", region="South America"),
    Row(nationality="Chilean", region="South America"),
    Row(nationality="Colombian", region="South America"),
    Row(nationality="Uruguayan", region="South America"),
    Row(nationality="Venezuelan", region="South America"),

    # Asia
    Row(nationality="Chinese", region="Asia"),
    Row(nationality="Hong Kong", region="Asia"),
    Row(nationality="Indian", region="Asia"),
    Row(nationality="Indonesian", region="Asia"),
    Row(nationality="Japanese", region="Asia"),
    Row(nationality="Malaysian", region="Asia"),
    Row(nationality="Thai", region="Asia"),

    # Africa
    Row(nationality="Rhodesian", region="Africa"),
    Row(nationality="South African", region="Africa"),

    # Oceania
    Row(nationality="Australian", region="Oceania"),
    Row(nationality="New Zealander", region="Oceania")
]

# COMMAND ----------

# DBTITLE 1,Step 2 markdown
# MAGIC %md
# MAGIC ##### Step 2 - Create nationality_region dataframe

# COMMAND ----------

# DBTITLE 1,Create dataframe
ref_nationality_region_df = spark.createDataFrame(nationality_region)

# COMMAND ----------

# DBTITLE 1,Step 3 markdown
# MAGIC %md
# MAGIC ##### Step 3 - Write the transformed data to the gold ref_nationality_region table

# COMMAND ----------

# DBTITLE 1,Write table
(
    ref_nationality_region_df
        .write
        .format("delta")
        .mode("overwrite")
        .option("overwriteSchema", "true")
        .saveAsTable(target_table)
)

# COMMAND ----------

# DBTITLE 1,Display target table
display(spark.table(target_table))
