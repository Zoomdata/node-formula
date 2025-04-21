{%- from 'node/map.jinja' import nodejs with context -%}

include:
  {%- if nodejs.use_nvm is defined and nodejs.use_nvm %}
  - node.nvm_install
  {%- else %}
  - node.repo
  - node.install
  {%- endif %}
  - node.env
