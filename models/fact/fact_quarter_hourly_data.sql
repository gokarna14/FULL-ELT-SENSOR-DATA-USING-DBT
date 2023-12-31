{{
    config(
        materialized = 'incremental',
        on_schema_change = 'fail'
    )
}}

WITH src_key_reference AS (
    SELECT * FROM {{ref('src_key_referenced')}}
)
SELECT
    {{dbt_utils.surrogate_key(['Date_Key', 'Time_Key', 'Sensor_ID'])}} as quarter_hourly_data_id,
    *
FROM src_key_referenced

{%if is_incremental() %}
   WHERE DATE_KEY + TIME_KEY > (SELECT MAX(DATE_KEY) + MAX(TIME_KEY) FROM {{this}})
{% endif %}