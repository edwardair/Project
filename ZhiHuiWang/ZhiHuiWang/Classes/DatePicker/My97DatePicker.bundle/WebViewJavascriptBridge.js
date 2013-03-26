;(function() {
	if (window.nativePage) { return; }
    //自定义的从webview发出的请求标识
    var EXECUTESCRIPT = "_objectc_webview_executescript_";
    //自定义的数组转换成字符后的连接符，在oc里再替换成双引号
    var OBJECT_ARRAY_CONNECTOR = "_OBJECTC_CONNECTOR_";

function _private_Base64() {  
   
    // private property  
    _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";  
   
    // public method for encoding  
    this.encode = function (input) {  
        var output = "";  
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;  
        var i = 0;  
        input = _utf8_encode(input);  
        while (i < input.length) {  
            chr1 = input.charCodeAt(i++);  
            chr2 = input.charCodeAt(i++);  
            chr3 = input.charCodeAt(i++);  
            enc1 = chr1 >> 2;  
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);  
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);  
            enc4 = chr3 & 63;  
            if (isNaN(chr2)) {  
                enc3 = enc4 = 64;  
            } else if (isNaN(chr3)) {  
                enc4 = 64;  
            }  
            output = output +  
            _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +  
            _keyStr.charAt(enc3) + _keyStr.charAt(enc4);  
        }  
        return output;  
    }  
   
    // public method for decoding  
    this.decode = function (input) {  
        var output = "";  
        var chr1, chr2, chr3;  
        var enc1, enc2, enc3, enc4;  
        var i = 0;  
        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");  
        while (i < input.length) {  
            enc1 = _keyStr.indexOf(input.charAt(i++));  
            enc2 = _keyStr.indexOf(input.charAt(i++));  
            enc3 = _keyStr.indexOf(input.charAt(i++));  
            enc4 = _keyStr.indexOf(input.charAt(i++));  
            chr1 = (enc1 << 2) | (enc2 >> 4);  
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);  
            chr3 = ((enc3 & 3) << 6) | enc4;  
            output = output + String.fromCharCode(chr1);  
            if (enc3 != 64) {  
                output = output + String.fromCharCode(chr2);  
            }  
            if (enc4 != 64) {  
                output = output + String.fromCharCode(chr3);  
            }  
        }  
        output = _utf8_decode(output);  
        return output;  
    }
   
    // private method for UTF-8 encoding  
    _utf8_encode = function (string) {  
        string = string.replace(/\r\n/g,"\n");  
        var utftext = "";  
        for (var n = 0; n < string.length; n++) {  
            var c = string.charCodeAt(n);  
            if (c < 128) {  
                utftext += String.fromCharCode(c);  
            } else if((c > 127) && (c < 2048)) {  
                utftext += String.fromCharCode((c >> 6) | 192);  
                utftext += String.fromCharCode((c & 63) | 128);  
            } else {  
                utftext += String.fromCharCode((c >> 12) | 224);  
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);  
                utftext += String.fromCharCode((c & 63) | 128);  
            }  
   
        }  
        return utftext;  
    }  
   
    // private method for UTF-8 decoding  
    _utf8_decode = function (utftext) {  
        var string = "";  
        var i = 0;  
        var c = c1 = c2 = 0;  
        while ( i < utftext.length ) {  
            c = utftext.charCodeAt(i);  
            if (c < 128) {  
                string += String.fromCharCode(c);  
                i++;  
            } else if((c > 191) && (c < 224)) {  
                c2 = utftext.charCodeAt(i+1);  
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));  
                i += 2;  
            } else {  
                c2 = utftext.charCodeAt(i+1);  
                c3 = utftext.charCodeAt(i+2);  
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));  
                i += 3;  
            }  
        }  
        return string;  
    }  
}
    //采用请求队列的目的是保证每个window.location的重定向都会被执行，否则瞬时内多个window.location改变只会执行最后一个 
    //!!!!!!!!!!!!!
    //这只是一个对于目前的设计来说可行的方案，每个请求并没有做key－value的键值映射，但在目前已经足够使用
    //如果添加回调等等其他的接口，需要增加键值对来维护队列的准确性,而不是每次都取队列的第一个
    //!!!!!!!!!!!!!
    
    //队列相关 start
    var eventQueue = new Array();
    var canSendNewRequest_ = true;
	function executeScript(functionName) 
    {
        var base64 = new _private_Base64();  
        var base64FunctionName = base64.encode(functionName); 
        eventQueue.push(base64FunctionName); 
        if(canSendNewRequest_)
        {
            canSendNewRequest_ = false;
            setTimeout(function _private_execute(){
        
                window.location = 'applewebdata://' + EXECUTESCRIPT + base64FunctionName;
        
            });
            
            
        } 
	}
    //这个方法只允许objectc调用,objectc中每执行完一个window.location转向的逻辑都会来调用一次sendNeWRequest
	function sendNeWRequest()
    {
        if(eventQueue.length > 0)
        {
            //把之前的第一个请求踢出去
            eventQueue.splice(0,1);
        }
        
        if(eventQueue.length > 0)
        {
            var base64FunctionName = eventQueue[0];
            setTimeout(function _private_execute(){
        
                window.location = 'applewebdata://' + EXECUTESCRIPT + base64FunctionName;
        
            });
            
            
        }
        else
        {
            //队列空了，把开关打开，下个请求会触发新一轮的队列循环
            canSendNewRequest_ = true;
        }
    }
    // 队列相关 end

	window.nativePage = {
    
		executeScript: executeScript,
        sendNeWRequest:sendNeWRequest
	}

})();
