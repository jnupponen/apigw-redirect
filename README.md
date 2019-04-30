# apigw-redirect
> Example project that does HTTP 302 Redirect with AWS API Gateway

## API Gateway 302 Redirect

This SAM template will do HTTP 302 redict from API Gateway url to https://www.google.com/ with AWS API Gateway mock response. See details in [template.yaml](template.yaml).

## Init

```
AWS_PROFILE=<profile> make init
```

## Deploy

```
AWS_PROFILE=<profile> make deploy
```

## Test

See stack outputs for API Gateway url and test with curl:

```
13:06 $ curl -D -  https://<ApiGatewayId>.execute-api.eu-west-1.amazonaws.com/Prod/
HTTP/1.1 302 Found
Date: Tue, 30 Apr 2019 10:06:56 GMT
Content-Type: application/json
Content-Length: 0
Connection: keep-alive
x-amzn-RequestId: af786abf-6b2f-11e9-85de-fb424c70a9a2
x-amz-apigw-id: Y8mqDFlZjoEFuQw=
Location: https://www.google.com/

```
