#!/bin/bash
set -e

# This script runs automatically during MongoDB initialization
# by the docker-entrypoint.sh when the database is first created

echo "Waiting for MongoDB to be fully ready..."
sleep 10

echo "Running data download and import scripts..."

# Download data files
# /resources/download_data.sh
echo "Running data download and import scripts..."

# Use absolute paths instead of relative CD commands
DATA_DIR="/data"
MODELS_DIR="/models"

# Download data files directly to the absolute path
curl -Lko "${DATA_DIR}/simple_flight_delay_features.jsonl.bz2" http://s3.amazonaws.com/agile_data_science/simple_flight_delay_features.jsonl.bz2

# Get the distances
curl -Lko "${DATA_DIR}/origin_dest_distances.jsonl" http://s3.amazonaws.com/agile_data_science/origin_dest_distances.jsonl

# Get the models
curl -Lko "${MODELS_DIR}/sklearn_vectorizer.pkl" http://s3.amazonaws.com/agile_data_science/sklearn_vectorizer.pkl
curl -Lko "${MODELS_DIR}/sklearn_regressor.pkl" http://s3.amazonaws.com/agile_data_science/sklearn_regressor.pkl

# Import using absolute path
echo "Importing origin_dest_distances into MongoDB..."
echo "Trying without auth..."
mongoimport -d agile_data_science -c origin_dest_distances --file "${DATA_DIR}/origin_dest_distances.jsonl"  || true
echo "Trying with auth. username and password..."
mongoimport --username root --password example --authenticationDatabase admin -d agile_data_science -c origin_dest_distances --file "${DATA_DIR}/origin_dest_distances.jsonl"  || true

echo "Creating index on origin_dest_distances... no auth..."
mongosh agile_data_science --eval 'db.origin_dest_distances.createIndex({Origin: 1, Dest: 1})'
echo "Creating index on origin_dest_distances with auth... username and password..."
mongosh --username root --password example --authenticationDatabase admin agile_data_science --eval 'db.origin_dest_distances.createIndex({Origin: 1, Dest: 1})'



echo "MongoDB initialization complete!"
