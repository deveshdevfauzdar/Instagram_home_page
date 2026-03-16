# Instagram Pixel Feed Challenge

This project is a polished Instagram Home Feed replication built for the Flutter UI/UX challenge.

## Challenge Objective

Recreate the Instagram Home Feed with strong visual fidelity, smooth gesture interactions, and clean architecture.

## State Management Choice

This implementation uses Riverpod with the Notifier API.

Why Riverpod for this assignment:
- Clear separation between UI and business logic.
- Test-friendly architecture.
- Predictable state transitions for loading, pagination, and local interactions.

## Tech Stack

- Flutter
- Riverpod (Notifier API)
- cached_network_image
- shimmer
- smooth_page_indicator

## Implemented Requirements

- Instagram-like top bar, stories tray, and post feed structure.
- Dark theme styling for Instagram-like feed presentation.
- Repository-driven mock data layer with 1.5s artificial latency.
- Shimmer loading state for initial load and pagination load.
- Infinite scrolling pagination: fetches next page when approaching the last 2 posts.
- Carousel posts using horizontal PageView and synchronized dot indicator.
- Pinch-to-zoom overlay interaction: image scales above UI and animates back on release.
- Web-friendly zoom fallback for Chrome recording (trackpad pinch or pointer wheel over image).
- Local state toggle for Like and Save actions.
- Custom snackbar for unimplemented actions (Comment and Share).
- Network image caching with cached_network_image.
- Error placeholder for failed image loading.

## Architecture

- Data Layer
	- [lib/src/features/feed/data/repositories/fake_post_repository.dart](lib/src/features/feed/data/repositories/fake_post_repository.dart)
- Domain Layer
	- [lib/src/features/feed/domain/models/post.dart](lib/src/features/feed/domain/models/post.dart)
	- [lib/src/features/feed/domain/models/story.dart](lib/src/features/feed/domain/models/story.dart)
	- [lib/src/features/feed/domain/repositories/post_repository.dart](lib/src/features/feed/domain/repositories/post_repository.dart)
- Application Layer
	- [lib/src/features/feed/application/feed_notifier.dart](lib/src/features/feed/application/feed_notifier.dart)
	- [lib/src/features/feed/application/feed_state.dart](lib/src/features/feed/application/feed_state.dart)
	- [lib/src/features/feed/application/feed_providers.dart](lib/src/features/feed/application/feed_providers.dart)
- Presentation Layer
	- [lib/src/features/feed/presentation/screens/feed_screen.dart](lib/src/features/feed/presentation/screens/feed_screen.dart)
	- [lib/src/features/feed/presentation/widgets](lib/src/features/feed/presentation/widgets)

## Project Structure

- lib/src/app.dart
- lib/src/features/feed/domain/models
- lib/src/features/feed/domain/repositories
- lib/src/features/feed/data/repositories
- lib/src/features/feed/application
- lib/src/features/feed/presentation/screens
- lib/src/features/feed/presentation/widgets

## Run Instructions

1. Install Flutter SDK and ensure flutter command is in PATH.
2. Clone this repository.
3. Open terminal in project root.
4. Run: flutter pub get
5. Run (default device): flutter run

Run on Chrome:
- flutter run -d chrome

Run on local web-server:
- flutter run -d web-server --web-hostname localhost --web-port 8081
- Open http://localhost:8081 in Chrome.

Notes for Windows:
- If desktop plugin symlink warning appears, enable Developer Mode.
- Always run Flutter commands from the project root where pubspec.yaml exists.

## Validation Commands

- flutter analyze
- flutter test

## Demo Recording Guide

Record one continuous demo showing the following in order:

1. Cold launch with shimmer loading.
2. Stories tray and feed scroll smoothness.
3. Infinite scroll triggering and page append.
4. Carousel post horizontal swipe and synced dots.
5. Pinch-to-zoom interaction with overlay and animated snap-back.
6. Like toggle and Save toggle.
7. Comment or Share button showing custom snackbar.

Recommended recording settings:
- Format: MP4 (H.264)
- Resolution: 1080p
- FPS: 30
- Keep cursor visible for gesture demos

## Demo Recording Checklist


## Edge Cases Handled

- Network image failure falls back to a safe placeholder.
- Pagination requests are guarded to avoid duplicate load-more calls.
- Error view includes retry for initial load failure.

## Known Scope Decisions

- Data is intentionally mock data from public image URLs.
- Feed interactions are local in-memory state for assignment focus.

## Submission Steps

1. Ensure checks pass:
	- flutter analyze
	- flutter test
2. Push code to a public GitHub repository.
3. Upload demo recording (Loom or MP4 link).
4. Submit both links with a short implementation note.

## Submission Template

- GitHub Repository: <your-public-repo-link>
- Demo Video: <loom-or-mp4-link>
- State Management: Riverpod (Notifier API)
- Notes: Implemented shimmer loading, infinite pagination, carousel, pinch-to-zoom overlay with snap-back animation, and local like/save states.
