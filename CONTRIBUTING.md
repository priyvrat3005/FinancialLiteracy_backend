# Contributing Guide

Guidelines for contributing to Moolah Minds.

## Development Workflow

### 1. Set Up Your Environment

Follow [SETUP.md](./SETUP.md) to get the project running locally.

### 2. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
git checkout -b fix/bug-description
```

Naming conventions:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring

### 3. Make Changes

Code with the following principles in mind:

**TypeScript:**
- Strict mode enabled (no `any` unless documented)
- Explicit return types on functions
- Interfaces for data structures

**File Organization:**
- One component/class per file
- Clear directory structure
- Descriptive names

**Commits:**
```bash
git add .
git commit -m "feat: add weekly game tick logic"
```

Message format: `<type>: <description>`
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation
- `refactor:` - Code restructuring
- `test:` - Adding tests
- `chore:` - Maintenance

### 4. Keep Code Quality High

```bash
# Format code
npm run format

# Check types
npm run type-check

# Lint
npm run lint

# Run tests
npm run test
```

### 5. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Create a Pull Request on GitHub with:
- Clear title describing the change
- Description of what and why
- Reference any related issues: `Closes #123`

## Code Standards

### Backend (Express + TypeScript)

**Service Layer:**
```typescript
export class ProfileService {
  async getProfile(userId: string, cohortId: string): Promise<Profile> {
    // Explicit return type
    // Business logic here
    // Database calls via db layer
  }
}
```

**API Routes:**
```typescript
router.get(
  '/:profileId',
  authMiddleware, // Protected
  asyncHandler(async (req, res) => {
    // Handle request
    // Use services
    // Return response
  })
);
```

**Error Handling:**
```typescript
// Always use ApiError for application errors
throw new ApiError(400, 'Invalid input', 'VALIDATION_ERROR');

// Never swallow errors
// Use asyncHandler to catch promises
```

### Frontend (React + TypeScript)

**Components:**
```typescript
interface Props {
  title: string;
  onAction: () => void;
}

export const Card: React.FC<Props> = ({ title, onAction }) => {
  return (
    <div onClick={onAction}>
      <h2>{title}</h2>
    </div>
  );
};
```

**Hooks:**
```typescript
export const useProfile = (profileId: string) => {
  const [profile, setProfile] = React.useState<Profile | null>(null);
  // Hook logic
  return profile;
};
```

### Database (Prisma)

**Schema Updates:**
```prisma
// Add @index for frequently queried columns
model User {
  id String @id @default(uuid())
  email String @unique
  
  @@index([email])
}
```

**Queries:**
```typescript
// Use type-safe Prisma queries
const user = await dbClient().user.findUnique({
  where: { id: userId },
  include: { profiles: true },
});
```

### Naming Conventions

- **Files**: `PascalCase.ts` (classes/components), `camelCase.ts` (utilities)
- **Classes**: `PascalCase`
- **Functions**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`
- **Database**: `snake_case` (Prisma handles mapping)

## Testing

### Unit Tests (Jest - Backend)

```typescript
describe('GameService', () => {
  it('should advance week successfully', async () => {
    const service = new GameService();
    const result = await service.advanceWeek(profileId);
    expect(result).toBeDefined();
  });
});
```

### Component Tests (Vitest - Frontend)

```typescript
describe('Card Component', () => {
  it('should render title', () => {
    render(<Card title="Test" onAction={() => {}} />);
    expect(screen.getByText('Test')).toBeInTheDocument();
  });
});
```

**Guidelines:**
- Test critical business logic
- Avoid snapshot tests for UI
- Aim for 80%+ coverage on services
- Include edge cases

## Documentation

When adding features, update:

1. **Code comments** - Explain "why" not "what"
2. **JSDoc** - For functions and classes
3. **README.md** - If user-facing
4. **ARCHITECTURE.md** - If architectural changes
5. **docs/** - For detailed documentation

Example comment:
```typescript
/**
 * Advances the game by one week.
 * 
 * This performs the weekly game tick:
 * 1. Credits salary
 * 2. Deducts obligations
 * 3. Processes decisions
 * 4. Triggers events
 * 
 * @param profileId - The player's profile ID
 * @throws {ApiError} If profile not found
 */
async advanceWeek(profileId: string): Promise<void> {
  // ...
}
```

## Review Process

### What Reviewers Look For

- ✅ Code follows project conventions
- ✅ TypeScript types are correct
- ✅ Error handling is appropriate
- ✅ Database queries are optimized
- ✅ Tests cover new code
- ✅ No console.log() statements (use logging service)
- ✅ Documentation is updated

### Addressing Feedback

- Respond to all comments
- Make requested changes in new commits
- Re-request review after updates
- Ask questions if feedback is unclear

## Performance Guidelines

### Backend

- Batch database queries where possible
- Use indexes for frequent queries
- Avoid N+1 problems (eager load with `include`)
- Cache computed values sparingly

### Frontend

- Memoize expensive computations (`useMemo`)
- Lazy load routes with `React.lazy`
- Minimize re-renders with `React.memo`
- Optimize images and assets

## Security Guidelines

- [ ] Never commit secrets (.env files)
- [ ] Validate all user inputs
- [ ] Use parameterized queries (Prisma does this)
- [ ] Implement CORS properly
- [ ] Use HTTPS in production
- [ ] Implement rate limiting on APIs
- [ ] Sanitize database outputs

## Troubleshooting

**Build fails**: Clear node_modules and reinstall
```bash
rm -rf node_modules package-lock.json
npm install
```

**Type errors**: Regenerate Prisma client
```bash
npx prisma generate
```

**Database issues**: Reset to clean state
```bash
npx prisma migrate reset
npm run db:seed
```

## Questions?

- Check existing GitHub issues
- Ask in pull request discussion
- Refer to [ARCHITECTURE.md](./ARCHITECTURE.md)
- Create a new issue for clarification

## Code of Conduct

Be respectful, inclusive, and professional. We're building this together as an educational project!
