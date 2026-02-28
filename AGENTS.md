# AI Coding Guidelines

## Core Direction
- Build and evolve this project as an Entity-Component-System (ECS) engine.
- Prefer composition over inheritance.
- Keep game logic in systems, data in components, and identity/lifecycle in entities.
- Follow gdd.md for game design and feature priorities.

## ECS Rules
- Entities: lightweight IDs, no game logic.
- Components: small, focused data containers.
- Systems: operate on component sets and contain behavior.
- Avoid mixing rendering, input, physics, and gameplay rules in one system unless truly necessary.

## Code Size and Style
- Follow good engineering practices and maintain a clear, consistent folder structure.
- Write the least code that correctly solves the problem.
- Prioritize readability and maintainability over cleverness.
- Reuse existing utilities/systems before adding new abstractions.
- Keep APIs small and explicit.
- Add comments only where intent is not obvious from code.
- Write documentation in `packages/engine/docs` for public APIs and complex systems.

## Change Discipline
- Make small, targeted changes.
- Do not introduce broad refactors unless required.
- If a change conflicts with ECS direction, choose the ECS-aligned solution.
- When creating/updating components and systems, also update the serialization code to ensure they are saved/loaded correctly.