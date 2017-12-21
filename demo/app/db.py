from datetime import datetime
from elasticsearch import Elasticsearch

db = Elasticsearch(["elasticsearch"], port=9200)

