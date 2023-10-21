use bf
bf env load

# Set environment variables
def main [] {
    let app = "/app"
    bf env set ASPNET_APP $app
    bf env set ASPNET_APP_LIVE $"($app)/live"
    bf env set ASPNET_APP_PUBLISH $"($app)/publish"
}
