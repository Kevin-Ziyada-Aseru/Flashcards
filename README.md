# Flashcards

A full-stack learning platform built with Flutter and Node.js. Study smarter by removing the setup friction. Go from document to active learning in under 60 seconds.

## Philosophy: User Experience First

Most study apps waste your time on setup. You spend 70% of your time typing vocab, definitions, and examples. Only 30% actually learning.

**Flashcards flips this ratio.**

We designed every screen, button, and interaction around one principle: **Get you studying in under 60 seconds.**

### How We Do It

**Intuitive UI**

- No jargon. No complex menus. The app explains itself.
- One tap to choose a learning mode. One tap to study.
- Clear visual hierarchy so you know where to look.

**Minimal Design**

- Everything feels intentional.
- Professional typography. Easy on the eyes.

**Fast Workflows**

- Add cards in seconds, not minutes.
- See results immediately.
- Navigation flows like you'd expect, not how a developer thinks.

### The Goal

From raw document → Active study session in 60 seconds.

Upload a PDF. AI extracts questions and answers. You're studying. Done.

Whether you're learning Korean vocabulary or mastering technical documentation, we remove the friction between "I want to learn this" and "I'm learning this now."

## Current Status

**Frontend**: In progress

- Login & Signup screens with form validation
- Home dashboard with learning mode selection
- Flip Cards study mode with 3D animations
- Activities tracking and empty states
- Reusable component system

**Backend**: In Progress

- Node.js + Express API structure
- PostgreSQL database schema design
- Authentication endpoints (not integrated yet)
- Not yet connected to frontend

**Integration**: Next Phase

- Will connect frontend to backend APIs
- User data persistence
- Cloud synchronization

## Features

### Authentication

- Email/password login
- User signup with terms acceptance
- Secure session management
- Password visibility toggle

### Study Modes (Planned)

**Flip Cards**

- 3D card flip animations
- Real-time quiz tracking
- Accuracy scoring
- Card management (add, delete, clear)

**Match Cards**

- Drag-to-match questions with answers
- Instant validation

**Multiple Choice**

- Four-option selection mode
- Accuracy tracking

**Write & Review**

- Open-ended response input
- Manual self-grading

### Dashboard

- Home screen with learning mode cards
- Recent activity list with scores
- Empty states for new users
- Bottom navigation (Learn, Browse, Saved, Profile)

## Tech Stack

**Frontend**

- Flutter 3.0+
- Dart 3.0+
- Zero external dependencies
- Modular architecture

**Backend** (Building)

- Node.js
- Express.js
- PostgreSQL
- RESTful API

**Design System**

- Navy (#1F3A5F) - Primary
- Teal (#00897B) - Accents
- Off-white (#FAF8F3) - Background
- Inter typography
- Natural shadows (0.04-0.12 opacity)

## Installation

### Frontend Setup

```bash
cd frontend
flutter pub get
flutter run
```

**Requirements:**

- Flutter SDK 3.0+
- Dart SDK 3.0+

### Backend Setup (In Progress)

```bash
cd backend
npm install
node src/server.js
```

**Requirements:**

- Node.js v18+
- PostgreSQL v14+

Configure database in `server.js`:

```javascript
const pool = new Pool({
  user: "postgres",
  password: "your_password",
  host: "localhost",
  port: 5432,
  database: "flashcards",
});
```

## Project Structure

```
flashcards/
├── frontend/
│   ├── lib/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup_screen.dart
│   │   ├── flip/
│   │   │   ├── view/
│   │   │   │   ├── flip_card.dart
│   │   │   │   ├── flip_decks_screen.dart
│   │   │   │   ├── empty_state.dart
│   │   │   │   ├── results_page.dart
│   │   │   │   ├── progress_section.dart
│   │   │   │   └── flip_card_widget.dart
│   │   │   ├── model/
│   │   │   │   └── card_result.dart
│   │   │   └── widget/
│   │   ├── home.dart
│   │   ├── widget/
│   │   │   ├── activities_section.dart
│   │   │   ├── btn_icon.dart
│   │   │   ├── btn_widget.dart
│   │   │   └── learning_mode_card.dart
│   │   └── main.dart
│   └── pubspec.yaml
│
├── backend/
│   ├── src/
│   │   ├── routes/
│   │   │   ├── flipcards.routes.js
|   |   |   └── cards.routes.js
|   |   |
│   │   ├── server.js
│   │   └── db.js
│   ├── package.json
│   └── package-lock.json
│
└── README.md
```

## Development

### Code Style

**Dart (Frontend)**

- Follow effective-dart conventions
- Use private methods (`_methodName`) for internal helpers
- Builder methods return `Widget` types
- Format: `dart format lib/`

**JavaScript (Backend)**

- ESLint configuration in backend/
- Consistent async/await patterns
- Clear error handling
- Lint: `npm run lint`

## Roadmap

**Phase 1** (Current)

- Frontend UI complete
- Backend API structure

**Phase 2** (Next)

- Backend integration
- User authentication
- Database persistence

**Phase 3** (Planned)

- Document parsing with AI
- Automated Q&A generation
- Statistics dashboard

**Future**

- Spaced repetition algorithm
- Collaborative study sets
- Export/import functionality
- Dark mode

## Contact

**Author**: Kevin Ziyada Aseru  
**Email**: kevin.aseru@emtechhouse.com  
**License**: MIT

## Contributing

This project is currently in active development. Contributions welcome.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/your-feature`)
3. Commit changes (`git commit -m 'Add your feature'`)
4. Push to branch (`git push origin feature/your-feature`)
5. Open a Pull Request
