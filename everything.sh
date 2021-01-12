#!/bin/bash
project='highpoint'

for environment in development production;
do
    echo "Building ${environment}..."
    make -C ../../Terraform-Modules/example/development/ init deploy
    echo "Deploying ${environment}..."
    make all ENVIRONMENT=${environment}
    echo "Testing ${environment}..."
    curl -sLk --max-time 3 -o /dev/null \
        -w "%{time_total} %{num_redirects} %{http_code} %{url_effective}\n" \
        "https://${project}-${environment}.aws.managedkaos.review/"
done
