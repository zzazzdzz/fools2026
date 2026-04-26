from http.server import BaseHTTPRequestHandler, HTTPServer
import binascii
import base64

def handle(vals):
    charset = b"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz=;"
    for c in vals:
        if c not in charset: return b"INVAL"
    kvs = bytes(vals).split(b";")
    for kv in kvs:
        kv_sp = kv.split(b"=")
        if len(kv_sp) != 2: return b"SYNTAX"
        if len(kv_sp[0]) >= 15: return b"INVAL"
        if len(kv_sp[1]) >= 15: return b"INVAL"
        print(kv_sp)
        if kv_sp[0] == b'TYPE' and kv_sp[1] == b'Gold':
            return b"Congrats, you got a gold certificate! fools2026{Very5ecure}"
    return b"Sorry, this is not a gold certificate."

class HexDecodeHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        hex_path = self.path.lstrip('/')

        try:
            if len(hex_path) == 0: raise ValueError("no string")
            if len(hex_path) == 45*2: raise ValueError("too long")
            decoded_bytes = binascii.unhexlify(hex_path)

            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            key = binascii.unhexlify('84E3D1A67A74DD4AFD2B2E3752DA49FC71F1244E389B86E19D4CB271A3CB9315D36FCC8E78E3285AE124E3')
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            vals = []
            for i in range(0, len(decoded_bytes)):
                vals.append(decoded_bytes[i] ^ key[i])
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.
            # you should not read this if you care about solving the challenge legit.

            outs = handle(bytes(vals))

            self.send_response(200)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Content-Length", str(len(outs)))
            self.end_headers()
            self.wfile.write(outs)

        except (binascii.Error, ValueError):
            error_msg = b"Enter a hex string in request path (example: GET /ABCD1234). Maximum 45 bytes"
            self.send_response(400)
            self.send_header("Content-Type", "text/plain")
            self.send_header("Content-Length", str(len(error_msg)))
            self.end_headers()
            self.wfile.write(error_msg)

    def log_message(self, format, *args):
        pass


def run(server_class=HTTPServer, handler_class=HexDecodeHandler, port=8333):
    server_address = ('127.0.0.1', port)
    httpd = server_class(server_address, handler_class)
    httpd.serve_forever()


if __name__ == "__main__":
    run()