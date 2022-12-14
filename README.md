# appologi.es

### Step one 
Download dart https://dart.dev/get-dart
### Step two
run `dart pub global activate conduit`
### Step three
append the following line to `.bashrc` `export PATH="$PATH":"$HOME/.pub-cache/bin"`
### Step four
clone the repository
### Step five
adjust the config.yaml and append bootnode: 167.71.64.150:8989
### Step six
run `conduit build`
### Step seven
add the following service to `../../etc/systemd/system``` `nano nameofservice.service`
in our case
```
[Service]
Type=simple
Restart=always
RestartSec=1
ExecStart=/root/gladiato.rs/gladiators.aot --config-path ./root/gladiato.rs/config.yaml

[Install]
WantedBy=multi-user.target
```
### Step eight
sudo apt install nginx
### Step nine
adjust `../../etc/nginx/sites-available/default`
to 
```
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;
        #
        # Note: You should disable gzip for SSL traffic.
        # See: https://bugs.debian.org/773332
        #
        # Read up on ssl_ciphers to ensure a secure configuration.
        # See: https://bugs.debian.org/765782
        #
        # Self signed certs generated by the ssl-cert package
        # Don't use them in a production server!
        #
        # include snippets/snakeoil.conf;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                proxy_pass http://127.0.0.1:8888;
        }
```
### Step nine
sudo service nameofservice start
### Step ten
sudo service nginx restart
