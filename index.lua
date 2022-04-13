local redis = require"redis"

function main(argv)
  local r = {}
  r.status = 200
  r.body = {}
  r.body.argv = argv
  
  local client.connect("localhost",6379)
  r.body.redis = client.get("test")
  
  return r
end
