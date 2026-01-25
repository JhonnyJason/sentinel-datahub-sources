# Storage Module

## Purpose
Public API for persistent state storage. Integrates the caching layer (`statecachemodule`) into the standard module initialization pattern.

---

## Architecture

```
storagemodule (public API)
    │
    └─► statecachemodule (LRU cache)
            │
            └─► statesavermodule (file I/O)
```

**Why this layer exists:**
- Adapts `statecachemodule.initialize(options)` to standard `initialize(cfg)` pattern
- Provides clean public API for other modules
- Hides internal caching/persistence details

---

## Exports

```coffee
initialize(cfg)
    # Initializes storage using cfg.persistentStateOptions
    # Called automatically by index.coffee

load(id) → object
    # Load state by id, returns cached or from disk

save(id, obj?)
    # Save state, only writes if changed

remove(id)
    # Delete state from cache and disk

```

---

## Configuration

In `configmodule`:
```coffee
persistentStateOptions = {
    basePath: "../state"    # Directory for state files
    maxCacheSize: 128       # Max cached entries
}
```

---

## Usage Example

```coffee
import * as storage from "./storagemodule.js"

# Load or create state
myState = storage.load("mydata")
myState.counter ?= 0
myState.counter++

# Save changes
await storage.save("mydata")

# Or save with new object
await storage.save("newdata", { key: "value" })
```

---

## Implementation Status

**TODO:**
- [ ] Wire up to statecachemodule
- [ ] Add `list()` function to enumerate stored states
- [ ] Fix statecachemodule issues (toJson, log label)

---

## Used By
- `datamodule` - stores historical price data
