use bf
use bf-s6

# Disable the ASP.NET service
export def disable [] {
    # disable the ASP.NET service
    if (bf-s6 svc is_up aspnet) {
        bf write "Disabling ASP.NET service." app/disable
        bf-s6 svc down aspnet
    } else {
        bf write debug "ASP.NET service is down." app/disable
    }

    # kill the .NET process (if it's still running)
    let dotnet_pids = ps | where name == "/usr/bin/dotnet" | get pid
    if ($dotnet_pids | length) > 0 {
        bf write "Killing .NET processes." app/disable
        $dotnet_pids | each {|x| kill --force --quiet $x }
    } else {
        bf write debug "No .NET processes found." app/disable
    }
}

# Restart application
export def restart [] {
    # disable the service
    disable

    # restart the applcation
    bf write $"Restarting ($env.ASPNET_ASSEMBLY) application." app/restart
    ^s6-rc -u change aspnet
}

# Switch publish and live application directories, and then restart the application
export def switch [
    --terminate (-t)    # If set, the container will terminate after switching code
] {
    # get directories for easy access
    let dir_publish = bf env ASPNET_APP_PUBLISH
    let dir_live = bf env ASPNET_APP_LIVE

    # check that there are some published files to switch to
    let published_files_count = ls $dir_publish | length
    if $published_files_count == 0 { bf write error "Please publish your application first." app/switch }

    bf write "Switching code." app/switch

    # create temporary directory and move live files into it
    let dir_temp = bf fs make_temp_dir
    let live_files_count = ls $dir_live| length
    if $live_files_count > 0 {
        bf write debug $" .. moving live files to ($dir_temp)." app/switch
        mv $"($dir_live)/*" $dir_temp
    }

    # move published files to live
    bf write debug $" .. moving published files to ($dir_live)." app/switch
    mv $"($dir_publish)/*" $dir_live

    # move old live files into publish
    let temp_files_count = ls $dir_temp | length
    if $temp_files_count > 0 { bf write debug $" .. moving old live files ($dir_publish)." app/switch }

    # reapply permissions
    bf write debug " .. reapplying permissions." app/switch
    bf ch apply_file $"(bf env CH_D)/10-aspnet"

    # output success message
    bf write ok "Application switched successfully."

    # terminate the container
    if $terminate { bf-s6 cont terminate }
}
