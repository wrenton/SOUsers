# SOUsers
SOUsers is an iOS application built using Swift & UIKit, which displays a list of top Stack Overflow users with relevant information and their profile picture. Users can follow/unfollow these top contributing SO users — with their follow status persisted locally across sessions.

If for whatever reason, the network call fails to retrieve users, an error alert will be displayed where the user can try to reload. 

The API request made to retrieve top users: 

```https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow```

## How to run?
Clone the repository:

```
git clone https://github.com/wrenton/SOUsers
```

Open the project in Xcode.

Build and run on an iOS simulator. No external dependencies. Just clone and run.

## Technical decisions

### UIKit vs. SwiftUI
While SwiftUI is modern and declarative, I chose to build this app using UIKit for a few reasons:
- Still provides more mature control over view hierarchies, especially for precise layout behavior and backwards compatibility.
- Has been around much longer and remains widely used across the iOS industry, especially in large, mature codebases.
- Personal familiarity ensured I could deliver a fully functional, testable app in a shorter amount of time.

That said, this app could be a great candidate for SwiftUI in the future.

### Remove storyboards
I decided to remove `Main.storyboard` and persue a more programmatic approach of handling ViewControllers. Storyboards are convenient, but they can:
- Become hard to manage as a project scales.
- Introduce merge conflicts in teams.
- Obscure the lifecycle and setup of ViewControllers.

I decided to build simpler views programmatically, but for the tableView cell I used a Nib file (.xib). I mainly wanted to demonstrate ability to do both, but I know use of these is preferential. I personally before nibs because:
- Offers a balance between reusability, readability, and separation of concerns.
- Easier to design and preview UI components visually.
- Cleanly separates cell design from the logic in the ViewController.

### DTO pattern
I used a Data Transfer Object (DTO) pattern to cleanly separate:
- Network response format (UserDTO).
- Internal domain model (User).

This gives flexibility if the API changes or if the UI needs to change how data is presented. It also makes it easier to apply transformations (e.g., formatting reputation or names).

### MVVM architecture
The app follows the Model-View-ViewModel (MVVM) pattern with Combine for data binding. This is to achieve clear separation of concerns, improve testability, and keep the codebase maintainable — even for a small project like this.

MVVM is a great fit for this size of project because:
- The ViewModels manage UI-related logic like transforming raw User models, handling follow/unfollow state, and exposing observable properties for the view.
- The ViewControllers are kept lightweight and focus only on UI rendering and user interaction.
- The Model layer remains clean, handling networking and data decoding independently.

MVVM with Combine strikes a practical balance: it adds meaningful structure without the complexity of heavier alternatives like VIPER or Clean Architecture, which would be overkill for an app of this size. It also leaves the codebase easy to scale if new features are added later.

### UserDefaults vs. CoreData
To persist the follow/unfollow status between sessions, I evaluated a couple options:
- CoreData: Powerful and scalable but overkill for storing simple flags.
- UserDefaults: Perfect for lightweight key-value storage.

Given that follow status was, local only and simple (userIDs), it's not relational or complex, I decided that UserDefaults would be better. It's performant, simple, and reduces overhead without sacrificing user experience.

### Maximise unit test coverage
One of the core goals was to write testable code.

To support this:
- I used protocols for key components (FollowersAPIProtocol, UsersAPIProtocol) to enable mocking.
- The ViewModel is completely independent of UIKit and is easily testable.

Dependencies are injected via initializers as protocols, making them easy to mock for testing.

## If I had more time
- Make it look nicer
- Load images better (maybe caching/preloading)
- Add UI tests
- Introduce pagination to load more users

## Screenshots
<img width="369" height="700" alt="image" src="https://github.com/user-attachments/assets/fd4aef71-cf66-4249-b4a5-01c51f6491b2" />
<img width="369" height="700" alt="image" src="https://github.com/user-attachments/assets/4782ec05-744d-47a3-9fee-fdb0e1f0c1f3" />

