name "reverse-proxy"

run_list(
         "recipe[apt]",
         "recipe[openssl]",
         "recipe[apache2]",
         "recipe[apache2::mod_ssl]",
         "recipe[apache2::mod_proxy]",
         "recipe[apache2::mod_proxy_http]"
)