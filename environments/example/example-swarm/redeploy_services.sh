#!/bin/bash

failed_once=false

check_result () {
    ___RESULT=$?
    if [ $___RESULT -ne 0 ]; then
        echo $1
        failed_once=true
    fi
}

source venv/bin/activate

# list services
DOCKER_SERVICES=$(docker service ls -q)

# array to hold process IDs
pids=()

# loop over services and force update
for service in $DOCKER_SERVICES; do
    # get name of service
    service_name=$(docker service inspect --format '{{.Spec.Name}}' $service)
    echo "updating service $service_name"

    # run the update in the background and save its PID
    (docker service update --force $service | sed  "s/^/[$service_name] /") &
    pids+=($!)
done

# wait for all processes to finish and check their exit codes
for pid in ${pids[@]}; do
    if ! wait $pid; then
        echo "failed to update service with PID $pid"
        failed_once=true
    fi
done

if [ "$failed_once" = true ]; then
    echo "failed to update one or more services"
    exit 1
fi
