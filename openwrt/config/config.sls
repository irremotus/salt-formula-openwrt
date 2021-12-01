# -*- coding: utf-8 -*-
# vim: ft=sls

{%- macro uci_config_file(name) %}
/etc/config/{{ name }}:
  file.managed:
    - source: salt://openwrt/files/uci/{{ name }}.tmpl.jinja
    - template: jinja
    - context:
        openwrt: {{ openwrt | json }}

check_config_{{ name }}:
  cmd.run:
  - name: uci show {{ name }}
  - onchanges:
      - file: /etc/config/{{ name }}
  - onchanges_in:
      - cmd: reload_config
{%- endmacro %}

{%- set openwrt = salt["pillar.get"]("openwrt", {}) %}

{{ uci_config_file('wireless') }}
{{ uci_config_file('network') }}

reload_config:
  cmd.run:
  - name: reload_config
