# Useful Commands

## Identify hash (with hashid):
```markdown
hashid <HASH>
```
## Crack SHA1:
hashcat -m 100 -a 0 <HASH> <WORDLIST>

## View results:
hashcat --show <HASH>
