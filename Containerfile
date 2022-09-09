FROM quay.io/centos/centos:stream9

RUN dnf upgrade -y && dnf install -y python3-pip sqlite && pip3 install duffy[app,sqlite]

COPY duffy-mock.yaml /app/

RUN duffy -c /app/duffy-mock.yaml setup-db

RUN echo 'INSERT INTO tenants (retired_at, name, is_admin, ssh_key, api_key, node_quota, session_lifetime, session_lifetime_max) VALUES (NULL, "tenant123", 1, "lol", "$2b$12$gXKnUUz0TQOI2wiANdBs6e4CGFU02h3KDo7ABreNcBsBCDGcndbsC", 1000, NULL, NULL);' | sqlite3 /app/mock.db
RUN echo 'INSERT INTO nodes (id, hostname, ipaddr, state, comment, pool) VALUES (0, "host0.example.com", "172.0.0.0", "ready", "host0", "physical-centos8stream-x86_64");' | sqlite3 /app/mock.db
RUN echo 'INSERT INTO nodes (id, hostname, ipaddr, state, comment, pool) VALUES (1, "host1.example.com", "172.0.0.1", "ready", "host1", "physical-centos8stream-x86_64");' | sqlite3 /app/mock.db
RUN echo 'INSERT INTO nodes (id, hostname, ipaddr, state, comment, pool) VALUES (2, "host2.example.com", "172.0.0.2", "ready", "host2", "physical-centos8stream-x86_64");' | sqlite3 /app/mock.db
RUN echo 'INSERT INTO nodes (id, hostname, ipaddr, state, comment, pool) VALUES (3, "host3.example.com", "172.0.0.3", "ready", "host3", "physical-centos8stream-x86_64");' | sqlite3 /app/mock.db
RUN echo 'INSERT INTO nodes (id, hostname, ipaddr, state, comment, pool) VALUES (4, "host4.example.com", "172.0.0.4", "ready", "host4", "physical-centos8stream-x86_64");' | sqlite3 /app/mock.db

RUN ln -s /usr/bin/true /usr/bin/ssh

CMD duffy -c /app/duffy-mock.yaml serve
EXPOSE 8080
