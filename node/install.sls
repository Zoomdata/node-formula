{%- from 'node/map.jinja' import nodejs with context -%}

nodejs/Install Node.js:
  pkg.installed:
    - name: {{ nodejs.pkg }}
    {%- if 'repo_name' in nodejs %}
    - fromrepo: {{ nodejs.repo_name }}
    {%- endif %}
