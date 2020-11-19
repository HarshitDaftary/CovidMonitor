# Covid Monitor
- Covid Monitor App mointors your current location for number of cases in cases7_per_100k for a region. 
- It shows rules to be followed by public in region based on current status (red, yellow and green).


### Configurations

  - Rules.plist file contains configuration for all rules with attributes: rule description, image, min and max counts of cases and color
  - Localizable.strings file contains German translation of messages
  - Modify Constants.swift file to change alert messages and timer duration

### Code Structure
  - Project is architected in DDD pattern
  - Repositories folder contains Database or API calls.
  - Rules folder contains Rules screen related code.
  - Map folder contains Map screen related code.

### Development Environment
  - This code is developed with Xcode 12.1 in Swift 5.3 language
  - Dependencies are integrated using swift packages

### Deployment Target
| Attribute | Detail |
| ------ | ------ |
| iOS Version | >= 13.7 |
| Device Family | iPhone |
| Supported Orientation | Portrait |

### Feature Enhancements

 - Write Tests
 - Add Dark Mode support
 - Add Search option in map screen
 - Add Push notification support for status change events
 - Cache region details from API to make network calls faster


License
----

MIT
