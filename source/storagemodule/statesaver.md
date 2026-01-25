# State Saver

## Purpose
Low-level file I/O layer for persistent state storage. Handles reading, writing, and backup of JSON state files.

**Note:** This is an internal module. Use `storagemodule` for the public API.

---

## How It Works

### File Structure
```
{basePath}/
  {id}.json         # Primary state file
  {id}.json.backup  # Backup from last successful save
```

### Backup Strategy
The backup exists to survive crashes during write operations:

1. `save(id, json)` → write to `{id}.json` → copy to `{id}.json.backup`
2. If crash during write → main file may be corrupted, backup intact
3. `load(id)` → try main file → if fails, try backup
4. Bonus: backup copy happens after successful write, non-blocking

The backup always contains the **previous successfully written version**, providing a recovery point if the current write fails.

---

## Exports

```coffee
initialize(path)
    # Sets base directory for state files
    # Default: "./state"
    # Creates directory if it doesn't exist

load(id) → { contentObj, contentJson }
    # Reads and parses {id}.json
    # Falls back to backup on failure
    # Returns { null, null } if both fail

save(id, contentJson)
    # Writes JSON string to {id}.json
    # Creates backup after successful write
    # Synchronous (blocks until write complete)

remove(id)
    # Deletes both main and backup files
    # Async, errors silently ignored
```

---

## Dependencies
- Node.js `fs` module (sync for load/save, async for remove)
- Node.js `path` module

---

## Used By
- `statecache` - the caching layer above this