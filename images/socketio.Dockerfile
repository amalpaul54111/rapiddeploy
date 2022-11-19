# syntax=docker/dockerfile:1.4
ARG FRAPPE_VERSION
FROM frappe/frappe-nginx:${FRAPPE_VERSION}

COPY --chown=frappe:frappe sites /home/frappe/frappe-bench/sites