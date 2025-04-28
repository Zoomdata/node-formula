{%- from 'node/map.jinja' import nodejs with context -%}

{%- if nodejs.node_home is defined %}
nodejs/Append NODE_HOME and PATH to environment:
  file.append:
    - name: '/etc/environment'
    - text:
      - 'NODE_HOME=/root/.nvm/versions/node/v18.20.7/bin/node'
      - 'PATH=/root/.nvm/versions/node/v18.20.7/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
{%- endif %}
