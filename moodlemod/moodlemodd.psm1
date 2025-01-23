function Get-MoodleSearchUser {
    
    param(
        [string]$webapp,
        [string]$token,
        [string]$username
    )

    $ErrorActionPreference = 'SilentlyContinue'

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

Export-ModuleMember -Function Get-MoodleSearchUser
