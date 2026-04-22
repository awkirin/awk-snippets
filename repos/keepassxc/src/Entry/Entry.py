from src.Entry.Url import Url
from src.Entry.Title import Title
from src.Entry.Username import Username

class Entry:

    def __init__(self, keepass_entry):
        self.entry = keepass_entry
        self.url = Url(self.entry)
        self.title = Title(self.entry)
        self.username = Username(self.entry)































