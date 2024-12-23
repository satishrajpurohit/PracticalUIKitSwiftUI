# PracticalUIKitSwiftUI

### SwiftUIAssignment

## This project provides a dynamic image carousel, a list of items, a search feature, and a floating action button (FAB) with a bottom sheet for statistics. The app is designed to handle any number of items and images dynamically, with a built-in feature to filter the list through a search bar and visualize statistics in a bottom sheet.

## Xcode Compatibility

- This project was developed using **Xcode 16** (or the latest stable release) and is **recommended** to be opened with **Xcode 16** or later for optimal performance.

## Key Features
- Image Carousel: A horizontally swipeable carousel that updates the list based on the selected image.
- Dynamic List: Scrollable list with real-time updates based on the images in the carousel.
- Sticky Search Bar: A pinned search bar that filters list items as the user types.
- Floating Action Button (FAB): Triggers a bottom sheet displaying:
- The count of items on the page.
- The top 3 most frequent characters in the list.

## Architecture Overview

This project follows a MVVM (Model-View-ViewModel) pattern to separate the UI logic from the data processing and business logic. The bottom sheet is a custom modal view triggered by the floating action button.

Model: The data used by the app, such as CatImage and CatBreed.
View: The visual elements that represent the UI, including the carousel, list, search bar, and bottom sheet.
ViewModel: Handles the logic to fetch data and filter it for the UI, like fetching images from the network or counting character occurrences.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
