## Generating documentation locally

Run `scripts/document.sh`

## Update the Mapbox Navigation SDK documentation site:
1. Clone mapbox-navigation-ios to a mapbox-navigation-ios-docs folder alongside your main mapbox-navigation-ios clone, and check out the `gh-pages` branch.
1. In your main mapbox-navigation-ios clone, check out the release branch and run `OUTPUT=../mapbox-navigation-ios-docs/navigation/0.4.0 scripts/document.sh`, where _0.4.0_ is the new SDK version.
1. In mapbox-navigation-ios-docs, edit [navigation/index.html](https://github.com/mapbox/mapbox-navigation-ios/blob/gh-pages/navigation/index.html) and navigation/docsets/Mapbox.xml to refer to the new SDK version.
1. Commit and push your changes to the `gh-pages` branch.