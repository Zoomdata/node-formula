{%- from 'node/map.jinja' import nodejs with context -%}

# ---------------------------------------------
# APT Configurations for Debian-based systems
# ---------------------------------------------
{%- for conf, params in nodejs.apt_config | default({}, true) | dictsort %}
nodejs/Configure APT {{ conf }}:
  file.managed:
    - name: {{ salt['file.join']('/etc/apt/apt.conf.d', conf) }}
    - user: root
    - group: root
    - mode: '0644'
    - contents: {{ params | yaml }}
{%- endfor %}

# ---------------------------------------------
# Configure package repo
# ---------------------------------------------
{%- if 'repo_name' in nodejs %}
nodejs/Set {{ nodejs.repo_name }} repo:
  pkgrepo.managed:
    # Debian/Ubuntu
    {%- if grains['os_family'] == 'Debian' %}
    {%- if 'repo_ppa' in nodejs %}
    - ppa: {{ nodejs.repo_ppa }}
    {%- else %}
    - name: {{ nodejs.repo_entry | format(**nodejs) }}
    {%- endif %}
    {%- endif %}

    # RedHat/CentOS
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

# ---------------------------------------------
# Execute repo setup script for RHEL/CentOS
# ---------------------------------------------
{%- if grains['os_family'] in ['RedHat', 'CentOS'] and 'setup_script' in nodejs %}
nodejs/Run setup script:
  cmd.run:
    - name: {{ nodejs.setup_script }}
    - unless: which node
    - shell: /bin/bash
{%- endif %}
