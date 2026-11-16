{% macro clean_percent(column_name) %}
    cast(
        replace(nullif({{ column_name }}, 'N/A'), '%', '') as double
        ) / 100.0
{% endmacro %}
