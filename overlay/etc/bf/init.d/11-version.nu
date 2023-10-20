use bf
bf env load -x

# Get installed version of ASP.NET runtime
def main [] { ls /usr/share/dotnet/shared/Microsoft.NETCore.App/ | get name }
