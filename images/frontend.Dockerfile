# syntax=docker/dockerfile:1.4
ARG FRAPPE_VERSION

FROM frappe/frappe-nginx

USER root

RUN rm -fr /usr/share/nginx/html/assets

COPY --from=assets /home/frappe/frappe-bench/sites/assets /usr/share/nginx/html/assets

USER 1000
