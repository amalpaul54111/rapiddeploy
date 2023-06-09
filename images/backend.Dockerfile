# syntax=docker/dockerfile:1.4

ARG ERPNEXT_VERSION
FROM erpnext-worker

COPY --chown=frappe:frappe repos ../apps

USER root
# RUN install-app healthcare && \
  # install-app wiki  && \
  # install-app india_compliance  && \
  # install-app tacten_core  && \
  # install-app payments && \
  # install-app frappe_s3_attachment && \
  # install-app hrms && \
  # install-app posawesome && \
  # install-app frappe_theme

USER root
RUN apt-get update && apt-get install -y libmagic-dev libmagic1 curl


USER frappe

COPY --from=assets /home/frappe/frappe-bench/sites/assets /home/frappe/frappe-bench/sites/assets

COPY --chown=frappe:frappe sites /home/frappe/frappe-bench/sites
