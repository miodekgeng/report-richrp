

description 'richrp'

version '1.0.0'

client_script {

  'client.lua'

}

server_scripts {

  '@mysql-async/lib/MySQL.lua',
  'server.lua'

}
