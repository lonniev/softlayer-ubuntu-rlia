name "rlia-server"

override_attributes(
                    
         "java" =>
              {
                "install_flavor" => "oracle",
                "jdk_version" => "7",
                "oracle" => { "accept_oracle_download_terms" => true }
              },
              
         "tomcat" =>
              {
                "base_version" => "7"                
              }
         )

run_list(
         "recipe[apt]",
         "recipe[openssl]",
         "recipe[java]",
         "recipe[tomcat]"
         )