# Medium Feed iOS App

(Checkout `main` branch)
Medium Feed iOS App fetches and displays articles from Medium using Moya for networking, Realm for local storage, SnapKit for UI layout, and follows the MVVM design pattern.

## Features

- Fetches articles from Medium (https://medium.com/feed/@primoapp).
- Stores articles locally with Realm.
- Displays articles in a list with pull-to-refresh.
- Detailed article view with an option to open in Safari.
- Uses Combine.

## Requirements

- Xcode 12.5 or later
- iOS 15.0 or later
- CocoaPods 1.10.1 or later

## Installation

1. Clone the Repository:

    ```sh
    git clone <repository_url>
    cd medium-feed-ios
    ```

2. Install Dependencies:

    ```sh
    pod install
    ```

3. Open the Workspace:

    ```sh
    open medium-feed-ios.xcworkspace
    ```

## Project Structure

- **Application:** Entry point & app lifecycle (`AppDelegate.swift`, `SceneDelegate.swift`, `ViewController.swift`)
- **Core:** Core utilities & networking (`ArticleService.swift`, `RSSParser.swift`)
- **Data:** Repositories & Realm models (`ArticleRepository.swift`, `RealmArticle.swift`)
- **Domain:** Models & UseCases (`Article.swift`, `RSSFeed.swift`, `FetchArticlesUseCase.swift`)
- **Presentation:** Coordinators, Scenes, ViewModels, Controllers, Views
  - **Home:** `HomeViewController.swift`, `HomeViewModel.swift`, `ArticleCell.swift`, `ArticleViewModel.swift`
  - **Detail:** `DetailViewController.swift`, `DetailViewModel.swift`

## Usage

1. **Home Screen:**
   - Displays a list of Medium articles.
   - Pull-to-refresh to load new articles.
  
2. **Detail Screen:**
   - Displays the full content of an article.
   - Option to open the full article in Safari.

## Networking Layer

Handles API interactions using Moya:

```swift
enum ArticleService: TargetType {
    case fetchArticles

    var baseURL: URL { return URL(string: "https://medium.com")! }

    var path: String { return "/feed/@primoapp" }
    var method: Moya.Method { return .get }
    var task: Task { return .requestPlain }
    var headers: [String: String]? { return ["Content-Type": "application/xml"] }
}
```

## License
This project is licensed under the MIT License - see the LICENSE file for details

