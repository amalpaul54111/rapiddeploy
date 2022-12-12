# syntax=docker/dockerfile:1.4

ARG ERPNEXT_VERSION
FROM frappe/erpnext-worker:${ERPNEXT_VERSION}

COPY --chown=frappe:frappe repos ../apps

USER root
RUN install-app healthcare && \
  install-app wiki  && \
  install-app india_compliance  && \
  install-app tacten_core  && \
  install-app payments && \
  install-app frappe_s3_attachment

USER root
RUN apt-get update && apt-get install -y libmagic-dev && apt-get install libmagic1


USER frappe

COPY --from=assets /home/frappe/frappe-bench/sites/assets /home/frappe/frappe-bench/sites/assets

COPY --chown=frappe:frappe sites /home/frappe/frappe-bench/sites


ADD  /repos/tacten_core/tacten_core/s3_update.py /home/frappe/frappe-bench/apps/frappe/frappe/integrations/doctype/s3_backup_settings/s3_backup_settings.py