import requests

class Url:

    def __init__(self, keepass_entry):
        self.entry = keepass_entry

    def has_http(self):
        if self.entry.url:
            return self.entry.url.strip().startswith("http://")
        return False

    def has_https(self):
        if self.entry.url:
            return self.entry.url.strip().startswith("https://")
        return False

    def has_www(self):
        if self.entry.url:
            return "www." in self.entry.url.strip()
        return False


    def remove_http(self):
        if self.entry.url:
            self.entry.url = self.entry.url.replace('http://', '')

    def remove_https(self):
        if self.entry.url:
            self.entry.url = self.entry.url.replace('https://', '')

    def remove_www(self):
        if self.has_www():
            self.entry.url = self.entry.url.replace('www.', '')

    def remove_end_slash(self):
        if self.entry.url:
            self.entry.url = self.entry.url.rstrip('/')

    def remove_wp_login(self):
        import re
        if self.entry.url:
            self.entry.url = re.sub(r'/wp-login\.php.*', '', self.entry.url)


    def add_http(self):
        if self.entry.url and not self.has_http() and not self.has_https():
            self.entry.url = 'http://' + self.entry.url

    def add_https(self):
        if self.entry.url and not self.has_http() and not self.has_https():
            self.entry.url = 'https://' + self.entry.url


    def google_ru_to_com(self):
        if self.entry.url:
            self.entry.url = self.entry.url.replace('google.ru', 'google.com')

    def check_url(self):
        if self.entry.url:

            self.add_https()
            tag = 'status: '
            try:
                response = requests.get(self.entry.url, timeout=5)
                tag = tag + f"{response.status_code}"
                print(f"Код ответа для {self.entry.url}: {response.status_code}")
            except requests.exceptions.RequestException as e:
                tag = tag + '504'
                print(f"Код ответа для {self.entry.url}: 504")
            self.entry.tags = list([tag])
