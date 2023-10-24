use bf

# Run preflight checks before executing process
export def preflight [...args] {
    # load environment
    bf env load

    # manually set executing script
    bf env set X aspnet/run

    # verify ASPNET_ASSEMBLY is set
    let assembly = bf env ASPNET_ASSEMBLY
    let dir_live = bf env ASPNET_APP_LIVE

    # verify assembly exists
    let assembly_path = $"($dir_live)/($assembly)"
    if ($assembly_path | bf fs is_not_file) {
        bf write notok $"($assembly_path) not found."
        let for = 30sec
        bf write $"Sleeping for ($for)."
        sleep $for
        exit 66
    }

    # start application
    bf write "Starting ASP.NET application."
    bf write debug $" .. ($assembly_path)."
}
