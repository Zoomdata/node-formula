{%- from 'node/map.jinja' import nodejs with context -%}

{%- if 'repo_name' in nodejs %}

nodejs/Set NODE_HOME env variable globally:
  file.blockreplace:
    - name: '/etc/environment'
    - content: 'NODE_HOME={{ nodejs.repo_base_url }}'
    - append_if_not_found: True
    - append_newline: True

{%- endif %}