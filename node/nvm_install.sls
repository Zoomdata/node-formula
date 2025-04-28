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
    - name: |
        mkdir -p /usr/local/nvm && \
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | NVM_DIR=/usr/local/nvm bash
    - creates: /usr/local/nvm
    - shell: /bin/bash

nvm/install node v18.20.7:
  cmd.run:
    - name: |
        export NVM_DIR="/usr/local/nvm" && \
        . "$NVM_DIR/nvm.sh" && \
        nvm install 18.20.7 && \
        nvm alias default 18.20.7
    - shell: /bin/bash
    - unless: test -x /usr/local/nvm/versions/node/v18.20.7/bin/node
    - require:
        - cmd: nvm/install script

nvm/set permissions for /usr/local/nvm:
  cmd.run:
    - name: chmod -R 755 /usr/local/nvm
    - shell: /bin/bash
    - require:
        - cmd: nvm/install node v18.20.7

nvm/persist NVM in profile:
  file.managed:
    - name: /etc/profile.d/nvm.sh
    - mode: '0755'
    - contents: |
        export NVM_DIR="/usr/local/nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nodejs/Check installed Node.js version:
  cmd.run:
    - name: /usr/local/nvm/versions/node/v18.20.7/bin/node --version
    - shell: /bin/bash
    - require:
        - cmd: nvm/set permissions for /usr/local/nvm

nodejs/Configure systemd DefaultEnvironment:
  file.managed:
    - name: /etc/systemd/system.conf.d/99-nodejs.conf
    - makedirs: True
    - mode: '0644'
    - contents: |
        [Manager]
        DefaultEnvironment=NODE_HOME=/usr/local/nvm/versions/node/v18.20.7/bin/node
        DefaultEnvironment=PATH=/usr/local/nvm/versions/node/v18.20.7/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    - require:
        - cmd: nvm/set permissions for /usr/local/nvm

nodejs/Reload systemd daemon:
  cmd.run:
    - name: systemctl daemon-reexec
    - shell: /bin/bash
    - require:
        - file: nodejs/Configure systemd DefaultEnvironment

{%- endif %}
