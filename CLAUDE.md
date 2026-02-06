# Folk-Coder

Educational platform for learning programming with gamified progress tracking.

## Architecture

See `.claude/architecture.puml` for the full diagram.

### Key Components

| Layer | Components |
|-------|------------|
| **Web** | Sessions, Registrations, Curriculum, Lessons, Journey, Hackathons, Admin |
| **Domain** | User, CurriculumModule, Lesson, LessonCompletion, ModulePrerequisite, Hackathon |
| **Data** | SQLite via ActiveRecord |

### Models

```
User (role: member|admin)
  └── has_many: Sessions, LessonCompletions

CurriculumModule (position-ordered)
  ├── has_many: Lessons
  └── has_many: ModulePrerequisites

Lesson (markdown content)
  └── has_many: LessonCompletions
```

### Key Features

- **Progress Tracking**: Streaks, milestones, completion percentage
- **Learning Path**: Module prerequisites, ordered lessons
- **Content Rendering**: Markdown via Redcarpet, embedded SVG
- **Hackathon Discovery**: Filterable event listings

### Tech Stack

Rails 8.1 | SQLite | Puma | Hotwire | Redcarpet | TailwindCSS

### Routes

- `/curriculum` - Browse modules
- `/lessons/:id` - View/complete lesson
- `/journey` - Progress dashboard
- `/hackathons` - Event discovery
- `/admin` - Admin dashboard (requires admin role)
