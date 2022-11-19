ARG FRAPPE_VERSION
ARG ERPNEXT_VERSION

FROM frappe/bench:latest as assets

ARG FRAPPE_VERSION
RUN bench init --version=${FRAPPE_VERSION} --skip-redis-config-generation --verbose /home/frappe/frappe-bench


WORKDIR /home/frappe/frappe-bench

# Comment following if ERPNext not required
ARG ERPNEXT_VERSION
RUN bench get-app --branch=${ERPNEXT_VERSION} --skip-assets --resolve-deps erpnext

COPY --chown=frappe:frappe repos apps
COPY --chown=frappe:frappe sites /home/frappe/frappe-bench/sites

# May not be required
# COPY --chown=frappe:frappe sites /usr/share/nginx/html/sites

RUN bench setup requirements

RUN bench build --production --verbose --hard-link
