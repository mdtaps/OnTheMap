# Learn To Pray

On The Map is an app that allows users to log in and retrieve user locations from an online server. The pins are shown as pins on a map. The user can also add their own pin on the map.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
- XCode 9.2
- Swift 3 or 4
- CocoaPods
```

### Installing

Clone from Github

```
git clone https://github.com/mdtaps/OnTheMap
```

If you don't have it installed already, install CocoaPods from Terminal

More details about it at https://guides.cocoapods.org/using/getting-started.html

```
$ sudo gem install cocoapods
```

Create a Podfile

```
$ cd OnTheMap <-- YOUR PROJECT DIRECTORY GOES HERE
$ pod init
```
Open your Podfile and place the following to enable Facebook login:

```
# Uncomment the next line to define a global platform for your project
    platform :ios, '9.0'

target 'OnTheMap' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    pod 'FBSDKCoreKit', '~> 4.22.1'
    pod 'FBSDKLoginKit', '~> 4.22.1'
    pod 'FBSDKShareKit', '~> 4.22.1'

    # Pods for OnTheMap

    target 'OnTheMapTests' do
    inherit! :search_paths
    # Pods for testing
    end

    target 'OnTheMapUITests' do
    inherit! :search_paths
    # Pods for testing
    end

end
```

Close your XCode project. From Terminal, while still in your project directory, run the code below.

```
$ pod install
```
If you have trouble, you can find Facebook's install documentation here: https://cocoapods.org/pods/Facebook-iOS-SDK

## Deployment

Use the Workspace (.xcworkspace) file to run the app

## Built With

* [Facebook API](https://developers.facebook.com/docs/facebook-login/ios) - Used for Facebook login

## Authors

* **Mark Tapia** - *Initial work* - [MDTaps](https://github.com/mdtaps)

If you would like to contribute to this project, please leave me a note!

## License

The contents of this repository is licensed under the [MIT License](https://opensource.org/licenses/MIT) 

## Acknowledgments

* Thanks to my beautiful wife who put up with me staying up late many nights and waking her up when I come to bed.
