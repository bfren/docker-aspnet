#!/usr/bin/env -S nu -n

use ../index/test.nu

const dotnet_branches = [
    "8"
    "9"
    "10"
    "11"
]

# Run test suite for image
def main [
    dotnet: string = "10"   # define which .NET version to use
    --all (-a)              # test all registered versions of .NET (overrides $dotnet)
] {
    let branches = if $all { $dotnet_branches } else { [$dotnet] }
    test "aspnet" $branches
}
