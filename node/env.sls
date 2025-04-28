{%- from 'node/map.jinja' import nodejs with context -%}

{%- if nodejs.node_home is defined %}
nodejs/Append NODE_HOME and PATH to environment:
  file.append:
    - name: '/etc/environment'
    - text:
      - 'NODE_HOME={{ nodejs.node_home }}'
      - 'PATH={{ nodejs.node_home | replace("/bin/node", "/bin") }}:$PATH'
{%- endif %}
