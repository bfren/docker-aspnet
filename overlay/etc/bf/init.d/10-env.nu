use bf
bf env load -x

# Set environment variables
def main [] {
    let app = "/app"
    bf env ASPNET_APP $app
    bf env ASPNET_APP_LIVE $"($app)/live"
    bf env ASPNET_APP_PUBLISH $"($app)/publish"
}
