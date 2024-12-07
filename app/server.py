import json
from datetime import datetime
from http.server import BaseHTTPRequestHandler
from http.server import HTTPServer

class S(BaseHTTPRequestHandler):
    def _set_response(self):
        self.send_response(200)
        self.send_header('Content-type', 'application/json')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.end_headers()

    def do_GET(self):
        self._set_response()

        res = {
            'datetime': str(datetime.now())
        }

        self.wfile.write(json.dumps(res).encode('utf-8'))


def run(server_class=HTTPServer, handler_class=S):
  server_address = ('', 8000)
  httpd = server_class(server_address, handler_class)
  try:
      httpd.serve_forever()
  except KeyboardInterrupt:
      httpd.server_close()

if __name__ == '__main__':
   run()