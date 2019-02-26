#This will bypass certain errors
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


#These variables will store the application key and secret key given 
#to a user when he/she makes  an application on the developer blackboard site.
$key = "49c89f44-329b-423a-8e88-d1ad7c6fb549"
$secret = "oqQKQwLkN185GwncD0836O8IFsp532b6"


#The Pre Encoded Credential variable stores the application & secret key before
#it gets encoded.
$pre_encode_cred = $key + ":" + $secret


#The auth variable encodes the key and secret key together. This will be sent in the
#api call when we need to initialize a new access token.
$auth = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($pre_encode_cred))


#Contains the credentials to connect to BB Learn's API successfully
$head = @{
"Content-Type"="application/x-www-form-urlencoded"
"Authorization"="Basic $auth"
}

$body = @{
"grant_type"="client_credentials"
}



#API Call to grab the Access Key
$response = Invoke-WebRequest -Method Post -Uri "https://testbb.alfredstate.edu/learn/api/public/v1/oauth2/token" -Headers $head -Body $body 

