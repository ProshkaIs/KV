
function get(req,a)
	local status = 200
	local headers = {
		['X-Tarantool'] = "FROM_TNT";
	}
	local log = require('log')
	log.info("Received GET request - processing start")
 	local ur = req.uri
	if ur=="/kv/" or ur=="/kv" then 
		log.error("Key is not specified 400")
		log.info("GET request proccesing end - failure")
		status = 400
		return status, headers, "400"
	end
	local splited = mysplit(ur,"/")
	
	if splited[3]~=nil then 
		log.error("Invalid url 400")
		log.info("GET request processin end - failure")
		status = 400
		return status,headers,"400" 
	end

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
	
	local log = require('log')
	log.info("Received POST request - processing start")
	
	if ur~="/kv" and ur~="/kv/" then
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
	log.info("POST request processin end - success")
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
	if ur == "/kv/" or ur=="/kv" then
	    log.error("Key is not specified 400")
	    log.info("PUT request processing end - failure")
	    status = 400    
	    return status,headers,"400"
        end
	local splited = mysplit(ur,"/")
	
	if splited[3]~=nil then
		log.error("Invalid url 400")
		log.info("PUT request processing end - failure")
		status = 400
		return status,headers,"400"
	end

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
	if ur=="/kv/" or ur=="/kv" then 
	    log.error("Key is not specified 400")
	    log.info("DELETE request processing end - failure")
	    status = 400
	    return status,headers,"400"
        end
	local splited = mysplit(ur,"/")
	
	if splited[3]~=nil then
		log.error("Invalid url 400")
		log.info("DELETE request processing end - failure")
		status = 400
		return status,headers,"400"
	end

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

box.cfg {
listen = 3311,
log = 'file:/etc/tarantool/instances.enabled/trylog.txt'
}

