include:
  - mysql.python
  
mysql-client:
  pkg.installed:
    - pkgs:
      - libmysqlclient18
      - libmysqlclient-dev
      - mysql-client
