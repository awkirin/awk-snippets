from src.App import App

app = App()

app.check_urls()
app.sanitize_urls()
app.sanitize_usernames()

app.save()