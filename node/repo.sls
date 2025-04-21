{%- from 'node/map.jinja' import nodejs with context -%}

{%- if 'repo_name' in nodejs %}
nodejs/Set {{ nodejs.repo_name }} repo:
  pkgrepo.managed:
    {%- if grains['os_family'] == 'Debian' %}
    - name: {{ nodejs.repo_entry | format(**nodejs) }}
    {%- endif %}
    {%- if grains['os_family'] == 'RedHat' %}
    - name: {{ nodejs.repo_name }}
    {%- if 'repo_key_url' in nodejs %}
    - gpgkey: {{ nodejs.repo_key_url }}
    - gpgcheck: 1
    {%- endif %}
    {%- if 'repo_base_url' in nodejs %}
    - baseurl: {{ nodejs.repo_base_url }}
    {%- endif %}
    {%- endif %}
{%- endif %}
