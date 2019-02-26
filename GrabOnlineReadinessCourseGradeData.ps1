#These two lines just allows this script to reference the GetOauthAccessToken script.
#These lines are imparative for thid script to grab the access token.
Set-Location "C:\Users\grossj\Desktop\"
.\GetOauthAccessToken.ps1

#This access token variable is set to the response variable that is pulled from the GetOauthAccessToken script
$access_token = $response.Content | ConvertFrom-Json | Select-Object -expand access_token
 


#Contains the credentials to connect to BB Learn's API successfully 
$header = @{
    "Accept"="application/json"
    "Authorization"="Bearer $access_token"
}

#Path To Output file variable stores the file where we want to send all the json data to
$pathToOutputFile = "C:\Users\grossj\Desktop\Exit_Test_Results.txt"

#-----------------------------------------------------------------------------------------------





$current_year = Get-Date -UFormat "%Y"

$date = Get-Date

$official_course_name = ""

#If the course is in the Fall
if(($date -ge "8/27/${current_year}") -and ($date -le "12/11/${current_year}"))
{
    #Output the right course name for Fall of ____ Year
    $official_course_name = "Online_Student_Readiness_fall_${current_year}"
}

#If the course is in the Winter
if(($date -ge "12/21/${current_year}") -and ($date -le "1/14/${current_year}"))
{
    #Output the right course name for Winter of ____ Year
    $official_course_name = "Online_Student_Readiness_winter_${current_year}"   
}

#If the course is in the Spring
if(($date -ge "1/21/${current_year}") -and ($date -le "5/10/${current_year}"))
{
    #Output the right course name for Spring of ____ Year
    $official_course_name = "Online_Student_Readiness_spring_${current_year}"   
}

#If the course is in the Summer
if(($date -ge "6/21/${current_year}") -and ($date -le "8/17/${current_year}"))
{
    #Output the right course name for Summer of ____ Year
    $official_course_name = "Online_Student_Readiness_summer_${current_year}"   
}


Write-Host $official_course_name

#----------------------------------------------------------------------------------------





#This variable will store all the userIds, and scores for each user of the Online Readiness Course
$user_and_scores = Invoke-WebRequest -Headers $header -Method Get -Uri "https://testbb.alfredstate.edu/learn/api/public/v1/courses/courseId:${official_course_name}/gradebook/columns/_56279_1/users?fields=score,userId" -ContentType "application/json" | ConvertFrom-Json | Select-Object -expand results

#This variable will end up storing all of the user ids 
$uids = @()

   
#We loop through all the user scores
ForEach($ind_user in $user_and_scores)
{
   #If the score of a individual user is gt or eq to 80% filter it into the form..
   if($ind_user.score -ge 80)
   {
        #then append it into the output file
        Add-Content $pathToOutputFile $ind_user

        #store the user ids into the uids variable to use by another script
        $uids += $ind_user.userId
   }
}
#add the timestamp for each time this script runs. This will be used for analysis & archiving purposes
$timestamp_date_time = Get-Date
$timestamp_date_time.ToUniversalTime();
Add-Content $pathToOutputFile "" 
Add-Content $pathToOutputFile "Timestamped Date & Time: ${timestamp_date_time}"


# add a border and line breaks so that the you end user reading the results isn't confused on where certain sets of data stop or begin
Add-Content $pathToOutputFile ""
Add-Content $pathToOutputFile "----------------------------------------------------------------------------"
Add-Content $pathToOutputFile ""





