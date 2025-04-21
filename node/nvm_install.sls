{%- from 'node/map.jinja' import nodejs with context -%}

{%- if nodejs.use_nvm is defined and nodejs.use_nvm %}

nvm/install deps:
  pkg.installed:
    - pkgs:
      {%- if grains['os_family'] == 'RedHat' %}
        - curl
        - gcc
        - make
        - openssl-devel
      {%- elif grains['os_family'] == 'Debian' %}
        - curl
        - gcc
        - make
        - libssl-dev
      {%- else %}
        - curl
        - gcc
        - make
      {%- endif %}
      
nvm/install script:
  cmd.run:
    - name: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    - creates: /root/.nvm
    - shell: /bin/bash

nvm/install node {{ nodejs.node_version }}:
  cmd.run:
    - name: |
        export NVM_DIR="/root/.nvm" && \
        . "$NVM_DIR/nvm.sh" && \
        nvm install {{ nodejs.node_version }} && \
        nvm alias default {{ nodejs.node_version }}
    - shell: /bin/bash
    - unless: test -x /root/.nvm/versions/node/v{{ nodejs.node_version }}/bin/node
    - require:
        - cmd: nvm/install script

nvm/persist env globally:
  file.managed:
    - name: /etc/profile.d/nvm.sh
    - mode: '0755'
    - contents: |
        export NVM_DIR="/root/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nodejs/Check installed version:
  cmd.run:
    - name: /root/.nvm/versions/node/v{{ nodejs.node_version }}/bin/node --version
    - shell: /bin/bash
    - require:
        - cmd: nvm/install node {{ nodejs.node_version }}

{%- endif %}
