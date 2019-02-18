[![Build Status](https://travis-ci.org/bcye/whathaveiread.svg?branch=master)](https://travis-ci.org/bcye/whathaveiread)
[![codecov](https://codecov.io/gh/bcye/whathaveiread/branch/master/graph/badge.svg)](https://codecov.io/gh/bcye/whathaveiread)
[![Gitter](https://badges.gitter.im/cash-log/community.svg)](https://gitter.im/whathaveiread/community?utm_source=share-link&utm_medium=link&utm_campaign=share-link)

# whathaveiread

[![Buy Me A Pizza](https://www.buymeacoffee.com/assets/img/custom_images/black_img.png)](https://www.buymeacoffee.com/bruceroet)

**Support the development and donate a pizza to pay for the developer account.**

WHIR - What have I read? Is an iOS app that allows you to keep track of all books you've read and keep a short summary about them.

**[App Store Link](https://itunes.apple.com/us/app/whir/id1368037703?ls=1&mt=8)**

## Contributing

Please join our [Gitter chat room](https://gitter.im/whathaveiread/community?utm_source=share-link&utm_medium=link&utm_campaign=share-link) this is where we discuss everything. View the roadmap on [Trello](https://trello.com/b/yiVirTlX)

Please create an issue with a feature request before starting to work.

## Support/Donate

Support the development and keep the app free.
* [Donate to keep the app free]((https://www.buymeacoffee.com/bruceroet)
* [Use my Amazon Affiliate link and keep the app free](https://www.amazon.com/gp/search?ie=UTF8&tag=whathaveiread-20&linkCode=ur2&linkId=e5ef7a865e38ca5a48e1260e27383e1c&camp=1789&creative=9325&index=photo&keywords=camera)
* [Join Treehouse](http://referrals.trhou.se/t15thbruce) and support my learning
* [Get $100 in server credits to spend in 60 days on DigitalOcean.](https://m.do.co/c/bd4368aa4d78) Enables me to set up servers for other projects, emails and websites
* [Start a SetApp trial](https://go.setapp.com/invite/nnhe4qgr) Get great apps like Ulysses for $10/m (or $5 as a student). In comparison most of the apps cost 50$ standalone or Ulysses costs 5$/m standalone. They have a great variety of development and iOS programming tools too.

## Installation

This project uses CocoaPods, but the `Pods` directory is checked into this repo, so no `pod install` is necessary. However, be sure to do your work in `WHIR.xcworkspace` instead of `WHIR.xcodeproj`.

We are using the Google Books API to query information on the books. Before building the project, you need to recreate the `keys.plist` file:
1. Go to `WHIR > Resources`
2. Create a new file named `keys.plist`
3. Add a key-value pair: the key is `G_API_PROD` and the value is your Google Books API key (you can generate one in the Google API console)
4. Build


## License

The project is licensed under the GNU GPL v3 license, as declared in the [LICENSE file.](LICENSE)
