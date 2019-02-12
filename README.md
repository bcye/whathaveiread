[![Build Status](https://travis-ci.org/bcye/whathaveiread.svg?branch=master)](https://travis-ci.org/bcye/whathaveiread)
[![codecov](https://codecov.io/gh/bcye/whathaveiread/branch/master/graph/badge.svg)](https://codecov.io/gh/bcye/whathaveiread)
[![Gitter](https://badges.gitter.im/cash-log/community.svg)](https://gitter.im/whathaveiread/community?utm_source=share-link&utm_medium=link&utm_campaign=share-link)

# whathaveiread

WHIR - What have I read? Is an iOS app that allows you to keep track of all books you've read and keep a short summary about them.

[App Store](https://itunes.apple.com/us/app/whir/id1368037703?ls=1&mt=8)

## Contributing

Please join our [Gitter chat room](https://gitter.im/whathaveiread/community?utm_source=share-link&utm_medium=link&utm_campaign=share-link) this is where we discuss everything. View the roadmap on [Trello](https://trello.com/b/yiVirTlX)

Please create an issue with a feature request before starting to work.

## Installation

This project uses CocoaPods, but the `Pods` directory is checked into this repo, so no `pod install` is necessary. However, be sure to do your work in `WHIR.xcworkspace` instead of `WHIR.xcodeproj`.

We are using the Google Books API to query information on the books. Before building the project, you need to recreate the `keys.plist` file:
1. Go to `WHIR > Resources`
2. Create a new file named `keys.plist`
3. Add a key-value pair: the key is `G_API_PROD` and the value is your Google Books API key (you can generate one in the Google API console)
4. Build


## License

The project is licensed under the GNU GPL v3 license, as declared in the [LICENSE file.](LICENSE)
