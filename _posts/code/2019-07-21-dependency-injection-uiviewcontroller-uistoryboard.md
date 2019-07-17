---
layout: post
title: "Dependency injection for UIViewController when using storyboards"
tags: code
---

Using storyboards can bring some advantages. But one of the biggest disadvantages of Storyboards is that the SB instatiates its viewcontrollers. So in order to inject dependencies we need to rely on property-injection which can get ugly. Fortunately there is an elegant way of creating a “storyboard-constructor” for UIViewController.

## The goal

Since all of us do TDD we’d love the test the allocation of the UIViewController we’re going to implement and double check wether it’s dependencies have been set or not.
The default way - prepareForSegue

This approach only works for segue-based apps - which i recommend to avoid since you have to construct some parts of the navigation flow in order to unitTest them

```swift
public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destVC = segue.destination as? MyDestinationVC {
        destVC.someService = SomeService()
        destVC.secondService = SecondService()
    }
}
```

Without segues - the awesome way

We cannot utlize constructors when a storyboard is used. However we can create a static function that initializes the viewController from the storyboard and automatically assigns it’s dependencies.

Let’s try to greenlight to following test:

```swift
let testViewModel = AwesomeViewModel()

func testAwesomeVC_allocationFromStoryboard(){
    let vc = AwesomeVC.initWithDependencies(viewModel: testViewModel)
    XCTAssertNotNil(vc)
    XCTAssertNotNil(vc.viewModel)
}
```

For that we can extend the class AwesomeVC with a static function that assigns the dependencies:

```swift
extension AwesomeVC {
    static func initWithDependencies(viewModel vm: AwesomeViewModel) -> AwesomeVC? {
        let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = sb.instantiateViewController(withIdentifier:
            "AwesomeVC") as? AwesomeVC {
            vc.viewModel = vm
            return vc
        }
        return nil
    }
}
```

Making it an optional also prevents the unit-test from crashing when the Storyboard is unable to find the corresponding VC for the identifier that is provided in the function.

Eh voila, the test passes and we can easily allocate the VC from everywhere inside the code and for example push it on top of a UINavigationController.

Greetings,

Florian
