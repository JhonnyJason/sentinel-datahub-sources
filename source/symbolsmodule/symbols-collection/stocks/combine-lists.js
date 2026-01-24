const fs = require('fs');
const path = require('path');

const dir = __dirname;
const files = fs.readdirSync(dir).filter(f => f.endsWith('.json') && f !== 'stocks.json');

const nameToEntry = new Map();   // name -> entry
const symbolToEntry = new Map(); // symbol -> entry (same entry objects)

for (const file of files) {
    const data = JSON.parse(fs.readFileSync(path.join(dir, file), 'utf8'));
    for (const item of data) {
        const name = typeof item === 'string' ? item : item.name;
        const symbol = typeof item === 'string' ? null : item.symbol;

        if (symbol) {
            // Has symbol
            if (symbolToEntry.has(symbol)) {
                // Symbol exists - check name conflict
                const entry = symbolToEntry.get(symbol);
                if (entry.name !== name) {
                    console.log(`Naming conflict at Symbol: ${symbol} -> "${entry.name}" vs "${name}" (keeping first)`);
                }
            } else if (nameToEntry.has(name)) {
                // Name exists, upgrade with symbol
                const entry = nameToEntry.get(name);
                if (!entry.symbol) {
                    entry.symbol = symbol;
                    symbolToEntry.set(symbol, entry);
                } else if (entry.symbol !== symbol) {
                    // Same name, different symbol - create separate entry
                    const newEntry = { symbol, name };
                    symbolToEntry.set(symbol, newEntry);
                    console.log(`Name collision: "${name}" -> ${entry.symbol} vs ${symbol} (keeping both)`);
                }
            } else {
                // New entry with symbol + name
                const entry = { symbol, name };
                nameToEntry.set(name, entry);
                symbolToEntry.set(symbol, entry);
            }
        } else {
            // Name only
            if (!nameToEntry.has(name)) {
                nameToEntry.set(name, { name });
            }
        }
    }
}

const result = [...nameToEntry.values()];
fs.writeFileSync(path.join(dir, 'stocks.json'), JSON.stringify(result, null, 2));
console.log(`Wrote ${result.length} entries (${symbolToEntry.size} with symbol, ${result.length - symbolToEntry.size} name-only)`);
