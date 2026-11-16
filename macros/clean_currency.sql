{% macro clean_currency(column_name) %}
    cast(
        replace(replace({{ column_name }}, '$', ''), ',', '')
        as decimal(10, 2)
    )
{% endmacro %}