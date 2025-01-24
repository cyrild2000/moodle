function Get-MoodleSearchUser {
    
    param(
        [string]$webapp,
        [string]$token,
        [string]$username
    )

    $ErrorActionPreference = 'SilentlyContinue'

    if([string]::IsNullOrEmpty($webapp)) {
        return @{Error="Error Get-MoodleSearchUser";Message="Your must provide a valid server URL"} | ConvertTo-Json
    }

    if([string]::IsNullOrEmpty($token)) {
        return @{Error="Error Get-MoodleSearchUser";Message="Your must provide a valide token"} | ConvertTo-Json
    }

    if([string]::IsNullOrEmpty($username)) {
        return @{Error="Error Get-MoodleSearchUser";Message="Your must provide a username in the form username@domain.fr"} | ConvertTo-Json
    }

    $user_search_url = -join ($webapp, "webservice/rest/server.php?wstoken=", $token, "&wsfunction=core_user_get_users&moodlewsrestformat=json&criteria[0][key]=username&criteria[0][value]=", $username)
    $user_reply = Invoke-WebRequest -uri $user_search_url -ContentType "application/json;charset=UTF-8"
    

    if($user_reply.StatusCode -eq "200") {

       if ((ConvertFrom-Json -InputObject $user_reply).users.length -gt 0) {
            return (ConvertFrom-Json -InputObject $user_reply).users
       } else {
            return @{Error="Error Get-MoodleSearchUser";Message="User Not Found"} | ConvertTo-Json
       }
    } else {
        return @{Error="Error Get-MoodleSearchUser";Message="HTTP ERROR"} | ConvertTo-Json
    }
}

function Get-MoodleSearchCourse {
    param ([string]$webapp, 
            [string]$token,
            [string]$codeModule
    )


    $ErrorActionPreference = 'SilentlyContinue'

    if([string]::IsNullOrEmpty($webapp)) {
        return @{Error="Error Get-MoodleSearchUser";Message="Your must provide a valid server URL"} | ConvertTo-Json
    }

    if([string]::IsNullOrEmpty($token)) {
        return @{Error="Error Get-MoodleSearchUser";Message="Your must provide a valide token"} | ConvertTo-Json
    }

    if([string]::IsNullOrEmpty($codeModule)) {
        return @{Error="Error Get-MoodleSearchCourse";Message="Your must provide a code module"} | ConvertTo-Json
    }

    $module_url = -join($webapp ,"webservice/rest/server.php?wstoken=", $token, "&wsfunction=core_course_search_courses&criterianame=search&criteriavalue=", $codeModule,"&moodlewsrestformat=json")
    $module_reply = Invoke-WebRequest -uri $module_url -ContentType "application/json;charset=UTF-8"
    if($module_reply.StatusCode -eq "200") {

       if ((ConvertFrom-Json -InputObject $module_reply).total -gt 0) {
            return (ConvertFrom-Json -InputObject $module_reply).courses
       } else {
            return @{Error="Error Get-MoodleSearchCourse";Message="Course Not Found"} | ConvertTo-Json
       }
    } else {
        return @{Error="Error Get-MoodleSearchCourse";Message="HTTP ERROR"} | ConvertTo-Json
    }
}

Export-ModuleMember -Function Get-MoodleSearchUser
Export-ModuleMember -Function Get-MoodleSearchCourse
