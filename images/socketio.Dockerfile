# syntax=docker/dockerfile:1.4
ARG FRAPPE_VERSION
FROM frappe/frappe-socketio:${FRAPPE_VERSION}

COPY --chown=frappe:frappe sites /home/frappe/frappe-bench/sites