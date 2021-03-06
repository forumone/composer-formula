get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/
    - env:
      - HOME: /root

install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - env:
      - HOME: /root
    - watch:
      - cmd: get-composer


composer-patch:
  pkg.installed:
    - name: patch

# Get COMPOSER_DEV_WARNING_TIME from the installed composer, and if that time has passed
# then it's time to run `composer selfupdate`
#
# It would be nice if composer had a command line switch to get this, but it doesn't,
# and so we just grep for it.
#
update-composer:
  cmd.run:
    - name: "/usr/local/bin/composer selfupdate"
    - unless: test $(grep --text COMPOSER_DEV_WARNING_TIME /usr/local/bin/composer | egrep '^\s*define' | sed -e 's,[^[:digit:]],,g') \> $(php -r 'echo time();')
    - cwd: /usr/local/bin
    - env:
      - HOME: /root
    - require:
      - cmd: install-composer
