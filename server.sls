{% set db = pillar.get('db',{}) -%}
{% set password = db.get('password','password') -%}

include:
  - mysql.client

mysql-server:
  debconf.set:
    - name: mysql-server
    - data:
        mysql-server/root_password: 
          type: password
          value: {{password}}
        mysql-server/root_password_again: 
          type: password
          value: {{password}}
  pkg.installed:
    - name: mysql-server-5.5
    - require:
      - debconf: mysql-server
  service.running:
    - name: mysql
    - enable: True
      - file: my.cnf
    - watch:
      - file: my.cnf

'my.cnf':
  file.comment:
    - name: /etc/mysql/my.cnf
    - regex: ^bind-address.+=.127\.0\.0\.1$
    - require:
        - pkg: mysql-server

mysql-root-user:
  mysql_user.present:
    - name: root
    - password: {{password}}
    - host: '%'
    - connection_host: localhost
    - connection_user: root
    - connection_pass: {{password}}
    - connection_port: 3306
    - require:
      - service: mysql-server
      - pkg: mysql-server

mysql-root-grant:
  mysql_grants.present:
    - grant: all privileges
    - user: root
    - host: '%'
    - database: '*.*'
    - grant_option: True
    - connection_host: localhost
    - connection_user: root
    - connection_pass: {{password}}
    - connection_port: 3306
    - escape: False
    - require:
        - mysql_user: mysql-root-user
    
    