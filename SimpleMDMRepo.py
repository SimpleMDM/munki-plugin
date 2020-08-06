# encoding: utf-8

# SimpleMDMRepo.py
# Version 1.0

from __future__ import absolute_import, print_function

import base64
import getpass
import json
import os
import subprocess
import tempfile

try:
    from urllib2 import quote
except ImportError:
    from urllib.parse import quote

from munkilib.munkirepo import Repo, RepoError
from autopkglib import URLGetter

BASE_URL = 'https://a.simplemdm.com/munki/plugin'

class SimpleMDMRepo(Repo):

    def __init__(self, baseurl):
        self.getter      = URLGetter()
        self.auth_header = self._fetch_auth_header()
        print(f'NOTICE: The SimpleMDMRepo plugin ignores the MUNKI_REPO value. "{BASE_URL}" will be used instead.')
        
    def _fetch_api_key(self):
        if 'SIMPLEMDM_API_KEY' in os.environ:
            return os.environ['SIMPLEMDM_API_KEY']
        else:
            print(f'Please provide a SimpleMDM API key')
            return getpass.getpass()

    def _fetch_auth_header(self):
        key          = self._fetch_api_key()
        token_bytes  = f'{key}:'.encode("UTF-8")
        base64_bytes = base64.b64encode(token_bytes)
        base64_str   = base64_bytes.decode("UTF-8")
        header       = f'Basic {base64_str}'

        return header

    def _curl(self, simplemdm_path_or_url, commands=None, form_data=None, headers=None, simplemdm_request=True):
        if not commands:
            commands = []
        if not form_data:
            form_data = {}
        if not headers:
            headers = {}

        self.getter = URLGetter()
        curl_cmd = self.getter.prepare_curl_cmd()

        # headers

        if simplemdm_request:
            headers['Authorization'] = self.auth_header

        self.getter.add_curl_headers(curl_cmd, headers)

        # form data

        for key, value in form_data.items():
            curl_cmd.extend(['-F', f'{key}={value}'])

        # commands
        
        curl_cmd.extend(commands)
        
        # url

        if simplemdm_request:
            url = os.path.join(BASE_URL, quote(simplemdm_path_or_url.encode('UTF-8')))
        else:
            url = simplemdm_path_or_url

        curl_cmd.append(url)

        resp = self.getter.download_with_curl(curl_cmd, False)

        return resp

    def itemlist(self, kind):
        resp = self._curl(kind)
        return json.loads(resp)

    def get(self, resource_identifier):
        resp = self._curl(resource_identifier)
        return resp

    def put(self, resource_identifier, content):
        commands = ['-X', 'POST']

        if len(content) > 1024:
            fileref, contentpath = tempfile.mkstemp()
            fileobj = os.fdopen(fileref, 'wb')
            fileobj.write(content)
            fileobj.close()
            commands.extend(['-T', contentpath])
        else:
            commands.extend(['-d', content])

        self._curl(resource_identifier, commands=commands)

        if contentpath:
            os.unlink(contentpath)
   
    def put_from_local_file(self, resource_identifier, local_file_path):
        if(resource_identifier.startswith('pkgs/')):
            filename = resource_identifier[len('pkgs/'):]

            # fetch upload url

            form_data = {
                'filename': filename
            }
            resp = self._curl('pkgs/create_url', form_data=form_data)
            upload_url = resp.decode("UTF-8")
            
            # upload binary

            headers = { 'Content-type': 'application/octet-stream' }
            commands = ['-X', 'PUT', '-T', local_file_path]
            self._curl(upload_url, commands=commands, headers=headers, simplemdm_request=False)

            # upload callback

            form_data = {
                'filename': filename,
                'upload_url': upload_url
            }
            self._curl('pkgs/create_callback', form_data=form_data)
        else:
            headers = { 'Content-type': 'application/octet-stream' }
            commands = ['-X', 'POST', '-T', local_file_path]
            self._curl(resource_identifier, headers=headers, commands=commands)
