from locust import HttpUser, task

class QuickstartUser(HttpUser):

    @task
    def app_html_test(self):
        self.client.get("/app.html")
