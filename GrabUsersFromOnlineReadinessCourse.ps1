#These two lines just allows this script to reference the GetOauthAccessToken script.
#These lines are imparative for thid script to grab the access token.
Set-Location "C:\Users\grossj\Desktop\"
.\GetOauthAccessToken.ps1
.\GrabOnlineReadinessCourseGradeData.ps1

#This access token variable is set to the response variable that is pulled from the GetOauthAccessToken script
$access_token = $response.Content | ConvertFrom-Json | Select-Object -expand access_token


#Contains the credentials to connect to BB Learn's API successfully 
$header = @{
    "Accept"="application/json"
    "Authorization"="Bearer $access_token"
}


#Path To Output file variable stores the file where we want to send all the json data to
$pathToOutputFile = "C:\Users\grossj\Desktop\User_ExternalId_Results.txt"


$timestamp_date_time = Get-Date
$timestamp_date_time.ToUniversalTime();


#We loop through all the user scores
ForEach ($uid in $uids)
{
    #for each individual user id in the list of userids that we are referencing from
    #we want to feed each id into the API Call and add the result to our text file
    $user_identification = Invoke-WebRequest -Headers $header -Method Get -Uri "https://testbb.alfredstate.edu/learn/api/public/v1/users/${uid}?fields=id,externalId,userName" -ContentType "application/json" | ConvertFrom-Json
    Add-Content $pathToOutputFile $user_identification
}
#add the timestamp for each time this script runs. This will be used for analysis & archiving purposes
Add-Content $pathToOutputFile "" 
Add-Content $pathToOutputFile "Timestamped Date & Time: ${timestamp_date_time}"

# add a border and line breaks so that the you end user reading the results isn't confused on where certain sets of data stop or begin
Add-Content $pathToOutputFile ""
Add-Content $pathToOutputFile "----------------------------------------------------------------------------"
Add-Content $pathToOutputFile ""