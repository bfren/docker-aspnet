use std/assert
use ../bf-aspnet/app.nu *


#======================================================================================================================
# helpers
#======================================================================================================================

# Create temporary live and publish directories containing the named files, run $action with the bf-aspnet environment
# pointing at them, and return the files left in each - tests run in parallel, so the real /app directories are never
# used (including by the permissions step, which reads a ch.d file written here instead of /etc/bf/ch.d/10-aspnet)
def with_app [
    live: list<string>      # Files to create in the live directory
    publish: list<string>   # Files to create in the publish directory
    action: closure         # The code to run
]: nothing -> record<live: list<string>, publish: list<string>> {
    let root = mktemp --directory
    let dirs = {live: $"($root)/live", publish: $"($root)/publish", ch_d: $"($root)/ch.d"}
    mkdir $dirs.live $dirs.publish $dirs.ch_d
    $live | each {|x| $x | save $"($dirs.live)/($x)" }
    $publish | each {|x| $x | save $"($dirs.publish)/($x)" }
    [$"($dirs.live) www:www 0400 0500" $"($dirs.publish) www:www 0600 0700"] | str join "\n" | save $"($dirs.ch_d)/10-aspnet"

    let vars = {
        BF_ASPNET_APP_LIVE: $dirs.live
        BF_ASPNET_APP_PUBLISH: $dirs.publish
        BF_ETC_CH_D: $dirs.ch_d
    }
    with-env $vars { do $action }

    let result = {
        live: (ls $dirs.live | get name | path basename | sort)
        publish: (ls $dirs.publish | get name | path basename | sort)
    }
    rm --recursive --force $root
    $result
}


#======================================================================================================================
# switch
#======================================================================================================================

export def switch__nothing_published__returns_error [] {
    let action = { with_app ["app.dll"] [] { switch } }

    assert error $action "switch should fail when nothing has been published"
}

export def switch__swaps_live_and_publish [] {
    let result = with_app ["old.dll"] ["new.dll" "new.json"] { switch }

    assert equal ["new.dll" "new.json"] $result.live "published files should be live"
    assert equal ["old.dll"] $result.publish "previous live files should be in publish"
}

export def switch__nothing_live__moves_published_to_live [] {
    let result = with_app [] ["new.dll"] { switch }

    assert equal ["new.dll"] $result.live "published files should be live"
    assert equal [] $result.publish "publish should be empty"
}

export def switch__twice__rolls_back [] {
    let result = with_app ["old.dll"] ["new.dll"] { switch ; switch }

    assert equal ["old.dll"] $result.live "switching twice should restore the original live files"
    assert equal ["new.dll"] $result.publish "switching twice should restore the original published files"
}

export def switch__applies_permissions [] {
    let root = mktemp --directory
    let live = $"($root)/live"
    let publish = $"($root)/publish"
    mkdir $live $publish $"($root)/ch.d"
    "" | save $"($publish)/new.dll"
    $"($live) www:www 0400 0500\n($publish) www:www 0600 0700" | save $"($root)/ch.d/10-aspnet"

    with-env {BF_ASPNET_APP_LIVE: $live, BF_ASPNET_APP_PUBLISH: $publish, BF_ETC_CH_D: $"($root)/ch.d"} { switch }
    let file = ^stat -c "%U:%G %a" $"($live)/new.dll" | str trim
    let dir = ^stat -c "%U:%G %a" $live | str trim
    rm --recursive --force $root

    assert equal "www:www 400" $file "live files should be read-only and owned by www"
    assert equal "www:www 500" $dir "live directory should be owned by www"
}


#======================================================================================================================
# restart_daily
#======================================================================================================================

# Run restart_daily with BF_ASPNET_ENABLE_DAILY_RESTART set to $enable and a stub s6-svc first on PATH, and return true
# if the stub was called (the real s6-svc would restart the test container's service)
def restart_daily_e [
    enable: string  # Value of BF_ASPNET_ENABLE_DAILY_RESTART
]: nothing -> bool {
    let dir = mktemp --directory
    let marker = $"($dir)/restarted"
    $"#!/bin/sh\ntouch ($marker)\n" | save $"($dir)/s6-svc"
    ^chmod +x $"($dir)/s6-svc"

    let path = [$dir] | append ($env.PATH | [$in] | flatten | str join (char esep) | split row (char esep))
    let vars = {PATH: $path, BF_ASPNET_ASSEMBLY: "app.dll", BF_ASPNET_ENABLE_DAILY_RESTART: $enable}
    with-env $vars { restart_daily }

    let result = $marker | path exists
    rm --recursive --force $dir
    $result
}

export def restart_daily__disabled__does_not_restart [] {
    assert equal false (restart_daily_e "0") "the application should not restart when the daily restart is disabled"
}

export def restart_daily__enabled__restarts [] {
    assert equal true (restart_daily_e "1") "the application should restart when the daily restart is enabled"
}
