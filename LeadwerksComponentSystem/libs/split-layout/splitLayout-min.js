var SplitLayout=function(e,t,n,o){e="number"==typeof arguments[0]?arguments[0]:200,t="number"==typeof arguments[1]?arguments[1]:200,n="object"==typeof arguments[2]?arguments[2]:{padding:"10px"},n["white-space"]="nowrap",n.overflow="hidden",n["text-overflow"]="ellipsis",n.position="absolute",n.top="0",n.left="0",n.bottom="0",o="object"==typeof arguments[3]?arguments[3]:{padding:"10px"},o["white-space"]="nowrap",o.overflow="hidden",o["text-overflow"]="ellipsis",o.position="absolute",o.top="0",o.right="0",o.bottom="0";var i=!0;window.addEventListener("DOMContentLoaded",function(){var t=document.createElement("div"),d=document.getElementById("nav");if("undefined"==typeof d||null==d)return alert("Left pane '#nav' not found."),void(i=!1);var r=document.getElementById("content");if("undefined"==typeof r||null==r)return alert("Right pane '#content' not found."),void(i=!1);var s=document.createElement("style"),l="";for(key in n)l+=key+":"+n[key]+";";var a="";for(key in o)a+=key+":"+o[key]+";";css="*{box-sizing:border-box}body{margin:0;padding:0;border:0;width:100%;height:100%;overflow:hidden}#container{position:absolute;top:0;left:0;right:0;bottom:0}#nav{"+l+"}#content{"+a+"}#splitter{position:absolute;background:#e8e8e8 url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAcAAAAvBAMAAADdg827AAAAJFBMVEWws7rGx8zMzdChpq64u8CqrrW/wcWdoaqSl6GmqbHR0tUAAAAc4jdzAAAADHRSTlOZmZmZmZmZmZmZmQDJ3LphAAAAKUlEQVQI12PYxhpZwCDkwGpADpGYCiSk3IFESgWQ8GynsWKyiV1iDhMAtikgHZgUCDoAAAAASUVORK5CYII=') no-repeat;background-position: center center;border-right:1px #999 dotted;border-left:1px #999 dotted;top:0;bottom:0;right:0px;width:7px;cursor:ew-resize}.noSel{-webkit-touch-callout: none;-webkit-user-select: none;-khtml-user-select: none;-moz-user-select: none;-ms-user-select: none;user-select: none}",head=document.head||document.getElementsByTagName("head")[0],s.type="text/css",s.appendChild(document.createTextNode(css)),head.insertBefore(s,head.getElementsByTagName("style")[0]);var c=e/window.innerWidth*100,p=100-c;d.style.right=p+"%",r.style.left=c+"%",t.id="splitter",d.appendChild(t)}),window.addEventListener("load",function(){if(i){if(new RegExp("(?:^|;\\s*)"+encodeURIComponent("winposition").replace(/[\-\.\+\*]/g,"\\$&")+"\\s*\\=").test(document.cookie)){var e=decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*"+encodeURIComponent("winposition").replace(/[\-\.\+\*]/g,"\\$&")+"\\s*\\=\\s*([^;]*).*$)|^.*$"),"$1"))||null;nav.style.right=e.split("|")[0],content.style.left=e.split("|")[1]}splitter.onmousedown=function(){document.onmousemove=function(e){if(e=e||event,1==e.which&&e.clientX>=0&&e.clientX<=window.innerWidth&&e.clientX>=t&&e.clientX<=window.innerWidth-t){nav.classList.add("noSel");var n=(e.clientX+5)/window.innerWidth*100,o=100-n;n=n.toFixed(2)+"%",o=o.toFixed(2)+"%",nav.style.right=o,content.style.left=n,document.cookie="winposition="+encodeURIComponent(o+"|"+n)+"; expires=Fri, 31 Dec 9999 23:59:59 GMT; path=/"}},document.onmouseup=function(){nav.classList.remove("noSel"),document.onmousemove=null}},document.getElementById("splitter").ondragstart=function(){return!1}}})};