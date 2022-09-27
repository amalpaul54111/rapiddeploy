# TODO: Pin to stable version
FROM frappe/frappe-nginx:latest

COPY --chown=frappe:frappe sites /home/frappe/frappe-bench/sites