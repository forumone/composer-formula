{%- set salt_user_home = salt['user.info'](salt_user).get('home', '/root') %}

get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/

install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - env:
      - HOME: {{ salt_user_home }}
    - watch:
      - cmd: get-composer

