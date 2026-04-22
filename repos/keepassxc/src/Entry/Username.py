class Username:

    def __init__(self, keepass_entry):
        self.entry = keepass_entry

    def lowercase(self):
        if self.entry.username:
            self.entry.username = self.entry.username.lower()

    def ya_to_yandex(self):
        if self.entry.username:
            self.entry.username = self.entry.username.replace('ya.ru', 'yandex.ru')


