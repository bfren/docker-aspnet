use bf
bf env load

# Get installed version of ASP.NET runtime
def main [] {
    # get the installed version ot ASP.NET
    let version = glob /usr/share/dotnet/shared/Microsoft.NETCore.App/*
    if ($version | length) != 1 { bf write error "Unable to determine ASP.NET version." }

    # output version
    bf write $"ASP.NET v($version | first | path basename) is installed."
}
