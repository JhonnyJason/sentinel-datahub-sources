# State Cache

## Purpose
LRU (Least Recently Used) caching layer for persistent state. Keeps frequently accessed states in memory while automatically evicting stale entries.

**Note:** This is an internal module. Use `storagemodule` for the public API.

---

## How It Works

### Architecture
```
statecache (LRU cache)
    │
    ├─► objCache      - parsed objects by id
    ├─► jsonCache     - JSON strings by id (for change detection)
    ├─► LRU list      - doubly-linked list for eviction order
    │
    └─► statesaver (file I/O)
```

### LRU Cache Mechanism
- Doubly-linked list tracks access order
- Head = most recently accessed
- Tail = least recently accessed
- When cache exceeds `maxCacheSize`, tail entry is evicted
- `touch()` moves entry to head on access

### Change Detection
Both JSON string and parsed object are cached. On `save()`:
- Serialize current object to JSON
- Compare with cached JSON string
- Only write to disk if changed

This avoids unnecessary disk writes when saving unchanged data.

---

## Exports

```coffee
initialize(options)
    # options: { basePath, maxCacheSize, defaultState }
    # basePath: directory for state files (default: "./state")
    # maxCacheSize: max entries in cache (default: 64)
    # defaultState: fallback values for missing states

load(id) → object
    # Returns cached object if available
    # Otherwise loads from disk
    # Falls back to defaultState[id] or {}
    # Synchronous

save(id, contentObj?)
    # If contentObj provided, updates cache
    # Compares to cached JSON, writes only if changed
    # Async (but underlying write is sync)

remove(id)
    # Removes from cache and deletes files
    # Async

logCacheState()
    # Debug: prints cache structure
```

---

## Important Behaviors

1. **Object references**: `load()` returns the cached object directly. Mutations affect the cached copy. Call `save()` to persist changes.

2. **Eviction on save**: If an object is evicted from cache before `save()` is called, changes are lost.

3. **Default state cloning**: When loading from `defaultState`, the object is cloned via JSON round-trip to prevent mutation of defaults.

---

## Dependencies
- `statesaver` - file I/O layer
- `thingy-debug` - logging

---

## Used By
- `storagemodule` - the public API layer