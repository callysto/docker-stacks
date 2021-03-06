# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

from jupyter_core.paths import jupyter_data_dir
import subprocess
import os
import errno
import stat

from s3contents import SwiftContentsManager
import s3contents

c = get_config()

if 'JUPYTERHUB_API_TOKEN' not in os.environ:
    c.NotebookApp.ip = '*'
    c.NotebookApp.port = 8888
    c.NotebookApp.open_browser = False

    # Generate a self-signed certificate
    if 'GEN_CERT' in os.environ:
        dir_name = jupyter_data_dir()
        pem_file = os.path.join(dir_name, 'notebook.pem')
        try:
            os.makedirs(dir_name)
        except OSError as exc:  # Python >2.5
            if exc.errno == errno.EEXIST and os.path.isdir(dir_name):
                pass
            else:
                raise
        # Generate a certificate if one doesn't exist on disk
        subprocess.check_call(['openssl', 'req', '-new',
                            '-newkey', 'rsa:2048',
                            '-days', '365',
                            '-nodes', '-x509',
                            '-subj', '/C=XX/ST=XX/L=XX/O=generated/CN=generated',
                            '-keyout', pem_file,
                            '-out', pem_file])
        # Restrict access to the file
        os.chmod(pem_file, stat.S_IRUSR | stat.S_IWUSR)
        c.NotebookApp.certfile = pem_file

c.NotebookApp.extra_template_paths = ["/opt/notebook/local_templates/"]

c.NotebookApp.contents_manager_class = SwiftContentsManager
c.SwiftContentsManager.auth_url = os.environ.get("OS_AUTH_URL", "")
c.SwiftContentsManager.username = os.environ.get("OS_USERNAME", "")
c.SwiftContentsManager.project_name = os.environ.get("OS_PROJECT_NAME", "")
c.SwiftContentsManager.password = os.environ.get("OS_PASSWORD", "")
c.SwiftContentsManager.user_domain_name = os.environ.get("OS_USER_DOMAIN_NAME", "")
c.SwiftContentsManager.project_domain_name = os.environ.get("OS_PROJECT_DOMAIN_NAME", "")
c.SwiftContentsManager.region_name = os.environ.get("OS_REGION_NAME", "")
c.SwiftContentsManager.container = os.environ.get("JPYNB_SWIFT_CONTAINER", "")
