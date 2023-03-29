# syntax=docker/dockerfile:1.4
ARG FRAPPE_VERSION
FROM frappe/frappe-socketio

COPY --chown=frappe:frappe sites /home/frappe/frappe-bench/sites