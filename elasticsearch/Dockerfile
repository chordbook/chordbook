# The official Elasticsearch Docker image
FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.5@sha256:c6ec6a90c011299a0a6cba5cdd607a634b2efef5522ed6ba14e2e772209a6080

# Copy our config file over
COPY --chown=1000:0 config.yml /usr/share/elasticsearch/config/elasticsearch.yml

# Allow Elasticsearch to create `elasticsearch.keystore`
# to circumvent https://github.com/elastic/ansible-elasticsearch/issues/430
RUN chmod g+ws /usr/share/elasticsearch/config

USER 1000:0
