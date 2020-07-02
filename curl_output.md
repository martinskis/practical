```sh
* Rebuilt URL to: http://practical.martinski.com:8080/
*   Trying 52.0.87.46...
* TCP_NODELAY set
* Connected to practical.martinski.com (52.0.87.46) port 8080 (#0)
> GET / HTTP/1.1
> Host: practical.martinski.com:8080
> User-Agent: curl/7.54.0
> Accept: */*
> 
< HTTP/1.1 302 Moved Temporarily
< Server: awselb/2.0
< Date: Thu, 02 Jul 2020 23:52:40 GMT
< Content-Type: text/html
< Content-Length: 126
< Connection: keep-alive
< Location: https://practical.martinski.com:8443/
< 
* Ignoring the response-body
{ [126 bytes data]
* Connection #0 to host practical.martinski.com left intact
* Issue another request to this URL: 'https://practical.martinski.com:8443/'
*   Trying 52.0.87.46...
* TCP_NODELAY set
* Connected to practical.martinski.com (52.0.87.46) port 8443 (#1)
* ALPN, offering h2
* ALPN, offering http/1.1
* Cipher selection: ALL:!EXPORT:!EXPORT40:!EXPORT56:!aNULL:!LOW:!RC4:@STRENGTH
* successfully set certificate verify locations:
*   CAfile: /etc/ssl/cert.pem
  CApath: none
* TLSv1.2 (OUT), TLS handshake, Client hello (1):
} [229 bytes data]
* TLSv1.2 (IN), TLS handshake, Server hello (2):
{ [98 bytes data]
* TLSv1.2 (IN), TLS handshake, Certificate (11):
{ [4842 bytes data]
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
{ [333 bytes data]
* TLSv1.2 (IN), TLS handshake, Server finished (14):
{ [4 bytes data]
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
} [70 bytes data]
* TLSv1.2 (OUT), TLS change cipher, Client hello (1):
} [1 bytes data]
* TLSv1.2 (OUT), TLS handshake, Finished (20):
} [16 bytes data]
* TLSv1.2 (IN), TLS change cipher, Client hello (1):
{ [1 bytes data]
* TLSv1.2 (IN), TLS handshake, Finished (20):
{ [16 bytes data]
* SSL connection using TLSv1.2 / ECDHE-RSA-AES128-GCM-SHA256
* ALPN, server accepted to use h2
* Server certificate:
*  subject: CN=practical.martinski.com
*  start date: Jul  2 00:00:00 2020 GMT
*  expire date: Aug  2 12:00:00 2021 GMT
*  subjectAltName: host "practical.martinski.com" matched cert's "practical.martinski.com"
*  issuer: C=US; O=Amazon; OU=Server CA 1B; CN=Amazon
*  SSL certificate verify ok.
* Using HTTP2, server supports multi-use
* Connection state changed (HTTP/2 confirmed)
* Copying HTTP/2 data in stream buffer to connection buffer after upgrade: len=0
* Using Stream ID: 1 (easy handle 0x7fecec80ec00)
> GET / HTTP/2
> Host: practical.martinski.com:8443
> User-Agent: curl/7.54.0
> Accept: */*
> 
* Connection state changed (MAX_CONCURRENT_STREAMS updated)!
< HTTP/2 200 
< date: Thu, 02 Jul 2020 23:52:40 GMT
< content-type: text/html; charset=utf-8
< content-length: 2507
< x-dns-prefetch-control: off
< x-frame-options: SAMEORIGIN
< strict-transport-security: max-age=15552000; includeSubDomains
< x-download-options: noopen
< x-content-type-options: nosniff
< x-xss-protection: 1; mode=block
< vary: Origin, Accept-Encoding
< access-control-allow-credentials: true
< etag: W/"9cb-0Fz8US25u82EQ53kdbU1Cbnd3GU"
< set-cookie: connect.sid=s%3AWWCSXkmkj7Ohj-nySt0h2IVsh3yzhkmF.HHMMdG%2FVrvFUXgLT9PMTG%2Bas5EfAja9aAkQ3uiili2o; Path=/; HttpOnly
< 
{ [2506 bytes data]
* Connection #1 to host practical.martinski.com left intact
<!DOCTYPE html><html lang="en"><head prefix="og: http://ogp.me/ns# nodejsexpressdemo: http://ogp.me/ns/apps/nodejsexpressdemo#"><meta charset="utf-8"><meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><meta name="viewport" content="width=device-width,initial-scale=1"><title>swimlane-devops-practical - Articles</title><meta name="keywords" content="{{ pkg.keywords.join(',') }}"><meta name="description" content="{{ pkg.description }}"><meta property="fb:app_id" content="293989217296609"><meta property="og:title" content="swimlane-devops-practical - Articles"><meta property="og:description" content="A demo app illustrating the usage of express, mongoose, passportjs, pug and other modules in nodejs"><meta property="og:url" content="http://nodejs-express-demo.herokuapp.com"><meta property="og:site_name" content="Swimlane DevOps Practical"><meta property="fb:admins" content="1037213945"><link href="/css/bootstrap.min.css" rel="stylesheet"><link href="/css/jquery.tagsinput.css" rel="stylesheet"><link href="//netdna.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet"><link rel="stylesheet" href="/css/app.css"><!--HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries--><!--if lt IE 9script(src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js")
script(src="https://oss.maxcdn.com/libs/respond.js/1.3.0/respond.min.js")--></head><body><nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark"><a class="navbar-brand" href="/">Swimlane DevOps Practical</a><button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button><div class="collapse navbar-collapse" id="navbarCollapse"><ul class="navbar-nav mr-auto"><li class="nav-item"><a class="nav-link" href="/articles/new" title="new article">New</a></li><li class="nav-item"><a class="nav-link" href="/login" title="Login">Login</a></li></ul></div></nav><div class="container"><div class="page-header"><h1>Articles</h1></div><div class="messages"></div><div class="content"><h4 class="text-muted">No articles.&nbsp;<a href="/articles/new">create one</a></h4></div></div><div class="footer my-5"></div><script src="//code.jquery.com/jquery-1.10.2.min.js"></script><script src="/js/bootstrap.min.js"></script><script src="/js/jquery.tagsinput.min.js"></script><script src="/js/app.js"></script></body></html>
```
