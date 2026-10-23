use bf
use bf-s6

# Restart the ASP.NET application
export def restart []: nothing -> nothing {
    bf write $"Restarting (bf env ASPNET_ASSEMBLY) application." app/restart
    bf-s6 svc restart aspnet
}

# Switch publish and live application directories, and then restart the application
export def switch [
    --terminate (-t)    # If set, the container will terminate after switching code
]: nothing -> nothing {
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
        $"($dir_live)/*" | into glob | mv $in $dir_temp
    }

    # move published files to live
    bf write debug $" .. moving published files to ($dir_live)." app/switch
    $"($dir_publish)/*" | into glob | mv $in $dir_live

    # move old live files into publish
    let temp_files_count = ls $dir_temp | length
    if $temp_files_count > 0 {
        bf write debug $" .. moving old live files ($dir_publish)." app/switch
        $"($dir_temp)/*" | into glob | mv $in $dir_publish
    }

    # reapply permissions
    bf write debug " .. reapplying permissions." app/switch
    bf-s6 ch apply_file "10-aspnet"

    # output success message
    bf write ok "Application switched successfully." app/switch

    # terminate the container
    if $terminate { bf-s6 cont terminate }

    # return nothing
    return
}
