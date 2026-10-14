use std/assert
use bf


#======================================================================================================================
# helpers
#======================================================================================================================

# The .NET revision installed (saved in the build log during installation), e.g. 10.0.12 or 11.0.0-rc.1
def revision []: nothing -> string { with-env {BF_ETC: "/etc/bf"} { bf build | get "ASP.NET" } }

# The runtimes reported by dotnet, e.g. 'Microsoft.AspNetCore.App 10.0.12 [/usr/share/dotnet/...]'
def runtimes []: nothing -> list<string> { ^dotnet --list-runtimes | lines }


#======================================================================================================================
# install
#======================================================================================================================

export def install__dotnet_runs [] {
    let result = ^dotnet --list-runtimes | complete

    assert equal 0 $result.exit_code $"dotnet does not run - the runtime or its dependencies are missing: ($result.stderr)"
}

export def install__installs_netcore_runtime_matching_build [] {
    let expected = $"Microsoft.NETCore.App (revision)"

    assert (runtimes | any {|x| $x | str starts-with $expected }) $"($expected) is not installed"
}

export def install__installs_aspnetcore_runtime_matching_build [] {
    let expected = $"Microsoft.AspNetCore.App (revision)"

    assert (runtimes | any {|x| $x | str starts-with $expected }) $"($expected) is not installed"
}

export def install__installs_globalisation_library [] {
    # DOTNET_SYSTEM_GLOBALIZATION_INVARIANT is false, so .NET needs ICU
    let result = ^apk info -e icu-libs | complete

    assert equal 0 $result.exit_code "icu-libs is not installed"
}


#======================================================================================================================
# init
#======================================================================================================================

export def init__version_script_finds_runtime [] {
    # 11-version fails the container start if it cannot find exactly one ASP.NET runtime
    let result = ^$nu.current-exe /etc/bf/init.d/11-version.nu | complete

    assert equal 0 $result.exit_code $"11-version.nu failed: ($result.stderr)"
}
