ARG FRAPPE_VERSION

FROM frappe/frappe-nginx:${FRAPPE_VERSION}

USER root

RUN rm -fr /usr/share/nginx/html/assets

#Todo
COPY --from=assets /home/frappe/frappe-bench/sites/assets /usr/share/nginx/html/assets

USER 1000
