function get(req,a)
	local status = 200
	local headers = {
		['X-Tarantool'] = "FROM_TNT";
	}
	local log = require('log')
	log.info("Received GET request - processing start")
 	local ur = req.uri
	if ur=="/api/" or ur=="/api" then 
		log.error("Key is not specified 400")
		log.info("GET request proccesing end")
		status = 400
		return status, headers, "400"
	end
	local splited = mysplit(ur,"/")


        local resp = box.space.era1:select{splited[2]}
        if resp[1]==nil then
	    log.error("Key doesnt exist 404")
	    log.info("GET request processing end - failure") 
	    status = 404
            return status,headers, "404"
        end

	log.info("Get request processing end - success")

        return status,headers,resp
end

function post(pack,req)
	
	local status = 200
	local headers = {
		['X-Tarantool']="FROM_TNT";
 	}
	local ur = pack.uri
	
	
	 --s = box.schema.create_space('era1', {if_not_exists = true, user = 'guest'})
        -- s:create_index("I",{unique=true,parts={{field=1,type='string'}}})
	local log = require('log')
	log.info("Received POST request - processing start")
	
	if ur~="/api" and ur~="/api/" then
	    log.error("Invalid url 400")
	    log.info("POST request processing end - failure")
	    status = 400
	    return status,headers,"400"
	end

	if req.key==nil then 
	    log.error("Key is not specified 400")
	    log.info("POST request procesing end - failure")
	    status = 400
	    return status,headers,"400"
        end
	if req.value==nil then
	     log.error("Value is not specified 400")
	     log.info("POST request processing end - failure")
	     status = 400
	     return status,headers,"400"
        end
	if type(req.key)~="string" then 
	      log.error("Key type is not string 400")
	      log.info("POST request processing end - failure")
	      status = 400
              return status,headers,"400"
        end    
	local tr = box.space.era1:select{req.key}
	if tr[1] ~= nil then
	    log.error("Key exists 409")
	    log.info("POST request processing end - failure")
	    status = 409
	    return status,headers,"409"
	end
	box.space.era1:insert{req.key,req.value}
	box.info("POST request processin end - success")
        return status,headers,"200"
	
	

end

function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

function put(req,data)
	local status = 200
	local headers = {
		['X-Tarantool']="FROM_TNT";
	}

	local log = require('log')
	log.info("PUT request processing start")
	
	local ur = req.uri
	if ur == "/api/" or ur=="/api" then
	    log.error("Key is not specified 400")
	    log.info("PUT request processing end - failure")
	    status = 400    
	    return status,headers,"400"
        end
	local splited = mysplit(ur,"/")
	
	if data.value==nil then
	    log.error("Value is not specified 400")
	    log.info("PUT request processing end - failure")
	    status = 404
            return status,headers,"400"
        end
		

	local tr = box.space.era1:select{splited[2]}
	if tr[1]==nil then
	    log.error("Key doesnt exist 404")
	    log.info("PUT request processing end - failure")
	    status  = 404 
            return status,headers,"404"
        end
	box.space.era1:replace{splited[2],data.value}
	box.info("PUT request processing end - success")
	return status,headers,"200"

end
	
function delete(req)
	local status = 200
	local headers = {
		['X-Tarantool']="FROM_TNT";
	}
        local log = require('log')
	log.info("DELETE request processing start")	
	local ur = req.uri
	if ur=="/api/" or ur=="/api" then 
	    log.error("Key is not specified 400")
	    log.info("DELETE request processing end - failure")
	    status = 400
	    return status,headers,"400"
        end
	local splited = mysplit(ur,"/")

	local tr = box.space.era1:select{splited[2]}
	if tr[1]==nil then
	    log.error("Key doesnt exist 404")
	    log.info("DELETE request processing end - failure")
	    status = 404
	    return status,headers,"404"
	end
	box.space.era1:delete{splited[2]}
	log.info("DELETE request processing end - success")
	return status,headers,"200"
	
	
end		

function fodfo(req, a)
    local status = 200
    local headers = {
      ["X-Tarantool"] = "FROM_TNT",
    }
    
   local ur = req.uri
   local splited = mysplit(ur,"/")

   local body = box.space.era1:select{splited[2]}
    return status, headers, body
  end	

function foo(req,a)
return a
end


box.cfg {
 listen = 3311, -- Specifying the location of Tarantool
log = 'file:/etc/tarantool/instances.enabled/trylog.txt'
 --log_level = 3	
}
-- Give access
---box.once('give_granter2', function()
 -- print("GRANTED") 
  --box.schema.user.grant('guest', 'read,write,execute,create,update,delete', 'universe')            
--end)
